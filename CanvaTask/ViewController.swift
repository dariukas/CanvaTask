//
//  ViewController.swift
//  CanvaTask
//
//  Created by Darius Miliauskas on 08/06/2017.
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
    
    func fetchStartRoom() {
        manager.fetchStartRoom(callback: {data ,error in
            if (error == nil) {
                
                if let theData = data {
                    
                    if let json = try? JSONSerialization.jsonObject(with: theData, options: []) as! [String : Any]
                    {
                        print(json)
                        let maze = try? Maze(json: json)
                        print(maze ?? "zero")
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

//https://developer.apple.com/swift/blog/?id=37
struct Maze {
    let id: String
//    let tileUrl: String?
}

enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

extension Maze {
    init?(json: [String: Any]) throws {
        guard let id = json["id"] as? String
            else {
               throw SerializationError.missing("id")
        }
        
//        guard let tileUrl = json["tileUrl"] as? String
//            else {
//                return nil
//        }
        
        self.id = id
//        self.tileUrl = tileUrl
    }
}

//        let server = MosaicTileServer()
//        server.fetchTile(for: <#T##UIColor#>, size: <#T##CGSize#>, success: <#T##(UIImage) -> Void#>, failure: <#T##(Error) -> Void#>)
