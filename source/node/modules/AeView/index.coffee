{Module}= require 'di'

#
# Db Module
#
# @author Michael F <tehfreak@awesome39.com>
#
module.exports= class ViewModule extends Module

    constructor: (config= {}, env= 'development') ->
        super



        @factory 'AppView', require './handlers/'



        @factory 'RedirectService', require './services/Redirect'

        @factory '$redirect', (RedirectService) ->
            new RedirectService


    #
    # Initialize module with injector.
    #
    # @public
    #
    init: (injector) ->

        injector.invoke (app, AppView) ->

            app.use '/', new AppView
