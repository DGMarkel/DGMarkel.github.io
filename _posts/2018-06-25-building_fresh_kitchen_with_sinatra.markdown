---
layout: post
title:      "Building Fresh Kitchen with Sinatra"
date:       2018-06-25 18:52:20 +0000
permalink:  building_fresh_kitchen_with_sinatra
---


Fresh Kitchen is a web app with a very simple concept.   It keeps users' kitchens organized and up to date in several ways: 

* by organizing food items into user-defined categories
* by tracking expiration dates and quantities of each item
* by warning users when items are within 2 days of expiration
* by directing users to the appropriate Fresh Direct page to replace products close to expiration
* by warning users of, and automatically removing, expired products

Before any project, I like to sit down and put together a pretty seriously fleshed-out game plan.  I had a very limited amount of time to build out the website: about three days.  Most of that hour was spent putting together two separate plans of attack: one was a list of essential tasks, to get a working site up and running; the other was a wishlist of items that weren't necessarry but would add to the user experience.

 
The following includes highlights from both lists:  
 
Essentials:  
 
* Users can create new accounts and log in with a secure password.
* Users have a food inventory
* Users have food in the following categories:
* Fruit
* Vegetables
* Meat
* Dry Goods
* Beverages
* Food belongs to users
* Food has an expiration date
* When food expires, Users will be notified.

Wishlist:

* Users can have accounts on Freshdirect, Amazon, and other grocery delivery sites
*  If Users have grocery delivery service, they will be asked if they’d like to place an order for expired foods
*  Each index page will include a list of expired foods

As with any project, this one took a few unexpected turns.  The first came about a day in, when I realized that my database, which consisted of a user table and a food table, wasn't set up to track food by category efficiently.  I'd already built out most of a working site at this point, and while I'd identified a problem in my data structure, I decided that I needed to finish building a completely useable site before tackling the issue.  I'm not entirely sure if this was the appropriate choice, as it was certainly time-consuming to add a category table my database and rewrite each route/view affected by the change. In the end, it took me halfway through the second day to make these changes, and gave me a more dynamic, user-friendly interface.

The final data structure is divided like this: Users have many categories, and many foods through categories.  Categories have many foods, and foods belong to users.  I spent a lot of time trying to figure out how each user would interact with the database: should there be a prescribed set of categories to add food items to, or should users define categories themselves?  Should users be limited to giving those items numeric quantities, or could they define quantities of items themselves?  In the end, I decided that there are too many categories/type of quantity to anticipate, and am leaving it to users to define these themselves.  Since there are many ways to group items, and not all people group them in the same way, I believe this makes for a more effective/user-friendly interface.

With a half-day left to work out coding details, I had plenty of time to work on my wishlist.  The first item I dealt with was tracking expiration dates.  This was quite time-consuming, and while it's not obvious to a user, the feature has more logic than any other aspect of the site.  In the end, I built 8 methods to track expiration: the User class has two: #expired_foods and #almost_expired_foods.  The Food class has six.  The first four are explicitly related to expiration: #almost_expired?, #expired?, #days_until_expiration, and a helper method, #date_splitter.  The last two are grammatical helper methods: if an item is close to expiring or is expired, the app will warn the user with the correct pronoun:  Tomatoes are referred to as "them" while soup is referred to as "it."  If tomatoes expired, the a warning will read "Tomatoes were removed from your inventory," whereas "Soup was removed..."  There is additional logic ensuring that warnings are only visible when food is close to or has expired.  


Finally, let's say a user's 7-grain peasant loaf is about to expire.  The about-to-expire warning  includes a link to Fresh Direct with a list of all the 7-grain peasant loaves in its inventory.  This feature of my site still needs work, but I'm happy that I was able to add this to Fresh Kitchen. 

One of my takeaways from this project is that users wouldn't be aware of the work involved in what are essentially mundane and invisible tasks.  No one but a coder would realize that logic is needed to dynamically account for word conjugation, or that it would take several hours to build out the logic necessary to check for and warn users regarding expiration.  I certainly gained an appreciation for the invisible work involved in great web design.

While Fresh Kitchen was running smoothly by the end of day two, I gave myself a third day to dress it up, work on user flow, eliminate pages and routes that seemed unnecessary, etc.  I spent the entire day looking at other sites for inspiration, testing out different looks for my page, and pushing my admittedly pretty meager CSS skills to the limit.  Overall, I'm happy with what I developed in a day, but I'm thankful that this project is a test of my backend skills and not visual design.

This is the first website I've built, and I finally feel like I'm well on my way to being a developer.  I'm looking forward to my next steps in this journey!




