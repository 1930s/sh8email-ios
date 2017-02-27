//
//  sh8mailTableViewController.swift
//  sh8email
//
//  Created by Hun Jae Lee on 1/20/17.
//  Copyright © 2017 이강산. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class Sh8mailTableViewController: UITableViewController {
	var username: String?
	var emails: [Mail] = []

    override func viewDidLoad() {
        super.viewDidLoad()
		print("<SYSTEM> Checking email for \(username)...")
		
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
	@IBAction func refreshButtonTapped(_ sender: Any) {
		self.checkEmail()
	}
	
	func checkEmail() {
        self.emails = []
		let sh8emailRequestURL = "https://sh8.email/rest/mail/\(username!)/list/"
		Alamofire.request(sh8emailRequestURL).responseArray { (response: DataResponse<[Mail]>) in
			self.emails = []
			let mailArray = response.result.value
            guard let mailArray = response.result.value
			// if mail exists in mailbox, put them in current mail list
			if let mailArray = mailArray {
				for mail in mailArray {
                    self.emails.append(mail)
					print(mail.description)
				}
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
			}
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
}

// MARK: - Table view data source
extension Sh8mailTableViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emails.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sh8mailCell", for: indexPath) as! sh8mailTableViewCell
        
        let mail = emails[indexPath.row]
        
        cell.senderLabel.text = mail.sender
        cell.recipDateLabel.text = Sh8helper.convertDate(mail.recipDate!)
        cell.subjectLabel.text = mail.subject
        cell.contentsLabel.text = Sh8helper.convertHtml(mail.contents!)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row: \(indexPath.row),  sender: \(self.emails[indexPath.row].sender)")
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
