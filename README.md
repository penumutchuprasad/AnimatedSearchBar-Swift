# AnimatedSearchBar Swift
Animated iOS native UISearchBar with simple example. All code is written with Swift 4

## PRESENTATION
AnimatedSearchBar will offer you suggestions when you priny something there. Its height changes depends on number of items.

## DEMO
![](https://github.com/Shymanskyi/AnimatedSearchBarSwift/blob/master/Gifs/AnimatedSearch.gif)

## USAGE
```Swift
let searchView = SearchView.instanceFromNib()
searchView.data = self.dataArray
searchView.didSelect = { (choice) in
    print(choice)
}
view.addSubview(searchView)
```

## Author
Oleksandr Shymanskyi (shymanskyi.oleksandr@gmail.com)
