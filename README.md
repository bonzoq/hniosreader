Hacker News API-Based iOS Reader
===========

Why another HN client? Live updates with minimum overhead have become possible with the introduction of the new API. Also, existent clients focused more on exact data scraping rather then user experience. It's time to change that and build a HN reader we all deserve.

This app utilizes Firebase iOS SDK https://www.firebase.com/docs/ios/quickstart.html, which allows for real-time content updates. However, as those updates could be too frequent, top 100 stories are downloaded just once. To get the latest 100 stories, pull to refresh. 

Number of comments and votes should change in real-time (to be done).

Currently these two endpoints have been implemented:

https://hacker-news.firebaseio.com/v0/topstories

and 

https://hacker-news.firebaseio.com/v0/item/.

To-do list:

1. Live updates of the number of comments and the score for each story.
2. Twitter or facebook style information that the top 100 stories have changed. User can then pull to refresh.
3. Tableview with comments. 
4. Displaying user profiles.

Feel free to contribute. Fork and submit a pull request. Since getting data has become straight-forward, usability and great user experience should be the priority now. Hopefully, with your help a free state-of-the-art app will become available for the benefit of this great community. 

![alt tag](https://raw.github.com/bonzoq/hniosreader/master/preview.png)

License
===========

The MIT License (MIT)

Copyright (c) 2014 HNiOSreader

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
