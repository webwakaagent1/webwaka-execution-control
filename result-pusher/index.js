const { ApiGatewayManagementApiClient, PostToConnectionCommand } = require('@aws-sdk/client-apigatewaymanagementapi');
const { DynamoDBClient, GetItemCommand } = require('@aws-sdk/client-dynamodb');

const dynamoClient = new DynamoDBClient({ region: process.env.AWS_REGION || 'us-east-1' });

exports.handler = async (event) => {
  console.log('Result Pusher invoked');
  console.log('Received event:', JSON.stringify(event, null, 2));

  try {
    // Process each record from SQS
    for (const record of event.Records) {
      const eventBridgeEvent = JSON.parse(record.body);
      const detail = JSON.parse(eventBridgeEvent.detail);

      console.log('Processing AI result:', detail);

      const { connectionId, generatedText, prompt, completedAt } = detail;

      if (!connectionId) {
        console.log('No connectionId provided, skipping WebSocket push');
        continue;
      }

      // Verify connection still exists in DynamoDB
      const getCommand = new GetItemCommand({
        TableName: process.env.CONNECTIONS_TABLE,
        Key: {
          connectionId: { S: connectionId }
        }
      });

      const connection = await dynamoClient.send(getCommand);

      if (!connection.Item) {
        console.log(`Connection ${connectionId} not found in DynamoDB, skipping`);
        continue;
      }

      // Initialize API Gateway Management API client
      const apiGatewayClient = new ApiGatewayManagementApiClient({
        region: process.env.AWS_REGION || 'us-east-1',
        endpoint: process.env.WEBSOCKET_ENDPOINT
      });

      // Push result to WebSocket connection
      const message = JSON.stringify({
        type: 'ai_response',
        prompt: prompt,
        generatedText: generatedText,
        completedAt: completedAt
      });

      const postCommand = new PostToConnectionCommand({
        ConnectionId: connectionId,
        Data: Buffer.from(message)
      });

      await apiGatewayClient.send(postCommand);

      console.log(`✅ Successfully pushed AI result to connection ${connectionId}`);
    }

    return {
      statusCode: 200,
      body: JSON.stringify({ message: 'Results pushed successfully' })
    };
  } catch (error) {
    console.error('Error pushing result:', error);
    throw error;
  }
};
