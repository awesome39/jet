{assert}= require 'chai'
request= require 'supertest'



Node= require '../../app/node'
node= Node 'testing', require '../../app/package.json'



describe 'HEAD /api/v1', ->
    it 'should return api version in headers', (done) ->

        request(node)
            .head('/api/v1')

            .expect(200)
            .expect('x-jetcraft-api', /Jetcraft API/)
            .expect('x-jetcraft-api-version', '1')

            .end (err, res) ->
                done err



describe 'HEAD /api/v1/tags', ->
    it 'should return api version in headers', (done) ->

        request(node)
            .head('/api/v1/tags')

            .expect(200)
            .expect('x-jetcraft-api', /Tags API/)
            .expect('x-jetcraft-api-version', '1')

            .end (err, res) ->
                done err



describe 'HEAD /api/v1/bukkit', ->
    it 'should return api version in headers', (done) ->

        request(node)
            .head('/api/v1/bukkit')

            .expect(200)
            .expect('x-jetcraft-api', /Bukkit API/)
            .expect('x-jetcraft-api-version', '1')

            .end (err, res) ->
                done err



describe 'HEAD /api/v1/bukkit/enchantments', ->
    it 'should return api version in headers', (done) ->

        request(node)
            .head('/api/v1/bukkit/enchantments')

            .expect(200)
            .expect('x-jetcraft-api', /BukkitEnchantments API/)
            .expect('x-jetcraft-api-version', '1')

            .end (err, res) ->
                done err



describe 'HEAD /api/v1/bukkit/materials', ->
    it 'should return api version in headers', (done) ->

        request(node)
            .head('/api/v1/bukkit/materials')

            .expect(200)
            .expect('x-jetcraft-api', /BukkitMaterials API/)
            .expect('x-jetcraft-api-version', '1')

            .end (err, res) ->
                done err



describe 'HEAD /api/v1/servers', ->
    it 'should return api version in headers', (done) ->

        request(node)
            .head('/api/v1/servers')

            .expect(200)
            .expect('x-jetcraft-api', /Servers API/)
            .expect('x-jetcraft-api-version', '1')

            .end (err, res) ->
                done err



describe 'HEAD /api/v1/servers/items should return api version in headers', ->
    it 'should be a function', (done) ->

        request(node)
            .head('/api/v1/servers/items')

            .expect(200)
            .expect('x-jetcraft-api', /ServersItems API/)
            .expect('x-jetcraft-api-version', '1')

            .end (err, res) ->
                done err



describe 'GET /api/v1/servers/server should return array', ->
    it 'should be a function', (done) ->

        request(node)
            .get('/api/v1/servers/server')

            .expect('Content-Type', /json/)
            .expect(200)

            .end (err, res) ->
                if err then return done err

                assert.isArray res.body

                done err
