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
agent.user_agent_alias = 'Mac Safari'
agent.page.forms[0]["email"]= pseudo
agent.page.forms[0]["pass"]= mdp
agent.page.forms[0]["serveur"]= 2
agent.page.forms[0]["connexion"]= "1"
agent.page.forms[0].submit
agent.get("http://www.3gm.fr/game/tchat.php")
puts "Connecté"
msg =""
while msg != "exit"
puts "Entrer un message :"
msg = gets.chomp #chomp supprime le \n en fin d'entrée
if msg != "exit"
agent.page.forms[1]["message"]=msg
agent.page.forms[1].submit
agent.get("http://www.3gm.fr/game/tchat.php")
end
end
