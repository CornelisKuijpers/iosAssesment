//
//  stackOverflowData.swift
//  Cornelis Assesment
//
//  Created by Cornelis Kuijpers on 2020/06/09.
//  Copyright © 2020 Cor Kuijpers. All rights reserved.
//

import Foundation

struct StackOverflowdata: Decodable{
    
    let items : [Items]
    
}

struct Items: Decodable{
    let is_answered : Bool
    let title : String
    let body : String
    let question_id : Int
    let answer_count : Int
    let view_count : Int
    let score : Int
    let owner : Owner
    let creation_date : Double
}

struct Owner: Decodable{
    let display_name : String
}
