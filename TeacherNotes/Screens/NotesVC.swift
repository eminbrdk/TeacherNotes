//
//  NotesVC.swift
//  TeacherNotes
//
//  Created by Muhammed Emin Bardakcı on 17.03.2023.
//

import UIKit

enum buttonType { case plus, minus }

class NotesVC: UIViewController {

    var student: Student!
    let context = CoreDataManagement().context
    let tableView = UITableView()
    var notes: [Note] = []
    var buttonType: buttonType = .minus
    
    override func viewDidLoad() {
        super.viewDidLoad()

        takeAllNotes()
        configureView()
        configureTableView()
    }
    
    func configureView() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "plus.app"), style: .done, target: self, action: #selector(addButtonPressed)),
            UIBarButtonItem(image: UIImage(systemName: "minus.square"), style: .done, target: self, action: #selector(minusButtonPressed))
        ]
    }
    
    @objc func addButtonPressed(_ sender: UIButton) {
        buttonType = .plus
        addAlert()
    }
    
    @objc func minusButtonPressed() {
        buttonType = .minus
        addAlert()
    }
    
    func addAlert() {
        let point = buttonType == .plus ? 1 : -1
        let message = buttonType == .plus ? "plus" : "minus"
        let title = buttonType == .plus ? "Plus" : "Minus"
        
        let alert = UIAlertController(title: "\(title) Note", message: "Add new \(message) note to \(student.name!)", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] _ in
            guard let self else { return }
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else { return }
            self.addNoteData(text: text, point: point)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    func sortNotes() {
        notes.sort { $0.date > $1.date }
    }
    
// MARK: - CORE DATA
    
    func addNoteData(text: String, point: Int) {
        let newNote = Note(context: context)
        newNote.text = text
        newNote.point = Int16(point)
        newNote.date = Date().timeIntervalSince1970
        newNote.student = student
        student.point += Int16(point)
        
        do {
            try context.save()
            notes.append(newNote)
            sortNotes()
            tableView.reloadData()
        } catch { return }
    }
    
    func takeAllNotes() {
        notes = student.notes?.allObjects as! [Note]
        sortNotes()
    }
}

// MARK: - TABLE VIEW

extension NotesVC: UITableViewDelegate, UITableViewDataSource {
    
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
        notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TeacTableViewCell.reuseID) as! TeacTableViewCell
        let note = notes[indexPath.row]
        cell.set(leftText: note.text!, rightText: String(note.point))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let selectedNote = notes[indexPath.row]
        student.point -= selectedNote.point
        CoreDataManagement().deleteData(data: selectedNote)
        notes.remove(at: indexPath.row)
        tableView.reloadData()
    }
}
