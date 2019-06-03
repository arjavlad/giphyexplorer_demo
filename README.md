# giphyexplorer_demo
This is a demo project for Giphy Explorer where you can search Giphy gifs.

How to Test the API response parser:
1. Open GiphyExplorerTests.swift and run "testGiphyResponseInitialiser". This will test the initialiser with sample json payload.

1. Why I have used Codable for json parsing?
-  Codable is the inbuilt Swift API which allows us to easily convert raw json response into swift models without needing to write complex code.
