//
//  CommentsViewController.swift
//  TVShows
//
//  Created by Ivana Mrsic on 05/08/2018.
//  Copyright © 2018 Ivana Mrsic. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import CodableAlamofire

let cellReuseIdentifier = "CommentTableViewCell"

class CommentsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var postStackBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var addCommentTextField: UITextField!
    @IBOutlet weak var commentsTableView: UITableView!
    
    @IBAction func postTapped(_ sender: Any) {
    }
    
    var episodeId: String?
    var comments: [Comment] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchComments()
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.title = "Comments"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic-navigate-back"), style: .plain, target: self, action: #selector(navigateBack))
        navigationItem.leftBarButtonItem?.tintColor = .black;
        
        //commentsTableView.separatorColor = .white
        
        addCommentTextField.layer.cornerRadius = 50
        
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        postStackBottomConstraint.constant = +keyboardSize.height
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        postStackBottomConstraint.constant = -keyboardSize.height
    }
    
    private func setupTableView() {
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        commentsTableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addCommentTextField.resignFirstResponder()
        return true
    }
    
    @objc func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
    
    private func fetchComments() {
        SVProgressHUD.show()
        
        guard let episodeId = episodeId else {
            return
        }
        
        let url = Constants.URL.constructFetchEpisodeCommentsUrl(episodeId: episodeId)
        
        Alamofire
            .request(url,
                     method: .get,
                     encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (dataResponse: DataResponse<[Comment]>) in
                
                SVProgressHUD.dismiss()
                
                switch dataResponse.result {
                case .success(let comments):
                    self?.comments = comments
                    //print(comments)
                    
                    self?.commentsTableView.reloadData()
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
    }
}

extension CommentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension CommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! CommentTableViewCell
        
        let comment = comments[indexPath.row]
        
        cell.setUp(comment: comment)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
}
