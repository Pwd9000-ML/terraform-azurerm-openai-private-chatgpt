locals {
  libre_app_settings = {
    ### App Service Configuration ###
    WEBSITE_RUN_FROM_PACKAGE = "1"
    DOCKER_REGISTRY_SERVER_URL          = "https://index.docker.io"#######
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
    DOCKER_ENABLE_CI                    = false
    WEBSITES_PORT                       = var.libre_app_port
    PORT                                = var.libre_app_port
    DOCKER_CUSTOM_IMAGE_NAME            = "ghcr.io/danny-avila/librechat-dev-api:latest"
    NODE_ENV                            = "production" #######

    ### Server Configuration ###
    APP_TITLE     = var.libre_app_title
    CUSTOM_FOOTER = var.libre_app_custom_footer
    HOST          = var.libre_app_host
    PORT          = var.libre_app_port
    MONGO_URI     = var.libre_app_mongo_uri != null ? var.libre_app_mongo_uri : "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.openai_cosmos_uri.id})"
    DOMAIN_CLIENT = var.libre_app_domain_client
    DOMAIN_SERVER = var.libre_app_domain_server

    ### Debug Logging ###
    DEBUG_LOGGING = var.libre_app_debug_logging
    DEBUG_CONSOLE = var.libre_app_debug_console

    ### Endpoints ###
    ENDPOINTS = var.libre_app_endpoints

    ### Azure OpenAI ###
    AZURE_API_KEY                      = var.libre_app_az_oai_api_key != null ? var.libre_app_az_oai_api_key : "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.openai_primary_key.id})"
    AZURE_OPENAI_MODELS                = var.libre_app_az_oai_models
    AZURE_USE_MODEL_AS_DEPLOYMENT_NAME = var.libre_app_az_oai_use_model_as_deployment_name
    AZURE_OPENAI_API_INSTANCE_NAME     = var.libre_app_az_oai_instance_name != null ? var.libre_app_az_oai_instance_name : split("//", split(".", azurerm_cognitive_account.az_openai.endpoint)[0])[1]
    AZURE_OPENAI_API_VERSION           = var.libre_app_az_oai_api_version

    ### Plugins ###
    # NOTE: You need a fixed key and IV. a 32-byte key (64 characters in hex) and 16-byte IV (32 characters in hex) 
    # Warning: If you don't set them, the app will crash on startup.
    DEBUG_PLUGINS = var.libre_app_debug_plugins
    CREDS_KEY     = var.libre_app_plugins_creds_key != null ? var.libre_app_plugins_creds_key : "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.libre_app_creds_key.id})"
    CREDS_IV      = var.libre_app_plugins_creds_iv != null ? var.libre_app_plugins_creds_iv : "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.libre_app_creds_iv.id})"

    ### Search ###
    SEARCH             = var.libre_app_enable_meilisearch
    MEILI_NO_ANALYTICS = var.libre_app_disable_meilisearch_analytics
    MEILI_HOST         = var.libre_app_meili_host != null ? var.libre_app_meili_host : "${azurerm_linux_web_app.meilisearch.name}.azurewebsites.net"
    MEILI_MASTER_KEY   = var.libre_app_meili_key != null ? var.libre_app_meili_key : "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.meilisearch_master_key.id})"

    ### User - Balance ###
    CHECK_BALANCE = false #######

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

    ### User - Registration and Login ###
    ALLOW_EMAIL_LOGIN         = var.libre_app_allow_email_login         #true
    ALLOW_REGISTRATION        = var.libre_app_allow_registration        #true
    ALLOW_SOCIAL_LOGIN        = var.libre_app_allow_social_login        #false
    ALLOW_SOCIAL_REGISTRATION = var.libre_app_allow_social_registration #false
    SESSION_EXPIRY            = 1000 * 60 * 15                          #15 minutes
    REFRESH_TOKEN_EXPIRY      = (1000 * 60 * 60 * 24) * 7               #7 days
    JWT_SECRET                = var.libre_app_jwt_secret != null ? var.libre_app_jwt_secret : "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.libre_app_jwt_secret.id})"
    JWT_REFRESH_SECRET        = var.libre_app_jwt_refresh_secret != null ? var.libre_app_jwt_refresh_secret : "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.libre_app_jwt_refresh_secret.id})"
  }
}

#MOVE TO CDN CSETTINGS 

#  cdn_gpt_origin = merge(
#    var.cdn_gpt_origin,
#    {
#      host_name          = module.privategpt_chatbot_container_apps.latest_revision_fqdn
#      origin_host_header = module.privategpt_chatbot_container_apps.latest_revision_fqdn
#    }
#  )

##################################################################################################################
### For reference, here is a list of additional/optional app settings that can be configured for librechat app ###
##################################################################################################################

### Also see the official project environment variables documentation here: https://docs.librechat.ai/install/configuration/dotenv.html
### Azure specific variables: https://docs.librechat.ai/install/configuration/dotenv.html#azure
### Offical Docs and Homepage: https://docs.librechat.ai/index.html

# app_settings = {
#   #==================================================#
#   #               Server Configuration               #
#   #==================================================#
#
#   #=============#
#   # Permissions #
#   #=============#
#   UID=1000
#   GID=1000
#
#   #===================================================#
#   #                     Endpoints                     #
#   #===================================================#
#   ENDPOINTS = "openAI,azureOpenAI,bingAI,chatGPTBrowser,google,gptPlugins,anthropic"
#   PROXY = ""
#
#   #============#
#   # Anthropic  #
#   #============#
#   ANTHROPIC_API_KEY = "user_provided"
#   ANTHROPIC_MODELS  = "claude-1,claude-instant-1,claude-2"
#   ANTHROPIC_REVERSE_PROXY = ""
#
#   #============#
#   # Azure      #
#   #============#
#    AZURE_API_KEY = ""
#    AZURE_OPENAI_MODELS = "gpt-4-1106-preview,gpt-4,gpt-3.5-turbo,gpt-3.5-turbo-1106,gpt-4-vision-preview"
#    AZURE_OPENAI_DEFAULT_MODEL = "gpt-3.5-turbo"
#    PLUGINS_USE_AZURE = true
#    AZURE_USE_MODEL_AS_DEPLOYMENT_NAME = true
#    AZURE_OPENAI_API_INSTANCE_NAME = split("//", split(".", module.openai.openai_endpoint)[0])[1]
#    AZURE_OPENAI_API_DEPLOYMENT_NAME = ""
#    AZURE_OPENAI_API_VERSION = ""
#    AZURE_OPENAI_API_COMPLETIONS_DEPLOYMENT_NAME = ""
#    AZURE_OPENAI_API_EMBEDDINGS_DEPLOYMENT_NAME  = ""
#
#    #============#
#    # BingAI     #
#    #============#
#    BINGAI_TOKEN = ""
#    BINGAI_HOST  = "https://cn.bing.com"
#
#   #============#
#   # ChatGPT    #
#   #============#
#   CHATGPT_TOKEN  = ""
#   CHATGPT_MODELS = "text-davinci-002-render-sha"
#   CHATGPT_REVERSE_PROXY = "<YOUR REVERSE PROXY>"
#
#   #============#
#   # Google     #
#   #============#
#   GOOGLE_KEY = "user_provided"
#   GOOGLE_MODELS = "gemini-pro,gemini-pro-vision,chat-bison,chat-bison-32k,codechat-bison,codechat-bison-32k,text-bison,text-bison-32k,text-unicorn,code-gecko,code-bison,code-bison-32k"
#   GOOGLE_REVERSE_PROXY= "<YOUR REVERSE PROXY>"
#
#   #============#
#   # OpenAI     #
#   #============#
#   OPENAI_API_KEY = ""
#   OPENAI_MODELS = "gpt-3.5-turbo-1106,gpt-4-1106-preview,gpt-3.5-turbo,gpt-3.5-turbo-16k,gpt-3.5-turbo-0301,text-davinci-003,gpt-4,gpt-4-0314,gpt-4-0613"
#   DEBUG_OPENAI = false
#   TITLE_CONVO  = false
#   OPENAI_TITLE_MODEL = "gpt-3.5-turbo"
#   OPENAI_SUMMARIZE = true
#   OPENAI_SUMMARY_MODEL = "gpt-3.5-turbo"
#   OPENAI_FORCE_PROMPT  = true
#   OPENAI_REVERSE_PROXY = "<YOUR REVERSE PROXY>"
#
#  #============#
#  # OpenRouter #
#  #============#
#  OPENROUTER_API_KEY = ""
#
#  #============#
#  # Plugins    #
#  #============#
#  # NOTE: You need a fixed key and IV. a 32-byte key (64 characters in hex) and 16-byte IV (32 characters in hex) 
#  # Warning: If you don't set them, the app will crash on startup.
#
#  PLUGIN_MODELS = "gpt-3.5-turbo,gpt-3.5-turbo-16k,gpt-3.5-turbo-0301,gpt-4,gpt-4-0314,gpt-4-0613"
#  DEBUG_PLUGINS = false
#  CREDS_KEY     = ""
#  CREDS_IV      = ""
#
#  ### Azure AI Search ###
#  AZURE_AI_SEARCH_SERVICE_ENDPOINT =
#  AZURE_AI_SEARCH_INDEX_NAME =
#  AZURE_AI_SEARCH_API_KEY =
#  AZURE_AI_SEARCH_API_VERSION = 
#  AZURE_AI_SEARCH_SEARCH_OPTION_QUERY_TYPE =
#  AZURE_AI_SEARCH_SEARCH_OPTION_TOP =
#  AZURE_AI_SEARCH_SEARCH_OPTION_SELECT =
#
#  ### DALL·E 3 ###
#  DALLE_API_KEY =
#  DALLE3_SYSTEM_PROMPT = "Your System Prompt here"
#  DALLE_REVERSE_PROXY =
#
#  ### Google ###
#  GOOGLE_API_KEY =
#  GOOGLE_CSE_ID =
#
#  ### SerpAPI ###
#  SERPAPI_API_KEY =
#
#  ### Stable Diffusion ###
#  SD_WEBUI_URL = "http://host.docker.internal:7860"
#
#  ### WolframAlpha ###
#  WOLFRAM_APP_ID =
#
#  ### Zapier ###
#  ZAPIER_NLA_API_KEY =
#
#  #============#
#  # Sarch      #
#  #============#
#  SEARCH = true
#  MEILI_NO_ANALYTICS = true
#  MEILI_HOST = "${azurerm_linux_web_app.meilisearch.name}.azurewebsites.net"
#  MEILI_HTTP_ADDR = 0.0.0.0:7700
#  MEILI_MASTER_KEY = ""
#
#  #=============#
#  # User System #
#  #=============#
#
#  #=============#
#  # Moderation  #
#  #=============#
#  OPENAI_MODERATION=true
#  OPENAI_MODERATION_API_KEY=sk-1234
#  OPENAI_MODERATION_REVERSE_PROXY=false
#
#  BAN_VIOLATIONS = true
#  BAN_DURATION   = 1000 * 60 * 60 * 2
#  BAN_INTERVAL   = 20
#
#  LOGIN_VIOLATION_SCORE        = 1
#  REGISTRATION_VIOLATION_SCORE = 1
#  CONCURRENT_VIOLATION_SCORE   = 1
#  MESSAGE_VIOLATION_SCORE      = 1
#  NON_BROWSER_VIOLATION_SCORE  = 20
#
#  LOGIN_MAX       = 7
#  LOGIN_WINDOW    = 5
#  REGISTER_MAX    = 5
#  REGISTER_WINDOW = 60
#
#  LIMIT_CONCURRENT_MESSAGES = true
#  CONCURRENT_MESSAGE_MAX    = 2
#
# LIMIT_MESSAGE_IP  = true
# MESSAGE_IP_MAX    = 40
# MESSAGE_IP_WINDOW = 1
#
# LIMIT_MESSAGE_USER  = false
# MESSAGE_USER_MAX    = 40
# MESSAGE_USER_WINDOW = 1
#
#========================#
# Balance                #
#========================#
# CHECK_BALANCE = false
#
#========================#
# Registration and Login #
#========================#
# ALLOW_EMAIL_LOGIN         = true
# ALLOW_REGISTRATION        = true
# ALLOW_SOCIAL_LOGIN        = false
# ALLOW_SOCIAL_REGISTRATION = false
#
# SESSION_EXPIRY       = 1000 * 60 * 15
# REFRESH_TOKEN_EXPIRY = (1000 * 60 * 60 * 24) * 7
#
# JWT_SECRET         = "dfsdgdsffgdsfgds"
# JWT_REFRESH_SECRET = "dfsdgdsffgdsfgds"
#
### Discord
# DISCORD_CLIENT_ID =
# DISCORD_CLIENT_SECRET =
# DISCORD_CALLBACK_URL = /discord/callback
#
### Facebook
# FACEBOOK_CLIENT_ID =
# FACEBOOK_CLIENT_SECRET =
# FACEBOOK_CALLBACK_URL = /oauth/facebook/callback
#
### GitHub
# GITHUB_CLIENT_ID =
# GITHUB_CLIENT_SECRET =
# GITHUB_CALLBACK_URL = /oauth/github/callback
#
### Google
# GOOGLE_CLIENT_ID =
# GOOGLE_CLIENT_SECRET =
# GOOGLE_CALLBACK_URL = /oauth/google/callback
#
### OpenID
# OPENID_CLIENT_ID =
# OPENID_CLIENT_SECRET =
# OPENID_ISSUER =
# OPENID_SESSION_SECRET =
# OPENID_SCOPE = "openid profile email"
# OPENID_CALLBACK_URL = /oauth/openid/callback
#
# OPENID_BUTTON_LABEL =
# OPENID_IMAGE_URL =
#
#========================#
# Email Password Reset   #
#========================#
# EMAIL_SERVICE =                  
# EMAIL_HOST =                     
# EMAIL_PORT = 25                   
# EMAIL_ENCRYPTION =               
# EMAIL_ENCRYPTION_HOSTNAME =      
# EMAIL_ALLOW_SELFSIGNED =         
# EMAIL_USERNAME =                 
# EMAIL_PASSWORD =                 
# EMAIL_FROM_NAME =                
# EMAIL_FROM = noreply@librechat.ai
#
#==========#
# Others   #
#==========#
### You should leave the following commented out ###
#
# #NODE_ENV =
# #REDIS_URI =
# #USE_REDIS =
# #E2E_USER_EMAIL =
# #E2E_USER_PASSWORD =
#
#=================================#
# Azure App Service Configuration #
#=================================#
#
# WEBSITE_RUN_FROM_PACKAGE            = "1"
# DOCKER_REGISTRY_SERVER_URL          = "https://index.docker.io"
# WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
# DOCKER_ENABLE_CI                    = false
# WEBSITES_PORT                       = 80
# PORT                                = 80
# DOCKER_CUSTOM_IMAGE_NAME            = "ghcr.io/danny-avila/librechat-dev-api:latest"
# NODE_ENV                            = "production"
# }