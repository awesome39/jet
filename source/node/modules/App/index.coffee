{Module}= require 'di'

App= require './models/App'

extend= require 'extend'
http= require 'http'

module.exports= class AppModule extends Module



    constructor: (config= {}, env= 'development') ->
        super



        @value 'config', config



        @factory 'log', () ->
            log= console.log
            log.namespace= (name) -> (args...) ->
                log name, args...
            log



        @factory 'App', () ->
            App



        @factory 'app', (App, config, log) ->
            app= new App
            app.set 'env', env

            cfg= config

            ###
            Конфиг приложения
            ###
            app.configure ->
                config= cfg.default or {}
                app.set 'config', config

            ###
            Конфиг приложения для разработчиков
            ###
            app.configure 'development', ->
                log 'configure for development'
                config= app.get 'config'
                extend true, config, cfg.development or {}

            ###
            Конфиг приложения для тестирования
            ###
            app.configure 'testing', ->
                log 'configure for testing'
                config= app.get 'config'
                extend true, config, cfg.testing or {}

            ###
            Конфиг приложения для производства
            ###
            app.configure 'production', ->
                log 'configure for production'
                config= app.get 'config'
                extend true, config, cfg.production or {}

            ###
            Логгер приложения
            ###
            app.configure ->
                app.set 'log', log

            ###
            Логгер приложения для разработки
            ###
            app.configure 'development', ->
                app.use App.logger 'dev'

            ###
            Логгер приложения для тестирования
            ###
            app.configure 'testing', ->
                app.use App.logger 'dev'

            app



        @factory 'cfg', (app) ->
            cfg= app.get 'config'



        @factory 'Error', () ->
            Error



        @factory 'srv', (app) ->
            srv= http.createServer app
            srv



        @factory 'Redis', require './mappers/Redis'
        @factory 'Maria', require './mappers/Maria'

        @factory 'db', (Redis, Maria, cfg, log) ->
            db= {}

            if cfg.db.maria
                db.maria= new Maria cfg.db.maria

            if cfg.db.redis
                db.redis= new Redis cfg.db.redis

            db
