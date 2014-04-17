module.exports = ( grunt ) ->

    sourceFiles = [ "./src/index.coffee" ]
    watchFiles  = [ "./src/**/*.coffee", "./src/**/*/js", "./src/**/*.html" ]

    # Project configuration
    #
    grunt.initConfig
        pkg:    grunt.file.readJSON( "package.json" )

        clean:
            dist:
                src: [ "dist" ]

            uglify:
                src: [ "dist/src/bundle.js" ]

        watch:
            src:
                files: watchFiles
                tasks: [ "browserify:watch", "copy:dist", "string-replace:debug" ]

        browserify:
            dist:
                files:
                    "dist/src/bundle.js": sourceFiles

                options:
                    browserifyOptions:
                        extensions:         [ ".coffee" ]

            debug:
                files:
                    "dist/src/bundle.js": sourceFiles

                options:
                    browserifyOptions:
                        extensions:         [ ".coffee" ]

                    bundleOptions:
                        debug:              true

            watch:
                files:
                    "dist/src/bundle.js": sourceFiles

                options:
                    watch:                  true

                    browserifyOptions:
                        extensions:         [ ".coffee" ]

                    bundleOptions:
                        debug:              true

        uglify:
            dist:
                files:
                    "dist/src/bundle.min.js": [ "dist/src/bundle.js" ]

        "string-replace":
            dist:
                files:
                    "dist/src/index.html": "src/index.html"
                options:
                    replacements: [
                        pattern:        "bundle.min.js"
                        replacement:    "bundle.min.js?build=" + ( grunt.option( "bambooNumber" ) or +( new Date() ) )
                    ]
            debug:
                files:
                    "dist/src/index.html": "src/index.html"
                options:
                    replacements: [
                        pattern:        "bundle.min.js"
                        replacement:    "bundle.js?build=" + ( grunt.option( "bambooNumber" ) or +( new Date() ) )
                    ]

        # Prepare the dist folder
        #
        copy:
            dist:
                files:
                    [
                        expand: true
                        cwd: "src"
                        src:
                            [
                                "**/*"
                                "!**/*.coffee"
                            ]
                        dest: "dist/src"
                    ,
                        expand: true
                        cwd: "src"
                        src:
                            [
                                "ses-configuration.json"
                            ]
                        dest: "dist"
                    ]



    # These plug-ins provide the necessary tasks
    #
    grunt.loadNpmTasks "grunt-browserify"
    grunt.loadNpmTasks "grunt-contrib-watch"
    grunt.loadNpmTasks "grunt-contrib-clean"
    grunt.loadNpmTasks "grunt-contrib-copy"
    grunt.loadNpmTasks "grunt-contrib-compress"
    grunt.loadNpmTasks "grunt-contrib-uglify"
    grunt.loadNpmTasks "grunt-string-replace"


    # Default tasks
    #
    grunt.registerTask "default",
    [
        "clean:dist"
        "browserify:dist"
        "uglify:dist"
        "clean:uglify"
        "copy:dist"
        "string-replace:dist"
    ]

    grunt.registerTask "debug",
    [
        "clean:dist"
        "browserify:debug"
        "copy:dist"
        "string-replace:debug"
    ]

