//
//  ShopListAPIResponseModel.swift
//  SingularityCodingTest
//
//  Created by Sunny Chowdhury on 8/21/20.
//  Copyright © 2020 Sunny Chowdhury. All rights reserved.
//

import Foundation
//   let shopListAPIResponse = try? newJSONDecoder().decode(ShopListAPIResponse.self, from: jsonData)

import Foundation

// MARK: - ShopListAPIResponse
class StoreListAPResonse: Codable {
    var data: [Store]?
    var links: Links?
    var meta: Meta?

    init(data: [Store]?, links: Links?, meta: Meta?) {
        self.data = data
        self.links = links
        self.meta = meta
    }
}

// MARK: - Datum
class Store: Codable {
    var id: Int?
    var name, address: String?

    init(id: Int?, name: String?, address: String?) {
        self.id = id
        self.name = name
        self.address = address
    }
}

// MARK: - Links
class Links: Codable {
    var first, last: String?
    var prev: String?
    var next: String?

    init(first: String?, last: String?, prev: String?, next: String?) {
        self.first = first
        self.last = last
        self.prev = prev
        self.next = next
    }
}

// MARK: - Meta
class Meta: Codable {
    var currentPage, from, lastPage: Int?
    var path: String?
    var perPage, to, total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage
        case from
        case lastPage
        case path
        case perPage
        case to, total
    }

    init(currentPage: Int?, from: Int?, lastPage: Int?, path: String?, perPage: Int?, to: Int?, total: Int?) {
        self.currentPage = currentPage
        self.from = from
        self.lastPage = lastPage
        self.path = path
        self.perPage = perPage
        self.to = to
        self.total = total
    }
}
