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
  let element_texts: [Element_texts_Architects]
}

struct Element_texts_Architects: Decodable {
    let text: String
}
