//
//  StudentsVC.swift
//  TeacherNotes
//
//  Created by Muhammed Emin Bardakcı on 17.03.2023.
//

import UIKit

class StudentsVC: UIViewController {

    var classs: Class!
    let context = CoreDataManagement().context
    let tableView = UITableView()
    var students: [Student] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        takeAllStudents()
        sortStudents()
        tableView.reloadData()
    }
    
    func configureView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.app"), style: .done, target: self, action: #selector(addButtonPressed))
    }
    
    @objc func addButtonPressed() {
        let alert = UIAlertController(title: "Student", message: "Add new student to \(classs.name!)", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] _ in
            guard let self else { return }
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else { return }
            self.addStudentData(name: text)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    
        present(alert, animated: true)
    }
    
    func sortStudents() {
        students.sort { $0.point > $1.point }
    }
    
// MARK: - CORE DATA
    
    func addStudentData(name: String) {
        let newStudent = Student(context: context)
        newStudent.name = name
        newStudent.point = Int16(0)
        newStudent.classs = classs
        
        do {
            try context.save()
            students.append(newStudent)
            sortStudents()
            tableView.reloadData()
        } catch { return }
    }
    
    func takeAllStudents() {
        students = classs.students?.allObjects as! [Student]
    }
}

// MARK: - TABLE VIEW

extension StudentsVC: UITableViewDelegate, UITableViewDataSource {
    
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
        students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TeacTableViewCell.reuseID) as! TeacTableViewCell
        let student = students[indexPath.row]
        cell.set(leftText: student.name!, rightText: String(student.point))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedStudent = students[indexPath.row]
        let notesVC = NotesVC()
        notesVC.student = selectedStudent
        notesVC.title = selectedStudent.name
        
        navigationController?.pushViewController(notesVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let selectedStudent = students[indexPath.row]
        CoreDataManagement().deleteData(data: selectedStudent)
        students.remove(at: indexPath.row)
        tableView.reloadData()
    }
}
