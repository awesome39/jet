redis= require 'redis'

module.exports= () -> class RedisMapper



    constructor: (config) ->

        @client= redis.createClient config.port, config.host, config.options

        @client.on 'connect', () ->
            console.log 'redis connected', arguments

        @client.on 'error', () ->
            console.log 'redis error', arguments

        @middleware= (req, res, next) =>
            console.log 'db.redis middleware'
            req.redis= @
            do next
