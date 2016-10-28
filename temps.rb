old_time = Time.now
puts "Il est #{old_time.hour}h#{old_time.min}m#{old_time.sec}s"
time = Time.now
while (1)
	if(time.sec == old_time.sec + )
		old_time = time
		puts "Il est #{old_time.hour}h#{old_time.min}m#{old_time.sec}s"
	end
	if(time.sec - 10 < 0)
		if(time.sec == old_time.sec - 50)
			old_time = time
			puts "Il est #{old_time.hour}h#{old_time.min}m#{old_time.sec}s"
		end
	end
	sleep(1)
	time = Time.now
end