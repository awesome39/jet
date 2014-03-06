{resolve}= require 'path'

#
#
#
#
#
module.exports= (App, log) -> class AppView extends App

    constructor: (config) ->
        app= super



        app.set 'log', log= log.namespace '[AppView]'
        log 'construct...'



        for path in config.AppView.paths

            app.use path.route, App.static resolve path.path



        return app
