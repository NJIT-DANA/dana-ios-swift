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
  let element_texts: [Element_texts_values]
  let files: File_PublicArt
}

struct Element_texts_values: Decodable {
    let text: String
    let element: Element_texts_keys
}

struct Element_texts_keys: Decodable {
    let name: String
}

struct File_PublicArt: Decodable {
    let url: String
}
