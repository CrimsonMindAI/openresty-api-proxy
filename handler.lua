local multipart = require "multipart"
local json_handler = require "json_handler"

local function handler()
    -- Retrieve the API key from the environment variable
    local api_key = os.getenv("APP_API_KEY")

    -- Get the request headers
    local headers = ngx.req.get_headers()

    -- Extract the Api-Url and Api-Method headers, defaulting Api-Method to "POST" if not provided
    local api_url = headers["Api-Url"]
    local api_method = headers["Api-Method"] or "POST"

    -- Get the content type of the request
    local content_type = ngx.var.http_content_type

    -- Check if the API key is set
    if not api_key then
        ngx.status = ngx.HTTP_BAD_REQUEST
        ngx.say("API_KEY environment variable is not set")
        return ngx.exit(ngx.HTTP_BAD_REQUEST)
    end

    -- Check if the Api-Url header is set
    if not api_url then
        ngx.status = ngx.HTTP_BAD_REQUEST
        ngx.say("Api-Url header not set")
        return ngx.exit(ngx.HTTP_BAD_REQUEST)
    end

    -- Validate the API URL format
    if not api_url:match("^https?://") then
        ngx.status = ngx.HTTP_BAD_REQUEST
        ngx.say("Invalid Api-Url")
        return ngx.exit(ngx.HTTP_BAD_REQUEST)
    end

    -- Handle the request based on the content type
    if content_type:find("multipart/form-data", 1, true) then
        -- Handle multipart/form-data requests
        multipart.handle(api_url, api_method, api_key)
    elseif content_type:find("application/json", 1, true) then
        -- Handle application/json requests
        json_handler.handle(api_url, api_method, api_key)
    else
        -- Log an error and return unsupported media type status for other content types
        ngx.log(ngx.ERR, "Unsupported content type: ", content_type)
        return ngx.exit(ngx.HTTP_UNSUPPORTED_MEDIA_TYPE)
    end
end

return handler