require 'tempfile'
require 'rubygems'
require 'spec'

require File.join(File.dirname(__FILE__), 'custom_matchers')

RAILS_ROOT = File.expand_path(File.dirname(__FILE__)) unless defined?(RAILS_ROOT)
PUBLIC = File.expand_path(File.join(RAILS_ROOT, 'public')) unless defined?(PUBLIC)

def file_path( filename )
  File.join(File.dirname(__FILE__), 'fixtures', filename)
end

def public_path( filename )
  File.join(File.dirname(__FILE__), 'public', filename)
end

def stub_tempfile(filename, mime_type=nil, fake_name=nil)
  raise "#{path} file does not exist" unless File.exist?(file_path(filename))
  
  t = Tempfile.new(filename)
  FileUtils.copy_file(file_path(filename), t.path)
  
  t.stub!(:original_filename).and_return(fake_name || filename)
  t.stub!(:content_type).and_return(mime_type)
  t.stub!(:local_path).and_return(t.path)
  return t
end

def stub_stringio(filename, mime_type=nil, fake_name=nil)
  if filename
    t = StringIO.new( IO.read( file_path( filename ) ) )
  else
    t = StringIO.new
  end
  t.stub!(:local_path).and_return("")
  t.stub!(:original_filename).and_return(filename || fake_name)
  t.stub!(:content_type).and_return(mime_type)
  return t
end

def stub_file(filename, mime_type=nil, fake_name=nil)
  f = File.open(file_path(filename))
  f.stub!(:content_type).and_return(mime_type)
  f.stub!(:original_filename).and_return(fake_name) if fake_name
  return f
end