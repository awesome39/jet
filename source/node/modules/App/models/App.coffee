express= require 'express'

module.exports= class App extends express

    constructor: () ->
        app= super
        @constructor.prototype.__proto__= app.__proto__
        app.__proto__= App.prototype

        return app
