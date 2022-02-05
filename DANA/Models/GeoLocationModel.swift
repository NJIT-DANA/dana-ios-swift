
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
  //let item: [String,AnyObject]
 let extended_resources: [String]
}


//struct itemVal: Decodable {
//  let id: Int
//  let url: String
//  let resource: String
//}


