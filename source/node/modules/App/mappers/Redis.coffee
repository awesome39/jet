redis= require 'redis'

module.exports= (log) -> class RedisMapper



    constructor: (config) ->
        log= log.namespace '[RedisMapper]'
        log 'Created.', do process.hrtime

        @client= redis.createClient config.port, config.host, config.options

        @client.on 'connect', () ->
            log 'redis connected', arguments

        @client.on 'error', () ->
            log 'redis error', arguments

        @middleware= => (req, res, next) =>
            req.redis= @
            do next
