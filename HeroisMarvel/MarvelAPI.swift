//
//  MarvelAPI.swift
//  HeroisMarvel
//
//  Created by Luana Martinez de La Flor on 24/11/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import Foundation
import SwiftHash
import Alamofire

class MarvelAPI {
    
    static private let basePath = "https://gateway.marvel.com/v1/public/characters?"
    static private let privateKey = "c2ec63c5be213642a287f3b02a4e83d5279f66c9"
    static private let publicKey = "c3bb399e266814ba5a88972eecc1980e"
    static private let limit = 50
    
    
    class func loadHeros(name: String?, page: Int = 0, onComplete: @escaping (MarvelInfo?)-> Void ){
        let offset = page * limit
        let startsWith: String
        
        if let name = name, !name.isEmpty {
            startsWith = "nameStartsWith=\(name.replacingOccurrences(of: " ", with: ""))&"
        }else{
            startsWith = ""
        }
        
        let url = basePath + "offset=\(offset)&limit=\(limit)&" + startsWith + getCredentials()
        print (url)
        
        AF.request(url).responseJSON { (response) in
            guard let data = response.data, let marvelInfo = try? JSONDecoder().decode(MarvelInfo.self, from: data),
                marvelInfo.code == 200 else {
                 onComplete(nil)
                return
                
            }
            onComplete
        }
        
        
    }
    
    private class func getCredentials() -> String{
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(ts+privateKey+publicKey).lowercased()
        return "ts=\(ts)apikey=\(publicKey)hash=\(hash)"
    }
    
    
}
