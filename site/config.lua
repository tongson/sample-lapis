local config = require("lapis.config")
config({"test","development"}, {
  secret = "xxx",
  hmac_digest = "sha256",
  session_name = "test",
})
config("production", {
  secret = "yyy",
  hmac_digest = "sha256",
  session_name = "prod",
})
