require 'rubygems'
require 'active_record'



ActiveRecord::Base.establish_connection(
    :adapter => "sqlite3",
    :database  => "Music.sqlite3.db"
)



class Track < ActiveRecord::Base
	has_and_belongs_to_many :genres
	has_many :trackratings
	attr_accessible :id, :genres
end


class Genre < ActiveRecord::Base
	has_and_belongs_to_many :tracks
	attr_accessible :id
end

class User < ActiveRecord::Base
	has_many :genreratings
	has_many :trackratings

	attr_accessible :id, :genreratings, :trackratings
end

class Trackrating < ActiveRecord::Base
	belongs_to :user
	belongs_to :track
	attr_accessible :user_id, :rating, :track_id
end


class Genrerating < ActiveRecord::Base
	belongs_to :user
	attr_accessible :user_id, :rating, :genre_id
end
