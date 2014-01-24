module.exports= (App, Account, AccountGithub, ProfileSession, $audit, $auth, $authenticate, $authorize, db, log) ->
    class AwesomeProfileApi extends App

        constructor: () ->
            app= super



            app.set 'log', log= log.namespace '[AwesomeProfileApi]'
            log 'construct...'



            ###
            Отдает манифест.
            ###
            app.head '/', (req, res) ->
                res.setHeader 'x-jet-api', 'Awesome Profile API'
                res.setHeader 'x-jet-api-version', 1
                do res.end



            ###
            Отдает аутентифицированного пользователя.
            ###
            app.get '/'
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



            app.post '/login'
            ,   AwesomeProfileApi.authUser()
            ,   (req, res, next) ->
                    res.json req.account



            return app



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