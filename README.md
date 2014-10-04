massive-archer
==============
The number-one site for up to date Husker news.

Dev environment setup
=====================
1. If you're on a Mac, get [Homebrew](http://brew.sh/)
2. Install mysql server and client on your computor.
3. Install git `brew install git` or `sudo apt-get install git`
4. Install rvm `\curl -sSL https://get.rvm.io | bash -s stable --ruby` This will install the latest stable Ruby. We have the version of Ruby used in the Gemfile so rvm will automatically switch when we're working in that folder. How great is that?
5. Install bundler `gem install bundler`
6. Clone the repository
7. You will need a /.config/ folder in the root and a config.json file in that folder. These are not committed to the repo. Email tlemburg for details. 
8. Go to that directory and `bundle install`
9. `rake migrate` to get your dev database up to date
10. `shotgun` in the root directory to launch the website at a localhost port (9393 I think is the default)
