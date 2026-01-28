const express = require('express');
const serverless = require('serverless-http');
const { S3Client, PutObjectCommand } = require('@aws-sdk/client-s3');
const { getSignedUrl } = require('@aws-sdk/s3-request-presigner');
const { SESClient, SendEmailCommand } = require('@aws-sdk/client-ses');
const { SNSClient, PublishCommand } = require('@aws-sdk/client-sns');
const { EventBridgeClient, PutEventsCommand } = require('@aws-sdk/client-eventbridge');

const app = express();

// AWS Clients
const s3Client = new S3Client({ region: process.env.AWS_REGION || 'us-east-1' });
const sesClient = new SESClient({ region: process.env.AWS_REGION || 'us-east-1' });
const snsClient = new SNSClient({ region: process.env.AWS_REGION || 'us-east-1' });
const eventBridgeClient = new EventBridgeClient({ region: process.env.AWS_REGION || 'us-east-1' });

// Environment variables
const UPLOAD_BUCKET = process.env.UPLOAD_BUCKET || 'webwaka-uploads-production';
const SNS_TOPIC_ARN = process.env.SNS_TOPIC_ARN || 'arn:aws:sns:us-east-1:123456789012:webwaka-notifications-production';
const EVENT_BUS_NAME = process.env.EVENT_BUS_NAME || 'webwaka-event-bus-production';
const SES_FROM_EMAIL = process.env.SES_FROM_EMAIL || 'noreply@webwaka.site';

// Middleware
app.use(express.json());

// CORS Middleware
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  
  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }
  
  next();
});

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

// File Upload Endpoint (Session 8)
app.post('/upload-url', async (req, res) => {
  try {
    const { fileName, fileType } = req.body;
    
    if (!fileName || !fileType) {
      return res.status(400).json({
        error: 'Missing required fields',
        message: 'fileName and fileType are required'
      });
    }
    
    // Generate unique file name
    const timestamp = Date.now();
    const uniqueFileName = `${timestamp}-${fileName}`;
    
    // Create presigned URL for upload
    const command = new PutObjectCommand({
      Bucket: UPLOAD_BUCKET,
      Key: uniqueFileName,
      ContentType: fileType
    });
    
    const uploadUrl = await getSignedUrl(s3Client, command, { expiresIn: 3600 });
    const fileUrl = `https://${UPLOAD_BUCKET}.s3.amazonaws.com/${uniqueFileName}`;
    
    res.json({
      uploadUrl,
      fileUrl,
      fileName: uniqueFileName
    });
  } catch (error) {
    console.error('Error generating presigned URL:', error);
    res.status(500).json({
      error: 'Failed to generate upload URL',
      message: error.message
    });
  }
});

// Send Email Endpoint (Session 7)
app.post('/send-email', async (req, res) => {
  try {
    const { to, subject, body } = req.body;
    
    if (!to || !subject || !body) {
      return res.status(400).json({
        error: 'Missing required fields',
        message: 'to, subject, and body are required'
      });
    }
    
    const command = new SendEmailCommand({
      Source: SES_FROM_EMAIL,
      Destination: {
        ToAddresses: [to]
      },
      Message: {
        Subject: {
          Data: subject
        },
        Body: {
          Text: {
            Data: body
          }
        }
      }
    });
    
    const result = await sesClient.send(command);
    
    res.json({
      success: true,
      messageId: result.MessageId
    });
  } catch (error) {
    console.error('Error sending email:', error);
    res.status(500).json({
      error: 'Failed to send email',
      message: error.message
    });
  }
});

// Send Notification Endpoint (Session 7)
app.post('/send-notification', async (req, res) => {
  try {
    const { message } = req.body;
    
    if (!message) {
      return res.status(400).json({
        error: 'Missing required field',
        message: 'message is required'
      });
    }
    
    const command = new PublishCommand({
      TopicArn: SNS_TOPIC_ARN,
      Message: message,
      Subject: 'WebWaka Notification'
    });
    
    const result = await snsClient.send(command);
    
    res.json({
      success: true,
      messageId: result.MessageId
    });
  } catch (error) {
    console.error('Error sending notification:', error);
    res.status(500).json({
      error: 'Failed to send notification',
      message: error.message
    });
  }
});

// Publish Event Endpoint (Session 9)
app.post('/publish-event', async (req, res) => {
  try {
    const { eventType, data } = req.body;
    
    if (!eventType || !data) {
      return res.status(400).json({
        error: 'Missing required fields',
        message: 'eventType and data are required'
      });
    }
    
    const command = new PutEventsCommand({
      Entries: [
        {
          Source: 'webwaka.api',
          DetailType: eventType,
          Detail: JSON.stringify(data),
          EventBusName: EVENT_BUS_NAME
        }
      ]
    });
    
    const result = await eventBridgeClient.send(command);
    
    res.json({
      success: true,
      eventId: result.Entries[0].EventId
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
