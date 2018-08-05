//
//  AddEpisodeViewController.swift
//  TVShows
//
//  Created by Ivana Mrsic on 26/07/2018.
//  Copyright © 2018 Ivana Mrsic. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import CodableAlamofire

let ADD_EPISODE_URL = "https://api.infinum.academy/api/episodes"

protocol AddEpisodeDelegate {
    func updateEpisodeList(episode: Episode)
}

class AddEpisodeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var episodeTitleInputText: UITextField!
    @IBOutlet weak var seasonNumberInputText: UITextField!
    @IBOutlet weak var episodeNumberInputText: UITextField!
    @IBOutlet weak var episodeDescriptionInputText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var delegate: AddEpisodeDelegate?
    
    var showId: String?
    var token: String?
    private var mediaId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
    }

    @IBAction func uploadPhotoTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .savedPhotosAlbum
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    @objc func didSelectCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didSelectAddEpisode() {
        addEpisode()
    }
    
    private func addMedia(image: UIImage) {
        guard let token = token else {
            return
        }
        
        let headers = ["Authorization": token]
        let imageByteData = UIImagePNGRepresentation(image)!
        
        Alamofire
            .upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imageByteData,
                                         withName: "file", fileName: "image.png",
                                         mimeType: "image/png")
            }, to: Constants.URL.postMedia,
               method: .post,
               headers: headers)
            { [weak self] result in
                switch result {
                case .success(let uploadRequest, _, _):
                    self?.processUploadRequest(uploadRequest)
                case .failure(let encodingError):
                    print(encodingError)
                } }
    }

    func processUploadRequest(_ uploadRequest: UploadRequest) {
        uploadRequest .responseDecodableObject(keyPath: "data") { (response:
            DataResponse<Media>) in
            switch response.result {
            case .success(let media):
                print("DECODED: \(media)")
                self.mediaId = media.id
                print("Proceed to add episode call...")
            case .failure(let error):
                print("FAILURE: \(error)")
            }
        }
    }
    
    private func addEpisode() {
        SVProgressHUD.show()
        
        guard let showId = showId,
            let episodeTitleText = episodeTitleInputText.text,
            let episodeDescriptionText = episodeDescriptionInputText.text,
            let episodeNumberText = episodeNumberInputText.text,
            let seasonNumberText = seasonNumberInputText.text,
            let token = token,
            let mediaId = mediaId
        else {
            return
        }
        
        let parameters: [String: String] = [
            "showId": showId,
            "title": episodeTitleText,
            "description": episodeDescriptionText,
            "episodeNumber": episodeNumberText,
            "season": seasonNumberText,
            "mediaId": mediaId
        ]
        
        let headers = ["Authorization": token]
        
        Alamofire
            .request(ADD_EPISODE_URL,
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (dataResponse: DataResponse<Episode>) in
                
                SVProgressHUD.dismiss()
                
                switch dataResponse.result {
                case .success(let episode):
                    if let delegate = self?.delegate {
                        delegate.updateEpisodeList(episode: episode)
                    }
                    self?.dismiss(animated: true, completion: nil)
                case .failure(let error):
                    self?.failedAddEpisodeAlert()
                    print("API failure: \(error)")
                }
            }
    }
    
    private func failedAddEpisodeAlert() {
        let alertController = UIAlertController(title: "Can't add episode", message: "Please check episode data", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Okay", style: .default)
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func setupViewController() {
        navigationController?.navigationBar.tintColor = UIColor(red: 255/255, green: 117/255, blue: 140/255, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didSelectCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(didSelectAddEpisode))
        navigationItem.title = "Add episode"
        
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false

        episodeTitleInputText.setBottomBorder()
        seasonNumberInputText.setBottomBorder()
        episodeNumberInputText.setBottomBorder()
        episodeDescriptionInputText.setBottomBorder()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickedImage = info["UIImagePickerControllerEditedImage"] as? UIImage
        guard let image = pickedImage else {
            return
        }
        imageView.image = image
        addMedia(image: image)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       // <#code#>
    }
}
