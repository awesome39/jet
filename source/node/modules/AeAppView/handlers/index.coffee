{resolve}= require 'path'

#
#
#
#
#
module.exports= (App, cfg, log) ->
    class AppView extends App

        constructor: () ->
            app= super



            app.set 'log', log= log.namespace '[AppView]'
            log 'construct...'



            for path in cfg.AppView.paths

                app.use path.route, App.static resolve path.path



            return app
