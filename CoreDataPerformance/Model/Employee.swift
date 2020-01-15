//
//  File.swift
//  CoreDataPerformance
//
//  Created by Benjamin HALIMI on 14/01/2020.
//  Copyright © 2020 Benjamin HALIMI. All rights reserved.
// test commit

import UIKit
import CoreData

class Employee: NSManagedObject {

}

struct EmployeeJSON: Codable
{
    var id: String?
    var name: String?
    var salary: String?
    var age: String?
    var profileImage: String?
    
    private enum CodingKeys: String, CodingKey
    {
        case id = "id"
        case name = "employee_name"
        case salary = "employee_salary"
        case age = "employee_age"
        case profileImage = "profile_image"
    }
}

struct Response<T: Decodable>: Decodable
{
    let data: T
    
    private enum CodingKeys: String, CodingKey
    {
        case data = "data"
    }
}

struct ArrayResponse<T: Decodable>: Decodable
{
    let data: [T]
    
    private enum CodingKeys: String, CodingKey
    {
        case data = "data"
    }
}
