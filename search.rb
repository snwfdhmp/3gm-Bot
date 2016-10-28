require 'rubygems'
require 'nokogiri'
require 'mechanize'
require 'open-uri'

agent=Mechanize.new
#agent.set_proxy '78.186.178.153', 8080
debut = Time.now
file = File.open("ids.txt", "r")
ids = file.read
ids = ids.gsub("\n","")
ids = ids.gsub(" ","")
ids = ids.split(";")
pseudo=ids[0]
mdp=ids[1]
agent.user_agent_alias='Mac Safari'
agent.get("http://www.3gm.fr/")
agent.page.forms[0]["email"]= pseudo
agent.page.forms[0]["pass"]= mdp
agent.page.forms[0]["serveur"]= 2
agent.page.forms[0]["connexion"]= "1"
agent.page.forms[0].submit
agent.get("http://www.3gm.fr/game/")
x=100
y=100
agent.get("http://www.3gm.fr/game/map.php?x=#{x}&y=#{y}")
fichier = File.open("search.txt", "w+") #Fichier directement dans le Drive
fichier.puts "Map scanner v1.0.1, par snwfdhmp. Derniere mise a jour du fichier : #{fichier.mtime}"

nombre_bases = 0
avancement = 0
puts "Scan en cours ..."
coordonnees = Array.new(1)

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

		next if nom != "Avant-poste"

		points = infos[1].split(")")[0]+")"
		points_format = points
		points = points.gsub(/[^0-9]/,'').to_i
		
		next if points > 100000

		pseudo = infos[1].split(")")[1]
		pseudo = pseudo.split(" ")
		if pseudo[1] != nil
		alliance = pseudo[1]

		alliance = " {"+alliance+"}"
		end
		pseudo = pseudo[0]

		next if pseudo=="itubergames"  #PSEUDOS NON REFERENCIES
		next if pseudo=="athos"

		link = cell.at(".actions_map").css("a")[2]["href"]
		link = link.gsub('mission.php?x', "")
		link = link.gsub('&y', "")
		link = link.gsub('&m', "")
		link = link.split("=")
		x_coor = link[1]
		y_coor = link[2]
		#puts "[#{x_coor};#{y_coor}] #{pseudo}#{alliance} #{points} : #{nom}"
		coordonnees[nombre_bases] = "[#{x_coor}; #{y_coor}] #{pseudo}#{alliance} #{points_format} : #{nom}"
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
coordonnees.each do |info|
	fichier.puts info
end
fichier.puts "\n Nombre de bases scannees : #{nombre_bases}"
fin = Time.now
temps = fin-debut
puts "Temps : #{temps}"