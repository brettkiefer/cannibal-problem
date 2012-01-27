Cannibal Problem
================

This is the cannibal problem as David Fullerton, Ted Unangst, and I devised it one day when lunch was REALLY late at Fog Creek. Robert Martin has thought about it a LOT more, covered the edge cases and written a much more detailed version here: https://github.com/bobbydavid/CannibalSolver

The 4-person solution is fun to work out without programming.

Four programmers are trapped in the offices of a small software company. Their names and weights (in lbs) are as follows:

Adam 200
Benjamin 190
Caleb 180
Daniel 170

After a couple of weeks, they have consumed all of the food in the office, and are on the brink of starvation. Naturally, they turn to cannibalism. The bigger people argue that they should get more votes because if it comes down to a melee, they will probably win. How long does each person survive, given the following rules?

1. Each time they run out of food, the group will elect a person to kill and eat. Each person casts a number of votes equal to the number of pounds they weigh. As soon as a majority of the pounds voting agree on eating someone, the vote is closed and he is killed.
2. After a person is killed, each of the remaining people will eat one pound of their flesh each day until the body is gone. Then they vote again, and so on.
3. Each person is trying to maximize the number of days that he will live.
4. Everyone is perfectly logical and feels no loyalty or anger.
5. Everyone is good at math.

Extra fun for programers:
Now, write a program to solve the general problem, and run it for this larger set of people:
Adam 200
Benjamin 190
Caleb 180
Daniel 170
Ephraim 160
Frank 150
Gideon 140
Hiram 130
Ichabod 120
Jacob 110
Kenan 100
Lehi 90

Extra extra fun for programmers:
Okay, now suppose that each cannibal consumes 1% of his body weight per day instead of one pound. Adapt your solution to this situation.


Compiling and running
---------

    ghc --make cannibal
    cannibal small.cnb

Ooh, a solution.

    cannibal big.cnb
Wait for it. This one takes a while.

I wouldn't look to this code for an example of good anything -- I wrote it several years ago while learning Haskell.
