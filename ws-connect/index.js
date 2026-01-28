const { DynamoDBClient, PutItemCommand } = require('@aws-sdk/client-dynamodb');

const dynamoClient = new DynamoDBClient({ region: process.env.AWS_REGION || 'us-east-1' });

exports.handler = async (event) => {
  console.log('WebSocket Connect:', JSON.stringify(event, null, 2));

  const connectionId = event.requestContext.connectionId;
  const tableName = process.env.CONNECTIONS_TABLE;

  try {
    // Store connection in DynamoDB
    const command = new PutItemCommand({
      TableName: tableName,
      Item: {
        connectionId: { S: connectionId },
        connectedAt: { S: new Date().toISOString() },
        ttl: { N: String(Math.floor(Date.now() / 1000) + 7200) } // 2 hours TTL
      }
    });

    await dynamoClient.send(command);

    console.log(`✅ Connection ${connectionId} stored in DynamoDB`);

    return {
      statusCode: 200,
      body: JSON.stringify({ message: 'Connected' })
    };
  } catch (error) {
    console.error('Error storing connection:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Failed to connect', error: error.message })
    };
  }
};
