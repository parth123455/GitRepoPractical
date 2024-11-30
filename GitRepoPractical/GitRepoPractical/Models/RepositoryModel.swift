//
//  RepositoryModel.swift
//  GitRepoPractical
//
//  Created by Parth gondaliya on 30/11/24.
//

import Foundation
struct Repository: Identifiable, Codable {
    let id: Int
    let name: String
    let description: String?
    let stars: Int?
    let forks: Int?
    let updatedAt: Date? // Ensure this is Date

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case stars = "stargazers_count"
        case forks
        case updatedAt = "updated_at"
    }

    init(entity: RepositoryEntity) {
        self.id = Int(entity.id)
        self.name = entity.name ?? ""
        self.description = entity.repoDescription
        self.stars = Int(entity.stars)
        self.forks = Int(entity.forks)
        self.updatedAt = entity.lastUpdated // Already a Date
    }
    
    // Implementing Equatable
      static func == (lhs: Repository, rhs: Repository) -> Bool {
          return lhs.id == rhs.id
      }
}
