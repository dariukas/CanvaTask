//
//  Maze.swift
//  CanvaTask
//
//  Created by Darius Miliauskas on 08/06/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import Foundation

//https://developer.apple.com/swift/blog/?id=37
//class Maze {
//    let id: String
//    var tileUrl: String?
//
//    init?(json: [String: Any]) throws {
//        guard let id = json["id"] as? String
//            else {
//                throw SerializationError.missing("id")
//        }
//        self.id = id
//    }
//}

struct Maze {
    let id: String
    var tileUrl: String?
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
        self.id = id
    }
}

//        let server = MosaicTileServer()
//        server.fetchTile(for: <#T##UIColor#>, size: <#T##CGSize#>, success: <#T##(UIImage) -> Void#>, failure: <#T##(Error) -> Void#>)
