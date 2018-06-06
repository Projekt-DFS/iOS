//
//  Downloader.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 09.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import Foundation

class Downloader {
    
    var links: [String]
    let communicator: Communicator
    
    
    init(links: [String]){
        self.links = links
        communicator = Communicator()
    }
    
    func downloadThumbnails(links: [String]) -> [Data]{
        // return communicator.getThumbnails()
        // TO DO
        return [Data]()
    }
    
}


