Objective: 
Make an app which-
* Reads JSON from a publicly available REST API endpoint
* Parses it and shows the contents in a table view
* Tapping on a table view item shows a detailed view of that item
* Persists the contents of the JSON data locally, so if the app is used without an
Internet connection, it will show previously downloaded content. If there is no internet
and no previously available data, please display an error in a user friendly way.

Approach:
* The API being used is: http://jsonplaceholder.typicode.com/ which fetches all posts and thereby shows its corresponding content on selection of a post
* Design pattern used - MVVM
* This exercise makes use of NSFetchedResultsController for showcasing data onto the View
* The data received from the service is saved onto Core Data and incase internet is not available it reads from therein.
* A fresh service call erases the previous cached data on successful receiving of data and stores it thereafter.

Note:
** Compiled on latest Xcode 11.1
** Tested on iOS 13

![Image of README](https://github.com/ratulchhibber/SampleCoreDataApp/blob/master/README.png)
