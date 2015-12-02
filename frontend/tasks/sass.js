var gulp         = require('gulp');
var sass         = require('gulp-sass');
var sourcemaps   = require('gulp-sourcemaps');
var autoprefixer = require('gulp-autoprefixer');
var fingerprint  = require('gulp-fingerprint');
var inlineImage  = require('gulp-inline-image');
var config       = require('../config');

gulp.task('sass', function () {
  return gulp.src(config.sass.src)
    .pipe(sourcemaps.init())
    .pipe(sass(config.sass.settings))
    .pipe(inlineImage())

    // Fingerprint images
    .pipe(fingerprint(config.images.manifest, {
      mode: 'replace',
      prefix: '/assets/images/'
    }))

    .pipe(autoprefixer({ browsers: ['last 2 version'] }))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest(config.sass.dest));
});
