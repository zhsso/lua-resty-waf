use Test::Nginx::Socket::Lua;

repeat_each(3);
plan tests => repeat_each() * 3 * blocks();

no_shuffle();
run_tests();

__DATA__

=== TEST 1: load module
--- config
    location = /t {
        access_by_lua '
			FreeWAF = require "FreeWAF.fw"
        ';
		content_by_lua 'ngx.exit(ngx.HTTP_OK)';
    }
--- request
    GET /t
--- response_body
--- error_code: 200
--- no_error_log
[error]

=== TEST 2: new instance
--- config
    location = /t {
        access_by_lua '
			FreeWAF = require "FreeWAF.fw"
			local fw = FreeWAF:new()
        ';
		content_by_lua 'ngx.exit(ngx.HTTP_OK)';
    }
--- request
    GET /t
--- response_body
--- error_code: 200
--- no_error_log
[error]

=== TEST 3:do not load invalid module
--- config
    location = /t {
        access_by_lua '
			FreeWAF = require "FreeWAF.fw2"
        ';
		content_by_lua 'ngx.exit(ngx.HTTP_OK)';
    }
--- request
    GET /t
--- error_code: 500
--- error_log
[error]
fw2

