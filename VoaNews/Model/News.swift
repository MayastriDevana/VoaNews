//
//  News.swift
//  VoaNews
//
//  Created by User on 23/04/24.
//

import Foundation

struct News: Codable{
    let messages: String
        let total: Int
        let data: [NewsArticle]
    }

    // MARK: - Datum
    struct NewsArticle: Codable, Identifiable {
        var id: String {
            link
        }
        let title: String
        let link: String
        let isoDate, description: String
        let image: String
    }

