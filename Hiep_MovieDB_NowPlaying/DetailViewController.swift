//
//  DetailViewController.swift
//  Hiep_MovieDB_NowPlaying
//
//  Created by Dinh Duy Hiep on 5/17/17.
//  Copyright © 2017 cntt17. All rights reserved.
//

import UIKit

class Downloader {
    
    class func downloadImageWithURL(_ url:String) -> UIImage! {
        
        let data = try? Data(contentsOf: URL(string: url)!)
        return UIImage(data: data!)
    }
}

class DetailViewController: UIViewController {
    // Khai báo các label để hiển thị thông tin Detail của phim
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var posterImage: UIImageView!
    @IBOutlet var releaseLabel: UILabel!
    @IBOutlet var voteLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    
    var queue = OperationQueue()
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovieDetail()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Hàm lấy thông tin Detail Movie từ trang https://www.themoviedb.org/
    func getMovieDetail() {
        if let id = movie?.id {
            let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(id)?api_key=f2eddf92e8482430aceb071df36d3e69&language=en-US")
            print("https://api.themoviedb.org/3/movie/\(id)?api_key=f2eddf92e8482430aceb071df36d3e69&language=en-US") // API = f2eddf92e8482430aceb071df36d3e69
            var temp = [String:Any]()
            let request = NSMutableURLRequest(url: url! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 3)
            
            request.httpMethod = "GET"
            
            _ = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (Data, URLResponse, Error) in
                
                if (Error != nil) {
                    print(Error!)
                } else {
                    
                    do {
                        temp = try JSONSerialization.jsonObject(with: Data!, options: .allowFragments) as! [String:Any]
                        self.queue.addOperation { () -> Void in
                            if let path = temp["poster_path"] as? String {
                                let image = Downloader.downloadImageWithURL("https://image.tmdb.org/t/p/w640\(path)")
                                OperationQueue.main.addOperation({
                                    self.posterImage.image = image
                                    self.titleLabel.text = temp["title"] as? String
                                    self.overviewLabel.text = temp["overview"] as? String
                                    self.releaseLabel.text = temp["release_date"] as? String
                                    self.voteLabel.text = temp["vote_average"] as? String
                                })
                            }
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }).resume()
        }
    }
}
