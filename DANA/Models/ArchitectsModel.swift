//
//  ArchitectsModel.swift
//  DANA
//
//  Created by Littman Library on 2/6/22.
//

import Foundation
struct ArchitectsModel: Decodable {
  let id: Int
  let url: String
  let files: File_Architects
  let element_texts: [Element_texts_Architects]
}

struct Element_texts_Architects: Decodable {
    let text: String
    let element: Element_type
}

struct Element_type: Decodable {
    let name: String
}
struct File_Architects: Decodable {
    let url: String
}
