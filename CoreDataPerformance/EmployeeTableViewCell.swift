//
//  EmployeeTableViewCell.swift
//  CoreDataPerformance
//
//  Created by Benjamin HALIMI on 14/01/2020.
//  Copyright © 2020 Benjamin HALIMI. All rights reserved.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelSalary: UILabel!
    @IBOutlet weak var labelAge: UILabel!
    
    public func updateCell(with name: String?, salary: String?, age: String?, image: UIImage?) {
        imageViewProfile.image = image
        labelName.text = name
        labelSalary.text = salary
        labelAge.text = age
    }
}
