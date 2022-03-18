//
//  LocationDetailsModel.swift
//  DANA
//
//  Created by Littman Library on 2/12/22.
//

import Foundation
struct LocationDetailModel: Decodable {
    let element_texts: [Element_texts_Maps]
    let id: Int
    let files:imageurl
   
    
}
struct Element_texts_Maps: Decodable {
    let text: String
    let element: Element_type_Map
}

struct Element_type_Map: Decodable {
    let name: String
}
struct imageurl: Decodable {
    let url: String
}

