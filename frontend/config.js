var sourcePath = '.';
var destinationPathPublic = '../public';

module.exports = {
  sourcePath: sourcePath,
  destinationPathPublic: destinationPathPublic,
  sass: {
    src: sourcePath + '/stylesheets/**/*.{sass,scss}',
    dest: destinationPathPublic + '/assets',
    settings: {
      indentedSyntax: true,     // enable .sass syntax
      outputStyle: 'extended'   // compress css
    }
  },
  html: {
    src: sourcePath + '/html',
    dest: destinationPathPublic,
  },
  images: {
    src: sourcePath + '/images',
    dest: destinationPathPublic + '/images',
  },
  javascript: {
    src: sourcePath + '/javascript',
    dest: destinationPathPublic + '/assets',
  }
};
