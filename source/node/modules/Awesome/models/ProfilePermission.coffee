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
                ,   [@table, profileId, @Permission.Permission.tablePermission, name, @table]
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
