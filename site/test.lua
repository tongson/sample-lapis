local request = require("lapis.spec.request").mock_request
local config = require("lapis.config").get()
local app = require("app")
local T = require("u-test")
local expect = T.expect
local trve = T.is_not_nil
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
	trve(body:find("Welcome"))
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
	trve(body:find("Hello"))
end
local layout = function()
	local status, body = request(app, "/layout")
	expect(200)(status)
	trve(body:find("<title>Test Layout", 1, true))
	trve(body:find("Greetings"))
	trve(body:find("Lua"))
end
local param = function()
	local status, body = request(app, "/param?test=yoyoyo")
	expect(200)(status)
	trve(body:find("yoyoyo"))
end
local param_match = function()
	local status, body = request(app, "/mparam/xoxoxo")
	expect(200)(status)
	trve(body:find("xoxoxo"))
end
local param_precedence = function()
	local status, body = request(app, "/pparam/ccc?this=aaa")
	expect(200)(status)
	trve(body:find("ccc"))
end
local named_route = function()
	local status, body = request(app, "/named")
	expect(200)(status)
	trve(body:find("/user/Lua", 1, true))
	status, body = request(app, "/user/xxx")
	expect(200)(status)
	trve(body:find("Hello xxx"))
	trve(body:find("go home: /named", 1, true))
end
local handle_404 = function()
	local status, body = request(app, "/lolxror")
	expect(404)(status)
	trve(body:find("not found!", 1, true))
end
T["ngx global is a table"] = g_ngx
T["Picking up test config"] = cfg
T["root is returning correctly"] = root
T["/world is returning correctly"] = world
T["etlua is rendered"] = etlua
T["layout is rendered"] = layout
T["param is rendered"] = param
T["matching param works"] = param_match
T["route match has precedence"] = param_precedence
T["named route works"] = named_route
T["able to handle 404s"] = handle_404
T.summary()
