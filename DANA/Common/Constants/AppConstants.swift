//
//  AppConstants.swift
//  DANA
//
//  Created by Rini Joseph on 2/5/22.
//

import Foundation
struct apiConstants {
    
    static let geolocationApi = "https://dana.njit.edu/api/geolocations" //done
    static let collectionsApi = "http://dana.njit.edu/api/collections"
    static let publicspaceApi = "https://dana.njit.edu/api/items?collection=5"
    static let buildingsApi   = "https://dana.njit.edu/api/items?collection=3"
    static let architectsApi  = "https://dana.njit.edu/api/items?collection=2" //done
    static let publicartApi  = "https://dana.njit.edu/api/items?collection=4"
    
}

struct textConstants {
    static let googleAPIKey = "AIzaSyCuVmO7LDPPdY1Gl85QcTC7WyEIBX_1gYY"
    static let collectionTitle = "Collections"
    static let publicspaceTitle = "Public Spaces"
    static let publicartTitle = "Public Art"
    static let buildingsTitle = "Buildings"
    static let architectViewTitle = "Architects"
    static let mapViewTitle = "Map"
    static let emptyString = ""
    static let architectEntity = "Architects_Firms"
    static let buildingEntity = "Buildings"
    static let spaceEntity = "PublicSpaces"
    static let artEntity = "PublicArts"
    static let locationEntity = "GeoLocations"
    static let architectCell = "architectcell"
    static let listCell = "listcell"
    static let detailCell = "detailscell"
    static let menuCell = "menucell"
    static let buildingCell = "buildingcell"
    static let publicspaceCell = "publicspacecell"
    static let publicartCell = "publicartcell"
    static let homeCell = "homecell"
    static let placeholderImage = "danaplaceholder"
    static let buildingsImage = "danabuildings"
    static let architectsImage = "danaarchitects"
    static let publicspacesImage = "danapublicspace"
    static let publicartImage = "danapublicart"
    static let danaAbout = "This archive is an initiative undertaken by the New Jersey Institute of Technology to document the built environment of Newark, New Jersey. This project is designed with the intent to improve public access to a variety of historic materials and to create a digital archive of past and present projects in Newark: old, new and renovated buildings, parks, planning and outdoor sculpture - anything of interest to the physical life of the city, its architecture, and its infrastructure. The archive includes plans of the city, architectural drawings, old photographs and postcards, rare books, articles in periodicals, monographs, exhibition catalogues, student projects, as well as links to other online resources.\nThe initial phase of this project was made possible thanks to generous support of The Bay and Paul Foundations and The Leavens Foundation. Additional support comes from the New Jersey Historical Commission and from the Investors Foundation."
    static let danaNetworkMessage = "Please connect to network and try again"
}

struct colorConstants {
    
    
}
