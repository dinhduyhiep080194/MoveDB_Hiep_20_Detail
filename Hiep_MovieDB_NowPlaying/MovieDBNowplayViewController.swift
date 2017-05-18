//
//  MovieDBNowplayViewController.swift
//  Hiep_MovieDB_NowPlaying
//
//  Created by cntt17 on 5/13/17.
//  Copyright © 2017 cntt17. All rights reserved.
//

import UIKit

class MovieDBNowplayViewController: UITableViewController {
    
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?
    
    var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovie()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = movies[indexPath.row].title
        cell.detailTextLabel?.text = movies[indexPath.row].overview
        
        return cell
    }
    
    func getMovie() {
        if dataTask != nil {
            dataTask?.cancel()
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=f2eddf92e8482430aceb071df36d3e69&language=en-US&page=1") // API = f2eddf92e8482430aceb071df36d3e69
        
        dataTask = defaultSession.dataTask(with: url! as URL) {
            data, response, error in
            
            DispatchQueue.main.async() {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    do {
                        if let data = data, let response = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions(rawValue:0)) as? [String: AnyObject] {
                            
                            // Get the results array
                            if let array: AnyObject = response["results"] {
                                for movieDictonary in array as! [AnyObject] {
                                    if let movieDictonary = movieDictonary as? [String: AnyObject], let id = movieDictonary["id"] as? Int {
                                        // Parse the search result
                                        let title = movieDictonary["title"] as? String
                                        let poster = movieDictonary["poster_path"] as? String
                                        let overview = movieDictonary["overview"] as? String
                                        let adult = movieDictonary["adult"] as? String
                                        let genre_ids = movieDictonary["genre_ids"] as? String
                                        let releaseDate = movieDictonary["release_date"] as? String
                                        let original_language = movieDictonary["original_language"] as? String
                                        let popularity = movieDictonary["popularity"] as? String
                                        let vote = movieDictonary["vote_average"] as? String
                                        self.movies.append(Movie(id: id, title: title, poster: poster, overview: overview, releaseDate: releaseDate, adult: adult, genre_ids: genre_ids, original_language: original_language, popularity: popularity, vote: vote))
                                    } else {
                                        print("Not a dictionary")
                                    }
                                }
                            } else {
                                print("Results key not found in dictionary")
                            }
                        } else {
                            print("JSON Error")
                        }
                    } catch let error as NSError {
                        print("Error parsing results: \(error.localizedDescription)")
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.tableView.setContentOffset(CGPoint.zero, animated: false)
                    }
                    
                }
            }
        }
        
        dataTask?.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "Movie detail":
                let detailVC = segue.destination as! DetailViewController
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    detailVC.movie = idAtIndexPath(indexPath: indexPath as NSIndexPath)
                }
                break
                
            default:
                break
            }
        }
    }
    
    // MARK: - Helper Method
    
    func idAtIndexPath(indexPath: NSIndexPath) -> Movie
    {
        return movies[indexPath.row]
    }
}

