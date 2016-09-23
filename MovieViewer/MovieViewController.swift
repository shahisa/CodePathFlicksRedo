//
//  MovieViewController.swift
//  MovieViewer
//
//  Created by John Doe on 9/22/16.
//  Copyright © 2016 MorganX. All rights reserved.
//

import UIKit
import AFNetworking


class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            url: url! as URL,
            cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest,
                                                                     completionHandler: { (dataOrNil, response, error) in
                                                                        if let data = dataOrNil {
                                                                            if let responseDictionary = try! JSONSerialization.jsonObject(
                                                                                with: data, options:[]) as? NSDictionary {
                                                                                print("response: \(responseDictionary)")
                                                                               self.movies = responseDictionary["results"] as! [NSDictionary]
                                                                                self.tableView.reloadData()
                                                                            }
                                                                        }
        })
        task.resume()
        
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movie = movies {
            return (movies?.count)!
        }else{
            return 0
        }
    }
    
    
    
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieViewCell
        
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        let baseURL = "http://image.tmdb.org/t/p/w500"
        if let posterPath = movie["poster_path"] as? String{
        let imageURL = URL(string: baseURL + posterPath)
        cell.posterView.setImageWith(imageURL!)
        
        }
        
        return cell

    }
    
   

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let movie = movies![indexPath!.row]
        
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie
        
        print("segue is called")
    }
    

}
