#!/bin/env ruby
# encoding: utf-8
require 'rubygems'
require 'nokogiri'
require 'mechanize'
require 'open-uri'
#DEFINITIONS DE FONCTIONS POUR ALLEGER LE CODE
def connect()
	agent=Mechanize.new
	puts "Mechanize opened"
	agent.set_proxy('213.174.124.185', 3128)
	puts "Proxy setted" 
	file = File.open("../../dev/projets/3gmbot/ids.txt", "r")
	ids = file.read
	ids = ids.gsub("\n","")
	ids = ids.gsub(" ","")
	ids = ids.split(";")
	pseudo=ids[0]
	mdp=ids[1]
	puts "IDs read"
	agent.user_agent_alias='Mac Safari'
	puts "Safari opened"
	agent.get("http://www.3gm.fr/")
	puts "On 3GM ..."
	agent.page.forms[0]["email"]= "" #TODO set
	agent.page.forms[0]["pass"]= "" #TODO set
	agent.page.forms[0]["serveur"]= 2
	agent.page.forms[0]["connexion"]= "1"

	agent.page.forms[0].submit
	agent.get("http://www.3gm.fr/game/")
	puts "Connected"
	return agent
	end
def get_batiments_infos(agent)
	agent.page.search('.demi_bloc').each do |bloc|
	(bloc.at('.build_top_titre')) ? (nom = bloc.at('.build_top_titre').text) : (next) #Petite condition ternaire pour ne pas choper d'erreur si le bloc n'a pas de titre (batiment indisponible)
	(bloc.at('.build_top_niveau')) ? (niveau = bloc.at('.build_top_niveau').text) : (next) #idem
	(bloc.at(".btn_developper")) ? (dev = "DEVELOPPEMENT POSSIBLE !") : (dev = "")
	(bloc.at(".btn_arreter")) ? (dev = "EN COURS") : ()
	puts "#{nom}(#{niveau})  #{dev}"
	end
end
def get_all_infos(agent, urls)
	urls.each do |url|
		agent.get(url)
		get_batiments_infos(agent)
	end
end
#DEFINITION DES VARIABLES
agent = connect # = Client web
urls = ["http://www.3gm.fr/game/build.php","http://www.3gm.fr/game/production.php","http://www.3gm.fr/game/army.php","http://www.3gm.fr/game/troops.php"] # = urls contenant des elements a developper

#BIENVENUE
pseudo = agent.page.search('#header_player_info').at_css("div span").parent.text
pseudo = pseudo.gsub(agent.page.search('#header_player_info').at_css("div span").text, "")
# Ces deux lignes m'ont beaucoup de temps ! J'ai du chercher dans la doc de nokogiri : note personnel : ex de at_css : "div h" "h.bold" "div + p.green"
pseudo = pseudo.strip #"Clarification" du pseudo
puts "Bienvenue #{pseudo} !"
puts "Compte rendu de la base :"
get_all_infos(agent, urls)
input = ""
while input!="logout"
	puts "Que faire ?"
	input = gets.chomp
	case input 
		when "autobuild"
			while (1)
			urls.each do |url|
				agent.get(url)
				agent.page.search('.demi_bloc').each do |bloc|
					(bloc.at('.build_top_titre')) ? (nom = bloc.at('.build_top_titre').text) : (next) #Petite condition ternaire pour ne pas choper d'erreur si le bloc n'a pas de titre (batiment indisponible)
					(bloc.at('.build_top_niveau')) ? (niveau = bloc.at('.build_top_niveau').text) : (next) #idem
					(bloc.at(".btn_developper")) ? (dev = 1) : (next)
					#CONDITIONS
					niveau = niveau.to_i
					next if nom == "Parlement" && niveau >= 10
					next if nom == "Service interne" && niveau >= 10
					next if nom == "Ambassade" && niveau >= 10
					next if nom == "Marche mondial" && niveau >= 3
					next if nom == "Etat major" && niveau >= 5
					next if nom == "Laboratoire scientifique" && niveau >= 9
					next if nom == "Services secrets" && niveau >= 12
					next if nom == "Fonderie" && niveau >= 20
					next if nom == "Industrie chimique" && niveau >= 20
					next if nom == "Plate-forme petroliere" && niveau >= 20
					next if nom == "Usine" && niveau >= 20
					next if nom == "Entrepot" && niveau >= 6
					next if nom == "Camp militaire" && niveau >= 9
					next if nom == "Hangar" && niveau >= 9
					next if nom == "Chantier naval" && niveau >= 9
					next if nom == "Base aerienne" && niveau >= 9
					next if nom == "Mur" && niveau >= 5
					if (dev == 1)
						agent.click bloc.at(".btn_developper").parent
						puts "Développement de #{nom}(#{niveau}) lancé !"
						agent.get(url)
					end
				end
			end
			sleep 10
		end
		when "logout"
		when "home"
			get_all_infos(agent, urls)
		when "map"
			x=100
			y=100
			agent.get("http://www.3gm.fr/game/map.php?x=#{x}&y=#{y}")
			agent.page.search("#map_table").at(".map_tr").each do |ligne|
				x-=10
					ligne.at(".map_td").each do |cell|
							if cell.at(".actions_map").at("a")
								link = cell.at(".actions_map").at("a")["href"]
								link = link.gsub('mission.php?x', "")
								link = link.gsub('&y', "")
								link = link.gsub('&m')
								link = link.split("=")
								x = link[0]
								y = link[1]
								pseudo = cell.at(".infos_map")[1].text
								type = cell[2][0]["class"]
								if type=="map_city"
									type="BASE"
								end
								if type=="map_city_poste"
									type="PA"
								end
								print "[#{x};#{y}] #{pseudo} (#{type})"
	
						end
						x+=1
					end
				y+=1
			end

		else
			if (input.index('build') != nil && input!="autobuild")
				tobuild = input.gsub("build ","")
				finded = 0
				urls.each do |url|
					break if finded == 1
					agent.get(url)
					agent.page.search('.demi_bloc').each do |bloc|
						(bloc.at('.build_top_titre')) ? (nom = bloc.at('.build_top_titre').text) : (next) 
						if nom == tobuild
							(bloc.at('.build_top_niveau')) ? (niveau = bloc.at('.build_top_niveau').text) : ()
							(bloc.at(".btn_developper")) ? (dev = 1) : (dev = 0)
							if (dev == 1)
								agent.click bloc.at(".btn_developper").parent
								puts "Développement de #{nom}(#{niveau}) lancé !"
								finded = 1
								break
							else
								puts "La construction de #{tobuild} (analysé comme #{nom}) est impossible (le bouton de construction n'a pas été trouvé)"
								break
							end
						else
							next
						end
					end
				end
			else if (input.index('auto') != nil && input!="autobuild")
				toautobuild = input.gsub("auto ","")
				finded = 0
				urls.each do |url|
					agent.get(url)
					agent.page.search('.demi_bloc').each do |bloc|
						(bloc.at('.build_top_titre')) ? (nom = bloc.at('.build_top_titre').text) : (next)
						while (nom == toautobuild)
							agent.get(url)
							(bloc.at(".build_top_niveau")) ? (niveau = bloc.at('.build_top_niveau').text) : ()
							(bloc.at(".btn_developper")) ? (dev=1) : (dev=0)
							if dev==1
								agent.click bloc.at(".btn_developper").parent
								puts "Amélioration de #{toautobuild}(#{niveau})..."
							else
								sleep 10
							end
						end
					end
				end
			else
				puts "Commande inconnue, réessayez"
			end
		end
	end
end
