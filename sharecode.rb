require 'rubygems'
require 'nokogiri'
require 'mechanize'
require 'open-uri'

file = File.open(ARGV[0], "r")
fichier = file
fichier = fichier.read
agent = Mechanize.new
agent.get("http://www.paste2.org/")
agent.page.forms[0]["code"]=fichier
agent.page.forms[0]["lang"]="rb"
agent.page.forms[0]["lang"]="Code source bot.rb"
agent.page.forms[0].submit
url = agent.page.title
url = url.gsub("Paste2.org - Viewing Paste ", "")
url = "http://paste2.org/"+url
puts url
agent.page.save! 'test.html'