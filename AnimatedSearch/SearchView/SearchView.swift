//
//  SearchView.swift
//  AnimatedSearch
//
//  Created by Oleksandr Shymanskyi on 6/21/18.
//  Copyright © 2018 Oleksandr Shymanskyi. All rights reserved.
//

import UIKit

class SearchView: UIView, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var showButton: UIButton!
    
    var data: [String]!
    var filteredArray = [String]()
    var didSelect: ((String) -> Void)?
    
    let searchViewHeight: CGFloat = 60
    let tableViewCellHeight = 44
    let cellReuseId = "SearchViewCell"
    let maxNumberItemsInTableView = 5
    let buttonWidth = 60
    let inset: CGFloat = 8
    let siblingsCornerRadius: CGFloat = 4
    let animationDurationForTableView = 0.5
    let animationDurationForSearchBar = 0.6
    
    var showSearchBar = false {
        didSet {
            let width = frame.size.width
            if showSearchBar {
                showButton.isHidden = true
                searchBar.isHidden = false
                UIView.animate(withDuration: animationDurationForSearchBar, animations: {
                    self.searchBar.frame = CGRect.init(x: 0,
                                                       y: self.searchBar.frame.origin.y,
                                                       width: width,
                                                       height: self.searchBar.frame.size.height)
                }) { (finished) in
                    self.searchBar.becomeFirstResponder()
                }
            } else {
                UIView.animate(withDuration: animationDurationForSearchBar, animations: {
                    self.searchBar.frame = CGRect.init(x: width / 2,
                                                       y: self.searchBar.frame.origin.y,
                                                       width: 0,
                                                       height: self.searchBar.frame.size.height)
                }) { (finished) in
                    self.searchBar.isHidden = true
                    self.showButton.isHidden = false
                }
            }
        }
    }
    
    // MARK: Init
    
    class func instanceFromNib() -> SearchView {
        return UINib(nibName: "SearchView",
                     bundle: nil).instantiate(withOwner: nil,
                                              options: nil)[0] as! SearchView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureSearchBar()
        configureTableView()
        
        backgroundColor = .clear
        frame  = CGRect.init(x: inset,
                             y: UIApplication.shared.statusBarFrame.size.height,
                             width: UIScreen.main.bounds.size.width - inset * 2,
                             height: searchViewHeight)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // when search view is hidden let superview accept gestures
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.point(inside: point, with: event) {
            let view = super.hitTest(point, with: event)
            return view == self ? nil : view
        }
        guard isUserInteractionEnabled, !isHidden, alpha > 0 else {
            return nil
        }
        
        for subview in subviews.reversed() {
            let convertedPoint = subview.convert(point, from: self)
            if let hitView = subview.hitTest(convertedPoint, with: event) {
                return hitView
            }
        }
        return nil
    }
    
    // MARK: Configuring methods
    private func configureSearchBar() {
        searchBar.layer.cornerRadius = siblingsCornerRadius
        searchBar.becomeFirstResponder()
        showSearchBar = false
        searchBar.isHidden = true
    }
    
    private func configureTableView() {
        resultsTableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0,
                                                                          y: 0,
                                                                          width: 0,
                                                                          height: 0.01))
        resultsTableView.backgroundColor = .clear
        resultsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseId)
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
    }
    
    // MARK: Actions
    
    @IBAction func showButtonAction(_ sender: UIButton) {
        showSearchBar = !showSearchBar
    }
    
    // MARK: UITableview datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId,
                                                 for: indexPath as IndexPath)
        // move UI setup to tableview cell class
        cell.layer.cornerRadius = siblingsCornerRadius
        cell.selectionStyle = .none
        
        cell.textLabel?.text = filteredArray[indexPath.row]
        cell.backgroundColor = UIColor.init(white: 1, alpha: 0.7)
        return cell
    }
    // MARK: UiTableview delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if didSelect != nil {
            didSelect!(filteredArray[indexPath.row])
            collapseSearhView()
        }
    }
    // MARK: UISearchBarDelegate functions
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Filter the data array
        filteredArray = data.filter({ (country) -> Bool in
            let countryText:NSString = country as NSString
            return (countryText.range(of: searchText, options: .caseInsensitive).location) != NSNotFound
        })
        // set height size depends on number of items in table view
        if filteredArray.count < maxNumberItemsInTableView {
            frame.size.height = searchViewHeight +
                CGFloat(tableViewCellHeight) * CGFloat(filteredArray.count)
        } else {
            frame.size.height = searchViewHeight + frame.size.width
        }
        UIView.transition(with: resultsTableView,
                          duration: animationDurationForTableView,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.resultsTableView.reloadData()
        })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        resultsTableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        collapseSearhView()
    }
    
    // MARK: Public
    // hide search view
    
    func collapseSearhView() {
        if showSearchBar {
            searchBar.resignFirstResponder()
            filteredArray.removeAll()
            resultsTableView.reloadData()
            
            UIView.animate(withDuration: 0.3, animations: {
                self.frame.size.height = self.searchViewHeight
            }) { (finished) in
                DispatchQueue.main.async {
                    self.showSearchBar = false
                }
            }
        }
    }
}
