{Module}= require 'di'

#
# AppView Module
#
# @constructor
#
# @copyright Awesome39.com 2014
#
module.exports= class AppViewModule extends Module



    constructor: (config= {}) ->
        super

        #
        # App View Handler
        #
        @factory 'AppView', require './handlers'



    #
    # Initialize module with injector.
    #
    # @public
    #
    init: (app, cfg, AppView) ->

        app.use cfg.AppView.route, new AppView
