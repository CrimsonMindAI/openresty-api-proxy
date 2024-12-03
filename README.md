# Project Overview

This project is a server-side proxy designed to handle HTTP requests with `multipart/form-data` and `application/json` content types. It processes incoming requests by appending an API key and forwarding them to a specified API URL.

The primary goal is to securely proxy API requests while keeping the API key hidden from the client.

OpenResty was chosen for its minimal overhead and its foundation on Nginx, which is widely used and commonly available in most environments.

## Requirements

- OpenResty
- LuaRocks or opm

## Installation

1. Install OpenResty: [OpenResty Installation Guide](https://openresty.org/en/installation.html)
2. Install Lua modules:
   ```sh
    luarocks install luaposix
    luarocks install lua-resty-http
    luarocks install lua-cjson
    luarocks install lua-resty-upload
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

## Potential Issues

### DNS Resolver Not Defined

If you encounter an error indicating that no resolver is defined to resolve a domain, you need to add a DNS resolver to your OpenResty configuration. Add the following resolver configuration to your `nginx.conf` file:

```nginx
http {
    resolver 8.8.8.8;
    # other configurations
}
````

## License

This project is licensed under the MIT License.