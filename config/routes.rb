Rails.application.routes.draw do
    #check if the server is crashed or not
    get '/health', to: 'health#health'



    #user register
    post '/user', to: 'user#create'

    #confirmation register
    get '/user_confirm_register/:user/:emailcode', to: 'user#confirmation'

    #user login
    post '/user_login', to: 'user#login'

    #get followers
    get '/followers/:username', to: 'user#followers'

    #get follows
    get '/follows/:username', to: 'user#follows'

    #delete a user
    #delete '/user', to: 'user#destroy'

    #get profile info of any user, passing the username desired
    get '/profile/:username', to:'user#profile'

    #follow a user
    post '/follow/:followed_username', to: 'relationfollows#create'
    #unfollow user
    delete '/follow/:followed_username', to: 'relationfollows#destroy'


    #create a tweet
    post '/tweet', to: 'tweet#create'

    #tweets in my feed (own tweets and tweets of users i follow)
    get '/tweets', to: 'tweet#list'

    #delete a tweet
    delete '/tweet', to: 'tweet#destroy'

end
