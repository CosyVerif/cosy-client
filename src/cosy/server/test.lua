local In_test   = require "lapis.spec".use_test_env
local In_server = require "lapis.spec".use_test_server
local Jwt       = require "jwt"
local Time      = require "socket".gettime

local Test = {}

if os.getenv "RUN_COVERAGE" then
  Test.environment = {
    nginx   = false,
    app     = function ()
      return require "cosy.server"
    end,
    use     = function ()
      In_test ()
    end,
    request = function ()
      return require "lapis.spec.request".mock_request
    end,
  }
else
  Test.environment = {
    nginx   = true,
    app     = function ()
      return nil
    end,
    use     = function ()
      In_test   ()
      In_server ()
    end,
    request = function ()
      return function (_, ...)
        return require "lapis.spec.server".request (...)
      end
    end,
  }
end

-- Users Rahan and Naouna are supposed to exist, whereas Crao does not exist.
Test.identities = {
  rahan  = "github|1818862",
  crao   = "google-oauth2|103410538451613086005",
  naouna = "twitter|2572672862",
}

function Test.make_token (user_id)
  local Config = require "lapis.config".get ()
  local claims = {
    iss = "https://cosyverif.eu.auth0.com",
    sub = user_id,
    aud = Config.auth0.client_id,
    exp = Time () + 10 * 3600,
    iat = Time (),
  }
  return Jwt.encode (claims, {
    alg = "HS256",
    keys = { private = Config.auth0.client_secret }
  })
end

function Test.clean_db ()
  local Db = require "lapis.db"
  Db.delete "executions"
  Db.delete "identities"
  Db.delete "projects"
  Db.delete "resources"
  Db.delete "stars"
  Db.delete "tags"
  Db.delete "users"
end

return Test
