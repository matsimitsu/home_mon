var gulp         = require('gulp');
var server       = require('gulp-server-livereload');
var config       = require('../config');

gulp.task('server', function() {
  gulp.src(config.destinationPathPublic)
  .pipe(server({livereload: true, open: true}))
})
