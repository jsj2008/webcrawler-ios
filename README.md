# About
This is a sample iOS app to learn NSThread API. Neither GCD, nor NSOperationQueue will be used.
The app will search for the given term on a given web page and all hyperlinks that are reachable from it.
The breadth search will be used.

Only built-in frameworks from iOS SDK will be used.

Its GUI has a single input screen that contains :

* A search term input
* A start URL input
* Load balancer settings (max threads count and max pages count)
* "Start" button

Pausing/resuming features are out of scope.


The program should produce a report as it proceeds. The report will contain the key-value pairs of 

* URL
* Number of search terms found

