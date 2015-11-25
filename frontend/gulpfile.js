var gulp        = require('gulp');
var plugins     = require('gulp-load-plugins' )();
var sourcemaps  = require('gulp-sourcemaps');
var browserify  = require('browserify');
var babelify    = require('babelify');
var concat      = require('gulp-concat');
var browserSync = require('browser-sync').create();
var source      = require('vinyl-source-stream');
var buffer      = require('vinyl-buffer');

gulp.task('default', ['serve']);

gulp.task('sass', function() {
  gulp.src('assets/stylesheets/*.sass')
    .pipe(plugins.sourcemaps.init())
    .pipe(plugins.autoprefixer({ browsers: ['last 2 versions'], cascade: false }))
    .pipe(plugins.sass({ indentedSyntax: true, errLogToConsole: true, outputStyle: 'compressed' }))
    .pipe(plugins.inlineImage())
    .pipe(plugins.sourcemaps.write())
    .pipe(gulp.dest('../public/assets'))
    .pipe(browserSync.stream());
});

gulp.task('js', function () {
  browserify({entries: 'assets/javascripts/application.js', debug: true})
  .transform(babelify)
  .bundle()
  .pipe(source('application.js'))
  .pipe(buffer())
  .pipe(sourcemaps.init({ loadMaps: true }))
  .pipe(sourcemaps.write('.'))
  .pipe(gulp.dest('../public/assets'));
});

gulp.task('serve', ['sass', 'js'], function() {
  browserSync.init({
    server: "../public"
  });

   gulp.watch("assets/stylesheets/*.sass", ['sass']);
   gulp.watch("assets/javascripts/*.js", "assets/javascripts/**/*.js" ['js']).on('change', browserSync.reload);
   gulp.watch("../public/*.html").on('change', browserSync.reload);
});
