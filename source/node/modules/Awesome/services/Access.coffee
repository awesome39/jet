module.exports= (log) -> class AccessService

    constructor: () ->



        access= (role) -> (req, res, next) ->

            if req.isAuthenticated()
                log 'ACCESS CHECK for PROFILE', req.profile
                req.profile (profile) ->
                        try
                            console.log 'profile loaded', profile
                            for permission in profile.permissions
                                if permission.name == role
                                    log 'ACCESS GRANTED WITH PERMISSION', permission
                                    return do next
                            res.status 401
                            return next Error 'Access denied.'
                        catch err
                            next err
                ,   (err) ->
                        log 'cannot load profile', err
                        next err

            else
                return next 401



        @constructor.prototype.__proto__= access.__proto__
        access.__proto__= AccessService.prototype

        return access

