def remove_overlap_duplicates(overlap_hash, overlap_array)
                              if overlap_array.blank?
  # puts "overlap_array was blank."
                                overlap_array << overlap_hash
  # puts overlap_array 
                                return overlap_array
                              else
  # puts "overlap_array NOT BLANK."

                              counter = 0
                              # initialize counter for duplicate-removal
                              overlap_array.each do |i|
  # puts "i = #{i}"
  # puts "--------"
  # puts "hash = #{overlap_hash}"
  # puts "/// counter = #{counter} /////"

                                  if ((
                                    (overlap_hash[:user1_id] == i[:user2_id]) && 
                                    (overlap_hash[:user2_id] == i[:user1_id]) && 
                                    (overlap_hash[:content] == i[:content])
                                    # removes cross-user duplicates
                                    ) || 
                                    (overlap_hash[:user1_id] == i[:user1_id]) && 
                                    (overlap_hash[:user2_id] == i[:user2_id]) && 
                                    (overlap_hash[:content] == i[:content])
                                    # removes same user content duplicates
                                    )
  # puts "already in the array, so skip this one"
                                    counter = counter + 1
  # puts counter
                                  end # if overlap == i

                                  break if counter > 0

                                end # loop overlap_array

  # puts "out of loop overlap_array, counter = #{counter}"
                              if counter == 0
# puts "APPEND hash into array"
                                overlap_array << overlap_hash
# puts overlap_array
                                return overlap_array
# puts "++++++++++++++++++++++"
                              else
# puts "counter > 0, do nothing...."
                                return overlap_array #return just as it came in
                              end # if counter = 0

                              end # if overlap_array.blank?                          
end

def social_overlap(users, *current_user)
# future direction to streamline this process may include implementing the function at this link:
# http://www.themomorohoax.com/2009/10/14/ruby-check-if-two-arrays-have-any-elements-in-common
      # users = User.all  #use this line to run over all Users

      overlap_array = []
      overlap_hash = Hash.new
      
# puts "#{users[1].name}"
# puts "-----"
# puts "#{current_user.blank?}"
# puts "-----"
# puts "#{current_user}"  # notice that it comes in as an ARRAY!
      
      if !current_user.blank?  # we have a current user, overwrite incoming users
# puts "#{current_user.first.name}"
        users = [User.find(current_user.first.id)] # made array to use .each method
# puts users
# puts "++++end of IF-BLANK-CHECK++++"
      end
      
      users.each do |user|
# puts "name1 = #{user.name}"
        nowposts = user.nowposts.all
        
        if nowposts.blank?
          # do nothing b/c nothing to compare
# puts "nowposts are blank"
        else
          # continue with nested loops...
          compare_user = User.find(:all, :conditions => ["id != ?", user.id])  
          # finds all users except the one at head of loop        

          compare_user.each do |user2|
# puts "name2 = #{user2.name} with ID = #{user2.id}"
              nowposts2 = user2.nowposts.all

              if nowposts2.blank?
                # do nothing
# puts "nowposts2 are blank"
              else
                # continue with nested loops...
                nowposts.each do |msg|  
# puts "msg1 = #{msg.content}"
                    user_content = msg.content.match(/'(.+)'|"(.+)"/).to_s

                    if user_content.blank?
# puts "user_content is blank."  
                      #do not enter loop if user_content is blank. 
                    else
                      #proceed with loop
# puts "continuing with loop on nowposts2"
                      nowposts2.each do |msg2|
# puts "msg2 = #{msg2.content}"
                          if msg2.content.include?(user_content) 
# puts "there is social overlap!" 
# puts "#{user.name} and #{user2.name} have #{user_content} in common!"
                            
                            overlap_hash = {
                              :user1_id => user.id,
                              :user2_id => user2.id,
                              :content =>  user_content
                            }
# puts overlap_hash                            

                            # overlap_array << overlap_hash # with duplicates
                            overlap_array = remove_overlap_duplicates(overlap_hash, overlap_array)

                          else
# puts "no overlap between #{user.name} and #{user2.name}"
                          end # if on msg2.content...

                      end # loop on nowposts*2*

                    end # if user_content.blank?

                end # loop on nowposts
                
              end # nowposts2.blank?

          end # loop on compare_user
                  
        end # nowposts.blank?
        
      end # loop on users.each
      
      return overlap_array
      
  end # social_overlap()