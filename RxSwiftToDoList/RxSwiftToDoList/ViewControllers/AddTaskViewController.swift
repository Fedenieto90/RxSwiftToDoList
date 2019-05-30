//
//  AddTaskViewController.swift
//  RxSwiftToDoList
//
//  Created by Federico Nieto on 30/05/2019.
//  Copyright © 2019 Federico Nieto. All rights reserved.
//

import UIKit
import RxSwift

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    
    var taskSubject = PublishSubject<Task>()
    var taskObservable : Observable<Task> {
        return taskSubject.asObservable()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func save() {
       guard let priority = Priority(rawValue: self.segmentedControl.selectedSegmentIndex),
        let title = self.textField.text else {
            return
        }
        let task = Task(title: title, priority: priority)
        taskSubject.onNext(task)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }

}
