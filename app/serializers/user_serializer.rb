class UserSerializer < ActiveModel::Serializer
  attributes :username, :email, :name, :tweets, :followers_count, :following_count

  def followers_count
    length = self.object.followers.length
    return length
  end

  def following_count
    length = self.object.following.length
    return length
  end

end
