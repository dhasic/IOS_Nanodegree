For users:

Salzburg Super Ski Card (SSSC) is one of the largest ski cards in the world. The card is valid in 25 different regions spanning over 5 counties in Austria and it gives access to over 2750 kilometers of slopes (with 2.100 km technical snowed). The card is valid for 199 days and  can be used on 925 ski lifts!
However, an average skier does not use all the benefits of the SSSC becasue it is difficult to know all the regions where the card is accepted. Until now!
This app is a perfect companion for a skier who posseses the SSSC. With an easy to use interface it is easy to discover all regions and access informations about those regions. Also, for an even better exerpeince, the app shows pictures taken by others and posted on Flicker right in the app, so the skier can easily look at all beautiful scenery and slopes the region provides.
But apart from this, how often, at the end of the season you wanted to know, how many days you actually skied and where. Well now this is easier then ever. By using this app and simply checking in and out when you ski, you automatically create a ledger where all the regions, dates and times in which you skied are saved and accessible to you at any time.
Informations such as total days skied and number of regions visited are also available and automatically updated as you ski through the season.

With this app, there are no more undiscovered regions! It provides you with everything you need for a perfect ski season with SSSC (apart from the snow, of course :) )


For reviewer:

This app uses only ios and xcode native libraries. It containes 4 viewcontrollers, uses core data and Flicker API to download the images.
When an App starts for the first time it loads the information about the regions from the file Regions.json. It stores those information in Core Data, more precisely in Region entity. The class RegionImporter.swift takes care of the import and storing everything in Core Data.

First view controller is called FirstPageViewController. On this page a user can select the region from the pickerview and then check in and out by pressing the button. The button changes functions CheckIn/Out after pressed. When a check in button is pressed an event is created. Events are stored in Core Data as well and are used to store when a user skied and where. They simply have start and end times (corresponding to check in and check out times) and region reference (the one selected by user). Cancel button cancels check in and deletes the event created. User choice of the region and state of the button is stored in NSUserDefaults and loaded when an app starts.

Second tab is managed by MapViewController. The view consists of a map where a pin simbolizes the region. The pin coordinates are constructed from longitude/latitude previously loaded in Core Data from Ragions.json file. When a user taps on the pin, an annotation displaying the region name appears with "info button" next to it. When this info button is clicked a RegionDetails View appears.

RegionDetails view (controlled by RegionDetailsViewController) displays the region details. It also has a clickable link taking the user to the official website by opening the link in Safari. Below the general information a collection view displaying images in located. New images are downloaded in viewDidLoad and also when a user clicks on More Images Button which reloads the collection view with new images. Stack view is used to split the view in half, one half for information, another for images. FlickerManager.swift class manages the FlickerApi.

Last view is Events Information view (controlled by EventInformationViewController). Here in the first part general informations are stored. They are updated whenever the view appears. In the bottom part a table view consisting of all events is displayed. Events (created when user checks in/out) are also updated whenever a view appears.