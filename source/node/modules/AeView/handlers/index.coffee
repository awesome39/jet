#
# Auth Service Factory
#
# @author Michael F <tehfreak@awesome39.com>
#
module.exports= (App, $isAuthenticate, $redirect, log) ->
    class AppView extends App

        constructor: ->
            app= super

            app.set 'log', log= log.namespace '[AppView]'
            log 'construct...'



            app.use App.static "#{__dirname}/../../../../pub/assets"



            app.get '/', $redirect '/welcome'

            # TODO не работает проверка, залогиненному говорит что нельзя
            app.get '/engine', $isAuthenticate('/')




            app.use App.static "#{__dirname}/../../../../pub/templates/Manage"



            return app
