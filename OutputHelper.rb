# OutputHelper.rb contains functions handling output and some prompt features.

# Created 2/11/2020 by Alli Hornyak
# Edited 2/11/2020 by Emily Niehaus - created write_to_output
# Edited 2/12/2020 by Alli Hornyak - created get_input_match, modified write_to_output
# Edited 2/12/2020 by Emily Niehaus - modified get_input_match to use regex
# Edited 2/15/2020 by Nick Harvey - removed unused functions, added get_building_name
# Edited 2/16/2020 by Emily Niehaus - modified write_to_output to include room type
# Edited 2/16/2020 by Nina Yao - modified write_to_output to use filters
# Edited 2/17/2020 by Tze Hei Tam - restructured OutputHelper to ease testing
# Edited 2/18/2020 by Nick Harvey - code cleanup
# Edited 2/19/2020 by Emily Niehaus - modified get_line to return a string
# Edited 2/20/2020 by Alli Hornyak - code cleanup based on Proj2 comments
# Edited 2/20/2020 by Nick Harvey - code style cleanup
# Edited 2/11/2020 by Emily Niehaus - write data to console
# Edited 2/12/2020 by Alli Hornyak - move methods from main
# Edited 2/12/2020 by Emily Niehaus - create regex matching method
# Edited 2/15/2020 by Nick Harvey - removed unused functions, added get_building_name
# Edited 2/16/2020 by Emily Niehaus - add room type
# Edited 2/16/2020 by Nina Yao - add filtering
# Edited 2/17/2020 by Tze Hei Tam - restructured OutputHelper to ease testing
# Edited 2/18/2020 by Nick Harvey - code cleanup
# Edited 2/19/2020 by Emily Niehaus - change get_line method


# Created 2/15/2020 by Tze Hei Tam
# Edited 2/17/2020 by Tze Hei Tam - split get_building_names to allow use of rspec
class OutputHelper

	# Created 2/11/2020 by Emily Niehaus
	# Edited 2/11/2020 by Emily Niehaus (using code chunks from Tze Hei Tam)
	# Edited 2/12/2020 by Nina Yao - changed code to use Room class
	# Edited 2/12/2020 by Alli Hornyak - changed code to write to file
	# Edited 2/12/2020 by Alli Hornyak - moved from main
	# Edited 2/16/2020 by Emily Niehaus - Added room type
	# Edited 2/16/2020 by Nina Yao - changed code to use filters
	# Edited 2/18/2020 by Nick Harvey - removed unused code
	# Edited 2/20/2020 by Nick Harvey - removed new line, minor code tweaks
=begin
	Writes classroom information to desired output file

	@ requires - name of .txt file
=end
    def write_to_output(out, room, filters)
	    
	    # Output rooms of selected building				    
		out.puts room.name.upcase
		out.puts "Room type: #{room.type}"
		out.puts "Computer type: #{room.comp_type}" 
		out.puts "Number of Seats: #{room.seats}"
		out.puts 'Room features:'
		i = 0
		until i >= filters.length
			if room.attributes().include? filters[i]
				out.puts "\t- #{filters[i]}\n"
			end
			i+=1
		end
		out.puts(get_line)
    end

	# Created 2/12/2020 by Alli Hornyak
	# Edited 2/12/2020 by Emily Niehaus - transformed into a generic regex matching method
=begin
	Prompts a user for input and returns a valid response.

	@ requires - 
		prompt message (string), 
		regex of valid response (regex), 
		error message (string)

	@ returns - 
		valid chioce (string)
=end
    def get_input_match(prompt, regex, invalid_msg)
	    puts prompt
	    input = gets.chomp
	    until input.match regex
		    puts invalid_msg
		    puts prompt
		    input = gets.chomp
	    end
	    input
    end

	# Created 2/12/2020 by Emily Niehaus
	# Edited 2/19/2020 by Emily Niehaus - return a string instead of calling puts
=begin
	@returns a line seperator.
=end
    def get_line
	    '--------------------------------------------------------'
    end

	# Created 2/15/2020 by Nick Harvey
	# Edited 2/15/2020 by Tze Hei Tam - modified for multiple buildings
	# Edited 2/17/2020 by Tze Hei Tam - moved checking code to check_building_input
=begin
	Will prompt user for building names, check if exists, then return building array
	    
	@requires 
		prompt, TTY:Prompt - tty prompt object
		buildings, Array(String) - list of valid buildings
		max_bldgs, Integer - maximum number of buildings

	@returns
		matches, Array(String)
=end
    def get_building_names(prompt, buildings, max_bldgs)
	    loop do
			answer = prompt.ask('Enter the building names separated by commas: ')

			# Check for empty input
			if answer.nil?
				puts 'Empty input is invalid. Please try again.'
				next
			end

			# Keep asking for building names until input matching instructions is given 
		    matches = check_building_input answer, max_bldgs, buildings
			if matches  == -1
			    puts 'Invalid input. Too many buildings or invalid building name. Please try again.'
		    else
			    puts get_line
			    return matches
		    end
	    end
    end

	# Created 2/17/2020 by Tze Hei Tam
=begin
	Returns an array with names when given a string of building names or returns -1 if input is invalid
	
	@requires 
		input, String with length > 0 - input string with building names
		buildings, Array(String) - list of valid buildings
		max_bldgs, Integer - maximum number of buildings
=end
	def check_building_input(input, max_bldgs, buildings)
		return -1 if (input.match /^[\w][\w\s]*(\s*,\s*[\w][\w\s]*)*$/).nil?
		
		matches = input.scan /[\w][\w\s]*[\w]/
 	
		return -1 if !matches.all? { |match| buildings.include? match} || matches.length > max_bldgs || matches.length < 1
		
		# Return array if valid input
		matches
	end
end

