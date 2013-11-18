{assert}= require 'chai'
request= require 'supertest'



Node= require '../../../../../app/node'
node= Node 'testing', require '../../../../../app/package.json'



describe 'HEAD /api/v1/users:', ->
    it 'should return api version in headers', (done) ->

        request(node)
            .head('/api/v1/users')

            .expect(200)
            .expect('x-jetcraft-api', /Users API/)
            .expect('x-jetcraft-api-version', '1')

            .end (err, res) ->
                done err



describe 'GET /api/v1/users should return users:', ->
    it 'should return users', (done) ->

        request(node)
            .get('/api/v1/users')

            .expect('Content-Type', /json/)
            .expect(200)

            .end (err, res) ->
                if err then return done err

                assert.isArray res.body, 'response body should be an array'
                assert.lengthOf res.body, 2, 'response body should contains users'

                done err



describe 'POST /api/v1/users should create user:', ->

    created= null

    it 'should return error if request cannot has `name`', (done) ->

        request(node)
            .post('/api/v1/users')
            .send({})

            .expect('Content-Type', /json/)
            .expect(500)

            .end (err, res) ->
                if err then return done err

                done err

    it 'should create user', (done) ->

        request(node)
            .post('/api/v1/users')
            .send({
                name: 'username'
                pass: 'password'
                })

            .expect('Content-Type', /json/)
            .expect(201)

            .end (err, res) ->
                if err then return done err

                assert.isObject res.body, 'response body should be an object'

                assert.deepProperty res.body, 'id'

                assert.deepPropertyVal res.body, 'name', 'username'
                assert.deepPropertyVal res.body, 'title', null

                assert.deepProperty res.body, 'emails'
                assert.isArray res.body.emails
                assert.lengthOf res.body.emails, 0

                assert.deepProperty res.body, 'phones'
                assert.isArray res.body.phones
                assert.lengthOf res.body.phones, 0

                assert.deepProperty res.body, 'accounts'
                assert.isArray res.body.accounts
                assert.lengthOf res.body.accounts, 0

                assert.deepProperty res.body, 'groups'
                assert.isArray res.body.groups
                assert.lengthOf res.body.groups, 0

                assert.deepProperty res.body, 'permissions'
                assert.isArray res.body.permissions
                assert.lengthOf res.body.permissions, 0

                assert.deepProperty res.body, 'updatedAt'
                assert.isNotNull res.body.updatedAt

                assert.deepProperty res.body, 'enabledAt'
                assert.isNull res.body.enabledAt

                created= res.body

                done err

    it 'should select created user', (done) ->

        request(node)
            .get('/api/v1/users/'+ created.id)

            .expect('Content-Type', /json/)
            .expect(200)

            .end (err, res) ->
                if err then return done err

                assert.isObject res.body, 'response body should be an object'

                assert.deepPropertyVal res.body, 'id', created.id

                assert.deepPropertyVal res.body, 'name', created.name
                assert.deepPropertyVal res.body, 'title', created.title

                assert.deepProperty res.body, 'emails'
                assert.isArray res.body.emails
                assert.lengthOf res.body.emails, 0

                assert.deepProperty res.body, 'phones'
                assert.isArray res.body.phones
                assert.lengthOf res.body.phones, 0

                assert.deepProperty res.body, 'accounts'
                assert.isArray res.body.accounts
                assert.lengthOf res.body.accounts, 0

                assert.deepProperty res.body, 'groups'
                assert.isArray res.body.groups
                assert.lengthOf res.body.groups, 0

                assert.deepProperty res.body, 'permissions'
                assert.isArray res.body.permissions
                assert.lengthOf res.body.permissions, 0

                assert.deepProperty res.body, 'updatedAt'
                assert.isNotNull res.body.updatedAt

                assert.deepProperty res.body, 'enabledAt'
                assert.isNull res.body.enabledAt

                done err

    it 'should select users with created user', (done) ->

        request(node)
            .get('/api/v1/users')

            .expect('Content-Type', /json/)
            .expect(200)

            .end (err, res) ->
                if err then return done err

                assert.isArray res.body, 'response body should be an array'
                assert.lengthOf res.body, 3, 'response body should contains users'

                assert.deepPropertyVal res.body, '0.id', created.id
                assert.deepPropertyVal res.body, '0.name', created.name

                done err

    it 'should delete created user', (done) ->

        request(node)
            .del('/api/v1/users/'+ created.id)

            .expect('Content-Type', /json/)
            .expect(200)

            .end (err, res) ->
                if err then return done err

                assert.isTrue res.body

                done err

    it 'should select users without deleted user', (done) ->

        request(node)
            .get('/api/v1/users')

            .expect('Content-Type', /json/)
            .expect(200)

            .end (err, res) ->
                if err then return done err

                assert.isArray res.body, 'response body should be an array'
                assert.lengthOf res.body, 2, 'response body should contains users'

                done err



describe 'GET /api/v1/users/:userId should select user:', ->

    it 'should select user', (done) ->

        request(node)
            .get('/api/v1/users/'+ 1)

            .expect('Content-Type', /json/)
            .expect(200)

            .end (err, res) ->
                if err then return done err

                assert.isObject res.body, 'response body should be an object'

                assert.deepPropertyVal res.body, 'id', 1

                assert.deepPropertyVal res.body, 'name', 'root'

                done err



describe 'POST /api/v1/users/:userId should update user:', ->

    it 'should update user', (done) ->

        request(node)
            .post('/api/v1/users/'+ 1)

            .send({
                title: 'Корневой администратор'
                })

            .expect('Content-Type', /json/)
            .expect(200)

            .end (err, res) ->
                if err then return done err

                assert.isObject res.body, 'response body should be an object'

                assert.deepPropertyVal res.body, 'id', 1

                assert.deepPropertyVal res.body, 'name', 'root'
                assert.deepPropertyVal res.body, 'title', 'Корневой администратор'

                done err

    it 'should update user again', (done) ->

        request(node)
            .post('/api/v1/users/'+ 1)

            .send({
                title: 'Главрут'
                })

            .expect('Content-Type', /json/)
            .expect(200)

            .end (err, res) ->
                if err then return done err

                assert.isObject res.body, 'response body should be an object'

                assert.deepPropertyVal res.body, 'id', 1

                assert.deepPropertyVal res.body, 'name', 'root'
                assert.deepPropertyVal res.body, 'title', 'Главрут'

                done err

    it 'should update user again', (done) ->

        request(node)
            .post('/api/v1/users/'+ 1)

            .send({
                title: 'Главрут'
                })

            .expect('Content-Type', /json/)
            .expect(200)

            .end (err, res) ->
                if err then return done err

                assert.isObject res.body, 'response body should be an object'

                assert.deepPropertyVal res.body, 'id', 1

                assert.deepPropertyVal res.body, 'name', 'root'
                assert.deepPropertyVal res.body, 'title', 'Главрут'

                done err
