{Module}= require 'di'

module.exports= class Awesome extends Module

    constructor: (config= {}) ->
        super



        @factory 'Account', require './models/Account'
        @factory 'AccountGithub', require './models/Account/Github'

        @factory 'Group', require './models/Group'

        @factory 'Permission', require './models/Permission'

        @factory 'Profile', require './models/Profile'
        @factory 'ProfileGroup', require './models/ProfileGroup'
        @factory 'ProfilePermission', require './models/ProfilePermission'

        @factory 'ProfileSession', require './models/ProfileSession'



        @factory 'Audit', require './services/Audit'

        @factory '$audit', (Audit, log) ->
            $audit= new Audit config

            $audit.use (something, next) ->
                log 'Audit!', something
                do next

            $audit



        @factory 'Auth', require './services/Auth'

        @factory '$auth', (Auth) ->
            new Auth config



        @factory 'Authenticate', require './services/Authenticate'

        @factory '$authenticate', (Authenticate) ->
            new Authenticate config



        @factory 'Authorize', require './services/Authorize'

        @factory '$authorize', (Authorize) ->
            new Authorize config



        @factory 'Session', require './services/Session'

        @factory 'session', (Session) ->
            new Session



        #
        # Класс приложения Awesome API
        #
        @factory 'AwesomeApi', require './handlers/Api/V1'



        #
        # Экземпляр приложения аутентификации
        #
        @factory 'authentication', (AwesomeApi, $auth, AccountGithub, ProfileSession, db, log) ->
            app= new AwesomeApi

            ###
            Аутентифицирует пользователя с помощью Гитхаба.
            ###
            app.get '/auth/github'
            ,   $auth.authenticate('github')

            ###
            Аутентифицирует пользователя с Гитхаба.
            ###
            app.get '/auth/github/callback'
            ,   db.maria.middleware()
            ,   (req, res, next) ->

                    handler= $auth.authenticate 'github', (err, account, info) ->

                        account= AccountGithub.auth account, req.maria
                        account (account) ->
                                if not account
                                    return res.json 400, null

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

                        ,   (err) ->
                                next err

                    handler req, res, next

            app



        #
        # Экземпляр приложения Awesome API
        #
        # @version 1
        #
        @factory 'awesome', (AwesomeApi, $authorize, db, log, $audit, $authenticate) ->
            app= new AwesomeApi

            app.use db.redis.middleware
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



            app
