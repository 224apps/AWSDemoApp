//
//  ViewController.swift
//  AwsDemoApp
//
//  Created by Abdoulaye Diallo on 11/5/18.
//  Copyright © 2018 224Apps. All rights reserved.
//

import UIKit
import AWSMobileClient
import AWSAuthUI
import AWSCore
import AWSDynamoDB


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    //Action for the Log Out Button
    @IBAction func LogOut(_ sender: UIButton) {
        AWSSignInManager.sharedInstance().logout(completionHandler: { (value, error) in
            self.checkForUserLogin()
        })
    }
    
    //Check if the user is logged in
    func checkForUserLogin()  {
        if !AWSSignInManager.sharedInstance().isLoggedIn {
            AWSAuthUIViewController.presentViewController(with: self.navigationController!, configuration: nil) { (provider, error) in
                if  error == nil {
                    print("success")
                }
                else {
                    print(error.debugDescription)
                }
            }
        } else {
            //createNote()
             //updateNote(noteID: "123", content: "updated Note")
            deleteNote(noteID: "123")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Check if the user in logged in
        checkForUserLogin()
    }
    
    func save(note: Note) {
        let objMapper = AWSDynamoDBObjectMapper.default()
        objMapper.save(note){ error in
            print( error.debugDescription )
        }
        
    }
    
    // MARK: - A function that create a note to be stored on the DynamoDB
    func createNote()  {
        guard let note = Note() else { return }
        note._userId =  AWSIdentityManager.default().identityId
        note._noteId = " 123"
        note._content = " This is note"
        note._creationDate = Date().timeIntervalSince1970 as NSNumber
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .short
        dateformatter.timeStyle = .short
        note._title = " This is a note on \(dateformatter.string(from: Date()))"
        save(note: note)
    }
    // MARK: - Create a function that load a note in the DynamoDB
    func loadNote(noteID: String)  {
        let objMapper = AWSDynamoDBObjectMapper.default()
        if let hashKey = AWSIdentityManager.default().identityId {
            objMapper.load(Note.self, hashKey: hashKey, rangeKey: noteID) { (model, error) in
                if let  note = model as?  Note {
                    print(note._content ?? "No  content" )
                }
            }
        }
        
    }
    
    // MARK: - Create a function that update a Note.
    func updateNote(noteID: String, content: String) {
        let objMapper = AWSDynamoDBObjectMapper.default()
        if let hashKey = AWSIdentityManager.default().identityId {
            objMapper.load(Note.self, hashKey: hashKey, rangeKey: noteID) { (model, error) in
                if let note = model as? Note {
                    note._content = content
                    self.save(note: note)
                }
            }
            
        }
    }
    // MARK:  - Delete a notee
    
    func deleteNote(noteID: String) {
        if let note = Note() {
            note._userId = AWSIdentityManager.default().identityId
            note._noteId = noteID
            let objMapper = AWSDynamoDBObjectMapper.default()
            objMapper.remove(note) { (error) in
                print(error.debugDescription ?? " No error.")
            }
        }
        
    }
    
    
}



