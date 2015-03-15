Hacker News Client Version 2.0
===========

This app is now available on Appstore at https://itunes.apple.com/us/app/hacker-news-client/id939454231?mt=8&uo=4.

This is probably the first iOS Hacker News client that uses the newly introduced official Firebase Hacker News API. One of the cool features of the new API are updates pushed in real time. The app refreshes the number of points and the number of comments for each story automatically. If you want to reload the stories completely, simply pull to refresh. Reloading stories does not happen automatically, since it could be annoying if the order of stories changed while the user is browsing them. 

What also distinguishes this app is its fresh look and feel. It feels like a proper iOS 8 app. It makes use of iOS 8 self-sizing tableview cells. You can adjust the comments' font size by going to iOS's Settings -> General -> Accessibility -> Larger Text and dragging the slider. 

Hacker News Client is completely open source. Feel free to contribute. 

Don't forget to install pods once you clone the code. 

Contributing
===========

Your ideas for improving this app are greatly appreciated. The best way to contribute is by submitting a pull request. I'll do my best to respond to you as soon as possible. You can also submit a new Github issue if you find bugs or have questions. 

To-do list as of 15 March 2015:

1. An app extension in the Today view (Today widget). https://developer.apple.com/library/ios/documentation/General/Conceptual/ExtensibilityPG/NotificationCenter.html#//apple_ref/doc/uid/TP40014214-CH11-SW1
2. Extending user profile with user's stories, polls and comments.

License
===========

The MIT License (MIT)

Copyright (c) 2014 Marcin Kmiec

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
