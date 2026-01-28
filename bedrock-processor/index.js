const { BedrockRuntimeClient, InvokeModelCommand } = require('@aws-sdk/client-bedrock-runtime');
const { EventBridgeClient, PutEventsCommand } = require('@aws-sdk/client-eventbridge');

// Initialize AWS SDK clients - force us-east-1 for Bedrock
const bedrockClient = new BedrockRuntimeClient({ region: 'us-east-1' });
const eventBridgeClient = new EventBridgeClient({ region: process.env.AWS_REGION || 'us-east-1' });

exports.handler = async (event) => {
  console.log('Bedrock Processor invoked');
  console.log('Received event:', JSON.stringify(event, null, 2));

  try {
    // Process each record from SQS
    for (const record of event.Records) {
      const eventBridgeEvent = JSON.parse(record.body);
      const detail = JSON.parse(eventBridgeEvent.detail);

      console.log('Processing AI request:', detail);

      const { prompt, connectionId, requestedAt } = detail;

      // Call AWS Bedrock (Claude model) in us-east-1
      const bedrockRequest = {
        modelId: 'anthropic.claude-3-haiku-20240307-v1:0',
        contentType: 'application/json',
        accept: 'application/json',
        body: JSON.stringify({
          anthropic_version: 'bedrock-2023-05-31',
          max_tokens: 1000,
          messages: [
            {
              role: 'user',
              content: prompt
            }
          ]
        })
      };

      console.log('Calling Bedrock API in us-east-1...');
      const command = new InvokeModelCommand(bedrockRequest);
      const response = await bedrockClient.send(command);

      // Parse Bedrock response
      const responseBody = JSON.parse(new TextDecoder().decode(response.body));
      const generatedText = responseBody.content[0].text;

      console.log('Generated text:', generatedText);

      // Publish success event to EventBridge
      const successEvent = {
        Source: 'com.webwaka.bedrock',
        DetailType: 'ai.text.generation.succeeded',
        Detail: JSON.stringify({
          prompt: prompt,
          generatedText: generatedText,
          connectionId: connectionId,
          requestedAt: requestedAt,
          completedAt: new Date().toISOString(),
          model: 'claude-3-haiku'
        }),
        EventBusName: process.env.EVENT_BUS_NAME
      };

      const putEventsCommand = new PutEventsCommand({
        Entries: [successEvent]
      });

      await eventBridgeClient.send(putEventsCommand);

      console.log('✅ Successfully processed AI request and published success event');
    }

    return {
      statusCode: 200,
      body: JSON.stringify({ message: 'AI requests processed successfully' })
    };
  } catch (error) {
    console.error('Error processing AI request:', error);

    // Publish failure event
    try {
      const failureEvent = {
        Source: 'com.webwaka.bedrock',
        DetailType: 'ai.text.generation.failed',
        Detail: JSON.stringify({
          error: error.message,
          failedAt: new Date().toISOString()
        }),
        EventBusName: process.env.EVENT_BUS_NAME
      };

      const putEventsCommand = new PutEventsCommand({
        Entries: [failureEvent]
      });

      await eventBridgeClient.send(putEventsCommand);
    } catch (publishError) {
      console.error('Failed to publish failure event:', publishError);
    }

    throw error;
  }
};
