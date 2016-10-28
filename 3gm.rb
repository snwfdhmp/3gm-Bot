require 'rubygems'
require 'nokogiri'
require 'mechanize'
require 'open-uri'

agent=Mechanize.new
puts "Mechanize opened"
#agent.set_proxy '78.186.178.153', 8080
file = File.open("ids.txt", "r")
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
agent.page.forms[0]["email"]= pseudo
agent.page.forms[0]["pass"]= mdp
agent.page.forms[0]["serveur"]= 2
agent.page.forms[0]["connexion"]= "1"
agent.page.forms[0].submit
agent.get("http://www.3gm.fr/game/")
puts "Connected"
x=100
y=100
agent.get("http://www.3gm.fr/game/map.php?x=#{x}&y=#{y}")
fichier = File.open("../Drive/map.txt", "w+") #Fichier directement dans le Drive
fichier.puts "Map screener, par snwhdhmp. Derniere mise a jour du fichier : #{fichier.mtime}"


while x < 311 do
agent.page.search('.map_td').each do |cell|
	if cell.at(".actions_map") != nil
		if cell.at(".actions_map").css("a")[2] != nil
		link = cell.at(".actions_map").css("a")[2]["href"]
		link = link.gsub('mission.php?x', "")
		link = link.gsub('&y', "")
		link = link.gsub('&m', "")
		link = link.split("=")
		x_coor = link[1]
		y_coor = link[2]
		pseudo = cell.css("div.infos_map").css("div")[2].text
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
		puts "[#{x_coor};#{y_coor}] #{pseudo}"
		fichier.puts "[#{x_coor};#{y_coor}] #{pseudo}"
	end
	end
end
x+=10
agent.get("http://www.3gm.fr/game/map.php?x=#{x}&y=#{y}")
if x == 300
	x=10
	y+=10
end
if y > 300
	x = 311
end
end