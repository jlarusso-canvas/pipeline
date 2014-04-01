# Rakefile.rb

require 'rubygems'
require 'bundler/setup'
Bundler.require

def color(str)
  "\033[32m#{str}\033[0m"
end

task :default => ["assets:reset_compiled", "compile:compass", "compile:sprockets", "assets:copy", "assets:change_paths"]

namespace :compile do
  task :compass do
    # Use compass to convert `application.css.scss` -> `application.css`
    Compass.add_project_configuration(File.join('config', 'compass.rb'))

    puts color "Running `compass compile`"
    `compass compile`
  end

  task :sprockets do
    # Setup Sprockets asset paths
    assets = Sprockets::Environment.new
    assets.append_path 'original_assets/javascripts'
    assets.append_path 'original_assets/stylesheets'

    # Concatenate project files using manifest files in original_assets/
    puts color "Compiling javascript"
    javascript = assets['application.js'].to_s

    puts color "Compiling stylesheets"
    stylesheet = assets['application.css.scss'].to_s

    # Write files to compiled_assets
    puts color "Writing application.js"
    File.open('compiled_assets/javascripts/application.js', 'w') { |f| f.write(javascript) }

    puts color "Writing application.css.scss"
    File.open('compiled_assets/stylesheets/application.css', 'w') { |f| f.write(stylesheet) }
  end
end

namespace :assets do
  origin = 'original_assets/'
  target = 'compiled_assets/'

  task :reset_originals do
    puts color "Clearing out original assets"
    FileUtils.rm_rf Dir.glob("#{origin}*")
  end

  task :reset_compiled do
    puts color "Clearing out old compiled assets"
    FileUtils.rm_rf Dir.glob("#{target}*")
    FileUtils.rm Dir.glob("#{origin}/images/sprites/*.png")

    puts color "Creating directory structure"
    dirs = ["#{target}", "#{target}images", "#{target}fonts", "#{target}stylesheets", "#{target}javascripts"]
    dirs.each do |dir|
      unless File.directory?(dir)
        Dir.mkdir(dir)
      end
    end
  end

  task :copy do
    puts color "Copying font assets to compiled_assets/"
    FileUtils.cp_r(Dir["#{origin}fonts/**"],"#{target}fonts")

    puts color "Copying image assets to compiled_assets/"
    FileUtils.cp_r(Dir["#{origin}images/**"],"#{target}images")
  end

  ## This changes the path from "/images" and "/fonts" to "/content/images" and "/content/fonts" for non-sprited(non-compiled) images and fonts in the css.
  task :change_paths do
    puts color "Converting font and image paths"
    filepath = "compiled_assets/stylesheets/application.css"
    css = File.read(filepath)
    css = css.gsub(/url\("\/images/, "url(\"/content/images")
    css = css.gsub(/url\('\/images/, "url(\'/content/images")
    css = css.gsub(/url\('\/fonts/, "url(\'/content/fonts")
    css = css.gsub(/url\("\/fonts/, "url(\"/content/fonts")
    File.open(filepath, "w").write(css)
  end

end
