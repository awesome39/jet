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

            images:
                src: ['<%= pkg.config.build.app.node %>/views/i']



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

            viewsScripts:
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

            viewsTemplates:

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

            viewsStyles:
                files: [{
                    expand: true
                    ext: '.css'
                    src: ['**/*.less']
                    cwd: '<%= pkg.config.build.src.node %>/views/assets/styles'
                    dest: '<%= pkg.config.build.app.node %>/views/assets/styles'

                }]



        copy:

            viewsImages: # ресурсы видов
                files: [{
                    expand: true
                    src: ['**/*.*']
                    cwd: '<%= pkg.config.build.src.node %>/views/assets/i'
                    dest: '<%= pkg.config.build.app.node %>/views/assets/i'
                }]

            viewsScripts: # скрипты видов
                files: [{
                    expand: true
                    src: ['**/*.js']
                    cwd: '<%= pkg.config.build.src.node %>/views/assets/scripts'
                    dest: '<%= pkg.config.build.app.node %>/views/assets/scripts'
                }]

            viewsStyles: # стили видов
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
            main:
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
                tasks: ['jade']

            images:
                options:
                    event: ['added', 'deleted', 'changed']
                    cwd: '<%= pkg.config.build.src.node %>/views/assets/i'
                files: ['**/*.coffee']
                tasks: ['copy:viewsAwesomeImages', 'copy:viewsImages']

            styles:
                options:
                    event: ['added', 'deleted', 'changed']
                    cwd: '<%= pkg.config.build.src.node %>/views/assets/styles'
                files: ['**/*.less']
                tasks: ['copy:viewsAwesomeStyles', 'copy:viewsStyles', 'less']

            scripts:
                options:
                    event: ['added', 'deleted', 'changed']
                    cwd: '<%= pkg.config.build.src.node %>/views/assets/scripts'
                files: ['**/*.coffee']
                tasks: ['copy:viewsAwesomeScripts', 'copy:viewsScripts', 'coffee:scripts']




    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-copy'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-jade'
    grunt.loadNpmTasks 'grunt-contrib-less'
    grunt.loadNpmTasks 'grunt-bower-task'
    grunt.loadNpmTasks 'grunt-yaml'



    grunt.registerTask 'build', ['copy', 'yaml', 'coffee', 'jade', 'less']

    grunt.registerTask 'build-node', ['yaml', 'coffee:node']
    grunt.registerTask 'build-node-modules', ['yaml', 'coffee:nodeModules']

    grunt.registerTask 'build-views-images', ['copy:viewsAwesomeImages', 'copy:viewsImages']
    grunt.registerTask 'build-views-styles', ['copy:viewsAwesomeStyles', 'copy:viewsStyles', 'less']
    grunt.registerTask 'build-views-scripts', ['copy:viewsAwesomeScripts', 'copy:viewsScripts', 'coffee:viewsScripts']
    grunt.registerTask 'build-views-templates', ['jade']

    grunt.registerTask 'build-views', ['build-views-images', 'build-views-styles', 'build-views-scripts', 'build-views-templates']
