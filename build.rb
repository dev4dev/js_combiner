#!/usr/bin/env ruby -wKU
# encoding: UTF-8

scripts = [
  {
    :file => "file.min.js",
    :min => false, 
  },{
    :file => "file.js",
    :min => true
  }
]

def minify file
  %x[/usr/local/bin/yuicompressor #{file} -o #{file}.min --charset utf-8]
  out = File::read("#{file}.min")
  File::delete("#{file}.min")
  out
end

out_file = 'build.js'
out_buffer = ''
work_dir = (File::dirname __FILE__) + "/"

scripts.each do |item|
  file = work_dir + item[:file]
  p file
  data = if item[:min]
    minify file
  else
    File::read(file)
  end
  
  out_buffer << data
end


File::open(out_file, 'w') do |f|
  f.write(out_buffer)
end

p 'Done!'