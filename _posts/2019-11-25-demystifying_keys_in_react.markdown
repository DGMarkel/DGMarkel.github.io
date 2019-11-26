---
layout: post
title:      "Demystifying keys in React"
date:       2019-11-26 04:27:03 +0000
permalink:  demystifying_keys_in_react
---


Even after having worked with React for the past six months or so, the purpose of React keys remained a bit of a mystery to me.  Why do we need them?  What is their purpose? How does React use them to track components?  Going through the official React documentation cleared up the mystery quite quickly.  As usual, and despite the fact that so many of us avoid reading it, it's always important to read the documentation!  So heres what I learned:

In a nutshell, key is a reserved React property that tells React when and how it should update components through rerenders.  Unlike other props, key can't be accessed through this.props.key.  React uses array indices as keys by default, but this is problematic because it makes reordering a generated list, or adding and removing items from that list, difficult to accomplish.

Let's run through a quick example.  Let's say we begin with an array of user objects:

const users = [{firstName: John, lastName: Doe, id: 0}, {firstName: Jane, lastName: Doe, id: 1} ]

We then map through the users array to generate a number of components to be rendered to the screen.

users.map(user => <li key={user.id}>`${user.firstName} ${user.lastName}` </li>

React uses unique keys to maintain state through rerender.  In other words, keys allow React to maintain, update, or destroy components through each automatic rerender as the list of users is updated.  Through each rerender -- let's say, when John Doe is removed from the array -- React compares the new set of keys to the old; if a new key has been generated, a new component will be created.  If an older key no longer exists, that component will be destroyed; and if an existing key has been updated, that corresponding component will also be updated.  


