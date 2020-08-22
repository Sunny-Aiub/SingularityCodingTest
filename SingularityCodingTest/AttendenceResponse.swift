// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let attendenceResponse = try? newJSONDecoder().decode(AttendenceResponse.self, from: jsonData)

import Foundation

// MARK: - AttendenceResponse
class AttendenceResponse: Codable {
    var code: Int?
    var appMessage, userMessage: String?
    var data: DataClass?

    enum CodingKeys: String, CodingKey {
        case code
        case appMessage
        case userMessage
        case data
    }

    init(code: Int?, appMessage: String?, userMessage: String?, data: DataClass?) {
        self.code = code
        self.appMessage = appMessage
        self.userMessage = userMessage
        self.data = data
    }
}

// MARK: - DataClass
class DataClass: Codable {
    var name, uid, latitude, longitude: String?
    var requestID, updatedAt, createdAt: String?
    var id: Int?

    enum CodingKeys: String, CodingKey {
        case name, uid, latitude, longitude
        case requestID
        case updatedAt
        case createdAt
        case id
    }

    init(name: String?, uid: String?, latitude: String?, longitude: String?, requestID: String?, updatedAt: String?, createdAt: String?, id: Int?) {
        self.name = name
        self.uid = uid
        self.latitude = latitude
        self.longitude = longitude
        self.requestID = requestID
        self.updatedAt = updatedAt
        self.createdAt = createdAt
        self.id = id
    }
}
//
//  AttendenceResponse.swift
//  SingularityCodingTest
//
//  Created by Sunny Chowdhury on 8/22/20.
//  Copyright © 2020 Sunny Chowdhury. All rights reserved.
//

import Foundation
