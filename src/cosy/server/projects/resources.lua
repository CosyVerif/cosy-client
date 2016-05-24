local respond_to  = require "lapis.application".respond_to
local json_params = require "lapis.application".json_params
local Model       = require "cosy.server.model"
local Decorators  = require "cosy.server.decorators"

return function (app)

  app:match ("/projects/:project/resources", respond_to {
    HEAD = Decorators.param_is_project "project" ..
           function ()
      return { status = 204 }
    end,
    GET = Decorators.param_is_project "project" ..
          function (self)
      return {
        status = 200,
        json   = self.project:get_resources () or {},
      }
    end,
    POST = json_params ..
           Decorators.is_authentified ..
           Decorators.param_is_project "project" ..
           function (self)
      local resource = Model.resources:create {
        project_id  = self.project.id,
        name        = self.params.name,
        description = self.params.description,
      }
      return {
        status = 201,
        json   = resource,
      }
    end,
    OPTIONS = Decorators.param_is_project "project" ..
              function ()
      return { status = 204 }
    end,
    DELETE = Decorators.param_is_project "project" ..
             function ()
      return { status = 405 }
    end,
    PATCH = Decorators.param_is_project "project" ..
            function ()
      return { status = 405 }
    end,
    PUT = Decorators.param_is_project "project" ..
          function ()
      return { status = 405 }
    end,
  })

end
