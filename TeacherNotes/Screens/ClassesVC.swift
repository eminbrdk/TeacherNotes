//
//  ClassesVC.swift
//  TeacherNotes
//
//  Created by Muhammed Emin Bardakcı on 17.03.2023.
//

import UIKit


class ClassesVC: UIViewController {

    let context = CoreDataManagement().context
    let tableView = UITableView()
    var classes: [Class] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        takeAllClasses()
        configureView()
        configureTableView()
    }
    
    func configureView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.app"), style: .done, target: self, action: #selector(addButtonPressed))
    }
    
    @objc func addButtonPressed() {
        let alert = UIAlertController(title: "Class", message: "Add new class to your notes", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] _ in
            guard let self else { return }
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else { return }
            self.addClassData(name: text)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    

    func sortClassess() {
        classes.sort { $0.date > $1.date }
    }
    
// MARK: - CORE DATA
    
    func addClassData(name: String) {
        let newClass = Class(context: context)
        newClass.name = name
        newClass.date = Date().timeIntervalSince1970
        
        do {
            try context.save()
            classes.append(newClass)
            sortClassess()
            tableView.reloadData()
        } catch { return }
    }
    
    func takeAllClasses() {
        do {
            classes = try context.fetch(Class.fetchRequest())
            sortClassess()
        } catch { return }
    }
}

// MARK: - TABLE VIEW

extension ClassesVC: UITableViewDelegate, UITableViewDataSource {
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        
        tableView.register(TeacTableViewCell.self, forCellReuseIdentifier: TeacTableViewCell.reuseID)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        classes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TeacTableViewCell.reuseID) as! TeacTableViewCell
        cell.set(leftText: classes[indexPath.row].name!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedClass = classes[indexPath.row]
        let studentsVC = StudentsVC()
        studentsVC.classs = selectedClass
        studentsVC.title = selectedClass.name
        
        navigationController?.pushViewController(studentsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let selectedClass = classes[indexPath.row]
        CoreDataManagement().deleteData(data: selectedClass)
        classes.remove(at: indexPath.row)
        tableView.reloadData()
    }
}
