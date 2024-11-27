-- Define a table to hold environment-related functions
local env = {}
-- Require the posix module for setting environment variables
local posix = require("posix")

-- Function to load environment variables from a file
function env.load_env(file)
    local vars = {}
    for line in io.lines(file) do
        local key, value = line:match("([^=]+)=([^=]+)")
        if key and value then
            vars[key] = value
        end
    end
    return vars
end

-- Function to set environment variables
function env.set_env(vars)
    for key, value in pairs(vars) do
        posix.setenv(key, value)
    end
end

-- Return the table of environment-related functions
return env