require 'fileutils'
require 'configuration'
require 'zip/zip'
require 'jar_builder'
require 'rawr'


class CompleteBuilder
  include FileUtils

  def deploy(options)
    @output_dir = options.output_dir
    @unpack_path = "#{@output_dir}/unpacked"
    @complete_path = "#{@output_dir}/complete"
    @project_name = options.project_name
    @base_jar_filename = options.base_jar_complete_path
    @project_unpack_path = "#{@unpack_path}/#{@project_name}"
    @complete_jar_filename = "#{@complete_path}/#{@project_name}.jar"
    @classpath = options.classpath
    @main_java_file = options.main_java_file
    @version = File.read('VERSION').strip

    @pack200 = `which pack200 2> /dev/null`.strip
    @advzip = `which advzip 2> /dev/null`.strip

    cleanup_paths
    unzip_files
    create_manifest
    create_complete_jar

    advzip_jar unless @advzip.empty?
    repack_jar unless @pack200.empty?
    advzip_jar unless @advzip.empty?
  end

  def advzip_jar
    advz = [@advzip, '-z', '-4'].join(' ')

    STDOUT.puts("=== Recompressing with:\n   #{advz}")
    Kernel.system(advz)
  end

  def repack_jar
    pack = [
      @pack200,
      '-J-Xms256m',
      '-J-Xmx1024m',
      '--repack',
      '--gzip',
      '--strip-debug',
      '--keep-file-order',
      '--segment-limit=-1',
      '--effort=9',
      '--deflate-hint=false',
      '--modification-time=latest',
      '--unknown-attribute=strip',
      '--verbose',
      "'#{@complete_jar_filename}'"
    ].join(' ')

    STDOUT.puts("=== Repacking jar file with:\n   #{pack}")
    Kernel.system(pack)
  end

  def create_complete_jar
    builder = Rawr::JarBuilder.new(@project_name, @complete_jar_filename, {
      :directory => @project_unpack_path})
    builder.build
    STDOUT.puts `pack200 --gzip --strip-debug --keep-file-order`
  end

  def create_manifest
    STDOUT.puts("=== Generating complete manifest")

    metainf_dir_path = File.join(@project_unpack_path, 'META-INF')
    manifest_path = File.join(metainf_dir_path, 'MANIFEST.MF')

    File.open(manifest_path, 'w+') do |manifest_file|
      manifest_file << <<-EOMM
Manifest-Version: 1.0
Built-By: #{`whoami`.strip}
Class-Path: .
Bundle-Version: #{@version}
Bundle-Name: CompassComplete
Main-Class: #{@main_java_file}
EOMM
    end
  end

  def cleanup_paths
    STDOUT.puts("=== Performing cleanup tasks")
    rm_rf @complete_path if File.exists? @complete_path
    rm_rf @unpack_path if File.exists? @unpack_path

    mkdir_p @complete_path
    mkdir_p @unpack_path
    mkdir_p @project_unpack_path
  end

  def unzip_files
    @classpath.each do |libpath|
      unzip_file libpath, @project_unpack_path
    end
    unzip_file @base_jar_filename, @project_unpack_path
  end

  def unzip_file(file, destination)
    STDOUT.puts("=== Unpacking jar #{file} to #{destination}")
    Zip::ZipFile.open(file) do |zip_file|
      zip_file.each do |f|
        f_path = File.join(destination, f.name)
        FileUtils.mkdir_p(File.dirname(f_path))
        zip_file.extract(f, f_path) unless File.exist?(f_path)
      end
    end
  end
end


desc "Combines the jar from rawr:jar and jruby-complete into a single dependency-free jar"
task :complete => ["rawr:jar"] do
  CompleteBuilder.new.deploy CONFIG
end

task :build => "rawr:jar"
task :clean => "rawr:clean"
task :jruby => "rawr:get:current-stable-jruby"

task :default => [:clean, :jruby, :build, :complete]

