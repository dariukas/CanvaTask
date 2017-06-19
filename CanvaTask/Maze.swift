//
//  Maze.swift
//  CanvaTask
//
//  Created by Darius Miliauskas on 08/06/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import Foundation

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

struct Room {
    let id: String
    var tileUrl: String?
    var type: String?
    var neighbors: [Room]?
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
    }
}

//        let server = MosaicTileServer()
//        server.fetchTile(for: <#T##UIColor#>, size: <#T##CGSize#>, success: <#T##(UIImage) -> Void#>, failure: <#T##(Error) -> Void#>)
