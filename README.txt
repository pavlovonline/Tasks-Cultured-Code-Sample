This is a sample code project. A task keeper. Except turbo charged.

This task keeper allows you to log into an account and keep track of all your tasks. Log into the same account across multiple devices. Or create multiple accounts and log into each separately.

Hit the + to add a task. You'll get asked if you want auto-emailing enabled. If you say yes, upon saving your task, you'll be prompted with a email message view where you can send yourself the reminder. (turn this off in settings later)

This keeper supports addition of photos, dates, and locations.

Photos are trimmed and sized down to keep the storage down using the UIImageResizer you'll find on my github.

Location is added using Google Places query. You can search for a place by name/address or have it show places around you.

Once added, you can hit the ">>" button to mark the task complete, which will remove it from the task view and make it appear in "Complete" section. Want to put it back? Hit the "<<" button.

Click on a task and you'll be shown a simple view with task information. Here you can also mark it complete. 

If the task has a location added, you will see the location. Hit the location title and you will be shown a map of the location point with a zoom animation. You can also hit the right BarButton to open it in Maps.

Some main points:
-This project heavily uses blocks/gcd/multi threading.
-Tasks are stored in a noSQL cloud storage, which will make them accessible from Android, Windows phone, or via REST.
-This was built pretty quickly in the past 2 days. If you want to see more of my work, please download V Nation on the App Store. 
-You do need internet connection for this to work. If I put more time into it, these would be cached locally in Core Data/local disk.
-If you have issues with Provisioning profiles (you shouldn't), just add the app to your existing provisioning profile on Apple Developer portal. Or shoot me a note.

-Anton
