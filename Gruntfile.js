'use strict';

var path = require('path')

module.exports = function (grunt) {

  [
    'grunt-contrib-coffee',
    'grunt-contrib-jade',
    'grunt-contrib-stylus',
    'grunt-exec',
    'grunt-regarde'
  ].forEach(grunt.loadNpmTasks);

  grunt.initConfig({
    exec: {
      app: {
        cmd: 'node app'
      }
    },

    watch: {
      stylus: {
        files: ['**/*.styl'],
        tasks: ['stylus']
      },
      jade: {
        files: ['**/*.jade'],
        tasks: ['jade']
      },
      coffee: {
        files: ['**/*.coffee'],
        tasks: ['coffee']
      }
    },

    coffee: {
      dist: {
        expand: true,
        cwd: 'src',
        src: ['**/*.coffee'],
        dest: 'dist',
        ext: '.js'
      }
    },

    jade: {
      compile: {
        options: {
          pretty: true
        },
        files: [
          {
            expand: true,
            cwd: 'src',
            src: '**/**.jade',
            dest: 'dist',
            ext: '.html'
          }
        ]
      }
    },

    stylus: {
      compile: {
        options: {
          'include css': true,
          'import': ['nib']
        },
        files: {
          'dist/main.css': ['src/styl/main.styl']
        }
      }
    }
  });

  grunt.renameTask('regarde', 'watch');
  grunt.registerTask('build', [
    'jade',
    'stylus',
    'coffee'
  ]);
  grunt.registerTask('default', [
    'build',
    'watch'
  ]);
};
