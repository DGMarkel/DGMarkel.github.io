---
layout: post
title:      "sheBuiltNYC - Rails + JS"
date:       2018-10-23 16:38:04 +0000
permalink:  shebuiltnyc_-_rails_js
---


Building up to it, I assumed this project would be a one or two day-er at best.  sheBuiltNYC, which I'd built with Rails the month before, felt fully-fleshed out -- there were just a few jQuery-powered bells and whistles to add.  And it's true that taking my pre-built site, adding a couple API endpoints and building a few templates for AJAX posts and get requests took about two days.  Project requirements: met.

But as I got into it, the jQuery bug hit me. And I don't know what it was - the devil on my left shoulder or an angel on my right -- but a little voice just kept on whispering, take it all the way, David - take it all the way. Which is how I ended up spending a very enjoyable ten days building out new functions, features, and styles for what  I decided would become a single window app.  

I spent the first three days building endpoints for every rails resource, modifying controllers and routes, adding templates for virtually every view, adding new styling, and building JS functions.  Nothing crazy - just grinding out jQuery templates, GET and POST functions, eliminating redundant views, etc.  

But while all of this was happening, my site still LOOKED the same, had the same user experience, and the artist in me was going, wait a darn minute - ALL that work? No sir.  And what's the point of a building a single window app if it behaves exactly like a normal site, anyway?

So days 3-6 were a deep dive into jQuery: replacing templated views that *looked* like ordinary pages with popup navigation menus, forms, and sidebars.  Animation happened: images that shift around the page, fade in and out of focus, and grow and shrink on hover.  

I was ready to be done at this point, but...did I go a little overboard? So the final days were spent refactoring my code, pulling out jQuery DOM manipulations that were either annoying, useless, or too slow, styling my new page for consistency, and searching for design precedents to get me all the way.

What I've ended up with is an app that is approximately a kajillion lines of code - well...more like 3000, but probably four or five times the size of my first iteration of sheBuiltNYC.  And while it's no where near perfect, I've learned that I can fricking do this; I love messing around with code; but most importantly, it's important to say enough if enough and know when to put a project down.
