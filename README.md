# My implementation of the following code challenge
## One thing I want to note is that since the instructions explicitly asked for a method to return the vertices of the cuboid, I included it in my code and tests. I don't actually use them for any other reason than that. Instead of using the vertices, I calculate the minimum x, y, and z values for a cuboid based on its dimensions. This should give me all the information I need in order to check for intersections, perform translations and rotations, and calculate vertices.


# Rails Coding Challenge

Here's a coding challenge related to a problem we actually faced. Feel free to ask any questions to fill in the blanks.

Write code that represents 3D objects in space - to keep it real simple, only "rectangular cuboids." That way you could represent one by having an origin (z,y,x) and length, width, height. Of course, you should be able to create (initialize) an object at a certain origin, with a certain length/width/height. You should also be able to move your object to a different origin. Additionally, you should be able to get a list of the vertices that represent the cuboid (a total of 8 vertices).

Now here's the important part - write a method that tests whether or not 2 cuboids are overlapping.

Bonus points:
Allow your objects to rotate (to keep it simple, only at 90 degree angles). The "tricky" part about the rotation is that - imagine the origin is walled - a rotation of an object that is up against a corner would also require the object to shift if you are rotating the object around its origin. This restriction exists because the objects are actually part of a bin packing algorithm - meaning the objects are inside a box and can only exist within the walls of the outer box.

We expect that you should be able to complete this challenge with 1-3 hours of work, depending on how thorough you are.  If it's taking longer than that then please re-read the directions or reach out to us becuase you might be doing more than is necessary.

## How to submit your results
Please follow these directions precisely because they affect our ability to evaluate your results.

1. Fork this repo
2. Do your coding challenge and push to your forked repo
3. Email a link to your repo to tim.cull@touchofmodern.com and the recruiter you were working with (i.e. Sally or Tarveen) to let us know you're ready.

## What we are looking for
We are looking for several things with this challenge.  First, of course, we're looking for your answer to be technically correct. Beyond that, we're also looking for:

1. Is your code easy to read and understand?
2. Are you following the usual conventions for Ruby development?
3. How good are you at writing tests? And how easy are they to read and understand?
4. Did you follow these directions?

Basically, write the code as if you were going to release it to a real website with an actual warehouse and if you mess it up then boxes will start piling up on the floor and stuff.  Because that's what happened to us.

When we get your response, here's exactly what we're going to do:

1. Run "bundle exec rake" and see that the tests pass.
2. Look at the code itself to see its correctness, readability, and general elegance.
3. Look at the tests to see their correctness, readability, and comprehensiveness.
4. Maybe write a few more tests of our own to see if we can break stuff.

That's it.  There aren't any hidden gotchas or trick questions.  That's really what we're going to do.

If you have any questions, please don't hesitate to contact me at tim.cull@touchofmodern.com

--Tim
