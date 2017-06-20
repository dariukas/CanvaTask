//
//  Maze.swift
//  CanvaTask
//
//  Created by Darius Miliauskas on 08/06/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import Foundation
import TakeHomeTask

let manager = MazeManager()

typealias ErrorMessage = String

class Manager {
    
    func requestStartRoom(completion: @escaping (Room?, ErrorMessage?) -> Void) {
        manager.fetchStartRoom(callback: {data ,error in
            if (error == nil) {
                if let theData = data {
                    if let theJson = try? JSONSerialization.jsonObject(with: theData, options: []), let json = theJson as? [String : Any]
                    {
                        do {
                            if let room = try Room(json: json) {
                                completion(room, nil)
                            }
                        }
                        catch {
                            let err = SerializationError.missing("id")
                            if case SerializationError.missing("id") = err {
                                completion(nil, "Error: The response is missing room id.")
                            }
                        }
                    }
                }
            } else {
                if let errorMessage = error as? String {
                    completion(nil, errorMessage)
                }
            }
        })
    }
    
    func requestRoomWith(roomID: Id, completion: @escaping (Room?, ErrorMessage?) -> Void) {
        manager.fetchRoom(withIdentifier: roomID, callback: {data ,error in
            if (error == nil) {
                if let theData = data {
                    if let theJson = try? JSONSerialization.jsonObject(with: theData, options: []), let json = theJson as? [String : Any]
                    {
                        do {
                            if let room = try Room(json: json) {
                                print(room)
                                completion(room, nil)
                            }
                        }
                        catch {
                            let err = SerializationError.missing("id")
                            if case SerializationError.missing("id") = err {
                                completion(nil, "Error: The response is missing room id.")
                            }
//                            self.alert(message: error.localizedDescription)
                        }
                    }
                }
            } else {
                if let errorMessage = error as? String {
                    completion(nil, errorMessage)
                }
            }
        })
    }
}

//maz.tileUrl = "http://lunar.lostgarden.com/uploaded_images/ExteriorTest-760306.jpg"
//https://developer.apple.com/swift/blog/?id=37
/*class Room {
    let id: String
    var tileUrl: String?
    var type: String?
    var neighbors: [Room]?
    
    init?(json: [String: Any]) throws {
        guard let id = json["id"] as? String
            else {
                throw SerializationError.missing("id")
        }
        self.id = id
    }
}*/

/*enum Direction: String {
    
    case South = "south"
    case North = "north"
    case West = "west"
    case East = "east"
}*/

typealias Id = String
typealias Type = String

struct Room {
    
    let id: Id
    var tileUrl: String?
    var type: Type?
    var rooms: [String: Id]
}

enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

extension Room {
    
    init?(json: [String: Any]) throws {
        guard let id = json["id"] as? String
            else {
                throw SerializationError.missing("id")
        }
        self.id = id
        
        if let tileUrl = json["tileUrl"] as? String {
            self.tileUrl = tileUrl
        }
        
        if let type = json["type"] as? String {
            self.type = type
        }
        
        self.rooms = [:]
        if let rooms = json["rooms"] as? [String: Any] {
            for (key, value) in rooms {
                if let room = value as? [String: Any] {
                    if let roomID = room["room"] as? String {
                        self.rooms[key] = roomID
                    } else if let lock = room["lock"] as? String {
                        self.rooms[key] = manager.unlockRoom(withLock: lock)
                    }
                }
            
            }
        }
    }
}

//        let server = MosaicTileServer()
//        server.fetchTile(for: <#T##UIColor#>, size: <#T##CGSize#>, success: <#T##(UIImage) -> Void#>, failure: <#T##(Error) -> Void#>)
