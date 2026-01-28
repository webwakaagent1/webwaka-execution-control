/**
 * Event Processor Lambda Function
 * 
 * This function is triggered by SQS messages from the processing queue.
 * It processes events that have been routed from EventBridge.
 */

exports.handler = async (event) => {
  console.log('Event Processor invoked');
  console.log('Received event:', JSON.stringify(event, null, 2));

  // Process each SQS record
  for (const record of event.Records) {
    try {
      console.log('Processing SQS message:', record.messageId);
      
      // Parse the EventBridge event from the SQS message body
      const eventBridgeEvent = JSON.parse(record.body);
      
      console.log('EventBridge event details:');
      console.log('  Source:', eventBridgeEvent.source);
      console.log('  DetailType:', eventBridgeEvent['detail-type']);
      console.log('  Detail:', JSON.stringify(eventBridgeEvent.detail, null, 2));
      console.log('  Time:', eventBridgeEvent.time);
      
      // Here you would add your actual event processing logic
      // For now, we just log the event
      
      console.log('✅ Successfully processed message:', record.messageId);
    } catch (error) {
      console.error('❌ Error processing message:', record.messageId, error);
      // In production, you might want to send failed messages to a DLQ
      throw error; // This will cause the message to be retried
    }
  }

  return {
    statusCode: 200,
    body: JSON.stringify({
      message: 'Events processed successfully',
      processedCount: event.Records.length
    })
  };
};
