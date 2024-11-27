local upload = require "resty.upload"  -- Import the resty.upload module for handling file uploads
local cjson = require "cjson"  -- Import the cjson module for JSON handling
local request = require "request"  -- Import the request module for sending HTTP requests

-- Function to read form data from the upload
local function read_form_data(form)
    local form_data = {}
    local current_field_name = nil

    while true do
        local typ, res, err = form:read()
        if not typ then
            ngx.log(ngx.ERR, "Failed to read: ", err)
            return nil, err
        end

        if typ == "header" then
            local header_name, header_value = res[1], res[2]
            if header_name == "Content-Disposition" then
                current_field_name = header_value:match('name="([^"]+)"')
            end
        elseif typ == "body" then
            if current_field_name then
                if not form_data[current_field_name] then
                    form_data[current_field_name] = res
                else
                    form_data[current_field_name] = form_data[current_field_name] .. res
                end
            end
        elseif typ == "part_end" then
            current_field_name = nil
        elseif typ == "eof" then
            break
        end
    end

    return form_data
end

-- Function to build the multipart body from form data
local function build_multipart_body(form_data, boundary)
    local body = ""

    for key, value in pairs(form_data) do
        body = body .. "--" .. boundary .. "\r\n"
        if key == "file" then
            body = body .. 'Content-Disposition: form-data; name="file"; filename="' .. key .. '"\r\n'
            body = body .. "Content-Type: application/octet-stream\r\n\r\n"
        else
            body = body .. 'Content-Disposition: form-data; name="' .. key .. '"\r\n\r\n'
        end
        body = body .. value .. "\r\n"
    end

    body = body .. "--" .. boundary .. "--\r\n"
    return body
end

-- Function to handle the multipart/form-data request
local function handle(apiUrl, apiMethod, api_key)
    local form, err = upload:new(4096)
    if not form then
        ngx.log(ngx.ERR, "Failed to initialize upload: ", err)
        return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
    end

    form:set_timeout(1000)  -- Set timeout to 1 second

    local form_data, err = read_form_data(form)
    if not form_data then
        return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
    end

    local boundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW"  -- Define the boundary for multipart/form-data
    local body = build_multipart_body(form_data, boundary)

    local headers = {
        ["Content-Type"] = "multipart/form-data; boundary=" .. boundary,
        ["x-api-key"] = api_key,
    }

    local res, err = request.send(apiUrl, apiMethod, body, headers)
    if not res then
        ngx.log(ngx.ERR, "Failed to request: ", err)
        return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
    end

    ngx.header.content_type = "application/json"
    ngx.say(cjson.encode({ status = res.status, body = cjson.decode(res.body) }))
end

return {
    handle = handle  -- Export the handle function
}