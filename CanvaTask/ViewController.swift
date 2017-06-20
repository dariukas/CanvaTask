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
    @IBOutlet weak var mazeView: UIView!

    let manager = Manager()
    var mazeIds = [Id]() //storing to avoid the repetition of the same tiles
    var queue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func generateBtnClick(_ sender: Any) {
//        self.queue.cancelAllOperations()
//        self.mazeImgView.subviews.forEach{ $0.removeFromSuperview()}
//        self.mazeIds = [Id]()
        startMaze()
//        if let vc = self.childViewControllers.first as? MazeViewController {
//            vc.startMaze()
//        }
    }

    func initialRect() -> CGRect {
        let width = self.mazeImgView.frame.width //Maze ImageView width
        let height = self.mazeImgView.frame.height //Maze ImageView height
        let startRectOrigin = CGPoint(x:width/2, y: height/2)
        let startRectSize = CGSize(width: width/50, height: width/50)
        return CGRect(origin: startRectOrigin, size: startRectSize)
    }
    
    func startMaze() {
        manager.requestStartRoom(completion: {room, errorMessage in
            guard let room = room else {
                self.alert(message: errorMessage ?? "Error!")
                return
            }
            self.addRoomWith(id: room.id, in: self.initialRect())
//            self.queue.addOperation { () -> Void in
//               
//            }
        })
    }
    
    //recursive method to repeat while the maze is completed
    func addRoomWith(id: Id, in rect: CGRect) {
        
        manager.requestRoomWith(roomID: id, completion: {room, errorMessage in
            guard let room = room else {
                self.alert(message: errorMessage ?? "Error!")
                return
            }
            
            guard !self.mazeIds.contains(room.id) else { //"contains" helps to validate non repetition
                return
            }
            self.mazeIds.append(room.id)
            
            guard let tileUrl = room.tileUrl else {
                return
            }
            
            self.setImageViewWithTile(tileUrl: tileUrl, tileFrame: rect){
                for (key, value) in  room.rooms {
                    self.addRoomWith(id: value, in: rect.moveTo(direction: key))
                }
                let operation1 = BlockOperation(block: {
                })
                operation1.completionBlock = {
                    print("Operation completed")
                }
                self.queue.addOperation(operation1)
      
            }
        })
    }
    
    func setImageViewWithTile(tileUrl: String, tileFrame: CGRect, completion: @escaping () -> Void) {
        let roomImgView = UIImageView(frame: tileFrame)
        roomImgView.downloadedFrom(link: tileUrl)
        DispatchQueue.main.async(){
            self.mazeImgView.addSubview(roomImgView)
            completion()
        }
    }
    
    func alert(message: ErrorMessage) {
        let alertController = UIAlertController(title: "Canva Challenge", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction) -> Void in
        })
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension CGRect {
    //creating a copy of CGRect which is moved to the certain direction
    func moveTo(direction: String) -> CGRect {
        var newRect = self
        let value = self.size.width
        switch direction {
            case "south":
                newRect.origin.y += value
                break
            case "north":
                newRect.origin.y -= value
                break
            case "east":
                newRect.origin.x += value
            case "west":
                newRect.origin.x -= value
            default:
                break
        }
        return newRect
    }
}

extension UIImageView {
    //downloading the image
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
