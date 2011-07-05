#!/usr/bin/env ruby -wKU
# encoding: UTF-8


require "yaml"

## -----
def minify file
  %x[/usr/local/bin/yuicompressor #{file} -o #{file}.min --charset utf-8]
  out = File::read("#{file}.min")
  File::delete("#{file}.min")
  out
end

## process config file
yaml_config = ARGV[0] || 'default.yml'
unless File::exists? yaml_config
  p 'config does not exists'
  exit
end

config = YAML::load_file(yaml_config)
if config['scripts'].nil? && config['out'].nil?
  p 'wrong config format'
  exit
end

## -----
out_buffer = ''
work_dir = (File::dirname __FILE__) + "/"

config['scripts'].each do |item|
  file = work_dir + item['file']
  p file
  data = if item['min']
    minify file
  else
    File::read(file)
  end
  
  out_buffer << data
end

## write output
File::open(config['out'], 'w') do |f|
  f.write(out_buffer)
end

p 'Done!'

## enf of file