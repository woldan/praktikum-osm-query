# Simple OSM XML Toying

## Prerequisites

The following assumes you want to manage the Ruby installation with [rbenv](https://github.com/sstephenson/rbenv).
This is not strictly necessary but very comfortable as it allows you to use different Ruby variants and even gem-sets
with different local projects.

### Ruby Installation and Details

Install `rbenv` to manage Ruby:

    brew install git
    brew install rbenv
    brew install ruby-build
    brew install bash-completion

Add `rbenv` to PATH and make auto-completion work:

    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
    echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

Depending on your terminal you might want/need to use `.bashrc` instead of `.bash_profile`.

Optional: Install modern Ruby

    rbenv install 2.0.0-p247

Select local Ruby installation:

    cd <project>
    rbenv local 2.0.0-p247

### Ruby Gem nokogiri

Install gem `nokogiri` for nicer XML support:

    gem install nokogiri

### Ruby Installation and Details

See the very few options:

    ruby queryosm.rb --help

Run it with downloaded dump:

    ruby queryosm.rb -f dump.xml

Run it with downloading from Web service

    ruby queryosm.rb

Both will produce a (not properly projected and upside-down) SVG file

    open out.svg
