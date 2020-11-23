class TweetSerializer < ActiveModel::Serializer
  attributes :id, :content, :created_at, :author

  def author
    user = self.object.user
    {
      name: user.name,
      username: user.username,
    }
  end
end
