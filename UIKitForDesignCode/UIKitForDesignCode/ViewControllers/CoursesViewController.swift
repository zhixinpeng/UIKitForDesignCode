//
//  CoursesViewController.swift
//  UIKitForDesignCode
//
//  Created by 彭智鑫 on 2022/7/20.
//

import UIKit

class CoursesViewController: UIViewController {
    var course: Course?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("This course is \(course?.courseTitle)")
    }
}
