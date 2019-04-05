#!/usr/bin/ruby
# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    hercules_ceryneian_hind_jtaylor.rb                 :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jtaylor <marvin@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/03/15 09:11:23 by jtaylor           #+#    #+#              #
#    Updated: 2019/03/15 09:11:23 by jtaylor          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

require "oauth2"

#Create the client credintials (user id and secret key) + acess token;
$client = OAuth2::Client.new(
ENV['hercules_ceryneian_hind_uid'],
ENV['hercules_ceryneian_hind_secret'],
site: "https://api.intra.42.fr")
$token = $client.client_credentials.get_token

def check_user_position(login)
	begin
		response = $token.get("/v2/users/#{login}/locations")
		until response.status == 200
			puts ("No response from server, will try every 5 seconds")
			sleep (5)
			if response.status == 200
				break
			end
		end
		if !response.parsed[0]["end_at"]
			puts (login.ljust(10) + ": " + response.parsed[0]["host"])
		else
			puts (login.ljust(10) + ": not logged in silly")
			puts ("(last login -> " + response.parsed[0]["host"] + ")")
		end
	rescue
		#raise $!, "Invalid User or other error", $!.backtrace
		puts "Invalid User or other error"
	end
end


if ARGV[0]
	if File.file?(ARGV[0]) and File.extname(ARGV[0]) == ".txt"
		file = File.open(ARGV[0], "r").each_line do |line|
			line == "\n" ? next : login = line.strip
			check_user_position(login)
		end
		file.close
	else
		puts "Invalid file (\?)"
	end
else
	puts "Usage: " + $PROGRAM_NAME + " [file.txt]"
end
