module.exports= (App, Account, AccountGithub, Group, Profile, ProfileSession, $audit, $auth, $authenticate, $authorize, db, log) ->
    class AwesomeApi extends App

        constructor: () ->
            app= super



            app.set 'log', log= log.namespace '[AwesomeApp]'
            log 'construct...'



            app.use db.redis.middleware()
            app.use db.maria.middleware()



            app.head '/users', (req, res) ->
                res.setHeader 'x-jetcraft-api', 'Awesome Users API'
                res.setHeader 'x-jetcraft-api-version', 1
                do res.end



            ###
            Отдает аутентифицированного пользователя.
            ###
            app.get '/user'
            ,   $authenticate('user')
            ,   $authorize('profile.select')
            ,   $audit('Get personal information')
            ,   (req, res, next) ->
                    req.profile (profile) ->
                            log 'profile resolved', profile
                            res.json profile
                    ,   (err) ->
                            log 'profile rejected', err
                            next err



            ###
            Отдает список пользователей.
            ###
            app.get '/users'
            ,   $authenticate('user')
            ,   $authorize('profiles.select')
            ,   $audit('Get personal information')

            ,   AwesomeApi.queryProfile()

            ,   (req, res, next) ->
                    req.profiles (profiles) ->
                            log 'profiles resolved', profiles
                            res.json profiles
                    ,   (err) ->
                            log 'profiles rejected', err
                            next err



            ###
            Добавляет пользователя.
            ###
            app.post '/users'
            ,   $authenticate('user')
            ,   $authorize('profiles.insert')
            ,   $audit('Add personal information')

            ,   db.maria.middleware.transaction()

            ,   AwesomeApi.createProfile()
            ,   AwesomeApi.createProfileEmails()
            ,   AwesomeApi.createProfilePhones()

            ,   db.maria.middleware.transaction.commit()

            ,   (req, res, next) ->
                    req.profile (profile) ->
                            log 'created profile resolved', profile
                            res.json 201, res.profile



            ###
            Отдает указанного пользователя.
            ###
            app.get '/users/:userId(\\d+)'
            ,   $authenticate('user')
            ,   $authorize('profiles.select')
            ,   $audit('Get personal information')

            ,   AwesomeApi.getProfile('userId')

            ,   (req, res, next) ->
                    req.profile (profile) ->
                            log 'selected profile resolved', profile
                            res.json profile
                    ,   (err) ->
                            log 'selected profile rejected', err
                            next err



            ###
            Обновляет указанного пользователя.
            ###
            app.post '/users/:userId(\\d+)'
            ,   $authenticate('user')
            ,   $authorize('profiles.update')
            ,   $audit('Upd personal information')

            ,   db.maria.middleware.transaction()

            ,   AwesomeApi.updateProfile('userId')
            ,   AwesomeApi.updateProfileEmails()
            ,   AwesomeApi.updateProfilePhones()

            ,   db.maria.middleware.transaction.commit()

            ,   (req, res, next) ->
                    req.profile (profile) ->
                            log 'updated profile resolved', profile
                            res.json profile
                    ,   (err) ->
                            log 'updated profile rejected', err
                            next err



            ###
            Удаляет указанного пользователя.
            ###
            app.delete '/users/:userId(\\d+)'
            ,   $authenticate('user')
            ,   $authorize('profiles.delete')
            ,   $audit('Del personal information')

            ,   AwesomeApi.deleteProfile('userId')

            ,   (req, res, next) ->
                    req.profile (profile) ->
                            log 'deleted profile resolved', profile
                            res.json profile



            ###
            Включает или выключает указанного пользователя.
            ###
            app.post '/users/:userId(\\d+)/enable'
            ,   $authenticate('user')
            ,   $authorize('profiles.enable')
            ,   $audit('Act personal information')

            ,   AwesomeApi.enableProfile('userId')

            ,   (req, res, next) ->
                    req.profile (profile) ->
                            log 'enabled profile resolved', profile
                            res.json profile
                    ,   (err) ->
                            log 'enabled profile rejected', err
                            next err



            app.post '/user/login'
            ,   AwesomeApi.authUser()
            ,   (req, res, next) ->
                    res.json req.account



            app.use (err, req, res, next) ->
                console.error err
                res.json
                    error: err.name
                    message: err.message
                ,   500



            return app



        @loadProfileSessions: (param) -> (req, res, next) ->
            profileId= req.param param

            req.profile= {}
            req.profile.sessions= ProfileSession.queryMaria profileId, req.query, req.maria
            req.profile.sessions (sessions) ->
                    res.sessions= sessions
                    next()
            ,   (err) ->
                    res.errors.push res.error= err
                    next(err)



        @authUser: () -> (req, res, next) ->
            handler= $auth.authenticate 'local', (err, account) ->
                if not account
                    return res.json 400, account
                account= Account.auth account, req.maria
                account (account) ->
                    if not account
                        return res.json 400, account
                    req.login account, (err) ->
                        headers= JSON.stringify
                            'referer': req.headers['referer']
                            'user-agent': req.headers['user-agent']
                            'accept': req.headers['accept']
                            'accept-encoding': req.headers['accept-encoding']
                            'accept-language': req.headers['accept-language']
                        session= ProfileSession.insertMaria req.account.profileId, req.sessionID, req.ip, headers, req.maria
                        session (session) ->
                                res.redirect '/'
                        ,   (err) ->
                                do req.logout
                                next err
            handler req, res, next



        @authUserGithub: () -> (req, res, next) ->
            handler= $auth.authenticate 'github', (err, account) ->
                account= AccountGithub.auth account, req.maria
                account (account) ->
                    if not account
                        res.json 400, account
                    else
                        req.login account, (err) ->
                            next err
            handler req, res, next



        @queryProfile: () -> (req, res, next) ->
            query= req.query
            req.profiles= Profile.query query, req.maria
            req.profiles (profiles) ->
                    res.profiles= profiles
                    next()
            ,   (err) ->
                    next(err)



        @getProfile: (param) -> (req, res, next) ->
            profileId= req.param param
            req.profile= Profile.getById profileId, req.maria
            req.profile (profile) ->
                    res.profile= profile
                    next()
            ,   (err) ->
                    next(err)



        @createProfile: () -> (req, res, next) ->
            req.profile= Profile.create req.body, req.maria
            req.profile (profile) ->
                    res.profile= profile
                    next()
            ,   (err) ->
                    next(err)

        @createProfileEmails: () -> (req, res, next) ->
            req.profile (profile) ->
                req.profile.emails= Profile.createEmails profile.id, req.body.emails or [], req.maria
                req.profile.emails (emails) ->
                        res.profile.emails= emails
                        next()
                ,   (err) ->
                        next(err)

        @createProfilePhones: () -> (req, res, next) ->
            req.profile (profile) ->
                req.profile.phones= Profile.createPhones profile.id, req.body.phones or [], req.maria
                req.profile.phones (phones) ->
                        res.profile.phones= phones
                        next()
                ,   (err) ->
                        next(err)



        @updateProfile: (paramProfileId) -> (req, res, next) ->
            profileId= req.param paramProfileId
            req.profile= Profile.update profileId, req.body, req.maria
            req.profile (profile) ->
                    res.profile= profile
                    next()
            ,   (err) ->
                    next(err)

        @updateProfileEmails: () -> (req, res, next) ->
            req.profile (profile) ->
                    req.profile.emails= Profile.updateEmails profile, req.body.emails or [], req.maria
                    req.profile.emails (emails) ->
                            profile.emails= emails
                            next()
                    ,   (err) ->
                            next(err)

        @updateProfilePhones: () -> (req, res, next) ->
            req.profile (profile) ->
                    req.profile.phones= Profile.updatePhones profile, req.body.phones or [], req.maria
                    req.profile.phones (phones) ->
                            profile.phones= phones
                            next()
                    ,   (err) ->
                            next(err)



        @deleteProfile: (paramProfileId) -> (req, res, next) ->
            profileId= req.param paramProfileId
            req.profile= Profile.delete profileId, req.maria
            req.profile (profile) ->
                    res.profile= profile
                    next()
            ,   (err) ->
                    if err instanceof Profile.delete.BadValueError then res.status 400
                    if err instanceof Profile.delete.NotFoundError then res.status 404
                    next(err)



        @enableProfile: (paramProfileId) -> (req, res, next) ->
            profileId= req.param paramProfileId
            req.profile= Profile.enable profileId, req.body.enabled, req.maria
            req.profile (profile) ->
                    res.profile= profile
                    next()
            ,   (err) ->
                    if err instanceof Profile.enable.BadValueError then res.status 400
                    if err instanceof Profile.enable.NotFoundError then res.status 404
                    next(err)



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
