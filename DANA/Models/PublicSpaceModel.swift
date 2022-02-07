//
//  PubllicSpaceModel.swift
//  DANA
//
//  Created by Littman Library on 2/6/22.
//

import Foundation
struct PublicSpaceModel: Decodable {
  let id: Int
  let url: String
  let element_texts: [Element_texts_Publicspace]
  let files: File_PublicSpace
}
struct Element_texts_Publicspace: Decodable {
    let text: String
}
struct File_PublicSpace: Decodable {
    let url: String
}
