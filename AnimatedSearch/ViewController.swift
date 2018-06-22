//
//  ViewController.swift
//  AnimatedSearch
//
//  Created by Oleksandr Shymanskyi on 6/20/18.
//  Copyright © 2018 Oleksandr Shymanskyi. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapKit: MKMapView!
    
    var dataArray = [String]()
    let inset: CGFloat = 8
    var searchView: SearchView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load test data
        loadListOfCountries()
        
        // setup test view
        searchView = SearchView.instanceFromNib()
        searchView.data = self.dataArray
        searchView.didSelect = { (choice) in
            print(choice)
        }
        view.addSubview(searchView)
        searchView.frame  = CGRect.init(x: inset,
                                        y: UIApplication.shared.statusBarFrame.size.height,
                                        width: UIScreen.main.bounds.size.width - inset * 2,
                                        height: searchView.searchViewHeight)
    } 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Private
    
    func loadListOfCountries() {
        // Specify the path to the countries list file.
        let pathToFile = Bundle.main.path(forResource: "countries", ofType: "txt")
        
        if let path = pathToFile {
            // Load the file contents as a string.
            let countriesString = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
            
            // Append the countries from the string to the dataArray array by breaking them using the line change character.
            dataArray = countriesString.components(separatedBy: "\n")
        }
    }
 
    // MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        self.searchView.collapseSearhView()
    }
}

