#Pipeline
#####So you want to compile assets from a Rails project without Rails?<br />
#####You've come to the right place.<br />

- Pipeline uses Sprockets to help compile assets by using the manifest files in your Rails project:<br />
`assets/javascripts/application.js`<br />
`assets/stylesheets/application.css.scss`<br />

- Pipeline compiles CoffeeScript, SCSS, and uses Compass for spriting.<br />
<br />

####Setup:
- Clone this repository.
- Install [RVM](https://rvm.io/rvm/install) if you don't have it already. Windows users can follow this [tutorial](http://blog.developwithpassion.com/2012/03/30/installing-rvm-with-cygwin-on-windows/).
- Install Ruby 1.9.3-p484 if you don't have it already: `rvm install 1.9.3-p484`
- Install Bundler if you don't have it already: `gem install bundler`
- Run `bundle install` to install gem dependencies

<br />

####How to use:
- Copy Rails assets into the `original_assets/` directory
- After copying, you should have a structure similar to the following::<br />
`original_assets/`<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`↪ fonts/`<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`↪ images/`<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`↪ javascripts/`<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`↪ stylesheets/`<br />

- Run `rake` to compile the assets into the `compiled_assets/` directory.

<br />

####API:
Executing the `rake` command calls the following tasks in this order:<br />
`assets:reset_compiled`, `compile:compass`, `compile:sprockets`, `assets:copy`<br />
<br />
If you want more granular control, you may call the tasks manually.<br />

- `rake assets:reset_compiled` deletes everything in `compiled_assets`, deletes sprite files in `original_assets`, and rebuilds the directory structure if necessary.<br />

- `rake compile:compass` uses Compass to compile and generate sprites.<br />

- `rake compile:sprockets` compiles and concatenates stylesheets and javascripts using the Rails manifest files.<br />

- `rake assets:copy` copies font and image assets over to `compiled_assets/`<br />

- `rake assets:reset_originals` clears out the `original_assets` directory. Note: this task is not used in the default `rake` task. It is here for convenience.
