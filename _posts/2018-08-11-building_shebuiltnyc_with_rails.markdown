---
layout: post
title:      "Building sheBuiltNYC with Rails "
date:       2018-08-11 10:16:01 -0400
permalink:  building_shebuiltnyc_with_rails
---


I spent most of that Thursday night  tangled in sheets, fumbling through app ideas like the desperate developer I was.  But lo, what the dawn brings: the spark of an idea, courtesy of Facebook, thank you very much.

A former employer - and one of my favorite sculptors - announced that she'd just won a commission to create the first statue of an historical female figure in Central Park.  Ten minutes later, the New York Times [published an article ](https://www.nytimes.com/2018/07/26/nyregion/women-monuments-new-york-city.html?hp&action=click&pgtype=Homepage&clickSource=story-heading&module=second-column-region&region=top-news&WT.nav=top-news) listing reader suggestions for additional memorials to famous female influencers.  

As it turns out, Mayor de Blasio's administration is making a significant push to add to the diversity of public monuments here.  She Built NYC is First Lady Shirlane McCray's initiative to redress the dearth of public monuments to women, women's organizations, and historical events significant to women's issues in New York City. 

I've worked as a sculptor and architectural restorationist for the past five years, and spend much of my free time studying and sketching monuments around the city.  I've had the opportunity to work on public monuments here, and my restoration work is in many civic, commercial, and private buildings in the area.  Building a website to support She Built NYC seemed like a fantastic tie-in to my professional background.

While [She Built NYC](https://women.nyc/she-built-nyc/) already has a site developed to collect nominations for prominent female figures from the public, I decided to design my own version of the site, with the hope that I could donate it to the campaign on its completion.  Unfortunately, the window for nominations closed before I finished my project, but I'm pleased to have produced a site with so much personal relevance. 

# An Overview of My Site:

sheBuiltNYC invites New Yorkers to join us in our effort to build new public monuments that honor women’s history in New York City.

This is an open call for nominations. We invite you to submit one nominee, and vote on all of our nominees, from the vast array of inspiring women who have contributed to our city. Our advisory panel will announce the subject and site of a new monument for our winning nominee in January 2019.

This is an educational site. The public is free to explore all of our nominee profiles, to learn about important figures in New York history. However, only registered users can make nominations, vote on nominations, and comment on them.

This is a social site. Registered users are free to edit and delete their comments and replies. The comments section is monitored by admins, who can edit and delete user comments and replies, as well as remove abusive users entirely. If a user is removed from the site, all of their data (nominations, comments, and replies) is preserved for public viewing.

Admins are free to delete proposals that don't fall under the purview of our mission to commission new monuments based on public rankings of our nominations.

# Developing sheBuiltNYC 
Building out the basic structure of my rails app was straightforward.  As with all of my projects, I outlined each step of the development process before getting started.  

Phase 1 involved building out the most essential aspects of the site - registering users, accepting new proposals, and allowing registered users to vote on all other proposals.  I established the resources and associations I would need to get a basic site up and running, and quickly generated User, Proposal, and Ranking resources, where Ranking was a join table representing user votes on proposals.  Views and their responding controller actions allowed users to create and edit profiles and create, edit, and delete proposals.

Phase 2 involved establishing user login, both through my site and through third-party logins, which I decided to limit to Facebook.  At this point, the bones of my site would be up and running, and I could move to phase three.

Phase 3 involved adding an admin attribute to my User table and creating what would become, essentially, a second site sitting on top my the first.  Where users have a profile page, admins have a stats page with access to site data including total number of nominations, votes, and users, most recent nominations and users, an admin-only users index allowing admins to delete and edit user profiles, etc.  Each page view would also allow admins to manipulate data beyond what a typical users is capable of.

Phase 4 involved making sheBuiltNYC social.  I added Comment and Reply resources, with corresponding views and controller actions for comment and reply indexes and create and edit forms.  

Phase 5, which I had to force myself to leave for last, involved styling the site.

Phase 6 is an ongoing wishlist for new features and refinements, which at this point include: 
* requiring admin approval of new proposals before they go public
* refining the system of comments and replies
* finding a gem to present admin stats in graph form 
* honing admin permissions - at this point, admins have too much control over user profiles
* continuing to style the site
* add JQuery features
* DRYing my code and moving CSS out of views and into layouts

# Key Issues in the Development Process 
Given the fact that this is the second site that I've developed indepently, and the first that I've made social, I was surprised by the level of complexity I was able to achieve.  What was more surprising was how many issues needed to be addressed to to control the flow of information on a social site.  Many unanticipated questions needed to be resolved:  
     
*When a user is blocked from the site, how should their proposal/comments/replies be preserved or removed?

*Can a user delete their proposal, especially if the proposal has already been voted on multiple times by other users?

*Should admins be allowed to delete or edit proposals?

*How much control over data, in general, should admins have? 

*How many comments can a user make on the same proposal?

*What type of ranking system should I use? A scale system, or a simple yes or no vote?

Of all of these issues, the most complicated to address was the first.  I hadn't anticipated how many bugs deleting a user would cause in my database.  Since proposals, comments, and replies all have user_id attributes, the first time I deleted a user caused a major breakdown in the functioning of my entire system.  Half my views no longer worked.  It wasn't until I built delete paths accounting this -- a couple hours of work, as I tracked bugs down one by one -- that I got my site running again.  

As it stands, I created a system where blocked users would have their profiles deletes but copied into a new account to preserve their data.  The controller action is cumbersome and will be refactored if I don't opt for a different solution for blocked users: 

```def destroy
    #this is a really weird feature...should I keep it or not?
    #if an admin deletes a user, that user is blocked from their account
    #BUT a new account is created with all the same attributes and associations

    if current_user.admin
      @user = User.find_by(id: params[:id])
      if @user.proposal
        @proposal = @user.proposal
      end
      @new_user = User.create(name: "#{@user.name} - removed for abusive behavior", email: (0...8).map { (65 + rand(26)).chr }.join, password:Devise.friendly_token[0,20])
      if @user.affiliation
        @new_user.update(affiliation: @user.affiliation)
      end
      if @user.borough
        @new_user.update(borough: @user.borough)
      end
      if @user.zip_code
        @new_user.update(zip_code: @user.zip_code)
      end
      if @user.proposal
        @new_user.update(proposal_id: @proposal.id)
      end
      if !@user.image_url.empty?
        @new_user.update(image_url: @user.image_url)
      end
      @user.rankings.each {|ranking| ranking.update(user_id: @new_user.id)}
      @user.comments.each {|comment| comment.update(user_id: @new_user.id)}
      @user.replies.each {|reply| reply.update(user_id: @new_user.id)}
      if @user.proposal
        @proposal.update(user_id: @new_user.id )
      end
      @user.destroy
      redirect_to users_path
    else
      redirect_to root_path
    end
  end
	```
	
Overall, I learned a huge amount about managing data while building this site; the basic issues that arise through sites with multiple levels of user interaction and how to handle them.  I'm very proud of the work I put into this, and look forward to continue building it out in the future.  







