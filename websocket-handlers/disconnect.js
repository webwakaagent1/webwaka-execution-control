const { DynamoDBClient, DeleteItemCommand } = require('@aws-sdk/client-dynamodb');

const dynamoClient = new DynamoDBClient({ region: process.env.AWS_REGION || 'us-east-1' });

exports.handler = async (event) => {
  console.log('WebSocket Disconnect:', JSON.stringify(event, null, 2));

  const connectionId = event.requestContext.connectionId;
  const tableName = process.env.CONNECTIONS_TABLE;

  try {
    // Remove connection from DynamoDB
    const command = new DeleteItemCommand({
      TableName: tableName,
      Key: {
        connectionId: { S: connectionId }
      }
    });

    await dynamoClient.send(command);

    console.log(`✅ Connection ${connectionId} removed from DynamoDB`);

    return {
      statusCode: 200,
      body: JSON.stringify({ message: 'Disconnected' })
    };
  } catch (error) {
    console.error('Error removing connection:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Failed to disconnect', error: error.message })
    };
  }
};
