module.exports= (log) -> class AccessService

    constructor: () ->

        access= (role) -> (req, res, next) ->
            if req.isAuthenticated()
                req.profile (profile) ->
                    for permission in profile.permissions
                        if permission.name == role
                            log 'ACCESS GRANTED WITH PERMISSION', permission
                            return do next
                    return next 401
            else
                return next 401

        @constructor.prototype.__proto__= access.__proto__
        access.__proto__= AccessService.prototype

        return access

