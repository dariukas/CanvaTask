//
//  ViewController.swift
//  CanvaTask
//
//  Created by Darius Miliauskas on 07/06/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import UIKit
import TakeHomeTask

class ViewController: UIViewController {
    
    @IBOutlet weak var mazeImgView: UIImageView!
    
    let manager = MazeManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         run()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func generateBtnClick(_ sender: Any) {
        fetchStartRoom()
    }
    
    func run() {
        
        
        
    }
    
    
    func fetchRoom(room: Room) {
        manager.fetchRoom(withIdentifier: room.id, callback: {data ,error in
            if (error == nil) {
                if let theData = data {
                    if let theJson = try? JSONSerialization.jsonObject(with: theData, options: []), let json = theJson as? [String : Any]
                    {
                        do {
                            if let room = try Room(json: json) as? Room {
                                print(room)
                            }
                        }
                        catch SerializationError.missing("room"){
                            self.alert(message: "Error: There is no room.")
                        }
                    }
                }
            } else {
                if let errorMessage = error as? String {
                    self.alert(message: errorMessage)
                }
            }
        })
    }
    


    func fetchStartRoom() {
        manager.fetchStartRoom(callback: {data ,error in
            if (error == nil) {
                if let theData = data {
                    if let theJson = try? JSONSerialization.jsonObject(with: theData, options: []), let json = theJson as? [String : Any]
                    {
//                        do {
                        
                        
                        if let maze = try? Room(json: json), let maz = maze {
                            
                            print(maz)
                            self.fetchRoom(room: maz)
                            
                        }
//                        } catch SerializationError.missing(err){
//                            alert(message: err)
//                            
//                        }
                    }
                }
            } else {
                if let errorMessage = error as? String {
                    self.alert(message: errorMessage)
                }
            }
            //mazeImgView = data
        })
    }
    
    func alert(message: String) {
        let alertController = UIAlertController(title: "Canva Challenge", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction) -> Void in
        })
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
