{assert}= require 'chai'
request= require 'supertest'



Node= require '../../../../../app/node'
node= Node 'testing', require '../../../../../app/package.json'



describe 'HEAD /api/v1/players', ->
    it 'should return api version in headers', (done) ->

        request(node)
            .head('/api/v1/players')

            .expect(200)
            .expect('x-jetcraft-api', /Players API/)
            .expect('x-jetcraft-api-version', '1')

            .end (err, res) ->
                done err



describe 'GET /api/v1/players/player should return players', ->
    it 'should return players', (done) ->

        request(node)
            .get('/api/v1/players/player')

            .expect('Content-Type', /json/)
            .expect(200)

            .end (err, res) ->
                if err then return done err

                assert.isArray res.body, 'response body should be an array'
                assert.lengthOf res.body, 2, 'response body should contains players'

                assert.deepPropertyVal res.body, '0.id', 1
                assert.deepPropertyVal res.body, '1.id', 2

                assert.deepPropertyVal res.body, '0.name', 'tehfreak'
                assert.deepPropertyVal res.body, '1.name', 'freekode'

                assert.deepPropertyVal res.body, '0.email', 'tehfreak@awesome39.com'
                assert.deepPropertyVal res.body, '1.email', 'freekode@awesome39.com'

                assert.deepPropertyVal res.body, '0.phone', '+71234567891'
                assert.deepPropertyVal res.body, '1.phone', '+71234567892'

                assert.deepProperty res.body, '0.createdAt'
                assert.deepProperty res.body, '1.createdAt'

                assert.deepProperty res.body, '0.enabledAt'
                assert.deepProperty res.body, '1.enabledAt'

                done err



describe 'POST /api/v1/players/player should create player', ->

    created= null

    it 'should return error if request cannot has `name`', (done) ->

        request(node)
            .post('/api/v1/players/player')
            .send({})

            .expect('Content-Type', /json/)
            .expect(500)

            .end (err, res) ->
                if err then return done err

                done err

    it 'should create player', (done) ->

        request(node)
            .post('/api/v1/players/player')
            .send({
                name: 'lol'
                pass: 'password'
                email: 'ololo@awesome39.com'
                phone: '+79876543210'
                })

            .expect('Content-Type', /json/)
            .expect(201)

            .end (err, res) ->
                if err then return done err

                assert.isObject res.body, 'response body should be an object'

                assert.deepProperty res.body, 'id'

                assert.deepPropertyVal res.body, 'name', 'lol'
                assert.deepPropertyVal res.body, 'email', 'ololo@awesome39.com'
                assert.deepPropertyVal res.body, 'phone', '+79876543210'
                #assert.deepProperty res.body, 'createdAt'
                #assert.deepProperty res.body, 'enabledAt'

                created= res.body

                done err

    it 'should select created player', (done) ->

        request(node)
            .get('/api/v1/players/player/'+ created.id)

            .expect('Content-Type', /json/)
            .expect(200)

            .end (err, res) ->
                if err then return done err

                assert.isObject res.body, 'response body should be an object'

                assert.deepPropertyVal res.body, 'id', created.id

                assert.deepPropertyVal res.body, 'name', created.name
                assert.deepPropertyVal res.body, 'email', created.email
                assert.deepPropertyVal res.body, 'phone', created.phone
                assert.deepProperty res.body, 'createdAt'
                #assert.deepProperty res.body, 'enabledAt'

                done err

    it 'should select players with created player', (done) ->

        request(node)
            .get('/api/v1/players/player')

            .expect('Content-Type', /json/)
            .expect(200)

            .end (err, res) ->
                if err then return done err

                assert.isArray res.body, 'response body should be an array'
                assert.lengthOf res.body, 3, 'response body should contains players'

                assert.deepPropertyVal res.body, '2.id', created.id
                assert.deepPropertyVal res.body, '2.name', created.name
                assert.deepPropertyVal res.body, '2.email', created.email
                assert.deepPropertyVal res.body, '2.phone', created.phone
                assert.deepProperty res.body, '2.createdAt'
                assert.deepProperty res.body, '2.enabledAt'

                done err

    it 'should delete created player', (done) ->

        request(node)
            .del('/api/v1/players/player/'+ created.id)

            .expect('Content-Type', /json/)
            .expect(200)

            .end (err, res) ->
                if err then return done err

                assert.isTrue res.body

                done err

    it 'should select players without deleted player', (done) ->

        request(node)
            .get('/api/v1/players/player')

            .expect('Content-Type', /json/)
            .expect(200)

            .end (err, res) ->
                if err then return done err

                assert.isArray res.body, 'response body should be an array'
                assert.lengthOf res.body, 2, 'response body should contains players'

                done err



describe 'GET /api/v1/players/player/:playerId should select player', ->

    it 'should select player', (done) ->

        request(node)
            .get('/api/v1/players/player/'+ 1)

            .expect('Content-Type', /json/)
            .expect(200)

            .end (err, res) ->
                if err then return done err

                assert.isObject res.body, 'response body should be an object'

                assert.deepPropertyVal res.body, 'id', 1

                assert.deepPropertyVal res.body, 'name', 'tehfreak'
                assert.deepPropertyVal res.body, 'email', 'tehfreak@awesome39.com'
                assert.deepPropertyVal res.body, 'phone', '+71234567891'
                assert.deepProperty res.body, 'createdAt'
                #assert.deepProperty res.body, 'enabledAt'

                done err



describe 'PATCH /api/v1/players/player/:playerId should update player', ->

    it 'should update player', (done) ->

        request(node)
            .patch('/api/v1/players/player/'+ 1)

            .send({
                email: 'michael@awesome39.com'
                })

            .expect('Content-Type', /json/)
            .expect(200)

            .end (err, res) ->
                if err then return done err

                assert.isObject res.body, 'response body should be an object'

                assert.deepPropertyVal res.body, 'id', 1

                assert.deepPropertyVal res.body, 'name', 'tehfreak'
                assert.deepPropertyVal res.body, 'email', 'michael@awesome39.com'
                assert.deepPropertyVal res.body, 'phone', '+71234567891'
                assert.deepProperty res.body, 'createdAt'
                #assert.deepProperty res.body, 'enabledAt'

                done err

    it 'should update player again', (done) ->

        request(node)
            .patch('/api/v1/players/player/'+ 1)

            .send({
                email: 'tehfreak@awesome39.com'
                })

            .expect('Content-Type', /json/)
            .expect(200)

            .end (err, res) ->
                if err then return done err

                assert.isObject res.body, 'response body should be an object'

                assert.deepPropertyVal res.body, 'id', 1

                assert.deepPropertyVal res.body, 'name', 'tehfreak'
                assert.deepPropertyVal res.body, 'email', 'tehfreak@awesome39.com'
                assert.deepPropertyVal res.body, 'phone', '+71234567891'
                assert.deepProperty res.body, 'createdAt'
                #assert.deepProperty res.body, 'enabledAt'

                done err

    it 'should update player again', (done) ->

        request(node)
            .patch('/api/v1/players/player/'+ 1)

            .send({
                email: 'tehfreak@awesome39.com'
                })

            .expect('Content-Type', /json/)
            .expect(200)

            .end (err, res) ->
                if err then return done err

                assert.isObject res.body, 'response body should be an object'

                assert.deepPropertyVal res.body, 'id', 1

                assert.deepPropertyVal res.body, 'name', 'tehfreak'
                assert.deepPropertyVal res.body, 'email', 'tehfreak@awesome39.com'
                assert.deepPropertyVal res.body, 'phone', '+71234567891'
                assert.deepProperty res.body, 'createdAt'
                #assert.deepProperty res.body, 'enabledAt'

                done err

    it 'should send 404 if player not found', (done) ->

        request(node)
            .patch('/api/v1/players/player/'+ 100500)

            .send({
                email: 'lol@awesome39.com'
                })

            .expect('Content-Type', /json/)
            .expect(404)

            .end (err, res) ->
                done err
