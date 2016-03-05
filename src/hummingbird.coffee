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
    if not searchResults? or Object.keys(searchResults).length == 0
      res.send "Search for something first. Baka."
      return

    if not res.match? or res.match[1].length <= 0
      res.send "Need exactly 1 argument."
      return

    number = parseInt(res.match[1], 10)

    if not number? or isNaN number
      res.send "Argument was not a number"
      return

    if number < 0
      res.send "You don't have to be so negative..."
      return

    if number > searchResults.search.length
      res.send "Not enough search results. Found #{searchResults.search.length} possible anime."
      return

    res.send "#{searchResults.search[number].title} - #{searchResults.search[number].desc[..100]} - more info: https://hummingbird.me/anime/#{searchResults.search[number].link}"


