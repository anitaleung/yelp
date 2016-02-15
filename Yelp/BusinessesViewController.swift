//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  
  
  var businesses: [Business]!
  var filteredData: [Business]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 120
    
    let searchBar = UISearchBar()
    searchBar.delegate = self
    searchBar.sizeToFit()
    
    navigationItem.titleView = searchBar
    
    searchBar.showsCancelButton = true
    
    navigationItem.titleView = searchBar
    
    Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
      self.businesses = businesses
      self.tableView.reloadData()
      
      
      for business in businesses {
        print(business.name!)
        print(business.address!)
      }
    })
   
    
    /* Example of Yelp search with more search options specified
    Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
    self.businesses = businesses
    
    for business in businesses {
    print(business.name!)
    print(business.address!)
    }
    }
    */
  }

  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.isEmpty {
      filteredData = businesses!
    } else {
      filteredData = businesses?.filter { business in
        return business.name!.lowercaseString.containsString(searchText.lowercaseString)
      }
    }
    print("TESTINGGGGG")
    tableView.reloadData()
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
    if filteredData != nil {
      cell.business = filteredData[indexPath.row]
    } else {
      cell.business = businesses[indexPath.row]
    }
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if filteredData != nil {
        return filteredData!.count
    } else if businesses != nil {
      return businesses.count
    } else {
      return 0
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}

extension BusinessesViewController: UISearchBarDelegate {
  func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
    searchBar.setShowsCancelButton(true, animated: true)
    return true;
  }
  
  func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
    searchBar.setShowsCancelButton(false, animated: true)
    return true;
  }
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    searchBar.setShowsCancelButton(false, animated: true)
    searchBar.resignFirstResponder()
    searchBar.text = ""
    filteredData = businesses!
    tableView.reloadData()
  }
}
