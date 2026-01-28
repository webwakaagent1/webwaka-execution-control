const express = require('express');
const serverless = require('serverless-http');
const { SESClient, SendEmailCommand } = require('@aws-sdk/client-ses');
const { SNSClient, PublishCommand } = require('@aws-sdk/client-sns');

// Initialize AWS SDK clients
const sesClient = new SESClient({ region: process.env.AWS_REGION || 'us-east-1' });
const snsClient = new SNSClient({ region: process.env.AWS_REGION || 'us-east-1' });

const app = express();

// Middleware
app.use(express.json());

// Routes
app.get('/', (req, res) => {
  res.json({
    message: 'Hello from WebWaka API!',
    version: '1.0.0',
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || 'production'
  });
});

app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    uptime: process.uptime(),
    timestamp: new Date().toISOString()
  });
});

app.get('/api/info', (req, res) => {
  res.json({
    service: 'WebWaka Backend API',
    description: 'Serverless backend powered by AWS Lambda and API Gateway',
    architecture: 'AWS Lambda + API Gateway',
    runtime: process.version,
    region: process.env.AWS_REGION || 'us-east-1'
  });
});

// Send Email Endpoint
app.post('/send-email', async (req, res) => {
  try {
    const { to, subject, body } = req.body;

    if (!to || !subject || !body) {
      return res.status(400).json({
        error: 'Missing required fields',
        required: ['to', 'subject', 'body']
      });
    }

    const params = {
      Source: 'noreply@webwaka.site',
      Destination: {
        ToAddresses: [to]
      },
      Message: {
        Subject: {
          Data: subject,
          Charset: 'UTF-8'
        },
        Body: {
          Text: {
            Data: body,
            Charset: 'UTF-8'
          }
        }
      }
    };

    const command = new SendEmailCommand(params);
    const result = await sesClient.send(command);

    res.json({
      success: true,
      message: 'Email sent successfully',
      messageId: result.MessageId,
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    console.error('Error sending email:', error);
    res.status(500).json({
      error: 'Failed to send email',
      message: error.message
    });
  }
});

// Send Notification Endpoint
app.post('/send-notification', async (req, res) => {
  try {
    const { message, subject } = req.body;

    if (!message) {
      return res.status(400).json({
        error: 'Missing required field: message'
      });
    }

    const params = {
      TopicArn: process.env.SNS_TOPIC_ARN,
      Message: message,
      Subject: subject || 'WebWaka Notification'
    };

    const command = new PublishCommand(params);
    const result = await snsClient.send(command);

    res.json({
      success: true,
      message: 'Notification published successfully',
      messageId: result.MessageId,
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    console.error('Error publishing notification:', error);
    res.status(500).json({
      error: 'Failed to publish notification',
      message: error.message
    });
  }
});

// Error handling
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    error: 'Internal Server Error',
    message: err.message
  });
});

// Export Lambda handler with basePath configuration for API Gateway stage
module.exports.handler = serverless(app, {
  basePath: '/prod'
});
