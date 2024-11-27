-- Function to get the full path of the current file
local function get_current_file_dir()
    local source = debug.getinfo(1, "S").source:sub(2)
    return source:match("(.*/)")
end

package.path = get_current_file_dir() .. "?.lua;" .. package.path

-- Require the env and handlers modules
local env = require("env")
local handler = require("handler")

-- Load environment variables from the .env file in the lts directory
local env_vars = env.load_env(get_current_file_dir() .. ".env")
-- Set the environment variables
env.set_env(env_vars)

-- Get the HTTP request method
local method = ngx.var.request_method
-- Only allow POST requests
if method == "POST" then
    handler()
else
    ngx.status = ngx.HTTP_NOT_ALLOWED
    ngx.say("Method not allowed")
    ngx.exit(ngx.HTTP_NOT_ALLOWED)
end