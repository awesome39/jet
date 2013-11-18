app= angular.module 'project.servers', ['ngResource','ngRoute']





###

Ресурсы

###
# Модель сервера.
app.factory 'Server', ($resource) ->
    $resource '/api/v1/servers/server/:serverId', {},
        create:
            method: 'post'

        update:
            method: 'put'
            params:
                serverId: '@id'

        delete:
            method: 'delete'
            params:
                serverId: '@id'



# Модель инстанса.
app.factory 'Instance', ($resource) ->
    $resource '/api/v1/servers/instance/:instanceId', {},
        create:
            method: 'post'

        update:
            method: 'put'
            params:
                instanceId: '@id'

        delete:
            method: 'delete'
            params:
                instanceId: '@id'



# Cписок тегов
app.factory 'TagList', ($resource) ->
    $resource '/api/v1/tags'





###

Контроллеры

###
# Контроллер панели управления.
app.controller 'ServersDashboardCtrl', ($scope, debug) ->
    if debug then debug.groupCollapsed('ServersServerListCtrl...')

    $scope.state= 'loaded'

    if debug then debug.groupEnd()


# Контроллер списка серверов.
app.controller 'ServersServerListCtrl', ($route, $rootScope, $scope, Server, debug) ->
    if debug then debug.groupCollapsed('ServersServerListCtrl...')

    $scope.state= 'loaded'

    p= $route.current.params.page or ''
    p= p.replace /[^~]/g, ''
    p= p.length

    q= $route.current.params.query or null

    if debug then debug.log("Список серверов, запрос: #{q}, страница: #{p}")

    load= ->
        $scope.servers= Server.query ->
            null
        , (res) ->
            $rootScope.error= res

    do load

    $scope.reload= ->
        do load

    if debug then debug.groupEnd()



# Контроллер формы сервера.
app.controller 'ServersServerDialogCtrl', ($rootScope, $scope, $route, $location, Server, TagList) ->
    if $scope.view.dialog.serverId
        $scope.server= Server.get $scope.view.dialog, ->
            $scope.action= 'update'
        , (res) ->
            $rootScope.error= res
            do $scope.hideViewDialog
    else
        $scope.server= new Server
        $scope.action= 'create'


    $scope.tags= TagList.query ->
        null
    , (res) ->
        $rootScope.error= res


    $scope.filterTag= (tag) ->
        show= true
        if $scope.server.tags
            $scope.server.tags.map (t) ->
                if t.id == tag.id
                    show= false

        return show


    $scope.addTag= (tag) ->
        newTag= JSON.parse angular.copy tag
        $scope.server.tags= [] if not $scope.server.tags
        $scope.server.tags.push newTag


    $scope.removeTag= (tag) ->
        remPosition= null
        $scope.server.tags.map (tg, i) ->
            if tg.id == tag.id
                $scope.server.tags.splice i, 1


    # Действия
    $scope.create= ->
        $scope.server.$create ->
            $location.path '/servers/server/list'
        , (res) ->
            $rootScope.error= res

    $scope.update= ->
        $scope.server.$update ->
            $location.path '/servers/server/list'
        , (res) ->
            $rootScope.error= res

    $scope.delete= ->
        $scope.server.$delete ->
            $location.path '/servers/server/list'
        , (res) ->
            $rootScope.error= res




# Контроллер формы сервера.
app.controller 'ServersServerFormCtrl', ($rootScope, $scope, $route, $location, Server, TagList, debug) ->
    if debug then debug.groupCollapsed('ServersServerFormCtrl...')

    #$scope.showViewDialog 'server'
    #$scope.server= new Server
    #$scope.action= 'create'
    #$scope.tags= TagList.query ->
    #    null
    #, (res) ->
    #    $rootScope.error= res

    if debug then debug.groupEnd()




# Контроллер инстанса.
app.controller 'ServersInstanceListCtrl', ($rootScope, $scope, Instance, debug) ->
    if debug then debug.groupCollapsed('ServersInstanceListCtrl...')

    $scope.state= 'loaded'

    load= ->
        $scope.instances= Instance.query ->
            null
        , (res) ->
            $rootScope.error= res

    do load

    $scope.showDetails= (instance) ->
        if instance
            $scope.view.dialog.instanceId= instance.id
        else
            $scope.view.dialog.instanceId= null
        $scope.showViewDialog 'instance'

    $scope.hideDetails= ->
        $scope.view.dialog.instanceId= null
        do $scope.hideViewDialog

    $scope.reload= ->
        do load

    if debug then debug.groupEnd()


# Контроллер формы инстанса.
app.controller 'ServersInstanceDialogCtrl', ($rootScope, $scope, $route, $location, Instance, Server) ->
    if $scope.view.dialog.instanceId
        $scope.instance= Instance.get $scope.view.dialog, ->
            $scope.action= 'update'
        , (res) ->
            $rootScope.error= res
            do $scope.hideViewDialog
    else
        $scope.instance= new Instance
        $scope.action= 'create'


    $scope.servers= Server.query ->
        null
    , (res) ->
            $rootScope.error= res


    # Действия
    $scope.create= ->
        $scope.instance.$create ->
            $location.path '/servers/instance/list'
        , (res) ->
            $rootScope.error= res

    $scope.update= ->
        $scope.instance.$update ->
            $location.path '/servers/instance/list'
        , (res) ->
            $rootScope.error= res

    $scope.delete= ->
        $scope.instance.$delete ->
            $location.path '/servers/instance/list'
        , (res) ->
            $rootScope.error= res
