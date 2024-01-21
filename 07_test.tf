locals {
  libre_app_settings = {


    #==================================================#
    #               Server Configuration               #
    #==================================================#
    APP_TITLE     = "test"
    CUSTOM_FOOTER = "test"
    HOST          = "0.0.0.0"
    PORT          = 80
    MONGO_URI     = ""
    DOMAIN_CLIENT = "http://localhost:3080"
    DOMAIN_SERVER = "http://localhost:3080"

    DEBUG_LOGGING = true
    DEBUG_CONSOLE = false

    ENDPOINTS = "azureOpenAI" #openAI,azureOpenAI,bingAI,chatGPTBrowser,google,gptPlugins,anthropic

    AZURE_API_KEY       = ""
    AZURE_OPENAI_MODELS = "gpt-4-1106-Preview,gpt-4-vision-preview"

    AZURE_USE_MODEL_AS_DEPLOYMENT_NAME = true
    AZURE_OPENAI_API_INSTANCE_NAME     = "gptopenai2698"

    AZURE_OPENAI_API_VERSION = "2023-07-01-preview"

    DEBUG_PLUGINS = true
    CREDS_KEY     = "dfsdgdsffgdsfgds"
    CREDS_IV      = "dfsdgdsffgdsfgds"

    SEARCH             = true
    MEILI_NO_ANALYTICS = true
    MEILI_HOST         = "${azurerm_linux_web_app.meilisearch.name}.azurewebsites.net"
    MEILI_MASTER_KEY   = "dfsdgdsffgdsfgds"

    BAN_VIOLATIONS = true
    BAN_DURATION   = 1000 * 60 * 60 * 2
    BAN_INTERVAL   = 20

    LOGIN_VIOLATION_SCORE        = 1
    REGISTRATION_VIOLATION_SCORE = 1
    CONCURRENT_VIOLATION_SCORE   = 1
    MESSAGE_VIOLATION_SCORE      = 1
    NON_BROWSER_VIOLATION_SCORE  = 20

    LOGIN_MAX       = 7
    LOGIN_WINDOW    = 5
    REGISTER_MAX    = 5
    REGISTER_WINDOW = 60

    LIMIT_CONCURRENT_MESSAGES = true
    CONCURRENT_MESSAGE_MAX    = 2

    LIMIT_MESSAGE_IP  = true
    MESSAGE_IP_MAX    = 40
    MESSAGE_IP_WINDOW = 1

    LIMIT_MESSAGE_USER  = false
    MESSAGE_USER_MAX    = 40
    MESSAGE_USER_WINDOW = 1


    CHECK_BALANCE = false


    ALLOW_EMAIL_LOGIN         = true
    ALLOW_REGISTRATION        = true
    ALLOW_SOCIAL_LOGIN        = false
    ALLOW_SOCIAL_REGISTRATION = false

    SESSION_EXPIRY       = 1000 * 60 * 15
    REFRESH_TOKEN_EXPIRY = (1000 * 60 * 60 * 24) * 7

    JWT_SECRET         = "dfsdgdsffgdsfgds"
    JWT_REFRESH_SECRET = "dfsdgdsffgdsfgds"

    WEBSITE_RUN_FROM_PACKAGE            = "1"
    DOCKER_REGISTRY_SERVER_URL          = "https://index.docker.io"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
    DOCKER_ENABLE_CI                    = false
    WEBSITES_PORT                       = 80
    # PORT                                = 80
    DOCKER_CUSTOM_IMAGE_NAME = "ghcr.io/danny-avila/librechat-dev-api:latest"
    NODE_ENV                 = "production"
  }
}