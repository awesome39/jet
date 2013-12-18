module.exports= (log) -> class AccessService

    constructor: () ->



        access= (role) -> (req, res, next) ->

            if req.isAuthenticated()
                req.profile (profile) ->
                        try
                            for permission in profile.permissions
                                continue if not permission.value
                                if ~role.search(new RegExp('^'+permission.name.replace('.','\\.')+'($|(\\.[a-z]+)+$)'))
                                    log 'ACCESS GRANTED with PERMISSION', permission
                                    return do next
                            return next Error 'Access denied.'
                        catch err
                            next err
                ,   (err) ->
                        next err

            else
                return next Error 'Access denied.'



        @constructor.prototype.__proto__= access.__proto__
        access.__proto__= AccessService.prototype

        return access

