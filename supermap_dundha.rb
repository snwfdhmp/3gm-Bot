#Développé par snwfdhmp
#Langage : Ruby
#Version : 1.0 (Publiée le 11/10/14)
#Notes : Améliorations à venir ...
# ***********************
# * NOTES D'UTILISATION *
# 1. Créer un fichier dans le même répertoire nommé ids.txt, et présenté comme tel :
# pseudo;motdepasse;serveur
# 2. 
# 2. Exécuter avec la commande ruby nom_fichier.rb
# 3. Au bout d'environ 2 minutes le fichier map.txt est créé dans le répertoire
# ***********************
#

require 'rubygems'
require 'nokogiri'
require 'mechanize'
require 'open-uri'

agent=Mechanize.new
#agent.set_proxy('213.174.124.185', 3128)
debut = Time.now
file = File.open("ids.txt", "r")
ids = file.read
ids = ids.gsub("\n","")
ids = ids.gsub(" ","")
ids = ids.split(";")
pseudo=ids[0]
mdp=ids[1]
serveur=ids[2]
alliance_break=""
pseudo_break = ""
if (File.exist?("alliances.txt"))
	alliance_break = File.open("alliances.txt", "r").read.gsub("\n","").gsub(" ","").split(";")
	puts "Alliances à exclure :"
	alliance_break.each do |a|
		puts a
	end
else
	alliance_break = ""
end
if (File.exist?("pseudos.txt"))
	pseudo_break = File.open("pseudos.txt", "r").read.gsub("\n","").gsub(" ","").split(";")
	puts "Pseudos à exclure :"
	pseudo_break.each do |p|
		puts p
	end
else
	pseudo_break = ""
end

agent.user_agent_alias='Mac Safari'
agent.get("http://www.3gm.fr/")
agent.page.forms[0]["email"]= pseudo
agent.page.forms[0]["pass"]= mdp
agent.page.forms[0]["serveur"]= serveur
agent.page.forms[0]["connexion"]= "1"
agent.page.forms[0].submit
agent.get("http://www.3gm.fr/game/")
x=100
y=100
agent.get("http://www.3gm.fr/game/map.php?x=#{x}&y=#{y}")
nombre_bases = 0
puts "Scan en cours ..."
coordonnees = Array.new(1)
coograph = Array.new(1)
avancement = 0
while x < 311 do
agent.page.search('.map_td').each do |cell|
	if cell.at(".actions_map") != nil
		if cell.at(".actions_map").css("a")[2] != nil
		#pseudo = cell.css("div.infos_map").css("div")[2].text
		# type = "Unknown"
		# if cell.css("div")[2].matches?(".map_city")
		# 	puts "Base"
		# end
		#if cell.css("div")[2].css("div")[0].class == "map_city"
		#type="Base"
		#end
		#if cell.css("div")[2].css("div")[0].class == "map_city_poste"
		#type="PA"
		#end
		infos = cell.css("div.infos_map").text
		#infos = infos.gsub(" ", "")
		infos = infos.gsub("", "")
		infos = infos.gsub("\n","")
		infos = infos.gsub("\t", "")
		infos = infos.gsub("\r", "")
		infos = infos.split("  ")
		nom = infos[0]
		points = infos[1].split(")")[0]+")"
		pseudo = infos[1].split(")")[1]
		pseudo = pseudo.split(" ")
		if pseudo[1] != nil
		alliance = pseudo[1]
		if alliance_break != ""
			alliance_break.each do |a|
				next if alliance == a #ALLIANCES NON REFERENCEES
			end
		end
		alliance = " {"+alliance+"}"
		end
		pseudo = pseudo[0]
		if pseudo_break!=""
			pseudo_break.each do |p|
				next if pseudo==p  #PSEUDOS NON REFERENCIES
			end
		end
		link = cell.at(".actions_map").css("a")[2]["href"]
		link = link.gsub('mission.php?x', "")
		link = link.gsub('&y', "")
		link = link.gsub('&m', "")
		link = link.split("=")
		x_coor = link[1]
		y_coor = link[2]
		#puts "[#{x_coor};#{y_coor}] #{pseudo}#{alliance} #{points} : #{nom}"  #Activer pour un mode verbose
		coordonnees[nombre_bases] = "[#{x_coor}; #{y_coor}] #{pseudo}#{alliance} #{points} : #{nom}"
		coograph[nombre_bases] = "#{pseudo}\##{x_coor}\##{y_coor}"
		nombre_bases += 1
	end
	end
end
x+=10
if x == 300
	x=10
	y+=10
	if y==120||y==140||y==160||y==180||y==200||y==220||y==240||y==260||y==280||y==300
		avancement+=10
		puts "#{avancement}%"
	end
end
if y > 300
	x = 311
end
agent.get("http://www.3gm.fr/game/map.php?x=#{x}&y=#{y}")
end
fichier = File.open("map.txt", "w+") #Fichier directement dans le Drive
fichier.puts "Map scanner v1.0, par martinsurleweb. Derniere mise a jour du fichier : #{fichier.mtime}"
coofile = File.open("coographfile.txt", "w+")
coordonnees.each do |info|
	fichier.puts info
end
coograph.each do |info|
	coofile.puts info
end
fichier.puts "\n Nombre de bases scannees : #{nombre_bases}"
fin = Time.now
temps = fin-debut
puts "Temps : #{temps}"