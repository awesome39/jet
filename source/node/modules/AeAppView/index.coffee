{Module}= require 'di'
{resolve}= require 'path'
localConfig= require('./package.json').config

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
    init: (app, cfg, $cfgJoin, env, AppView) ->

        config= $cfgJoin cfg, localConfig, env


        app.set 'views', resolve config.AppView.views
        app.set 'view engine', 'jade'

        app.use config.AppView.route, new AppView config
