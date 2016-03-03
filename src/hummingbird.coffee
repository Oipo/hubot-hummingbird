module.exports = (robot) ->

  searchResults = {}

  robot.respond /hummingbird-search (.*)/i, (res) ->
    animeTitle = res.match[1]
    robot.http("https://hummingbird.me/search.json?query=#{animeTitle}&type=mixed")
          .get() (err, httpRes, body) ->
            if err
              res.send "Encountered an error #{err}"
              return

            if httpRes.statusCode isnt 200
              res.send "Request didn't come back HTTP 200 :("
              return

            searchResults = JSON.parse(body)

            res.send "Found #{searchResults.search.length} possible anime. First possible anime: #{searchResults.search[0].title}"


  robot.respond /hummingbird-list (.*)/i, (res) ->
    if not searchResults?
      res.send "Search for something first. Baka."
      return

    number = res.match[1]

    if number > searchResults.length
      res.send "Not enough search results. Found #{searchResults.search.length} possible anime."
      return

    res.send "#{searchResults.search[number].title} - #{searchResults.search[number].desc[..100]} - more info: https://hummingbird.me/anime/#{searchResults.search[number].link}"


