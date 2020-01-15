//
//  ConnectionManager.swift
//  CoreDataPerformance
//
//  Created by Benjamin HALIMI on 14/01/2020.
//  Copyright © 2020 Benjamin HALIMI. All rights reserved.
//

import Foundation
import CoreData

class ConnectionManager
{
    static let shared = ConnectionManager()
    
    private init(){}
    
    public func getAllEmployees(completion: @escaping ([EmployeeJSON]?) -> Void)
    {
        var request = URLRequest(url: URL(string: "http://dummy.restapiexample.com/api/v1/employees")!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                print("NETWORK ERROR: \(error.debugDescription)")
                completion(nil)
                return
            }
            
            if let d = data
            {
                do {
//                    let json = try JSONSerialization.jsonObject(with: d, options: [])
                    let response = try JSONDecoder().decode(ArrayResponse<EmployeeJSON>.self, from: d)
                                            
                        CoreDataManager.shared.persistentContainer.performBackgroundTask { context in
                            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                            for employeeJSON in response.data {
                                
                                guard let id = employeeJSON.id else {
                                    continue
                                }
                                let employee = Employee(context: context)
                                employee.id = id
                                employee.name = employeeJSON.name
                                employee.salary = employeeJSON.salary
                                employee.age = employeeJSON.age
                                if let profileImage = employeeJSON.profileImage {
                                    employee.image = Data(base64Encoded: profileImage, options: .ignoreUnknownCharacters)
                                }
                            }
                            
                            if context.hasChanges {
                                do {
                                    try context.save()
                                } catch let error {
                                    print("CORE_DATA SAVING ERROR: \(error)")
                                }
                            }
                        }
                    completion(response.data)
                } catch let error {
                    print("PARSING ERROR: \(error)")
                }
            }
            else
            {
                completion(nil)
            }
        }.resume()
    }
}
