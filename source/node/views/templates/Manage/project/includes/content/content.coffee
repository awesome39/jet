app= angular.module 'project.content', ['ngResource','ngRoute']





###

Ресурсы

###
# Модель материала.
app.factory 'Material', ($resource) ->
    $resource '/api/v1/bukkit/materials/:materialId', {},
        create:
            method: 'post'

        update:
            method: 'put'
            params:
                materialId: '@id'

        delete:
            method: 'delete'
            params:
                materialId: '@id'



# Модель чар.
app.factory 'Enchantment', ($resource) ->
    $resource '/api/v1/bukkit/enchantments/:enchantmentId', {},
        create:
            method: 'post'

        update:
            method: 'put'
            params:
                enchantmentId: '@id'

        delete:
            method: 'delete'
            params:
                enchantmentId: '@id'



# Модель тега
app.factory 'Tag', ($resource) ->
    $resource '/api/v1/tags/:tagId', {},
        create:
            method: 'post'

        update:
            method: 'put'
            params:
                tagId: '@id'

        delete:
            method: 'delete'
            params:
                tagId: '@id'



# Список серверов
app.factory 'ServerList', ($resource) ->
    $resource '/api/v1/servers/server'





###

Контроллеры

###
# Контроллер панели управления.
app.controller 'ContentDashboardCtrl', ($scope) ->
    $scope.state= 'loaded'



# Контроллер материалов баккита
app.controller 'ContentMaterialListCtrl', ($rootScope, $scope, Material, debug) ->
    if debug then debug.groupCollapsed('ContentMaterialListCtrl...')

    $scope.state= 'loaded'
    load= ->
        $scope.materials= Material.query ->
            null
        , (res) ->
            $rootScope.error= res

    do load

    $scope.showDetails= (material) ->
        if material
            $scope.view.dialog.materialId= material.id
        else
            $scope.view.dialog.materialId= null
        $scope.showViewDialog 'material'

    $scope.hideDetails= ->
        $scope.view.dialog.materialId= null
        do $scope.hideViewDialog

    $scope.reload= ->
        do load

    if debug then debug.groupEnd()


# Контроллер формы материала.
app.controller 'ContentMaterialDialogCtrl', ($rootScope, $scope, $location, Material) ->
    if $scope.view.dialog.materialId
        $scope.material= Material.get $scope.view.dialog, ->
            $scope.action= 'update'
        , (res) ->
            $rootScope.error= res
            do $scope.hideViewDialog
    else
        $scope.material= new Material
        $scope.action= 'create'


    # Действия
    $scope.create= ->
        $scope.material.$create ->
            $location.path '/content/materials/list'
        , (res) ->
            $rootScope.error= res

    $scope.update= ->
        $scope.material.$update ->
            $location.path '/content/materials/list'
        , (res) ->
            $rootScope.error= res

    $scope.delete= ->
        $scope.material.$delete ->
            $location.path '/content/materials/list'
        , (res) ->
            $rootScope.error= res



# Контроллер чар баккита
app.controller 'ContentEnchantmentListCtrl', ($rootScope, $scope, $location, Enchantment, debug) ->
    if debug then debug.groupCollapsed('ContentEnchantmentListCtrl...')

    $scope.state= 'loaded'

    load= ->
        $scope.enchantments= Enchantment.query ->
            null
        , (res) ->
            $rootScope.error= res

    do load

    $scope.showDetails= (enchantment) ->
        if enchantment
            $scope.view.dialog.enchantmentId= enchantment.id
        else
            $scope.view.dialog.enchantmentId= null
        $scope.showViewDialog 'enchantment'

    $scope.hideDetails= ->
        $scope.view.dialog.enchantmentId= null
        do $scope.hideViewDialog


    $scope.reload= ->
        do load

    if debug then debug.groupEnd()


# Контроллер формы чара.
app.controller 'ContentEnchantmentDialogCtrl', ($rootScope, $scope, $location, Enchantment) ->
    if $scope.view.dialog.enchantmentId
        $scope.enchantment= Enchantment.get $scope.view.dialog, ->
            $scope.action= 'update'
        , (res) ->
            $rootScope.error= res
            do $scope.hideViewDialog
    else
        $scope.enchantment= new Enchantment
        $scope.action= 'create'



    # Действия
    $scope.create= ->
        $scope.enchantment.$create ->
            $location.path '/content/enchantment/list'
        , (res) ->
            $rootScope.error= res

    $scope.update= ->
        $scope.enchantment.$update ->
            $location.path '/content/enchantment/list'
        , (res) ->
            $rootScope.error= res

    $scope.delete= ->
        $scope.enchantment.$delete ->
            $location.path '/content/enchantment/list'
        , (res) ->
            $rootScope.error= res



# Контроллер списка тегов.
app.controller 'ContentTagListCtrl', ($rootScope, $scope, Tag, debug) ->
    if debug then debug.groupCollapsed('ContentTagListCtrl...')

    $scope.state= 'loaded'

    load= ->
        $scope.tags= Tag.query ->
            null
        , (res) ->
            $rootScope.error= res

    do load

    $scope.showDetails= (tag) ->
        if tag
            $scope.view.dialog.tagId= tag.id
        else
            $scope.view.dialog.tagId= null
        $scope.showViewDialog 'tag'

    $scope.hideDetails= ->
        $scope.view.dialog.tagId= null
        do $scope.hideViewDialog


    $scope.reload= ->
        do load

    if debug then debug.groupEnd()


# Контроллер формы тега.
app.controller 'ContentTagDialogCtrl', ($rootScope, $scope, $location, Tag) ->
    if $scope.view.dialog.tagId
        $scope.tag= Tag.get $scope.view.dialog, ->
            $scope.action= 'update'
        , (res) ->
            $rootScope.error= res
            do $scope.hideViewDialog
    else
        $scope.tag= new Tag
        $scope.action= 'create'


    $scope.filterTag= (tag) ->
        show= true
        if $scope.tag.parentTags
            $scope.tag.parentTags.map (t) ->
                if t.id == tag.id
                    show= false

        return show

    $scope.addTag= (tag) ->
        newTag= JSON.parse angular.copy tag
        $scope.tag.parentTags= [] if not $scope.tag.parentTags
        $scope.tag.parentTags.push newTag

    $scope.removeTag= (tag) ->
        remPosition= null
        $scope.tag.parentTags.map (tg, i) ->
            if tg.id == tag.id
                $scope.tag.parentTags.splice i, 1

    # Действия
    $scope.create= ->
        $scope.tag.$create ->
            $location.path '/content/tag/list'
        , (res) ->
            $rootScope.error= res

    $scope.update= ->
        $scope.tag.$update ->
            $location.path '/content/tag/list'
        , (res) ->
            $rootScope.error= res

    $scope.delete= ->
        $scope.tag.$delete ->
            $location.path '/content/tag/list'
        , (res) ->
            $rootScope.error= res
