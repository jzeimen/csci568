
require './active_record_classes.rb'





def user_distance(thing1, thing2)
	genre_ratings_1 = thing1.genreratings
	genre_ratings_2 = thing2.genreratings
	genre_ratings_1.map!{|g| g.genre_id}
	genre_ratings_2.map!{|g| g.genre_id}
	possible = genre_ratings_1 | genre_ratings_2
	ratings_vector_1 = possible.map do |c| 
		r = Genrerating.find_by_user_id_and_genre_id(thing1.id,c)
		x=0
		x= r.rating if r
		x
	end
	ratings_vector_2 = possible.map do |c| 
		r = Genrerating.find_by_user_id_and_genre_id(thing2.id,c)
		x=0
		x= r.rating if r
		x
	end
	#top is the dot product
	top = [ratings_vector_1, ratings_vector_2].transpose.map{|x,y| x*y}.reduce(0,:+)
	bottom = ratings_vector_1.map{|x| x*x}.reduce(0,:+)*ratings_vector_1.map{|x| x*x}.reduce(0,:+)
	return 1.0/0 if bottom==0
	top/bottom
end