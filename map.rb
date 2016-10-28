require 'rubygems'
require 'nokogiri'
require 'mechanize'
require 'open-uri'

def connect()
	agent=Mechanize.new
	puts "Mechanize opened"
	#agent.set_proxy '213.186.33.24', 80
	#puts "Proxy setted" 
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
	return agent
	end
	agent = connect
	x=100
	y=100
	agent.get("http://www.3gm.fr/game/map.php?x=#{x}&y=#{y}")
	map = agent.page.search("#map_table")
	map.at(".map_td").each do |cell|
		if cell.at(".actions_map") != nil #in `at': can't convert String into Integer 
			if cell.at(".actions_map").at("a") != nil
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
		end
	end
				