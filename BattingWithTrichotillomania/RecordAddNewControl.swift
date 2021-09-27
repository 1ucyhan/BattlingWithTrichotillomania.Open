//
//  AddRecordViewController.swift
//  BattingWithTrichotillomania
//
//  Created by Lucy Han on 09/14/2021.
//


import UIKit
import Firebase

class RecordAddNewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var recordHistoryController : RecordsHistoryViewController?
               
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    lazy var timestampTextField: UITextField = {
        let tf = UITextField()
        
        tf.textAlignment = .center
        //tf.backgroundColor = UIColor.blue
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Pick your date right here ..."
        tf.borderStyle = .roundedRect
        
        let picker = UIDatePicker()
   
        // Posiiton date picket within a view
        picker.timeZone = NSTimeZone.local
        //picker.backgroundColor = UIColor.white
        picker.datePickerMode = .dateAndTime
        
        tf.inputView = picker
        
        picker.addTarget(self, action:#selector(self.tsValueChanged), for: .valueChanged)
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = BWTFormatConstants.timestampFormatStr
        tf.text = dateFormatter.string(from: Date())
        
        
        return tf
    }()
    
    
    @objc func tsValueChanged(sender: UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = BWTFormatConstants.timestampFormatStr
        timestampTextField.text = dateFormatter.string(from: sender.date)
    }
    */
    
    let ratingcontrol: RatingControl = {
        let rating = RatingControl()
        rating.rating = 3
        rating.translatesAutoresizingMaskIntoConstraints = false
       // rating.backgroundColor = UIColor.yellow
        rating.isUserInteractionEnabled = true
        return rating
    }()
    
    
    lazy var recordImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "image2")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode =  .scaleAspectFit
        //imageView.backgroundColor = UIColor.red
                
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectRecordImageView)))

        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
            
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray
        
        let saveImage   = UIImage(named: "icon-save-64")
        let saveButtonItem   = UIBarButtonItem(image: saveImage,  style: .plain, target: self, action: #selector(handleSave))
        
        let cancelImage   = UIImage(named: "icon-cancel-64")
        let cancelButtonItem   = UIBarButtonItem(image: cancelImage,  style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = saveButtonItem
        navigationItem.leftBarButtonItem = cancelButtonItem
        
        setupLayout()
    }
    

    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @objc func handleSave() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            //for some reason uid = nil
            return
        }
                    
        //successfully authenticated user
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("record_images").child("\(imageName).jpg")
            
        if let recordImage = self.recordImageView.image, let uploadData = recordImage.jpegData(compressionQuality: 0.1)
        {
            storageRef.putData(uploadData, metadata: nil, completion: { (_, error) in
                    
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    storageRef.downloadURL(completion: { (url, err) in
                        if let err = err {
                            print(err)
                            return
                        }
                        guard let url = url else { return }
                        
                        
                        guard let key = Database.database().reference().child("records").child(uid).childByAutoId().key else { return }
                        
                        let values : [String:Any] = ["timestamp": Int(Date().timeIntervalSince1970),
                                      "rating": self.ratingcontrol.rating,
                                      "recordImageUrl": url.absoluteString]

                        
                        Database.database().reference().child("records").child(uid).child(key).setValue(values, withCompletionBlock: { (err, ref) in
                        
                        if err != nil {
                            print(err!)
                            return
                        }
                    })
                    })
                    
                })
            }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    private func setupLayout()
    {
        let stackView   = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.vertical
        // stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        // stackView.spacing   = 8.0

            // stackView.addArrangedSubview(timestampTextField)
        stackView.addArrangedSubview(recordImageView)
        stackView.addArrangedSubview(ratingcontrol)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(stackView)

        stackView.backgroundColor = UIColor.white
        //Constraints
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        // stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        /*
        //x,y,w,h
        timestampTextField.topAnchor.constraint(equalTo:  stackView.topAnchor, constant: 60).isActive = true
        
        timestampTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        timestampTextField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        timestampTextField.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        timestampTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        timestampTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        */
        
        recordImageView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 60).isActive = true
        recordImageView.heightAnchor.constraint(equalToConstant: 320).isActive = true
        recordImageView.widthAnchor.constraint(equalToConstant: 320).isActive = true
                
        //recordImageView.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 2).isActive = true
        recordImageView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        //recordImageView.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: 2).isActive = true
        //recordImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 60).isActive = true
        
        ratingcontrol.topAnchor.constraint(equalTo: recordImageView.bottomAnchor, constant: 2).isActive = true
        //ratingcontrol.leftAnchor.constraint(equalTo:  self.view.leftAnchor, constant: 32).isActive = true
        //ratingcontrol.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 32).isActive = true
        //ratingcontrol.widthAnchor.constraint(equalToConstant: 240).isActive = true
        ratingcontrol.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        ratingcontrol.widthAnchor.constraint(equalToConstant: 168).isActive = true
        ratingcontrol.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    
    
    @objc func handleSelectRecordImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            recordImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    

    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
        
        // Depending on style of presentation {modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddImageMode = presentingViewController is UINavigationController
        if isPresentingInAddImageMode
        {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController
        {
            owningNavigationController.popViewController (animated: true)
        }
        else
        {
            fatalError("Not inside a navigation controller.")
        }
    
        
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
