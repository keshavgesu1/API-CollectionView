//
//  ImageModel.swift
//  api
//
//  Created by Keshav Raj Kashyap on 28/01/21.
//

import Foundation
struct ImageModel: Codable {
    var results: [resutlItem]
}

struct resutlItem: Codable {
    let urls: Urls
}

struct Urls: Codable {
    let regular: String
}
