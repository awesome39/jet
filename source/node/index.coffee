di= require 'di'

App= require './modules/App'
Awesome= require './modules/Awesome'

###
Возвращает настроенный экзмепляр приложения.
###
module.exports= (env, manifest, log) ->
    cfg= manifest.config
    log= log



    injector= new di.Injector [
        new App(env, manifest.config)
        new Awesome()
    ]



    injector.invoke (app, srv, log) ->
        app.set 'server', srv



    injector.invoke (app, App, db, log) ->
        app.set 'injector', injector

        app.use do App.compress

        app.use App.static "#{__dirname}/views/assets"



    injector.invoke (app, App, auth, session) ->
        app.use do App.cookieParser
        app.use do App.json

        app.use session.init
            key:'manage.sid', secret:'user'

        app.use do auth.init
        app.use do auth.sess



    injector.invoke (app, db, App, log) ->

        app.set 'db', db



        app.enable 'strict routing'



        app.get '/', (req, res, next) ->
            if do req.isAuthenticated
                res.redirect '/engine/'
            else
                res.redirect '/welcome/'

        app.get '/welcome', (req, res) -> res.redirect '/welcome/'



        app.get '/project', (req, res) -> res.redirect '/project/'
        app.get '/project/', (req, res, next) ->
            if do req.isAuthenticated
                do next
            else
                res.redirect '/welcome/'



        app.get '/engine', (req, res) -> res.redirect '/engine/'
        app.get '/engine/', (req, res, next) ->
            if do req.isAuthenticated
                do next
            else
                res.redirect '/welcome/'



        app.use App.static "#{__dirname}/views/templates/Manage"



        #
        # Обработчик Authentication API
        #
        app.use '/', injector.invoke (authentication) ->
            authentication



        #
        # Обработчик Awesome API
        #
        app.use '/api/v1', injector.invoke (awesome) ->
            awesome



        app
