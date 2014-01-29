{Module}= require 'di'

module.exports= class Awesome extends Module



    constructor: (config= {}) ->
        super



        @config= @constructor.manifest.config or {}



        @factory 'Account', require './models/Account'
        @factory 'AccountGithub', require './models/Account/Github'

        @factory 'Group', require './models/Group'

        @factory 'Permission', require './models/Permission'

        @factory 'Profile', require './models/Profile'
        @factory 'ProfileGroup', require './models/ProfileGroup'
        @factory 'ProfilePermission', require './models/ProfilePermission'

        @factory 'ProfileSession', require './models/ProfileSession'



        @factory 'Audit', require './services/Audit'

        @factory 'Auth', require './services/Auth'
        @factory 'AuthSession', require './services/AuthSession'
        @factory 'Authenticate', require './services/Authenticate'
        @factory 'Authorize', require './services/Authorize'



        @factory '$audit', (Audit, log) ->
            $audit= new Audit config

            $audit.use (something, next) ->
                log 'Audit!', something
                do next

            $audit



        @factory '$auth', (Auth, $session) ->
            $auth= new Auth config

            $auth.$session= $session

            $auth



        @factory '$authenticate', (Authenticate) ->
            new Authenticate config



        @factory '$authorize', (Authorize) ->
            new Authorize config



        @factory '$session', (AuthSession) ->
            new AuthSession



        #
        # Класс приложения Awesome
        #
        @factory 'AwesomeApp', require './handlers'



        #
        # Класс приложения Awesome API
        #
        @factory 'AwesomeApi', require './handlers/Api/V1'



        #
        # Класс приложения Awesome Permissions API
        #
        @factory 'AwesomePermissionsApi', require './handlers/Api/V1/Permissions'



        #
        # Класс приложения Awesome Profile API
        #
        @factory 'AwesomeProfileApi', require './handlers/Api/V1/Profile'

        #
        # Класс приложения Awesome Profiles API
        #
        @factory 'AwesomeProfilesApi', require './handlers/Api/V1/Profiles'



        #
        # Экземпляр приложения Awesome
        #
        @factory 'awesome', (AwesomeApp) ->
            new AwesomeApp



        #
        # Экземпляр приложения Awesome API
        #
        # @version 1
        #
        @factory 'awesomeApi', (AwesomeApi) ->
            new AwesomeApi



    init: (log) ->

        log 'INIT MODULE'
