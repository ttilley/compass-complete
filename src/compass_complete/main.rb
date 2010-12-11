$main_file = __FILE__
$main_file_expanded = File.expand_path($main_file)
$main_dir = File.join($main_file, '..')
$main_dir_expanded = File.expand_path($main_dir) + '/'

$: << $main_dir_expanded

$system_vendor = ['bouncy-castle-java', 'jruby-openssl', 'rb-inotify']
$app_vendor = ['fssm', 'sass', 'chunky_png', 'compass']
$plugins_vendor = [
  'compass-960-plugin',
  'compass-susy-plugin',
  'fancy-buttons',
  'font-stack'
]

($system_vendor + $app_vendor + $plugins_vendor).each {|v| $: << "#{v}/lib"}
$app_vendor.each {|v| require v}

[
  'ninesixty',
  'susy',
  'fancy-buttons',
  'font-stack'
].each {|v| require v}


$bin_paths = {
  'compass' => 'compass/bin/compass',
  'sass' => 'sass/bin/sass',
  'sass-convert' => 'sass/bin/sass-convert'
}

begin
  first_arg = ARGV.shift

  if first_arg == '--as-irb'
    ARGV.clear
    require 'irb'
    IRB.start
  elsif first_arg == '--as'
    binary = ARGV.shift
    load $bin_paths[binary]
  else
    binary = 'compass'
    ARGV.unshift first_arg
    load $bin_paths[binary]
  end
rescue SystemExit
end
