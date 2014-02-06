module.exports= (App, AwesomePermissionsApi, AwesomeProfileApi, AwesomeProfilesApi, Account, Group, ProfileSession, $audit, $auth, $authenticate, $authorize, db, log) ->
    class AwesomeApi extends App

        constructor: () ->
            app= super



            app.set 'log', log= log.namespace '[AwesomeApp]'
            log 'construct...'



            app.use db.redis.middleware()
            app.use db.maria.middleware()



            app.use '/permissions', new AwesomePermissionsApi

            app.use '/user', new AwesomeProfileApi

            app.use '/users', new AwesomeProfilesApi



            app.use (err, req, res, next) ->
                console.log "Error [#{err.name}]: #{err.message}"

                res.json
                    error: err.name
                    message: err.message
                ,   500



            return app



        @queryGroup: () -> (req, res, next) ->
            query= req.query

            req.groups= Group.query query, req.maria
            req.groups (groups) ->
                    res.groups= groups
            ,   (err) ->
                    res.errors.push res.error= err

            do next



        @updateAccount: () -> (req, res, next) ->
            accountId= req.user.id

            req.account= Account.update accountId, req.body, req.maria
            req.account (account) ->
                    res.account= account
            ,   (err) ->
                    res.errors.push res.error= err

            do next
