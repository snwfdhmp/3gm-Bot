#!/bin/env ruby
# encoding: utf-8
require 'rubygems'
require 'nokogiri'
require 'mechanize'
require 'open-uri'
agent=Mechanize.new
curseur=Mechanize.new
pseudo=ARGV[0]
mdp=ARGV[1]
n=0
agent.get("http://www.3gm.fr/")
agent.page.forms[0]["email"]= pseudo
agent.page.forms[0]["pass"]= mdp
agent.page.forms[0]["serveur"]= 2
agent.page.forms[0]["connexion"]= "1"
agent.page.forms[0].submit
agent.get("http://www.3gm.fr/game/")
agent.page.links.each do |link|
lien=link.text.gsub("\n","")
puts "#{n} : #{lien}"
n+=1
end
