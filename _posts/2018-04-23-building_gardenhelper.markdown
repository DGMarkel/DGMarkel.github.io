---
layout: post
title:      "Building GardenHelper "
date:       2018-04-23 18:39:25 +0000
permalink:  building_gardenhelper
---

Living in Brooklyn, it's been a few years since I've had a garden of my own.  But it's spring, finally, and the community garden just outside my apartment is buzzing with activity.  I sat at the kitchen table last week, trying to decide on a scraping project and  looking down at the gardeners prepping their beds for this year's crops.  I found myself wondering, how do they know what to plant, when to plant it, and how to take care of their crops?  

Wouldn't it be nice to have an app that presents all that information in one place?

The basic idea of GardenHelper is to provide detailed planting, growing and harvesting information there crops based on the current month and the user's local growing conditions. Initially, it seemed like a pretty daunting task to scrape for all this information, but I managed to find a few sites that had aggregated the information into a useful interface.

**Plan of Attack

At this point, I'd determined what I wanted my app to do and where I'd be scraping my information from.  Before sitting down to code, I quickly jotted down some notes on how I thought the interface would work, as well as what kind of properties a crop has:

1. User is greeting with a welcome message.
2. User is prompted for their location (city, state, or zip code)
3. If the user enters their city or state, greet them again with a cutesy message like "Hey there, Brooklyn!"
4. GardenHelper knows what month it is.
5. GardenHelper puts an unindexed list of vegetables that should be planted this month.
6. "For more growing information, please enter the name of a veggie you'd like to plant."
7. After info, **maybe** ask user if they'd like a list of local retailers selling that plant, if possible.
8. Prompt user to save the veggie to their garden wishlist, go back to the main veggie index, or exit.

GardenHelper files:
garden_helper_cli.rb - CLI for GardenScraper
garden_scraper.rb - scrapes data from https//garden.org, creates new Month and Vegetable class instances
vegetable.rb -- class GardenHelper::vegetable

What is a vegetable?
  - has a name
  - has a scientific name
  - has many species
  - date it should be started from seed
  - date it should be planted
  - has a basic description
  - has growing information:
    - how much it needs to be watered
    - how much sun it needs
    - what kind of soil it likes
    - what plants grow well with it    
  - has a url
    - https://wikipedia.com/#{vegetable.name.downcase.capitalize}
    
		**Build the CLI First; the Rest Will Follow
		
Monday morning, I watched Avi's CLI Gem Walkthrough a couple times and settled on a similar development strategy: build the CLI first, and everything else will follow.  At that point, I wasn't really sure how many classes I would need to build or what kind of info I'd be able to scrape.  I *did* have my CLI outlined already, though, so it was fairly easy to mock up a working interface with fake data.  

I created a GardenHelper executable, an environment, and a couple ruby files: cli.rb, scraper.rb vegetable.rb, gardener.rb, and month.rb, each of which contained a class of the same name.  With my CLI mocked up, I played around with the various classes for about an hour, quickly realizing that, based on the site I was scraping, a Month class would be unnecessary.  The Gardener class was also unnessary, since every time I opened the executable, it would create a new instance of GardenHelper::CLI, which is implicitly the same as a Gardener class.

**Starting to Build the Scraper Class

With a much leaner domain than I'd started with, I was ready to move on to scraping.  The site I chose, https://garden.org/apps/calendar/, was fantastic and frustrating in equal measure.  It has a great entry point for users: entering location by zip, state, city, or landmark! generates a planting guide customized to that specific location based on the USDA hardiness zone map.  If I wanted data for Brooklyn, my url would look like this:  https://garden.org/apps/calendar/q=Brooklyn, and that pattern persisted for any type of location data I entered.  Here I'd been thinking that it would be a huge struggle to scrape for data by location, and this great tool let me scrape for any location with a simple insertion of user input.

doc = Nokogiri::HTML(open("https://garden.org/apps/calendar/q=#{user_input}"

**Frustration in Equal Measure

Off to a great start: ten minutes in and I'm already scraping by location.  But the HTML on those locations pages!  I mean, no offense, National Gardening Association, but just tables on tables on tables of data with no distinct CSS classes or id's to differentiate.   For a newbie scraper, this was kind of a nightmare.  It took me a full day to grab the info I wanted for my CLI. I'm going to gloss over the details because

**Distaster Strikes

So at this point it's Wednesday morning.  I'm just about to finish my Scraper, I've got a scrappy CLI that's presenting all of the information I want, and it's looking like I'm going to be finished roughing out my project in an hour or two.  I'm still struggling to grab some information, so I'm messing around in pry, scraping the page every few minutes, when this pops up in my console:

"Excessive requests from your IP has resulted in an automatic block being added to our system. This is a protective mechanism to protect us against malicious bot traffic. If you are a regular visitor of the site, then please accept our apologies and know that we did not intend to block you. If you feel that your IP should not have been blocked, please contact us at admin@garden.org."

I've been scraping to much, and now I'm blocked from the page.  I contact the admin, and no deal. Distaster.
But disasters come with lessons attached:  web admins don't like scrapers.  Next time, I'll save a copy of the website and scrape files locally. (I actually *didn't* do this for my next scraper, but I probably should have) 


**A Blessing in Disguise

So I'm sitting there, depressed and just kind of thinking okay, what now?  I'm like an hour from finishing, and it's back to square one?  I take a deep breath, go back to google, and find a BETTER site within half an hour.  Better structured, easier to scrape, and more gardening information.

**Scraping por segunda vez

In many ways, my issues with gardenate.com are exactly opposite to the ones I had with garden.org.  Just quickly glancing at dev tools, it's pretty clear that I'll be able to scrape data from the site really quickly.  The issue is with navigating to the correct page to scrape based on user input.  They've got a drop-menu that lists global growing locations, and I'm so daunted by this that I'm not really sure if I'm going to be able to scrape from this site.  But it's my best bet, so I get started.

**Pulling Data from a Drop Menu**

I start exploring the drop-menu interface, trying to figure out how it works, how it's written in HTML, and what data I need to pull to get to the page I really want - the growing zone page.  Each option looks like this: 

<option value="61">Canada – Zone 2a – Sub-Arctic</option>

and the url generated by that option is 

https://www.gardenate.com/?zone=61

There are multiple problems to address.  First,* my CLI isn't going to work anymore*, since the first site I scraped was so flexible in terms of searching by location.  Now, the user will need to provide a growing zone, and there aren't any sites that allow you to search for growing zones by location in an easily scrapable way *except* for the garden.org, which I've been blocked from scraping.  So big deal, I'll just provide a link in the CLI telling users where to search for their climate zone.  Problem one, solved.

Problem two: How to I use user input to scrape the correct page for their location?  What data do I need to grab from a given menu option, and how am I going to grab it? 

I want to limit my search to locations in the US, so I need and iterator method, #detect, which finds the first option that includes "US" and the user's input.  I then want to return the value of that option, which I can insert into the url "https://www.gardenate.com/?zone=#{user_input}

  def self.find_index_by_climate_zone(climate_zone)
    user_generated_index = nil
    doc = Nokogiri::HTML(open("https://www.gardenate.com"))

    climate_zone_menu = doc.css('.steps')
    climate_zone_menu.css('option').detect do |menu_option|
      user_generated_index = menu_option if menu_option.text.include?("USA") && menu_option.text.include?("# {climate_zone}")
    end
    user_generated_index.values.last
  end
	
	So now, if the user inputs growing 2a,  my GardenHelper::Scraper class method find_index_by_climate_zone(climate_zone) returns "61"
	
Problem three: I need a scraper method that will take the return value of find_index_by_climate zone and scrape the page that index number, "61", leads to.  Simple: 

def self.scrape_vegetables(user_generated_index)
    doc = Nokogiri::HTML(open("https://www.gardenate.com/?zone=#{user_generated_index}"))
    doc.css('tr')
  end
	
	**Building a Vegetable Class**
	
At this point, it's Wednesday afternoon.  It took me about four hours less to build a scraper for the second website than it did for the first, and I'm ready to get my program up and running.  GardenHelper::Scraper is a lean class with just two methods.  At this point, my vegetable class is three methods: initialize, new_from_index, and add_attributes, or something along those lines.  The way I've got my Vegetable class set up:
* vegetable objects initialize with a name
* new_from_index instantiates scraped vegetables with name and url attributes and pushes them to a class array.  The url is a link to a description page for that vegetable instance.
* add_attributes iterates through the class array, scrapes the url contained in each object, and adds attributes to each object from its scraped description page.

**Building CLI 2.0 and Encountering A Major Issue

I rough out a new CLI so I can take a look at how my Vegetable class is working.  What I want is to puts out an unordered list of scraped vegetable.names, which the user should then be able to input to access an in-depth description of their input vegetable. 

I immediately hit a major snag.  My scraper's working correctly, the CLI is fine, and there's nothing wrong with my vegetable class.  But when I input my growing zone, the CLI just sits.  And sits. And sits.  Until five minutes or so later, when that list of plant names finally rolls out.  

As it turns out, scraping 70+pages for data takes a loooooooooooong time.

**My Proudest Moment

I'm scratching my head thinking, what kind of user is going to sit there like it's 1995, waiting for a few lines of text to load?  How am I going to cut down on wait....

Ok, so I already have a method that instantiates vegetable objects with just their names and urls.  What if I push just that into an array?  What if, when the user opens GardenHelper, it knows *how* to scrape more information about it's objects, but it *doesn't* scrape for that information until the user tells it to?

Eureka!  Now I've got an app with a reasonable load time, that scrapes and saves requested information but doesn't know more than it needs to.

**FIne-Tuning the CLI

It took me about half a day to rework GardenHelper using gardenate.  So maybe I'm too much of a perfectionist, because I spent another two-and-half days messing around with the CLI, getting it to put out information in the most readable format possible.  The majority of cli.rb is interface and formatting methods.  I have a separate formatting method for every vegetable attribute, and it was only through running the code over and over again that I discovered all the kinks in formatting.  I'm honestly not sure if it was necessary, as part of the assignment, to make a sweet, sweet interface, but I'm sure that I wouldn't be happy without one.


**Outcome

Overall, I'm really happy with how GardenHelper turned out.  It looks great, works exactly the way I wanted it to, and I'm pretty sure I've worked out most of the formatting kinks as far as presentation.  I learned a ton and have a lot more confidence re: programming on my own and problem solving.  Stack Overflow is my best friend.  More importantly, this was my first real opportunity to engage with other Flatiron Students, which added to my overall enjoyment of this project.  Given how long I spent on my CLI, I decided not to turn it into a gem, although I plan on doing that in the future.  Looking forward to learning more.

Please feel free to take a look at my project here:
https://github.com/DGMarkel/cli-data-gem-assessment-v-000
   

