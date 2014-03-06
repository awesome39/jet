{Module}= require 'di'
{Strategy}= require 'passport-github'
localConfig= require('./package.json').config

#
# App Authentication Github Module
#
# @author Michael F <tehfreak@awesome39.com>
#
module.exports= class AppAuthGithubModule extends Module

    constructor: (config= {}) ->
        super



        @config= @constructor.manifest.config or {}



        #
        # Account Github Model
        #
        # @factory
        #
        @factory 'AccountGithub', require './models/AccountGithub'



        #
        # App Authentication Github Handler
        #
        @factory 'AppAuthGithub', require './handlers'



    #
    # Initialize module with injector.
    #
    # @public
    #
    init: (injector, app) ->

        injector.invoke ($auth, cfg, $cfgJoin, env, AccountGithub) ->

            config= $cfgJoin cfg, localConfig, env

            $auth.use new Strategy

                clientID: config.auth.github.clientID
                clientSecret: config.auth.github.clientSecret

            ,   (accessToken, refreshToken, github, done) ->

                    done null, new AccountGithub
                        providerId: github.id
                        providerName: github.username

        app.use '/', injector.invoke (AppAuthGithub) ->
            new AppAuthGithub
