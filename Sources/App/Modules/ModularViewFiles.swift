//
//  File.swift
//  
//
//  Created by Samantha Gatt on 5/29/20.
//

import Vapor
import Leaf

struct ModularViewFiles: LeafFiles {
    let workingDir: String
    let modulesDir: String
    let alternateDir: String
    let nioLeafFiles: NIOLeafFiles
    
    init(workingDir: String,
         modulesDir: String = "Sources/App/Modules",
         alternateDir: String = "Resources",
         fileio: NonBlockingFileIO) {
        self.workingDir = workingDir
        self.modulesDir = modulesDir
        self.alternateDir = alternateDir
        self.nioLeafFiles = NIOLeafFiles(fileio: fileio)
    }
    
    func file(path: String, on eventLoop: EventLoop) -> EventLoopFuture<ByteBuffer> {
        let viewsDir = "Views"
        var alternatePath = alternateDir + "/" + viewsDir
        let ext = ".leaf"
        
        /// Passed in path name minus `.leaf` IF it was included
        let name = path.replacingOccurrences(of: ext, with: "")
        alternatePath += name + ext
        
        // If the file exists in the alternate directory, return it
        // Any files of the same name in the alternate directory
        // will override the one in a modular directory
        if FileManager.default.fileExists(atPath: alternatePath) {
            return nioLeafFiles.file(path: workingDir + alternatePath,
                              on: eventLoop)
        }
        
        // Turn the given path into an array by directory
        let components = name.split(separator: "/")
        var pathComponents: [String] = []
        // If there's more than one item in the components array
        if let firstPathComp = components.first {
            // Add Views directory after module name (first directory in given path)
            pathComponents = [String(firstPathComp), viewsDir]
                // Add the rest of the given path
                + components.dropFirst().map { String($0) }
        }
        let modulePath = modulesDir + "/" + pathComponents.joined(separator: "/") + ext
        return nioLeafFiles.file(path: workingDir + modulePath, on: eventLoop)
    }
}
