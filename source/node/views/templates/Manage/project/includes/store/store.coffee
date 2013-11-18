app= angular.module 'project.store', ['project.content']





###

Ресурсы

###
# Модель предмета.
app.factory 'Item', ($resource) ->
    $resource '/api/v1/servers/item/:itemId', {},
        create:
            method: 'post'

        update:
            method: 'put'
            params:
                itemId: '@id'

        delete:
            method: 'delete'
            params:
                itemId: '@id'



# Модель материала.
app.factory 'MaterialList', ($resource) ->
    $resource '/api/v1/bukkit/materials/:materialId'



# Модель чар.
app.factory 'EnchantmentList', ($resource) ->
    $resource '/api/v1/bukkit/enchantments/:enchantmentId'



# Модель списка сероверов.
app.factory 'ServerList', ($resource) ->
    $resource '/api/v1/servers/server'



# Модель списка тегов.
app.factory 'TagList', ($resource) ->
    $resource '/api/v1/tags/server'





###

Контроллеры

###
# Контроллер панели управления.
app.controller 'StoreDashboardCtrl', ($scope) ->
    $scope.state= 'loaded'



# Контроллер списка предметов.
app.controller 'StoreItemListCtrl', ($rootScope, $scope, $location, Item, debug) ->
    if debug then debug.groupCollapsed('StoreItemListCtrl...')

    $scope.state= 'loaded'

    load= ->
        $scope.items= Item.query (items) ->
            for item in items
                for server in item.servers
                    server.abbr= 'L'
        , (res) ->
            $rootScope.error= res

    do load

    $scope.showDetails= (item) ->
        if item
            $scope.view.dialog.itemId= item.id
        else
            $scope.view.dialog.itemId= null
        $scope.showViewDialog 'item'

    $scope.hideDetails= ->
        $scope.view.dialog.itemId= null
        do $scope.hideViewDialog

    $scope.reload= ->
        do load

    if debug then debug.groupEnd()


# Контроллер формы предмета.
app.controller 'StoreItemDialogCtrl', ($rootScope, $scope, $route, $q, $location, Item, MaterialList, EnchantmentList, ServerList, TagList) ->

    $scope.materials= MaterialList.query ->
    $scope.enchantments= EnchantmentList.query ->
    $scope.servers= ServerList.query ->
    $scope.tags= TagList.query ->
    $scope.item= Item.get $scope.view.dialog, ->

    promise= $q.all
        materials: $scope.materials.$promise
        enchantments: $scope.enchantments.$promise
        servers: $scope.servers.$promise
        tags: $scope.tags.$promise

    promise.then (resolved) ->
            if $scope.view.dialog.itemId
                $scope.action= 'update'
            else
                $scope.action= 'create'
    ,   (error) ->
            $rootScope.error= error
            do $scope.hideViewDialog


    $scope.filterServer= (server) ->
        show= true
        if $scope.item.servers
            $scope.item.servers.map (srv) ->
                if srv.id == server.id
                    show= false

        return show


    # ищем теги подходящие выбранным серверам
    $scope.filterTag= (tag) ->
        show= false
        if $scope.item.servers
            $scope.item.servers.map (server) ->
                if tag.servers.indexOf(server.id) != -1
                    show= true

        if $scope.item.tags
            $scope.item.tags.map (t) ->
                if t.id == tag.id
                    show= false

        return show



    # при выборе материала подставляем назавание в соотвествующие поля
    $scope.changeMaterial= (material) ->
        $scope.item.material= JSON.parse(material).id
        $scope.item.titleRu= JSON.parse(material).titleRu
        $scope.item.titleEn= JSON.parse(material).titleEn


    $scope.addEnchantment= (enchantment) ->
        newEnchantment= JSON.parse angular.copy enchantment
        newEnchantment.level= 1
        $scope.item.enchantments= [] if not $scope.item.enchantments
        $scope.item.enchantments.push newEnchantment


    $scope.removeEnchantment= (enchantment) ->
        remPosition= null
        $scope.item.enchantments.map (ench, i) ->
            if ench.id == enchantment.id
                $scope.item.enchantments.splice i, 1


    $scope.addServer= (server) ->
        newServer= JSON.parse angular.copy server
        $scope.item.servers= [] if not $scope.item.servers
        $scope.item.servers.push newServer


    $scope.removeServer= (server) ->
        remPosition= null
        $scope.item.servers.map (srv, i) ->
            if srv.id == server.id
                $scope.item.servers.splice i, 1


    $scope.addTag= (tag) ->
        newTag= JSON.parse angular.copy tag
        $scope.item.tags= [] if not $scope.item.tags
        $scope.item.tags.push newTag


    $scope.removeTag= (tag) ->
        remPosition= null
        $scope.item.tags.map (t, i) ->
            if t.id == tag.id
                $scope.item.tags.splice i, 1


    # Действия
    $scope.create= ->
        $scope.item.$create ->
            $location.path '/store/items/list'
        , (res) ->
            $rootScope.error= res

    $scope.update= ->
        $scope.item.$update ->
            $location.path '/store/items/list'
        , (res) ->
            $rootScope.error= res

    $scope.delete= ->
        $scope.item.$delete ->
            $location.path '/store/items/list'
        , (res) ->
            $rootScope.error= res
