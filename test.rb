temps = "12 h 40 m 30 s"
temps = temps.gsub(" ", "")
temps = temps.split(/hms/)
puts "Heures : #{temps[0]}"
puts "Minutes : #{temps[1]}"
puts "Secondes : #{temps[2]}"
puts "Temps : #{temps}"

temps = "1 j 50 h 5 m 30 s"
temps = temps.gsub(" ", "").gsub("h", "|").gsub("min", "|").gsub("s", "|")
temps = temps.split("|")
tmp = 0
mul = 0
if (temps[3])
	tmp += temps[3].to_i
	mul += 1
end
if(temps[2])
	if (mul == 1)
		tmp += temps[2].to_i * 60
		mul += 1
	end 
	if (mul == 0)
		tmp += temps[2].to_i
		mul += 1 
	end
end
if (temps[1])
	if (mul == 2)
		tmp += temps[1].to_i * 3600
		mul += 1
	end
	if (mul == 1)
		tmp += temps[1].to_i * 60
		mul += 1
	end
	if (mul == 0)
		tmp += temps[1].to_i
		mul += 1
	end
end
if (temps[0])
	if (mul == 3)
		tmp += temps[0].to_i * 86400
	end
	if (mul == 2)
		tmp += temps[0].to_i * 3600
	end
	if (mul == 1)
		tmp += temps[0].to_i * 60
	end
	if (mul == 0)
		tmp += temps[0].to_i
	end
end
puts "___________________"
puts "s = #{tmp}"