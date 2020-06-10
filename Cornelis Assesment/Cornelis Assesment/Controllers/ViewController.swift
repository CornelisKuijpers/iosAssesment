//
//  ViewController.swift
//  Cornelis Assesment
//
//  Created by Cornelis Kuijpers on 2020/06/09.
//  Copyright © 2020 Cor Kuijpers. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UISearchBarDelegate, NetworkingManagerDelegate {

    @IBOutlet weak var txtSearchBar: UISearchBar!
    @IBOutlet weak var tableviewAnswers: UITableView!
    
    var networkingManager = NetworkingManager()
    var answers : [Answer] = []
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addNavBarImage()
        
        //Data Sources
        tableviewAnswers.dataSource = self
        
        //Delegates
        txtSearchBar.delegate = self
        networkingManager.delegate = self
        tableviewAnswers.delegate = self
        
        //Register Nib
        tableviewAnswers.register(UINib(nibName: "AnswersCell", bundle: nil), forCellReuseIdentifier: "reusableCell")
        
        tableviewAnswers.backgroundView = activityIndicator

    }

    func addNavBarImage() {
        let navController = navigationController!
        let image = UIImage(named: "logo") //Your logo url here
        let imageView = UIImageView(image: image)
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        let bannerX = bannerWidth / 2 - (image?.size.width)! / 2
        let bannerY = bannerHeight / 2 - (image?.size.height)! / 2
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }

    //MARK: - Functions from NetworkManager
    func didFail(error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Oops! Not expected", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            self.activityIndicator.stopAnimating()
        }
    }
    
    func didUpdateData(StackOverflowdata: StackOverflowdata) {
        
        answers = []
        
        for answer in StackOverflowdata.items{
            
            let body = answer.body.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            
            let answerdata = Answer(is_Answered: answer.is_answered, title: answer.title, body: body, answers: answer.answer_count, views: answer.view_count, date: answer.creation_date, askedBy: answer.owner.display_name, votes: answer.score, question_id: answer.question_id)
            
            answers.append(answerdata)
            
        }
        
        DispatchQueue.main.async {
            self.tableviewAnswers.reloadData()
        }
        
    }
    
    //MARK: - txtSearch Functions
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        if searchBar.text != "" {
            return true
        }else{
            searchBar.placeholder = "Input required"
            return false
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        answers = []
        
        tableviewAnswers.reloadData()
        
        activityIndicator.startAnimating()
        
        if let searh = searchBar.text {
            print(searchBar.text!)
            networkingManager.searchStackOverflow(searchText: searh)
        }
        
        searchBar.text = ""
        //Rename placeholder if nothing was searched previous
        searchBar.placeholder = "Search"
    }
    
}

//MARK: - Table View Extensions
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableviewAnswers.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as! AnswersCell
        
        let answerIndex = answers[indexPath.row]
        
        if answerIndex.is_Answered {
            
            cell.imgAnswered.image = UIImage(named: "ic-check")
            
        }
        
        let date = Date(timeIntervalSince1970: answerIndex.date)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MMM dd ''YY" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        
        cell.txtTitle.text = "Q : \(answerIndex.title)"
        cell.txtBody.text = answerIndex.body
        cell.txtTotalViews.text = "\(answerIndex.views) views"
        cell.txtTotalAnswers.text = "\(answerIndex.answers) answers"
        cell.txttotalVotes.text = "\(answerIndex.votes) votes"
        cell.txtAskedBy.text = "asked \(strDate) by \(answerIndex.askedBy)"
        
        return cell
    }
}

extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Create a variable that you want to send based on the destination view controller
        // You can get a reference to the data by using indexPath shown below
        let question_id = answers[indexPath.row].question_id

        // Create an instance of PlayerTableViewController and pass the variable
        let destinationVC = WebController()
        destinationVC.question_id = question_id

        navigationController?.pushViewController(destinationVC, animated: true)
        // Let's assume that the segue name is called playerSegue
        // This will perform the segue and pre-load the variable for you to use
        
    }


}


