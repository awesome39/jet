deferred= require 'deferred'

module.exports= (Permission, log) -> class ProfilePermission extends Permission
    @table= 'profile_permission'

    @Permission: Permission



    constructor: (data) ->

        @id= data.id
        @profileId= data.profileId
        @permissionId= data.permissionId

        @value= data.value

        @enabledAt= data.enabledAt
        @updatedAt= data.updatedAt





    @createByName: (profileId, name, db, done) ->
        dfd= do deferred

        process.nextTick =>
            try

                if not profileId
                    throw new @createByName.BadValueError 'profileId cannot be null'

                if not name
                    throw new @createByName.BadValueError 'name cannot be null'

                db.query """
                    INSERT
                        ??
                    SET
                        profileId= ?,
                        permissionId= (
                            SELECT
                                Permission.id

                            FROM
                                ?? AS Permission

                            WHERE
                                Permission.name = ?
                        )
                    ;

                    SELECT
                        ProfilePermission.*

                    FROM
                        ?? AS ProfilePermission

                    WHERE
                        ProfilePermission.id= LAST_INSERT_ID()
                    """
                ,   [@table, profileId, @Permission.tablePermission, name, @table]
                ,   (err, res) =>
                        if not err
                            if res[0].affectedRows == 1 and res[1].length == 1
                                data= new @ res[1][0]
                                dfd.resolve data
                            else
                                err= Error 'profile permission not created'
                        else
                            dfd.reject err

            catch err
                dfd.reject err

        dfd.promise

    @createByName.BadValueError= class CreateBadValueError extends Error
        constructor: (message) ->
            @message= message





    @enable: (id, enabled, db, done) ->
        dfd= do deferred
        try

            err= null
            if not id
                err= new @enable.BadValueError 'id cannot be null'

            enabled= enabled|0

            if err
                if done instanceof Function
                    process.nextTick ->
                        done err
                return dfd.reject err

            db.query """
                UPDATE
                    ??
                   SET
                    enabledAt= IF(?, IF(enabledAt, enabledAt, NOW()), NULL)
                 WHERE
                    id= ?
                ;
                SELECT
                    enabledAt
                  FROM
                    ??
                 WHERE
                    id= ?
                """
            ,   [@table, enabled, id, @table, id]
            ,   (err, res) =>

                if not err
                    enabledAt= res[1][0].enabledAt
                    enabled= !!enabledAt
                    dfd.resolve
                        enabledAt: enabledAt
                        enabled: enabled
                else
                    dfd.reject err

                if done instanceof Function
                    process.nextTick ->
                        done err, state

        catch err
            dfd.reject err

        dfd.promise

    @enable.BadValueError= class EnableBadValueError extends Error
        constructor: (message) ->
            @message= message

    @enable.NotFoundError= class EnableNotFoundError extends Error
        constructor: (message) ->
            @message= message
