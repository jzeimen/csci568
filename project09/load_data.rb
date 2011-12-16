
require './active_record_classes.rb'

def load_data 

		
	puts "Cleaning..."
	Track.delete_all
	Genre.delete_all
	User.delete_all
	Trackrating.delete_all
	Genrerating.delete_all

	 puts "Loading genres..."
	 # loads genres into the database
	 File.open("track1/genreData1.txt").each do |record|
	 	Genre.create(:id => record)
	 end

	# puts "Loading artists..."
	# # loads artists into the database
	# File.open("track1/artistData1.txt").each do |record|
	# 	Artist.create(:id => record)
	# end

	# puts "Loading albums..."
	# # loads albums into the database
	# File.open("track1/albumData1.txt").each do |line|
	# 	tokens = line.split("|")
	# 	genres = tokens[2..tokens.length]

	# 	genres.map! {|g| Genre.find(g)}
	# 	Album.create(:id => tokens[0], :artist_id => tokens[1], :genres => genres)
	# end

	puts "Loading tracks..."
	 # loads tracks into the database
	 done  = 0
	File.open("track1/trackData1.txt").each do |line|
		tokens = line.split("|")
		genres = tokens[3..tokens.length]
		puts done if((done%1000)==0)

		done += 1
		genres.map! {|g| Genre.find(g)}
		Track.create(:id => tokens[0], :genres => genres)
	end

	puts "Loading users and ratings..."
	# Adds users and their ratings to the database
	userId = 0
	File.open("track1/trainIdx1.firstLines.txt").each do |line|
		tokens = line.split("|")
		if tokens.length == 2
			userId = tokens[0]
			User.create(:id => userId)
		else
			tokens = line.split(" ")
			#userId.map! {|u| User.find(u)}
			Trackrating.create(:user_id => userId, :rating => tokens[1], :track_id => tokens[0])
		end
	end

end


class Counts
	attr_accessor :ratings, :number

	def initialize
		@ratings = 0;
		@number = 0;
	end

	def average
		0.0+(@ratings/@number)
	end
	def insert(rating)
		@ratings+=rating
		@number+=1
	end
end


def calculate_genre_scores
	#For each user
	Genrerating.delete_all
	count =0;
	User.find(:all).each do |user|
		ratings_hash = Hash.new
		#for each rated track
		user.trackratings.each do |tr|

			next if !(tr.track)
			#for each genre in that track add the rating consideration

			track_genres = tr.track.genres

			track_genres.each do |genre|
				if ratings_hash.key?(genre.id)
					ratings_hash[genre.id].insert(tr.rating)
				else
					c = Counts.new
					c.insert(tr.rating)
					ratings_hash[genre.id]=c
				end
			end
		end

		ratings_hash.each do |genre, counts|
			Genrerating.create(:user_id=>user.id,:genre_id => genre, :rating=>counts.average)
			puts "inserted"
		end
		puts count
		count+=1
	end
end

















