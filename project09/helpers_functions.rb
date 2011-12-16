
require './active_record_classes.rb'





def user_distance(user1, user2)
	genre_ratings_1 = user1.genreratings
	genre_ratings_2 = user2.genreratings

	gr1 = genre_ratings_1.map{|g| g.genre_id}
	gr2 = genre_ratings_2.map{|g| g.genre_id}
	possible = gr1 | gr2
	ratings_vector_1 = possible.map do |c| 
		r = Genrerating.find_by_user_id_and_genre_id(user1.id,c)
		x=0
		x= r.rating if r
		x
	end
	ratings_vector_2 = possible.map do |c| 
		r = Genrerating.find_by_user_id_and_genre_id(user2.id,c)
		x=0
		x= r.rating if r
		x
	end
	ratings_vector_1.to_s
	#top is the dot product
	top = [ratings_vector_1, ratings_vector_2].transpose.map{|x,y| x*y}.reduce(0,:+)
	bottom = ratings_vector_1.map{|x| x*x}.reduce(0,:+)*ratings_vector_2.map{|x| x*x}.reduce(0,:+)
	#puts bottom
	return 1.0/0 if bottom==0
	1.0*top/bottom
end



#Returns a hash with key being user id, and value being an array with the k nearest users
def k_nearest_neighbors(k)
	hash = Hash.new
	User.find(:all).each do |user|
		puts "finding nearest neighbors for #{user.id}"
		#If they didn't rate anything, move along
		if(	user.genreratings.size == 0 )
			hash[user.id]=Array.new
			next
		end
		sorted_users = User.find(:all, :conditions=>["id != #{user.id}"]).sort_by{|other|user_distance(user,other)}
		closest = sorted_users[0...k]
		closest_ids = closest.map{|c| c.id}
		hash[user.id]=closest_ids
	end
	hash
end



def predict(nearest_neighbors, user_id, track_id)

	#Get the active record objects
	begin
		track = Track.find(track_id)
	rescue ActiveRecord::RecordNotFound
		return 50
	end
	#if there is not track just give a guess of 50
	return 50 if !track;

	nearest_neighbors.map!{|n| User.find(n)}
	nearest_neighbors.push(User.find(user_id))

	#Finds genres that we have an idea about, and genres we have in the song	
	possible_genres = nearest_neighbors.reduce(Array.new){|a,n| a | n.genreratings.map{|g| g.genre_id}}
	possible_genres = possible_genres & track.genres.map{|g| g.id}
	rating_sum =0
	ratings = 0
	possible_genres.each do |genre|
		nearest_neighbors.each do |neigh|
			r = Genrerating.find_by_user_id_and_genre_id(neigh.id,genre)
			next if !r
			rating_sum += r.rating
			ratings +=1
		end
	end
	return 50 if ratings == 0 
	return 1.0*rating_sum/ratings
end

def find_rmse(k)
	actual = Array.new
	calculated = Array.new

	puts "Finding nearest neighbors.."
	hash=k_nearest_neighbors(k)


	puts "Predicting ratings "
	to_test = Validationrating.find(:all)
	to_test.each do |v|
		actual.push(v.rating)
		calculated.push(predict(hash[v.user_id],v.user_id,v.track_id))
	end

	sse = [actual,calculated].transpose.map{|x,y| (x-y)**2}.reduce(0,:+)
	#rmse:
	Math.sqrt(sse/to_test.size)
end


