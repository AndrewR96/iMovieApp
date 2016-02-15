//
//  MoviesViewController.swift
//  iMovieNet
//
//  Created by Andrew Rivera on 2/12/16.
//  Copyright © 2016 Andrew Rivera. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var movies: [NSDictionary]?
    
    //uncomment:
   var filteredMovies: [NSDictionary]?
    
    
    var endpoint: String!
    
    /*let data = ["Deadpool", "The 5th Wave", "Kung Fu Panda 3", "Zoolander 2"
        , "How to Be Single", "Zootopia", "Embrace of the Serpent","Misconduct", "The Specialist"
        , "Hail, Caesar!", "Ride Along 2", "Jarhead 3: The Siege", "Pride and Prejudice and Zombies",
        "Dirty Grandpa", "The Key", "The Boy", "Donald Trump's The Art Of The Deal", "Homo Sapiens",
        "Batman: Bad Blood","The Forest"]*/
    
    /*var filteredData: [String]!
    var searchController: UISearchController!
    */
    
    override func viewDidLoad() {
    super.viewDidLoad()
        
        tableView.dataSource = self
            //filteredData = data
        
        tableView.delegate = self
        searchBar.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        // uncomment:
       //filteredMovies = movies
        
}
    
func refreshControlAction(refreshControl: UIRefreshControl) {

        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!,cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
           timeoutInterval: 10)
    
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
        delegate: nil, delegateQueue: NSOperationQueue.mainQueue()
        )
            
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    
    
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                
            MBProgressHUD.hideHUDForView(self.view, animated: true)
                
                if let data = dataOrNil{
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            print("response: \(responseDictionary)")
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                            self.tableView.reloadData()
                            
                    }
                }
                self.tableView.reloadData()
                
                refreshControl.endRefreshing()
        });task.resume()

        // Do any additional setup after loading the view.
}


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       // if let movies = movies {
        
        //uncomment:
        if let filteredMovies = movies{
           return filteredMovies.count
            
            
            return movies!.count
            
        }
            else{
                    return 0
        }
    }
   
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
       let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        //let movie = filteredMovies![indexPath.row]
        
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.redColor()
        cell.selectedBackgroundView = backgroundView
        
        let movie = movies![indexPath.row]
            let title = movie["title"] as! String
            let overview = movie["overview"] as! String
       
        
            if let posterPath = movie["poster_path"] as? String{
            let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
            let posterUrl = NSURL(string: posterBaseUrl + posterPath)
            cell.posterView.setImageWithURL(posterUrl!)
    }
        else{
            
            cell.posterView.image = nil
          
    }
            cell.titleLabel.text = title
            cell.overviewLabel.text = overview
        
            print("row \(indexPath.row)")
            return cell
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        // When there is no text, filteredData is the same as the original data
        if searchText.isEmpty {
            filteredMovies = movies
        } else {
            // The user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
            
            filteredMovies = movies?.filter({ (movie: NSDictionary) -> Bool in
                // If dataItem matches the searchText, return true to include it
                if let title = movie["title"] as? String{
                    if title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    
                        return true
                } else {
                    return false
                }
            }
                return false
                })
        }
        tableView.reloadData()
        }

    
    //The bottom code is part of assignment two!
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie = movies![indexPath!.row]
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.movie = movie
        
        
        
        print("print prepare for segure called")
        
        //Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
}
}


