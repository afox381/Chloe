# YNAP Technical Test

## Author

Andrew Fox, June 2022

## Project Details

The Chloe app consists of three core sections, a horizontally scrolled list of categories which, when tapped take the user to a paged collection view
containing products from that category. Both of these are written using UIKit and Swift. Tapping on a product in the collection view takes the user 
to the detail view showing a broader collection of information about the selected product. This was written using SwiftUI.

Combine is used for the data fetching. A single unit test was included for the business logic around the local repository, in line to handle the likes
(though not currently wired up due to time constraints). Snapshot tests were included for a single category layout as well as a single arranged detail
view. These could of course be extended, but cover a basic set of features for this technical test.  

The "iOS Developer test" pdf goes into additional detail around project requiremenets. 

This project was completed in roughly 12 hours across the span of 5 days.

The target device developed against was the latest Swift/iOS on the iPhone 13 Simulator. All snapshot tests have been set against this combination.

## Suggested Improvements

- Localisation files should be added and replace all hard-coded strings in the app (TODO's have been left in-code as a reminder)
- The "Likes" feature shoud be wired up correctly to enable liking of products, though preferably tied to an account
- Discrete communication error states should be handled and communicated to the user appropriately
- Offline state should be handled
- Improved UI handling of other device sizes, with half an eye on iPad
- Snapshot tests should be fixed to a specific iOS release
