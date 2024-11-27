local cjson = require "cjson"  -- Import the cjson module for JSON handling
local request = require "request"  -- Import the request module for sending HTTP requests

-- Function to handle the application/json request
local function handle(apiUrl, apiMethod, api_key)
    ngx.req.read_body()  -- Read the request body
    local body = ngx.req.get_body_data()  -- Get the body data

    -- Set the request headers
    local headers = {
        ["Content-Type"] = "application/json",
        ["x-api-key"] = api_key,
    }

    -- Send the request using the request module
    local res, err = request.send(apiUrl, apiMethod, body, headers)
    if not res then
        ngx.log(ngx.ERR, "Failed to request: ", err)  -- Log the error
        return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)  -- Exit with 500 status
    end

    ngx.header.content_type = "application/json"  -- Set the response content type
    ngx.say(cjson.encode({ status = res.status, body = cjson.decode(res.body) }))  -- Send the response
end

return {
    handle = handle  -- Export the handle function
}