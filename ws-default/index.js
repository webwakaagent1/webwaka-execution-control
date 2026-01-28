exports.handler = async (event) => {
  console.log('WebSocket Default Route:', JSON.stringify(event, null, 2));

  return {
    statusCode: 200,
    body: JSON.stringify({ message: 'Default route - no action specified' })
  };
};
