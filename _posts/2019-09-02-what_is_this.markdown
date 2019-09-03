---
layout: post
title:      "What is this???"
date:       2019-09-03 02:48:33 +0000
permalink:  what_is_this
---


this keyword refers to an object, that object which is executing the current bit of javascript code.
In other words, every javascript function while executing has a reference to its current execution context, called this. Execution context means here is how the function is called.
To understand this keyword, only we need to know how, when and from where the function is called, does not matter how and where function is declared or defined.

A function's this keyword behaves a little differently in JavaScript compared to other languages. It also has some differences between strict mode and non-strict mode.

In most cases, the value of this is determined by how a function is called (runtime binding). It can't be set by assignment during execution, and it may be different each time the function is called. ES5 introduced the bind() method to set the value of a function's this regardless of how it's called, and ES2015 introduced arrow functions which don't provide their own this binding (it retains the this value of the enclosing lexical context).
