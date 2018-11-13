# encoding: utf-8
#
# Copyright 2015, Patrick Muench
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# author: Christoph Hartmann
# author: Dominik Richter
# author: Patrick Muench

title 'NGINX server config'

# attributes
CLIENT_MAX_BODY_SIZE = attribute(
  'client_max_body_size',
  description: 'Sets the maximum allowed size of the client request body, specified in the “Content-Length” request header field. If the size in a request exceeds the configured value, the 413 (Request Entity Too Large) error is returned to the client. Please be aware that browsers cannot correctly display this error. Setting size to 0 disables checking of client request body size.',
  default: '1k'
)

CLIENT_BODY_BUFFER_SIZE = attribute(
  'client_body_buffer_size',
  description: 'Sets buffer size for reading client request body. In case the request body is larger than the buffer, the whole body or only its part is written to a temporary file. By default, buffer size is equal to two memory pages. This is 8K on x86, other 32-bit platforms, and x86-64. It is usually 16K on other 64-bit platforms.',
  default: '1k'
)

CLIENT_HEADER_BUFFER_SIZE = attribute(
  'client_header_buffer_size',
  description: 'Sets buffer size for reading client request header. For most requests, a buffer of 1K bytes is enough. However, if a request includes long cookies, or comes from a WAP client, it may not fit into 1K. If a request line or a request header field does not fit into this buffer then larger buffers, configured by the large_client_header_buffers directive, are allocated.',
  default: '1k'
)

LARGE_CLIENT_HEADER_BUFFER = attribute(
  'large_client_header_buffers',
  description: 'Sets the maximum number and size of buffers used for reading large client request header. A request line cannot exceed the size of one buffer, or the 414 (Request-URI Too Large) error is returned to the client. A request header field cannot exceed the size of one buffer as well, or the 400 (Bad Request) error is returned to the client. Buffers are allocated only on demand. By default, the buffer size is equal to 8K bytes. If after the end of request processing a connection is transitioned into the keep-alive state, these buffers are released.',
  default: '2 1k'
)

KEEPALIVE_TIMEOUT = attribute(
  'keepalive_timeout',
  description: 'The first parameter sets a timeout during which a keep-alive client connection will stay open on the server side. The zero value disables keep-alive client connections. The optional second parameter sets a value in the “Keep-Alive: timeout=time” response header field. Two parameters may differ.',
  default: '5 5'
)

CLIENT_BODY_TIMEOUT = attribute(
  'client_body_timeout',
  description: 'Defines a timeout for reading client request body. The timeout is set only for a period between two successive read operations, not for the transmission of the whole request body. If a client does not transmit anything within this time, the 408 (Request Time-out) error is returned to the client.',
  default: '10'
)

CLIENT_HEADER_TIMEOUT = attribute(
  'client_header_timeout',
  description: 'Defines a timeout for reading client request header. If a client does not transmit the entire header within this time, the 408 (Request Time-out) error is returned to the client.',
  default: '10'
)

SEND_TIMEOUT = attribute(
  'send_timeout',
  description: 'Sets a timeout for transmitting a response to the client. The timeout is set only between two successive write operations, not for the transmission of the whole response. If the client does not receive anything within this time, the connection is closed.',
  default: '10'
)

HTTP_METHODS = attribute(
  'http_methods',
  description: 'Specify the used HTTP methods',
  default: 'GET\|HEAD\|POST'
)

NGINX_CONFIG_PATH = attribute(
  'nginx_config_path',
  description: 'Path where nginx config file is installed',
  default: '/hab/svc/hab-webserver/config/nginx.conf'
)
NGINX_PATH = attribute(
  'nginx_path',
  description: 'Path where nginx config file is installed',
  default: '/etc/nginx'
)

# determine all required paths
nginx_path      = NGINX_PATH
nginx_conf      = NGINX_CONFIG_PATH
nginx_confd     = File.join(nginx_path, 'conf.d')
nginx_enabled   = File.join(nginx_path, 'sites-enabled')
nginx_hardening = File.join(nginx_confd, '90.hardening.conf')
conf_paths      = [nginx_conf, nginx_hardening]

options = {
  assignment_regex: /^\s*([^:]*?)\s*\ \s*(.*?)\s*;$/
}

options_add_header = {
  assignment_regex: /^\s*([^:]*?)\s*\ \s*(.*?)\s*;$/,
  multiple_values: true
}

control 'nginx-02' do
  impact 1.0
  title 'Check NGINX config file owner, group and permissions.'
  desc 'The NGINX config file should owned by root, only be writable by owner and not write- and readable by others.'
  describe file(nginx_conf) do
    it { should be_owned_by 'root' }
    it { should_not be_readable.by('others') }
    it { should_not be_writable.by('others') }
    it { should_not be_executable.by('others') }
  end
end

control 'nginx-05' do
  impact 1.0
  title 'Disable server_tokens directive'
  desc 'Disables emitting nginx version in error messages and in the “Server” response header field.'
  describe parse_config_file(nginx_conf, options) do
    its('server_tokens') { should eq 'off' }
  end
end

control 'nginx-06' do
  impact 1.0
  title 'Prevent buffer overflow attacks'
  desc 'Buffer overflow attacks are made possible by writing data to a buffer and exceeding that buffer boundary and overwriting memory fragments of a process. To prevent this in nginx we can set buffer size limitations for all clients.'
  describe parse_config_file(nginx_conf, options) do
    its('client_body_buffer_size') { should eq CLIENT_BODY_BUFFER_SIZE }
  end
  describe parse_config_file(nginx_conf, options) do
    its('client_max_body_size') { should eq CLIENT_MAX_BODY_SIZE }
  end
end


