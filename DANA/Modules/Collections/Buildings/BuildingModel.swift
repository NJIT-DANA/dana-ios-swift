//
//  ArchitectsModel.swift
//  DANA
//
//  Created by Littman Library on 2/6/22.
//

import Foundation
struct BuildingModel: Decodable {
  let id: Int
  let url: String
  let element_texts: [Element_texts_Building]
  let files: File_Building
}

struct Element_texts_Building: Decodable {
    let text: String
    let element: Element_type_key
}

struct Element_type_key: Decodable {
    let name: String
}
struct File_Building: Decodable {
    let url: String
}

