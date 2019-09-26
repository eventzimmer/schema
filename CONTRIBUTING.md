Contribution guideline
----------------------

Heads up! You've already made the first step by reading through the repository that led you here. We'd like you to add some finishing touches for your contributions :sparkles: 

### Self-conception

`eventzimmer` is a non-profit organization which comes with a privacy first mentality. It was born out of the idea that noone should have to log in, let alone provide personal information, to access public information (erm, erm, Facebook). If you make a contribution, please bear this in mind. New features should invade user privacy as little as possible. Thank you :cake: 

### Submitting your pull requests

We highly value the open source community. It is insanely innovative, and unlike professional environment, leaves plenty of room for experiments.

Noone grows a guru, so do not be afraid of submitting even a rough idea. We will guide you through the process, if need be.

All of our repositories come with continous integration and continous deployment. If your PR is green :white_check_mark:  on GitHub, it will most likely pass.

Please also make sure you check this list:

- add your change to the `CHANGELOG.md` in the respective repository
- make sure Travis tests pass :white_check_mark:
- if your commit does close an existing ticket: use a [closing issue keyword](https://help.github.com/en/articles/closing-issues-using-keywords) (e.g: `closes #15`) in your commit. This makes live easier for our issue tracker.
- if possible, test your changes with the deploy preview at least once. Promises made, you will enjoy it :hamburger: 
- add yourself to the [`CONTRIBUTORS.md`](https://github.com/eventzimmer/schema/blob/master/CONTRIBUTORS.md) as you like

### Side notes about issue reporting

If you open an issue in one of our issue trackers, please include a decent amount of information to reproduce. It may not have been outlined enough, but [writing good bug reports](https://www.softwaretestinghelp.com/how-to-write-good-bug-report/) is an art in itself. Please include at least the following information:

- the version that is affected. If you use the deployed version of `site` or `dashboard`, you can assume the latest `master`
- a textual description of what is the problem
- a copy of your requests to `api.eventzimmer.de`. Include at least the `request headers`, `response headers` and `body`. In Chrome, you can easily capture requests with [network analysis](https://developers.google.com/web/tools/chrome-devtools/network/reference) from the devtools.
- optionally a visual description of your issue. It **really** helps if you record a video, or a GIF of your bug. 

If you do include a request `body`, consider uploading it as a file attachment to your issue. Noone wants to read network dumps in a GitHub issue. Thanks :wine_glass: 

### Side notes about licensing

If you submit a pull request in one of our repositories, please do note you understand the consequences. Unless explicitely stated otherwise, your source code **will** be published with the repositories license (MIT). Contributions with incompatible license will most likely not be accepted.

