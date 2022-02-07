//
//  PublicArtModel.swift
//  DANA
//
//  Created by Littman Library on 2/6/22.
//


import Foundation
struct PublicArtModel: Decodable {
  let id: Int
  let url: String
  let element_texts: [Element_texts_publicArt]
  let files: File_PublicArt
}

struct Element_texts_publicArt: Decodable {
    let text: String
}
struct File_PublicArt: Decodable {
    let url: String
}
