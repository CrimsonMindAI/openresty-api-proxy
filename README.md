# Project Overview

This project is a server-side proxy designed to handle HTTP requests with `multipart/form-data` and `application/json` content types. It processes incoming requests by appending an API key and forwarding them to a specified API URL.

The primary goal is to securely proxy API requests while keeping the API key hidden from the client.

OpenResty was chosen for its minimal overhead and its foundation on Nginx, which is widely used and commonly available in most environments.

## Requirements

- OpenResty
- Lua modules:
   - `resty.upload`
   - `cjson`
   - `resty.http`

## Installation

1. Install OpenResty: [OpenResty Installation Guide](https://openresty.org/en/installation.html)
2. Install Lua modules:
   ```sh
   opm get pintsized/lua-resty-http
   opm get openresty/lua-cjson
   opm get openresty/lua-resty-upload
   ```

## Configuration

Set the `APP_API_KEY` environment variable with your API key:
```sh
export APP_API_KEY=your_api_key
```

## Usage

### Headers

- `Api-Url`: The URL of the API to forward the request to.
- `Api-Method`: The HTTP method to use (e.g., GET, POST). Defaults to POST if not provided.

### Example Request

#### Multipart/form-data

```sh
curl -X POST http://yourserver/endpoint \
  -H "Api-Url: https://api.example.com/resource" \
  -H "Api-Method: POST" \
  -F "file=@/path/to/your/file"
```

#### Application/json

```sh
curl -X POST http://yourserver/endpoint \
  -H "Api-Url: https://api.example.com/resource" \
  -H "Api-Method: POST" \
  -H "Content-Type: application/json" \
  -d '{"key": "value"}'
```

## File Descriptions

### `handler.lua`

Handles incoming requests, validates headers, and delegates processing based on content type.

### `multipart.lua`

Processes multipart/form-data requests, reads form data, and builds the multipart body.

### `json_handler.lua`

Processes application/json requests, reads the request body, and forwards it to the specified API.

### `request.lua`

Sends HTTP requests using the `resty.http` module.

### `proxy.lua`

Main entry point for handling requests.

## License

This project is licensed under the MIT License.