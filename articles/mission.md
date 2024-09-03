## Skeleton

Claim: existing tools are not satisfactory.
Disclaimer: for organizations that have the dev firepower to use complex frameworks, these ones do tend to provide very complete functionality.
Point: problems mainly arise for small teams.
Criticism: see RoyalSloth's article for a criticism of today's technologies.
Note: I'll focus on pointing out areas of improvement in the large picture.
Point: complexity is the major obstacle.
Observation: this is often due to programming language limitations.
Observation: multiple dispatch helps make things simpler.
Explanation: what is multiple dispatch, and how it facilitates simplicity.
Further read: Grug's satire.
Observation: gap between web-based and native technologies.

# Improving the state of application development

When developing a cross-platform desktop application, the set of tools at our disposal today seems rather unsatisfactory.

Don't get me wrong, there are many solutions that get the job done. If you can afford to throw in lots of devs to the task, you will probably not care that a framework is more difficult to use than another, so long as you can get what you asked for in the end.
However, if you are alone or part of a small team, this is where the shortcomings of today's technologies for desktop applications really show. The development process is tedious and rough, often resulting in a poor experience and productivity. Not only does it require lots of effort to build a graphical cross-platform application, the lack of enjoyment in the process surely deters more than one enthusiastic developer from even trying seriously. Why bother developing graphical interfaces when the cost for doing so is so largely in favor of their command-line counterparts?

A crisiticm of major cross-platform GUI frameworks was already made by RoyalSloth [in his blog post](https://blog.royalsloth.eu/posts/sad-state-of-cross-platform-gui-frameworks/). I will not dive into the shortcomings of specific frameworks, and will instead focus on the larger picture. What may be improved? What would a great application development experience look like, and how can we get there?

I believe a major obstacle to an enjoyable and productive experience is first and firemost the complexity of the current solutions. I do not criticize application frameworks for that; a lot of the time, this complexity stems from aging low-level programming languages and patterns imposed by them. In contrast, modern yet mature languages (and even more so, high-level languages) are easier to use and to build upon.

For instance, object-oriented programming (C++, Java) was a step up from procedural programming (C) when used with care and expertise. Concurrently, many programming paradigms emerged with their strengths and weaknesses. I find that a very promising improvement lies with [multiple dispatch](https://en.wikipedia.org/wiki/Multiple_dispatch) when used with [subtyping](https://en.wikipedia.org/wiki/Subtyping). In the [Julia language](https://en.wikipedia.org/wiki/Julia_(programming_language)), multiple dispatch is *de facto* the primary paradigm (although it is a multi-paradigm language). In essence, the contribution of this feature to inviting simplicity comes from the ability to intuitively categorize types and write functions in the same global namespace, without worrying about whether a function is global, bound to a class, or bound to an instance of a class along.
I will leave a link to https://grugbrain.dev, an excellent satire that captures a lot of issues faced by programmers today; complexity being among the main ones. APIs built on top of imperative programming often carry unintuitive namespacing challenges and leaky abstractions lies declarative programming.

There appears to be a huge gap between web-based technologies and their native counterparts. It is not without reason that web frameworks have known a major success for desktop application development; most of them have better tooling and make for a better experience overall.
