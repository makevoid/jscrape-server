# jScrape
### server

### scraping in javascript made easy

What do I need to test the solution?

[jscrape](https://github.com/makevoid/jscrape)
the javascript client library


What do I need to run the scraping in production?

[jscrape-server](https://github.com/makevoid/jscrape-server):
- the ruby eventmachine executable running


more infos: [http://jscrape.it](jscrape.it)


### Setup

    git clone git://github.com/makevoid/jscrape-server.git
    cd jscrape-server
    bundle install    

### Run

    ruby jscrape.rb -p 3000
  
or (daemonized)
  
    ruby jscraped.rb start -- -p 3000


enjoy!



p.s.: don't forget to set

    $.jScrape_server = "localhost:3000"
  
or whatever your host/port is on your clientside javascript code.


### Changes:

added cookie support (api will probably change)

example: 

    http://jscrape.it:9393//q/<URL>/<COOKIE>

    http://jscrape.it:9393/q/http%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DjL1KiWN26Q0/PREF=f1=40000000&f2=40000000
    # returns a youtube video (html5 version)
    
    
    # ajax request (using jquery):  
    $.get("http://jscrape.it:9393/q/"+encodeURIComponent("http://makevoid.com"), function(data){ console.log(data)  })
    
