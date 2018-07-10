---
layout: post
title:      "Bcrypt, Has_Secure_Password and Password Encryption"
date:       2018-07-10 11:50:34 -0400
permalink:  bcrypt_has_secure_password_and_password_encryption
---



has_secure_password is a an activerecord macro that makes password encryption so easy that it almost feels like magic.  Just a few lines of code and installation of the bcrypt gem provides strong password security.    

The majority of the work in maintaining password security goes to bcrypt, an algorithm that takes user passwords and "hashes them," converting them into strings of gibberish and adding a "salt", or small string of random data.  These hashed passwords are incredibly difficult to revert to their original format.  Hashed passwords are stored server-side in the password_digest column of a user table. Returning users' password entries can then be authenticated against the password_digest attribute.

has_secure_password is added to a user model and gives it three instance methods: authenticate, password=, and password_confirmation=.  It validates, on creation of a new account, that password fields have been filled in, that passwords are less than or equal to 72 bytes in size, and, optionally, that a user has entered the password correctly twice.  If any of these conditions haven't been met, a new account will not be created.

In the following signup route, we see has_secure_password validations in action.  If a new user instance cannot be saved to the database given user input, the user will be redirected to a failure page: 

```
post "/signup" do
		user = User.new(:username => params[:username], :password => params[:password])
		if user.save
			redirect "/login"
		else
			redirect "/failure"
		end
	end
```

If a user instance can be saved to the database, its password will be hashed using the has_secure_password password= method.

To continue with a basic Sinatra login example: when an existing user attempts to log into their account, the following post route is triggered: 

```
post "/login" do
		user = User.find_by(:username => params[:username])

		if user && user.authenticate(params[:password])
			session[:user_id] = user.id
			redirect "/success"
		else
			redirect "/failure"
		end
	end
```

Given their input, the route checks to see if the user already has an account and if they've entered the correct password.  Again, the password input is authenticated against the user instance's password_digest attribute by calling user.authenticate(params[:password]), which will either return false or the user object. 

At this point, has_secure_password has done its work, and the user will either be redirected to a success page or a failure page.  

To recap, has_secure_password, working in conjunction with bcrypt, offers great password security with just a few lines of code and just, at least in the example above, the use of two methods: password= and authenticate.

