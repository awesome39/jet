{Module}= require 'di'

#
# App Authentication Module
#
# @author Michael F <tehfreak@awesome39.com>
#
module.exports= class AppAuthModule extends Module

    constructor: ->
        super



        #
        # Account Model
        #
        # @factory
        #
        @factory 'Account', require './models/Account'

        #
        # Group Model
        #
        # @factory
        #
        @factory 'Group', require './models/Group'

        #
        # Profile Model
        #
        # @factory
        #
        @factory 'Profile', require './models/Profile'

        #
        # Profile Group Model
        #
        # @factory
        #
        @factory 'ProfileGroup', require './models/ProfileGroup'

        #
        # Profile Session Model
        #
        # @factory
        #
        @factory 'ProfileSession', require './models/ProfileSession'

        #
        # Permission Model
        #
        # @factory
        #
        @factory 'Permission', require './models/Permission'

        #
        # Profile Permission Model
        #
        # @factory
        #
        @factory 'ProfilePermission', require './models/ProfilePermission'



        #
        # Authorize Service
        #
        # @factory
        #
        @factory 'Authorize', require './services/Authorize'

        #
        # Instance of Authorize Service
        #
        # @factory
        #
        @factory '$authorize', (Authorize) ->
            new Authorize



        #
        # Auth Service
        #
        # @factory
        #
        @factory 'Auth', require './services/Auth'

        #
        # Instance of Auth Service
        #
        # @factory
        #
        @factory '$auth', (Auth, $session) ->
            $auth= new Auth

            $auth.$session= $session

            $auth



        #
        # Auth Session Service
        #
        # @factory
        #
        @factory 'AuthSession', require './services/AuthSession'

        #
        # Instance of Auth Session Service
        #
        # @factory
        #
        @factory '$session', (AuthSession) ->
            new AuthSession



        #
        # Authenticate Service
        #
        # @factory
        #
        @factory 'Authenticate', require './services/Authenticate'

        #
        # Instance of Authenticate
        #
        # @factory
        #
        @factory '$authenticate', (Authenticate) ->
            new Authenticate



        @factory 'IsAuthenticateService', require './services/IsAuthenticate'

        @factory '$isAuthenticate', (IsAuthenticateService) ->
            new IsAuthenticateService



    #
    # Initialize module with injector.
    #
    # @public
    #
    init: (injector) ->

        injector.invoke (app, App, $auth) ->

            app.use do App.cookieParser
            app.use do App.json

            app.use $auth.$session.init
                key:'manage.sid', secret:'user'

            app.use do $auth.init
            app.use do $auth.sess
