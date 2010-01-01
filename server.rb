require "rubygems"
require "sinatra"
require "rackproxy"
 
begin
  require 'thin'
rescue LoadError
  puts 'Lose a little weight maybe?'
end

use Rack::Proxy do |req|
  if req.path =~ /(project.*)$/
    URI.parse("http://localhost:3000#{req.path}")
  end
end

get '/' do
  redirect '/index.html'
end
