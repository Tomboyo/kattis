# Kattis Solutions
[Open Kattis](https://open.kattis.com/) is a problem site that the [ACM ICPC](https://icpc.baylor.edu/) uses for its contests (that's where I first learned about it). I'm working through them as a way to practice recognizing and applying various algorithmic techniques. My objective is only to solve each problem according to the time and space restrictions enforced by Kattis, and to do so expressively. I'll go back and refactor/improve code if it's interesting, but otherwise I will favor working on new problems with that time instead.

# Format
The source directory contains packages named after kattis problems. Each such package contains a file called Solution which contains the solution to the Kattis problem. There are corresponding tests and test resources checked in, as well. All checked-in solutions have passed on Kattis unless otherwise indicated.

The documentation directory contains markdown files, one each per problem. They provide a link to the Kattis problem description and contain explanations of how my solutions solve the problems.

# Kattio
The Kattis site provides a Java IO utility called Kattio that they claim should be fast enough for all Kattis problems (unlike, say, Scanner). I've included the source (with minor modifications, such as a package name) within the kattio directory of this project.