# Criando a API Gateway HTTP API
resource "aws_apigatewayv2_api" "http_api" {
  name          = "${var.projectName}-api-gateway"
  protocol_type = "HTTP"
}

# Criando uma rota para criação de usuário
resource "aws_apigatewayv2_route" "create_user_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /create-user"
  target    = "integrations/${aws_apigatewayv2_integration.create_user_integration.id}"
}

# Configurando a integração da Lambda de criação de usuário
resource "aws_apigatewayv2_integration" "create_user_integration" {
  api_id             = aws_apigatewayv2_api.http_api.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.create-user-lambda.invoke_arn
}

# Criando uma rota para autenticação
resource "aws_apigatewayv2_route" "auth_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /auth"
  target    = "integrations/${aws_apigatewayv2_integration.auth_integration.id}"
}

# Configurando a integração da Lambda de autenticação
resource "aws_apigatewayv2_integration" "auth_integration" {
  api_id             = aws_apigatewayv2_api.http_api.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.auth-lambda.invoke_arn
}

# Publicando a API Gateway
resource "aws_apigatewayv2_stage" "stage" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}