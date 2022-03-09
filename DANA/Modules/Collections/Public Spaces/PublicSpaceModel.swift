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
      let files: File_PublicSpace
      let element_texts: [Element_texts_PublicSpace]
    }

    struct Element_texts_PublicSpace: Decodable {
        let text: String
        let element: Element_type_publicspace
    }

    struct Element_type_publicspace: Decodable {
        let name: String
    }
    struct File_PublicSpace: Decodable {
        let url: String
    }

