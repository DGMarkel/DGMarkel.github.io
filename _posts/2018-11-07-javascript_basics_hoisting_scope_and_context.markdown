---
layout: post
title:      "Javascript Basics: Hoisting, Scope, and Context"
date:       2018-11-07 17:26:33 -0500
permalink:  javascript_basics_hoisting_scope_and_context
---


Javascript engines initialize and execute code in seperate stages and read the code from top to bottom.  In the first stage, declarations are saved to memory without being assigned values.  They are undefined until the engine moves to execution.  These declarations fall into four variable types:  undeclared, var, let, and const.  

Undeclared, var, and let variables can have their values reassigned, while const can only be assigned once.


As of ES6, the most recent version of Javascript, programmers are advised to use only let and const, as they provide a greater degree of control over variable scope, which I'll describe below.  

# Scope

The scope of a variable refers to where it is defined within Javacript code.  There are three types of scoping in Javascript: global, function, and block scope.

**Global Scope**

Undeclared variables, which are not preceded by var, let, or const, are accessible anywhere within a given set of code.  They can be defined at any point within that code, and their values can be modified indiscriminately. 

**Function Scope**

Var declarations are function scoped, meaning that, for the most part, they are only defined within the function in which they were initialized.   The following example illustrates this concept:

```
function aColor() {
  color = "blue"
  console.log(color)	
	var color
}

aColor() ==> 
blue 
undefined

color ==> 
Uncaught ReferenceError: color is not defined at <anonymous>:1:1
```

Var declarations are also accessible to any function nested within the function where that declaration was made. Their values are only accessible to other functions if they are passed to them as an argument, as in the following example;

```
function aColor() {
  color = "blue";
  myFavoriteColor(color);
	var color
}

function myFavoriteColor(color) {
  console.log(`My favorite color is ${color}`);
}

aColor() ==> 
My favorite color is blue
undefined
```

**Hoisting**

When var declarations are initialized, they are "hoisted" to the top of their scope.  Variable assignments, on the other hand, are not.  In other words, declarations behave as if they were written at the top of their function, no matter where they were actually written into it.  However, they are not assigned a value until their functions are executed.  

Let's take a look at our example again:

```
function aColor() {
  color = "blue"
  console.log(color)	
	var color
}

aColor() ==> 
blue 
undefined
```

Even though our declaration, var color, is the last line of code in function aColor(), it's hoisted to the first line by being saved to memory during the JS engine's initialization phase.  When aColor() is executed, color is assigned a value and can be logged.

If we write the function slightly differently, we achieve a different result:

```
function aColor() {
  console.log(color)	
	var color = "blue"
}

aColor() ==> 
undefined
undefined
```

Even though it's perfectly acceptable to declare a function and assign it a value simultaneously, ```var color = blue``` is read as an assignment, and therefore isn't hoisted.  Since Javascript is executed from top to bottom, color is undefined when it it's logged by aColor().

For this reason, and for logic's sake, it is always advisable to assign values to variables at the top of their scope.

```
function aColor() {
  var color = "blue"
  console.log(color)	
}

aColor() ==> 
blue
undefined
```

**Block Scope**

The declarations let and const, which were introduced in ES6, are block scoped, meaning accessible within a set of curly braces.  In many ways, let is just like var, the major difference being that var is accessible anywhere within its parent function, while let is only accessible within its block 
Here's an example illustrating their differences:

```
function guessMyFavoriteColor (color) {
	if (color === "blue") {
	  var reply = "You got it right!";
	} else {
	  return false
	}
	console.log(reply)
}

guessMyFavoriteColor("blue") ==>
  "You got it right!"
	undefined

function guessMyFavoriteColor (color) {
	if (color === "blue") {
	  let reply = "You got it right!";
	} else {
	  return false
	}
	console.log(reply)
}

guessMyFavoriteColor("blue") ==>
  Uncaught ReferenceError: reply is not defined at guessMyFavoriteColor (<anonymous>:7:14) at <anonymous>:1:1
```

Const declarations work similarly to let, except that they must be assigned a variable when they are declared, because they can't be reassigned after that point.

# Context
In contrast to scope and hoisting, context is a relatively simple concept.  When this is called within the method of an object, it refers to that object.  

```
let definitelyTrue = {
  tautology: function() {
	  return this;
	}
}

definitelyTrue.tautology() === definitelyTrue ==>
true 
```

When the new operator is called to create a new instance of an object, this refers to that instance.  

```
class Answer {
  constructor(awesomeKnowledge) {
	this.awesomeKnowledge = awesomeKnowledge;
	}
	
	wisdom () {
	console.log(this.awesomeKnowledge)
	}
}

	
let request = new Answer("You're amazing")

request.wisdom() ==>
  "You're amazing"
  undefined
	```

This called on its own will default to the global context and return the window object.

```
this ==>
  Window {postMessage: ƒ, blur: ƒ, focus: ƒ, close: ƒ, parent: Window, …}
```

Finally, there are several exceptions: inside of an arrow function, this will refer to that functions container, and inside of a function nested within an instance method, this will return undefined.






















