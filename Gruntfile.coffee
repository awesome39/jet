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

            views:
                files: [{
                    expand: true
                    ext: '.css'
                    src: ['**/*.less']
                    cwd: '<%= pkg.config.build.src.node %>/views/assets/styles'
                    dest: '<%= pkg.config.build.app.node %>/views/assets/styles'

                }]



        copy:

            scripts:
                files: [{
                    expand: true
                    src: ['**/*.js']
                    cwd: '<%= pkg.config.build.src.node %>/views/assets/scripts'
                    dest: '<%= pkg.config.build.app.node %>/views/assets/scripts'
                }]

            styles: # стили приложения
                files: [{
                    expand: true
                    src: ['**/*.css']
                    cwd: '<%= pkg.config.build.src.node %>/views/assets/styles'
                    dest: '<%= pkg.config.build.app.node %>/views/assets/styles'
                }]

            viewsAwesomeStyles: # осомный стиль
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

            sql:
                files: [{
                    expand: true
                    src: ['**/*.sql']
                    cwd: '<%= pkg.config.build.src.node %>/db/sql'
                    dest: '<%= pkg.config.build.app.node %>/db/sql'
                }]



         bower:
            install:
                options:
                    targetDir: '<%= pkg.config.build.src.node %>/views/assets/bower_components'
                    layout: 'byComponent'
                    install: true
                    cleanTargetDir: false
                    cleanBowerDir: true



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
    grunt.loadNpmTasks 'grunt-bower-task'
    grunt.loadNpmTasks 'grunt-yaml'



    # сборка шаблонов
    grunt.registerTask 'templates', ['clean:templates', 'jade']

    # сборка стилей
    grunt.registerTask 'styles', ['copy:styles', 'copy:viewsAwesomeStyles', 'less']

    # сборка скриптов
    grunt.registerTask 'scripts', ['clean:scripts', 'copy:scripts', 'copy:viewsAwesomeScripts', 'coffee:scripts']

    grunt.registerTask 'views', ['templates', 'styles', 'scripts']
    grunt.registerTask 'views-clean', ['clean:templates', 'clean:styles', 'clean:scripts']



    # сборка модулей
    grunt.registerTask 'node_modules', ['coffee:nodeModules']
    grunt.registerTask 'node_modules-clean', ['clean:nodeModules']



    # сборка приложения
    grunt.registerTask 'node', ['coffee:node']
    grunt.registerTask 'node-clean', ['clean:node'] #чистит все епта



    # сборка приложения
    grunt.registerTask 'app', ['yaml', 'coffee', 'jade', 'less', 'copy']
    grunt.registerTask 'app-clean' ['clean:all'] #чистит вобще все епта



    grunt.registerTask 'recompile', ['clean:node', 'node']



    grunt.registerTask 'default', ['app-clean', 'app']
