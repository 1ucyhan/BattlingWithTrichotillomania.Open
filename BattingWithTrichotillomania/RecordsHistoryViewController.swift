//
//  CheckHistoryViewController.swift
//  BattingWithTrichotillomania
//
//  Created by Lucy Han on 09/14/2021.
//


import UIKit
import Firebase
import os.log

class RecordsHistoryViewController: UITableViewController {

    var records = [Record]()

    let cellId = "cellId"
     

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let exitImage   = UIImage(named: "icon-exit")
        let exitButtonItem   = UIBarButtonItem(image: exitImage,  style: .plain, target: self, action: #selector(handleLogout))
        
        let messagesImage   = UIImage(named: "icon-messages")
        let messagesButtonItem   = UIBarButtonItem(image: messagesImage,  style: .plain, target: self, action: #selector(handleMessages))
            
        let addRecordImage   = UIImage(named: "icon-add")
        let addRecordButtonItem   = UIBarButtonItem(image: addRecordImage,  style: .plain, target: self, action: #selector(handleAddRecord))

        // Intentionally forbid EDIT, only allow ADD
        navigationItem.leftBarButtonItems = [exitButtonItem]//, self.editButtonItem]
        navigationItem.rightBarButtonItems = [addRecordButtonItem, messagesButtonItem]//, self.editButtonItem]
          
        checkIfUserIsLoggedIn()
        
        tableView.register(RecordCell.self, forCellReuseIdentifier: cellId)
                       
    }
  
    
    @objc func handleMessages() {
        let messagesController = MessagesController()
        let navController = UINavigationController(rootViewController: messagesController)
        present(navController, animated: true, completion: nil)
        
    }
        
    
    @objc func handleAddRecord() {
        let recordAddNewController = RecordAddNewController()
        let navController = UINavigationController(rootViewController: recordAddNewController)
        present(navController, animated: true, completion: nil)
    }
    
    
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchCurrentUserProfileAndSetupNavBarTitle()
        }
    }
    
    
    // Use known uid to get user details from DB then use this details to set up Nav Bar
    func fetchCurrentUserProfileAndSetupNavBarTitle() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
 //               self.navigationItem.title = dictionary["name"] as? String
                
                let user = User(dictionary: dictionary)
                self.setupNavBarWithUser(user)
                
                
            }
            
           }, withCancel: nil)
    }
        
    
    
    func observeUserRecords() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        Database.database().reference().child("records").child(uid).observe(.childAdded, with: { (snapshot) in
                       
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let record = Record(dictionary: dictionary)
                self.records.append(record)
                
                //this will crash because of background thread, so lets use dispatch_async to fix
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
            
            }, withCancel: nil)
        
    }
    
            
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
  
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if isFullScreeen == true
        {
            removeImage()
            return
        }

        let cell = tableView.cellForRow(at: indexPath) as! RecordCell

            if let photoUrl =  cell.checkrecord?.recordImageUrl {
                self.addImageViewWithImage(imageURL: photoUrl)
            }
    }
    
    var isFullScreeen = false
    
    
    func addImageViewWithImage(imageURL: String) {

        let imageView = UIImageView(frame: self.view.frame)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.black
        imageView.loadImageUsingCacheWithUrlString(imageURL)
        imageView.tag = 666
        
        self.view.addSubview(imageView)
        
        isFullScreeen = true
        
    }
        
    
    
    func removeImage() {
        let imageView = (self.view.viewWithTag(666)! as! UIImageView)
        imageView.removeFromSuperview()
        isFullScreeen = false
    }
    
    
    
    func setupNavBarWithUser(_ user: User)
    {
        self.records.removeAll()
        tableView.reloadData()
        
        self.observeUserRecords()
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        containerView.addSubview(profileImageView)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        let nameLabel = UILabel()
        
        containerView.addSubview(nameLabel)
        
        if user.name!.count > 8
        {
            nameLabel.text = user.name!.prefix(8) + "..."
        }
        else
        {
            nameLabel.text = user.name
        }
       
        //need x,y,width,height anchors
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        //need x,y,width,height anchors
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        
        self.navigationItem.titleView = titleView
    }
    
    
    
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        loginController.recordsHistoryController = self
        present(loginController, animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RecordCell
        let record = records[indexPath.row]
        cell.checkrecord = record
        
        return cell
    }
  
    
       /*
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "")
        {
            
        case "AddItem":
            os_log("Adding a new entry.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let singleEntryViewController = segue.destination as? RatingChartViewController else
            {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedPictureCell = sender as? PictureTableViewCell else
            {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedPictureCell) else
            {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedRecord = records[indexPath.row]
            // singleEntryViewController.entry = selectedRecord;
            
        default:
            fatalError("Unexpected Segue Indentifier; \(String(describing: segue.identifier))")
        }
    }
 */
    
    
    
    func fetchRecordsbyUserSimulated()
    {
        let photo1 = "gs://battingwithtrichotillomania.appspot.com/record_images/lucyhan_logo_289x278@2x.png" // UIImage(named: "lucyhan_logo")
        let photo2 = "gs://battingwithtrichotillomania.appspot.com/record_images/Screen Shot 2017-05-27 at 7.08.25 PM.png" // (named: "image1")
        let photo3 = "gs://battingwithtrichotillomania.appspot.com/record_images/Screen Shot 2017-05-27 at 7.08.06 PM.png" // UIImage(named: "image2")
        let photo4 = "gs://battingwithtrichotillomania.appspot.com/record_images/Screen Shot 2017-05-27 at 7.06.41 PM.png" // UIImage(named: "image3")
        
        
        
        guard let record1 = Record(timestamp: 1632204645, recordImageUrl: photo1, rating: 1) else
        {
            fatalError("Unable to instantiate record1")
        }
        guard let record2 = Record(timestamp: 1632224645, recordImageUrl: photo2, rating: 2) else
        {
            fatalError("Unable to instantiate record1")
        }
        guard let record3 = Record(timestamp: 1632294645, recordImageUrl: photo3, rating: 3) else
        {
            fatalError("Unable to instantiate record1")
        }
        guard let record4 = Record(timestamp: 1632304645, recordImageUrl: photo4, rating: 4) else
        {
            fatalError("Unable to instantiate record1")
        }
        
        self.records += [record1, record2, record3, record4]
        
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
}
