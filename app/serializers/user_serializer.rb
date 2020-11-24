class UserSerializer < ActiveModel::Serializer
  attributes :username, :email, :name, :tweets, :followers_count, :following_count, :followed_before

  def followers_count
    length = self.object.followers.length
    return length
  end

  def following_count
    length = self.object.following.length
    return length
  end

  def followed_before
    puts "--------------------"
    puts @instance_options[:current_user]
    puts "--------------------"
  end

end
