# WebSocket Connect Lambda
resource "aws_lambda_function" "websocket_connect" {
  filename         = "${path.module}/../websocket-connect.zip"
  function_name    = "webwaka-websocket-connect"
  role             = aws_iam_role.websocket_lambda.arn
  handler          = "index.handler"
  source_code_hash = filebase64sha256("${path.module}/../websocket-connect.zip")
  runtime          = "nodejs20.x"
  timeout          = 30

  environment {
    variables = {
      CONNECTIONS_TABLE = aws_dynamodb_table.websocket_connections.name
      AWS_REGION        = var.aws_region
    }
  }

  tags = {
    Name        = "WebWaka WebSocket Connect"
    Environment = var.environment
    Project     = "WebWaka"
  }
}

# WebSocket Disconnect Lambda
resource "aws_lambda_function" "websocket_disconnect" {
  filename         = "${path.module}/../websocket-disconnect.zip"
  function_name    = "webwaka-websocket-disconnect"
  role             = aws_iam_role.websocket_lambda.arn
  handler          = "index.handler"
  source_code_hash = filebase64sha256("${path.module}/../websocket-disconnect.zip")
  runtime          = "nodejs20.x"
  timeout          = 30

  environment {
    variables = {
      CONNECTIONS_TABLE = aws_dynamodb_table.websocket_connections.name
      AWS_REGION        = var.aws_region
    }
  }

  tags = {
    Name        = "WebWaka WebSocket Disconnect"
    Environment = var.environment
    Project     = "WebWaka"
  }
}

# WebSocket Default Lambda
resource "aws_lambda_function" "websocket_default" {
  filename         = "${path.module}/../websocket-default.zip"
  function_name    = "webwaka-websocket-default"
  role             = aws_iam_role.websocket_lambda.arn
  handler          = "index.handler"
  source_code_hash = filebase64sha256("${path.module}/../websocket-default.zip")
  runtime          = "nodejs20.x"
  timeout          = 30

  environment {
    variables = {
      CONNECTIONS_TABLE = aws_dynamodb_table.websocket_connections.name
      AWS_REGION        = var.aws_region
    }
  }

  tags = {
    Name        = "WebWaka WebSocket Default"
    Environment = var.environment
    Project     = "WebWaka"
  }
}

# Lambda Permissions for API Gateway
resource "aws_lambda_permission" "websocket_connect" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.websocket_connect.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.websocket.execution_arn}/*"
}

resource "aws_lambda_permission" "websocket_disconnect" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.websocket_disconnect.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.websocket.execution_arn}/*"
}

resource "aws_lambda_permission" "websocket_default" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.websocket_default.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.websocket.execution_arn}/*"
}

# WebSocket API Integrations
resource "aws_apigatewayv2_integration" "connect" {
  api_id           = aws_apigatewayv2_api.websocket.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.websocket_connect.invoke_arn
}

resource "aws_apigatewayv2_integration" "disconnect" {
  api_id           = aws_apigatewayv2_api.websocket.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.websocket_disconnect.invoke_arn
}

resource "aws_apigatewayv2_integration" "default" {
  api_id           = aws_apigatewayv2_api.websocket.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.websocket_default.invoke_arn
}

# WebSocket API Routes
resource "aws_apigatewayv2_route" "connect" {
  api_id    = aws_apigatewayv2_api.websocket.id
  route_key = "$connect"
  target    = "integrations/${aws_apigatewayv2_integration.connect.id}"
}

resource "aws_apigatewayv2_route" "disconnect" {
  api_id    = aws_apigatewayv2_api.websocket.id
  route_key = "$disconnect"
  target    = "integrations/${aws_apigatewayv2_integration.disconnect.id}"
}

resource "aws_apigatewayv2_route" "websocket_default" {
  api_id    = aws_apigatewayv2_api.websocket.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.default.id}"
}
