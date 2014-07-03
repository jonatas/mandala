module.exports = (grunt) ->
  grunt.loadNpmTasks('grunt-contrib')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-watch')

  grunt.initConfig
    watch:
      coffee:
        files: 'js/*.coffee'
        tasks: ['coffee:compile']

    coffee:
      compile:
        expand: true,
        flatten: true,
        cwd: "#{__dirname}/js/",
        src: ['*.coffee'],
        dest: 'js/',
        ext: '.js'

  grunt.registerTask('default', ['coffee']);
