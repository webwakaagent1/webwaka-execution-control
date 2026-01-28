const express = require('express');
const serverless = require('serverless-http');
const { SESClient, SendEmailCommand } = require('@aws-sdk/client-ses');
const { SNSClient, PublishCommand } = require('@aws-sdk/client-sns');
const { S3Client } = require('@aws-sdk/client-s3');
const { getSignedUrl } = require('@aws-sdk/s3-request-presigner');
const { PutObjectCommand } = require('@aws-sdk/client-s3');
const { EventBridgeClient, PutEventsCommand } = require('@aws-sdk/client-eventbridge');

// Initialize AWS SDK clients
const sesClient = new SESClient({ region: process.env.AWS_REGION || 'us-east-1' });
const snsClient = new SNSClient({ region: process.env.AWS_REGION || 'us-east-1' });
const s3Client = new S3Client({ region: process.env.AWS_REGION || 'us-east-1' });
const eventBridgeClient = new EventBridgeClient({ region: process.env.AWS_REGION || 'us-east-1' });

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

// Generate Upload URL Endpoint
app.post('/generate-upload-url', async (req, res) => {
  try {
    const { filename, contentType } = req.body;

    if (!filename || !contentType) {
      return res.status(400).json({
        error: 'Missing required fields',
        required: ['filename', 'contentType']
      });
    }

    // Generate a unique key for the file
    const timestamp = Date.now();
    const randomString = Math.random().toString(36).substring(7);
    const key = `uploads/${timestamp}-${randomString}-${filename}`;

    // Create the S3 PutObject command
    const command = new PutObjectCommand({
      Bucket: process.env.UPLOADS_BUCKET_NAME,
      Key: key,
      ContentType: contentType
    });

    // Generate presigned URL (valid for 5 minutes)
    const uploadUrl = await getSignedUrl(s3Client, command, { expiresIn: 300 });

    res.json({
      success: true,
      uploadUrl: uploadUrl,
      key: key,
      expiresIn: 300,
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    console.error('Error generating upload URL:', error);
    res.status(500).json({
      error: 'Failed to generate upload URL',
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

// Publish Event Endpoint
app.post('/publish-event', async (req, res) => {
  try {
    const { eventType, data } = req.body;

    if (!eventType) {
      return res.status(400).json({
        error: 'Missing required field: eventType'
      });
    }

    const event = {
      Source: 'com.webwaka.api',
      DetailType: eventType,
      Detail: JSON.stringify(data || {}),
      EventBusName: process.env.EVENT_BUS_NAME,
      Time: new Date()
    };

    const command = new PutEventsCommand({
      Entries: [event]
    });

    const result = await eventBridgeClient.send(command);

    if (result.FailedEntryCount > 0) {
      throw new Error(`Failed to publish event: ${JSON.stringify(result.Entries[0].ErrorMessage)}`);
    }

    res.json({
      success: true,
      message: 'Event published successfully',
      eventId: result.Entries[0].EventId,
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    console.error('Error publishing event:', error);
    res.status(500).json({
      error: 'Failed to publish event',
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
