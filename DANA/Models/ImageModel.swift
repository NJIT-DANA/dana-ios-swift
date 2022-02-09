//
//  ImageModel.swift
//  DANA
//
//  Created by Littman Library on 2/7/22.
//

import Foundation
struct ImageModel: Decodable {
  let id: Int
  let item :architectID
  let url: String
  let file_urls:file_url_list
}
struct file_url_list:Decodable{
    let original: String
    let fullsize: String
    let thumbnail: String
    let square_thumbnail: String
}

struct architectID: Decodable{
let id: Int
    
}
