module.exports= (grunt) ->
    grunt.initConfig
        pkg: grunt.file.readJSON 'package.json'



        clean:
            all:
                src: ['<%= pkg.config.build.app.root %>']

            node:
                src: ['<%= pkg.config.build.app.node %>']

            nodeModules:
                src: ['<%= pkg.config.build.app.nodeModules %>']

            templates:
                src: ['<%= pkg.config.build.app.node %>/views/templates']

            styles:
                src: ['<%= pkg.config.build.app.node %>/views/styles']

            scripts:
                src: ['<%= pkg.config.build.app.node %>/views/scripts']



        yaml:
            nodeManifest:
                options:
                    space: 4
                files:
                    '<%= pkg.config.build.app.root %>/package.json': '<%= pkg.config.build.src.root %>/package.yaml'



        coffee:
            # сборка модулей приложения, я хз почему это отдельно ну ок пока будет
            nodeModules:
                options:
                    bare: true
                files: [{
                    expand: true
                    ext: '.js'
                    src: ['**/*.coffee']
                    cwd: '<%= pkg.config.build.src.nodeModules %>'
                    dest: '<%= pkg.config.build.app.nodeModules %>'
                }]

            # сборка всего остального приложения, требуется перезапуск приложения
            node:
                options:
                    bare: true
                files: [{
                    expand: true
                    ext: '.js'
                    src: ['*.coffee']
                    cwd: '<%= pkg.config.build.src.node %>/'
                    dest: '<%= pkg.config.build.app.node %>/'
                }, {
                    expand: true
                    ext: '.js'
                    src: ['*.coffee']
                    cwd: '<%= pkg.config.build.src.root %>/'
                    dest: '<%= pkg.config.build.app.root %>/'
                }, {
                    expand: true
                    ext: '.js'
                    src: ['**/*.coffee']
                    cwd: '<%= pkg.config.build.src.node %>/handlers'
                    dest: '<%= pkg.config.build.app.node %>/handlers'
                }, {
                    expand: true
                    ext: '.js'
                    src: ['**/*.coffee']
                    cwd: '<%= pkg.config.build.src.node %>/models'
                    dest: '<%= pkg.config.build.app.node %>/models'
                }, {
                    expand: true
                    ext: '.js'
                    src: ['**/*.coffee']
                    cwd: '<%= pkg.config.build.src.node %>/modules'
                    dest: '<%= pkg.config.build.app.node %>/modules'
                }, {
                    expand: true
                    ext: '.js'
                    src: ['**/*.coffee']
                    cwd: '<%= pkg.config.build.src.node %>/db'
                    dest: '<%= pkg.config.build.app.node %>/db'
                }]

            scripts:
                options:
                    bare: true
                files: [{
                    expand: true
                    ext: '.js'
                    src: ['**/*.coffee']
                    cwd: '<%= pkg.config.build.src.node %>/views/assets/scripts'
                    dest: '<%= pkg.config.build.app.node %>/views/assets/scripts'
                }]



        jade:
            # все основные темплейты
            views:
                options:
                    data:
                        debug: false
                files: [{
                    expand: true
                    ext: '.html'
                    src: ['**/*.jade', '!**/layout.jade']
                    cwd: '<%= pkg.config.build.src.node %>/views/templates'
                    dest: '<%= pkg.config.build.app.node %>/views/templates'

                }]



        less:
            # стили приложения
            views:
                files: [{
                    expand: true
                    ext: '.css'
                    src: ['**/*.less']
                    cwd: '<%= pkg.config.build.src.node %>/views/assets/styles'
                    dest: '<%= pkg.config.build.app.node %>/views/assets/styles'

                }]



        copy:
            # скрипты могут быть тут
            scripts:
                files: [{
                    expand: true
                    src: ['**/*.js']
                    cwd: '<%= pkg.config.build.src.node %>/views/assets/scripts'
                    dest: '<%= pkg.config.build.app.node %>/views/assets/scripts'
                }]

            # стили приложения
            styles:
                files: [{
                    expand: true
                    src: ['**/*.css']
                    cwd: '<%= pkg.config.build.src.node %>/views/assets/styles'
                    dest: '<%= pkg.config.build.app.node %>/views/assets/styles'
                }]

            # копируем стиль осома
            viewsAwesomeStyles:
                files: [{
                    expand: true
                    src: ['**/*.css']
                    cwd: '<%= pkg.config.build.src.node %>/views/assets/bower_components/awesome/css'
                    dest: '<%= pkg.config.build.app.node %>/views/assets/styles'
                }]
            viewsAwesomeFont:
                files: [{
                    expand: true
                    src: ['**/*', '!**/*.json', '!**/*.md']
                    cwd: '<%= pkg.config.build.src.node %>/views/assets/bower_components/awesome/font'
                    dest: '<%= pkg.config.build.app.node %>/views/assets/font'
                }]
            viewsAwesomeImages:
                files: [{
                    expand: true
                    src: ['**/*', '!**/*.json', '!**/*.md']
                    cwd: '<%= pkg.config.build.src.node %>/views/assets/bower_components/awesome/i'
                    dest: '<%= pkg.config.build.app.node %>/views/assets/media'
                }]
            viewsAwesomeScripts:
                files: [{
                    expand: true
                    src: ['**/*.js']
                    cwd: '<%= pkg.config.build.src.node %>/views/assets/bower_components/awesome/js'
                    dest: '<%= pkg.config.build.app.node %>/views/assets/scripts'
                }]

            # дампы бд
            sql:
                files: [{
                    expand: true
                    src: ['**/*.sql']
                    cwd: '<%= pkg.config.build.src.node %>/db/sql'
                    dest: '<%= pkg.config.build.app.node %>/db/sql'
                }]



        # активное обновление
        watch:
            templates:
                options:
                    event: ['added', 'deleted', 'changed']
                    cwd: '<%= pkg.config.build.src.node %>/views/templates/'
                files: ['**/*.jade', '**/*.coffee']
                tasks: ['clean:templates', 'jade']

            styles:
                options:
                    event: ['added', 'deleted', 'changed']
                    cwd: '<%= pkg.config.build.src.node %>/views/assets/styles'
                files: ['**/*.less']
                tasks: ['clean:styles', 'copy:styles', 'copy:viewsAwesomeStyles', 'less']

            scripts:
                options:
                    event: ['added', 'deleted', 'changed']
                    cwd: '<%= pkg.config.build.src.node %>/views/assets/scripts'
                files: ['**/*.coffee']
                tasks: ['clean:scripts', 'copy:scripts', 'copy:viewsAwesomeScripts', 'coffee:scripts']





    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-copy'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-jade'
    grunt.loadNpmTasks 'grunt-contrib-less'
    grunt.loadNpmTasks 'grunt-yaml'



    # сборка шаблонов
    grunt.registerTask 'templates', ['clean:templates', 'jade']

    # сборка стилей
    grunt.registerTask 'styles', ['clean:styles', 'copy:styles', 'copy:viewsAwesomeStyles', 'less']

    # сборка скриптов
    grunt.registerTask 'scripts', ['clean:scripts', 'copy:scripts', 'copy:viewsAwesomeScripts', 'coffee:scripts']

    # только собирает приложение
    grunt.registerTask 'build', ['yaml', 'coffee', 'jade', 'less', 'copy']
    grunt.registerTask 'build-node', ['yaml', 'coffee']

    # собирает приложение когда все пакеты установлены, чистит только код
    grunt.registerTask 'compile', ['clean:node', 'build']
    grunt.registerTask 'compile-node', ['build-node']

    # стандартно собираем начисто!!! приложение
    grunt.registerTask 'default', ['clean:all', 'build']
