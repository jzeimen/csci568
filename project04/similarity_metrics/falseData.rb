PEOPLE = %w(Joe Andy Nick Lydia Ada )


MJSONGS = [ 
	"Thriller",
	"Beat It",
	"Billie Jean",    									
	"Pretty Young Thing",    									
	"Don't Stop 'Til You Get Enough",    									
	"Man in the Mirror",    									
	"Smooth Criminal",    									
	"The Way You Make Me Feel",    									
	"Rock With You",    									
	"Human Nature",    									
	"Wanna Be Startin' Somthin'",    									
	"Bad",    									
	"Black or White",    									
	"Ben",    									
	"Heal the World"
]

NO_SONGS = 2
POSSIBLE_SONG_COUNTS = (1..50).to_a

def get_song_counts() 
	{}.tap do |song_counts|	
		PEOPLE.each do |person|
			song_counts[person] = {}.tap do |counts|
				MJSONGS.sort_by{ rand }.slice(0...NO_SONGS).each do |song|
					counts[song] = POSSIBLE_SONG_COUNTS[ rand(POSSIBLE_SONG_COUNTS.size) ]
				end
			end
		end
	end
end

def print_song_counts(song_counts)
	song_counts.each do |person, counts|
		puts person
		counts.each do |song, count|
			puts "\t#{count} \t#{song}"
		end
		puts
	end
end

