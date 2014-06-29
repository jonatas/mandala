gulp       = require 'gulp'
gutil      = require 'gulp-util'
clean      = require 'gulp-clean'
coffee     = require 'gulp-coffee'

gulp.task 'clean', ->
  gulp.src('./js/app.js', read: false).pipe clean()

compile = (map) ->
  console.log("compiling")
  gulp.src('./js/*.coffee')
    .pipe coffee({sourceMap: map}).on('error', gutil.log)
    .pipe gulp.dest('./js/')

gulp.task 'watch', ->
  gulp.watch './js/*.coffee', -> compile(false)

gulp.task 'build', ['clean'], -> compile(true)

gulp.task 'default', ['clean', 'build', 'watch']
