local lapis = require("lapis")
local app = lapis.Application()
local from_json = require("lapis.util").from_json
app:enable("etlua")
app.layout = require("views.layout")
app.handle_404 = function()
	return {
		status = 404,
		"not found!",
	}
end
local capture_errors_json = require("lapis.application").capture_errors_json
local json_params = require("lapis.application").json_params

app:get("/hello", function()
	return { render = "hello" }
end)

app:get("/layout", function(self)
	self.page_title = "Test Layout"
	return { render = "t_layout" }
end)

app:get("/param", function(self)
	local v = self.params.test
	return v
end)

app:match("/mparam/:match", function(self)
	local v = self.params.match
	return v
end)

app:match("/pparam/:this", function(self)
	return self.params.this
end)

app:match("named_route", "/named", function(self)
	return self:url_for("named_route2", { name = "Lua" })
end)

app:match("named_route2", "/user/:name", function(self)
	return "Hello " .. self.params.name .. ", go home: " .. self:url_for("named_route")
end)

app:post("/create", function(self)
        local t = from_json(self.params.item)
        return {
                json = t
        }
end)

app:get("/", function()
	return "Welcome to Lapis " .. require("lapis.version")
end)

app:get("/world", function()
	return { json = { success = true } }
end)

app:get("/form", function(self)
	local csrf = require("lapis.csrf")

	return {
		json = {
			csrf_token = csrf.generate_token(self),
		},
	}
end)

app:post(
	"/form",
	capture_errors_json(function(self)
		local csrf = require("lapis.csrf")
		csrf.assert_token(self)
		return {
			json = { success = true },
		}
	end)
)

app:match("/dump-params", function(self)
	return {
		json = self.params,
	}
end)

app:match(
	"/dump-json-params",
	json_params(function(self)
		return {
			json = self.params,
		}
	end)
)

return app
