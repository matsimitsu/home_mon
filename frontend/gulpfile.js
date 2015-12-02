var gulp         = require('gulp');
var watch        = require('gulp-watch');
var gulpSequence = require('gulp-sequence');
var env          = require('gulp-env');
var requireDir   = require('require-dir');
var config       = require('./config');

requireDir('./tasks', { recurse: true });

// Development
gulp.task('watch', function(cb) {
  gulpSequence('clean', 'html', 'images', 'sass', 'javascript', cb);

  watch(config.html.src+'/*', function(cb) {
    gulp.start('html');
  });

  watch(config.images.src+'/**/*', function(cb) {
    gulp.start('images');
    gulp.start('sass');
  });

  watch(config.sass.src, function(cb) { gulp.start('sass'); });
  watch(config.javascript.src+'/**/*', function(cb) { gulp.start('javascript'); });
});

// Production build
gulp.task('set-env', function () {
  env({
    vars: {
      NODE_ENV: 'production'
    }
  })
});

gulp.task('build', function(cb) {
  var tasks = ['set-env', 'clean', 'fonts', 'images', 'sass', 'javascript'];
  tasks.push(cb);
  gulpSequence.apply(this, tasks);
});

gulp.task('default', ['watch', 'server']);
