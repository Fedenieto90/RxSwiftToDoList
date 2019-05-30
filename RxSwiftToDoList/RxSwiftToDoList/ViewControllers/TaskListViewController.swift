//
//  TaskListViewController.swift
//  RxSwiftToDoList
//
//  Created by Federico Nieto on 30/05/2019.
//  Copyright © 2019 Federico Nieto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TaskListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl : UISegmentedControl!
    
    var tasks = BehaviorRelay<[Task]>(value: [])
    var filteredTasks = [Task]()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navVC = segue.destination as? UINavigationController,
            let vc = navVC.children.first as? AddTaskViewController else {
                fatalError()
        }
        
        vc.taskSubject.subscribe(onNext: { [unowned self] task in
            var existingTasks = self.tasks.value
            existingTasks.append(task)
            self.tasks.accept(existingTasks)
            let priority = Priority(rawValue: self.segmentedControl.selectedSegmentIndex - 1)
            self.filterTasks(by: priority)
            self.updateTableView()
        }).disposed(by: disposeBag)
    }
    
    
    func filterTasks(by priority: Priority?) {
        if priority == nil {
            self.filteredTasks = self.tasks.value
            self.updateTableView()
        } else {
            self.tasks.map { tasks in
                return tasks.filter{ $0.priority == priority! }
                }.subscribe(onNext: { [weak self] tasks in
                    self?.filteredTasks = tasks
                    self?.updateTableView()
                }).disposed(by: disposeBag)
        }
    }
    
    @IBAction func priorityValueChanged(segmentedControl: UISegmentedControl) {
        let priority = Priority(rawValue: segmentedControl.selectedSegmentIndex - 1)
        self.filterTasks(by: priority)
    }
    
    func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        let task = self.filteredTasks[indexPath.row]
        cell.textLabel?.text = task.title
        return cell
    }
    
    
}
