var gulp        = require('gulp');
var plugins     = require('gulp-load-plugins' )();
var sourcemaps  = require('gulp-sourcemaps');
var browserify  = require('browserify');
var babelify    = require('babelify');
var source      = require('vinyl-source-stream');
var config       = require('../config');

gulp.task('javascript', function () {
  var b = browserify({entries: config.javascript.src + '/application.js', debug: true})
  .transform(babelify, {
      presets: ['es2015', 'react']
  })

  b.bundle()
  .on('error', function(err) {
    console.error(err.toString())
    this.emit("end")
  })
  .pipe(source('application.js'))
  .pipe(gulp.dest(config.javascript.dest));
});
