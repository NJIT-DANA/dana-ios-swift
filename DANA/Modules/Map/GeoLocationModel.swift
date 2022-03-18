
//struct maparray: Decodable{
//    let mapvalue:[map]
//}

struct LocationModel: Decodable {
  let id: Int
  let url: String
  let latitude: Double
  let longitude: Double
  let zoom_level: Int
  let map_type: String
  let address: String
  let item:item_Maps
}

struct item_Maps: Decodable {
    let url: String
    let id: Int
}

struct Element_texts_maps: Decodable {
    let text: String
    let element: Element_type
}

struct Element_type_map: Decodable {
    let name: String
}

//struct itemVal: Decodable {
//  let id: Int
//  let url: String
//  let resource: String
//}


