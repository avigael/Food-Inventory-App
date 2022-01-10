# FoodBox - Food Inventory App

This is an application developed in Swift for iOS and iPadOS devices that allows you to keep track of food items in your pantry and their freshness.

## Features: Version 3.0
You can scan barcodes to quickly add items to your inventory. Setting an expiration date will send 2 push notifications one notification warning you that the expiration date is near and one notifying you when the item has expired. You can turn notifications on and off and modify the threshold for how early you are warned of an expiration.

To personalize your application you can modify the default color scheme and change the background image.

This application is built entirely in Swift and uses SwiftUI for the interface. However, there are some features that require UIKit tools that then interface with SwiftUI. Barcode information is provided by the [Edamam API](https://www.edamam.com/ "Edamam API"). This application uses CoreData, AppStorage, and FileManager to store user data.

## Screenshots
<div>
	<img src="https://raw.githubusercontent.com/avigael/Food-Inventory-App/main/Previews/Splash.png" height=450>
	<img src="https://raw.githubusercontent.com/avigael/Food-Inventory-App/main/Previews/Create.PNG" height=450>
	<img src="https://raw.githubusercontent.com/avigael/Food-Inventory-App/main/Previews/Scan.png" height=450>
	<img src="https://raw.githubusercontent.com/avigael/Food-Inventory-App/main/Previews/Home.PNG" height=450>
	<img src="https://raw.githubusercontent.com/avigael/Food-Inventory-App/main/Previews/Settings.PNG" height=450>
	<img src="https://raw.githubusercontent.com/avigael/Food-Inventory-App/main/Previews/Search.PNG" height=450>
	<img src="https://raw.githubusercontent.com/avigael/Food-Inventory-App/main/Previews/Delete.PNG" height=450>
</div>
