# Movie App

This app categorized into 3 parts.
* POPULAR
* TOP RATED
* UPCOMING

All the data is coming from https://www.themoviedb.org

In POPULAR View Controller you are able to search any movie from the web site it automatically shows. Other View Controllers just show the information related to categorized movies.

All 3 View Controllers Subclassed by UITableViewController and one UITableViewCell is used for all View Controllers to display data.
One Seperate View Controller shows the whole information about movie.

This app does not use Web-site API server instead it looks through the movie informations and collects then it shows to you. That is becase cacheing the data is a little bit tricky in this case. I could not get any one of my account id approved so I decided not to use it.
I used some open source libraries:
- SwiftSoup:  https://github.com/scinfu/SwiftSoup

It allows you to search web site and get information from it by using the elements of the web site.
- SDWebImage: https://github.com/SDWebImage/SDWebImage

In table View I used an image that will be called when I scroll the table view cell. In order to reach out to the internet everytime when I scroll it uses uers data. So this open source library helps to cache the image itself.

- ProgressRingView: https://github.com/maxkonovalov/MKRingProgressView

To be able to show movie rank I used MKRingProgressView so it allows you to make Ring Progress.

- YouTubePlayer: https://github.com/gilesvangruisen/Swift-YouTube-Player

It allows to play youtube link where we need to play Movie Trailer.

![untitled design](https://user-images.githubusercontent.com/23249828/49878883-021a4800-fe6c-11e8-90b8-dd989fd3bdac.png)
