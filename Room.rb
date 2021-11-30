# Room.rb describes the Room class, used to contain the information of each room scraped.

# Created 2/12/2020 by Nina Yao
# Edited 2/16/2020 by Emily Niehaus
# Edited 2/20/2020 by Alli Hornyak - changes made based on Proj 2 comments
# Edited 2/20/2020 by Tze Hei Tam - Added method header for initialize
# Edited 2/16/2020 by Emily Niehaus - add type variable

class Room
	attr_accessor :name, :type, :comp_type, :seats, :attributes

	# Created 2/12/2020 by Nina Yao
	# Edited 2/16/2020 by Emily Niehaus - added type variable
=begin
	Initializes Room

	@updates - @name, @type, @comp_type, @seats, @attributes
=end
	def initialize(name)
		@name = name
		@type = nil
		@comp_type = nil
		@seats = nil
		@attributes = []
	end
end

