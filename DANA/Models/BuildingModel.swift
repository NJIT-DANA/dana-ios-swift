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
}

struct Element_texts_Building: Decodable {
    let text: String
}
