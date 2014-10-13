#!/bin/env ruby
# encoding: utf-8
require 'rubygems'
require 'nokogiri'
require 'mechanize'
require 'open-uri'
agent=Mechanize.new
curseur=Mechanize.new
file = File.open("../../dev/projets/3gmbot/ids.txt", "r")
ids = file.read
ids = ids.gsub("\n","")
ids = ids.gsub(" ","")
ids = ids.split(";")
pseudo=ids[0]
mdp=ids[1]
agent.get("http://www.3gm.fr/")
agent.page.forms[0]["email"]= pseudo
agent.page.forms[0]["pass"]= mdp
agent.page.forms[0]["serveur"]= 2
agent.page.forms[0]["connexion"]= "1"
agent.page.forms[0].submit
agent.get("http://www.3gm.fr/game/")
puts "Connecté"
input = ""
while(input!="quit")
puts "Entrer un URL pour le charger et voir les liens"
input = gets
input = input.gsub("\n", "")
if (input!="quit")
puts "URL demandé:"+input
input = input.gsub("http://www.3gm.fr/", "")
input = "http://www.3gm.fr/"+input
agent.get(input)
n = 0
agent.page.links.each do |link|
lien=link.text.gsub("\n","")
if(lien != "")
puts "#{n} : #{lien}"
end
n+=1
end
end
end

