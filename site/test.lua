local request = require("lapis.spec.request").mock_request
local config = require("lapis.config").get()
local app = require("app")
local T = require("u-test")
local expect = T.expect
local json = require("cjson")
local g_ngx = function()
	expect("table")(type(ngx))
end
local cfg = function()
	expect("xxx")(config.secret)
	expect("test")(config.session_name)
	expect("sha256")(config.hmac_digest)
end
local root = function()
	local status, body = request(app, "/")
	expect(200)(status)
	T.is_not_nil(body:find("Welcome"))
end
local world = function()
	local status, body = request(app, "/world")
	expect(200)(status)
	local b = json.decode(body)
	expect(true)(b.success)
end
local etlua = function()
	local status, body = request(app, "/hello")
	expect(200)(status)
	T.is_not_nil(body:find("Hello"))
end
local layout = function()
	local status, body = request(app, "/layout")
	expect(200)(status)
	T.is_not_nil(body:find("<title>Test Layout", 1, true))
	T.is_not_nil(body:find("Greetings"))
	T.is_not_nil(body:find("Lua"))
end
T["ngx global is a table"] = g_ngx
T["Picking up test config"] = cfg
T["root is returning correctly"] = root
T["/world is returning correctly"] = world
T["etlua is rendered"] = etlua
T["layout is rendered"] = layout
T.summary()
