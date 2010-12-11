configuration do |c|
  c.project_name = "compass-complete"
  c.main_ruby_file = "compass_complete/main"
  c.main_java_file = "compass_complete.Main"
  c.source_dirs = ["src", "vendor"]

  c.source_exclude_filter = [
    /.*.gemspec$/,
    /.*.rdoc$/,
    /Rakefile/,
    /Gemfile.*/,
    /Manifest.*/,
    /fssm\/profile.*/,
    /fssm\/example.rb/,
    /sass\/vendor\/fssm/,
    /[^\/]*\/CONTRIBUTING.*/,
    /[^\/]*\/README.*/,
    /[^\/]*\/TODO.*/,
    /[^\/]*\/(MIT-)?LICENSE.*/,
    /[^\/]*\/License.*/,
    /[^\/]*\/History.*/,
    /[^\/]*\/(test|spec|features|tasks)/,
    /[^\/]*\/(yard|docs|doc-src|benchmarks|examples)/,
    /\/pkg\//
  ]

  c.compile_ruby_files = false
  c.java_lib_files = []
  c.java_lib_dirs = ["lib/java"]
  c.target_jvm_version = 1.6
  c.jvm_arguments = ""
  c.java_library_path = ""

  # Undocumented option 'extra_user_jars'
  # c.extra_user_jars[:data] = { :directory => 'data/images/png',
  #                             :location_in_jar => 'images',
  #                             :exclude => /*.bak$/ }

  #c.mac_do_not_generate_plist = nil
  #c.mac_icon_path = nil
  #c.windows_icon_path = nil

end
