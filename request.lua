local http = require "resty.http"  -- Import the resty.http module for HTTP requests

-- Function to send an HTTP request
local function send(apiUrl, apiMethod, body, headers)
    local httpc = http.new()  -- Create a new HTTP client instance
    return httpc:request_uri(apiUrl, {
        method = apiMethod,  -- Set the HTTP method (e.g., GET, POST)
        body = body,  -- Set the request body
        headers = headers,  -- Set the request headers
        ssl_verify = false  -- Disable SSL verification
    })
end

return {
    send = send  -- Export the send function
}