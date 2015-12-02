var gulp        = require('gulp');
var imagemin    = require('gulp-imagemin');
var pngquant    = require('imagemin-pngquant');
var rev         = require('gulp-rev');
var fingerprint = require('gulp-fingerprint');
var config      = require('../config');

gulp.task('images', function () {
  return gulp.src(config.images.src + '/**/*', {base: config.images.src})
    .pipe(rev())
    .pipe(imagemin({
      progressive: true,
      use: [pngquant()]
    }))
    .pipe(gulp.dest(config.images.dest))
    .pipe(rev.manifest())
    .pipe(gulp.dest(config.images.dest));
});
