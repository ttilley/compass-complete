configuration do |c|
	c.project_name = "compass-complete"

	# The main ruby file to invoke, minus the .rb extension
	# default value: "main"
	#
	c.main_ruby_file = "main"

	# The fully-qualified name of the main Java file used to initiate the application.
	# default value: "org.rubyforge.rawr.Main"
	#
	c.main_java_file = "org.rubyforge.rawr.Main"

	# A list of directories where source files reside
	# default value: ["src"]
	#
	c.source_dirs = ["src", "vendor"]

	# A list of regexps of files to exclude
	# default value: []
	#
	c.source_exclude_filter = []

	# Whether Ruby source files should be compiled into .class files
	# default value: true
	#
	c.compile_ruby_files = true

	# A list of individual Java library files to include.
	# default value: []
	#
	c.java_lib_files = []

	# A list of directories for rawr to include . All files in the given directories get bundled up.
	# default value: ["lib/java"]
	#
	c.java_lib_dirs = ["lib/java"]

	c.target_jvm_version = 1.6

	c.jvm_arguments = ""

	c.java_library_path = ""

	# Undocumented option 'extra_user_jars'
	# default value: {}
	#
	#c.extra_user_jars[:data] = { :directory => 'data/images/png',
	#                             :location_in_jar => 'images',
	#                             :exclude => /*.bak$/ }

	# Undocumented option 'mac_do_not_generate_plist'
	# default value: nil
	#
	#c.mac_do_not_generate_plist = nil

	# Undocumented option 'mac_icon_path'
	# default value: nil
	#
	#c.mac_icon_path = nil

	# Undocumented option 'windows_icon_path'
	# default value: nil
	#
	#c.windows_icon_path = nil

end
