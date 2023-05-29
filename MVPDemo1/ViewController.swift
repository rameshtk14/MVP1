//
//  UserViewController.swift
//  MVPDemo1
//
//  Created by RAMESH on 29/05/23.
//

import UIKit

class UserViewController: UIViewController {
   
    var presenter = UserPresenter()
    private var users = [User]()
    
    //MARK: -UI
    private let table: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let label: UILabel = {
       let label = UILabel()
       label.textAlignment = .center
       label.isHidden = true
       return label
    }()
    
    fileprivate func setupUI() {
        title = "Users"
        view.addSubview(table)
        view.addSubview(label)
        view.backgroundColor = .systemBlue
        table.dataSource = self
        table.delegate = self
    }
    //MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.setViewDelegate(delegate: self)
        presenter.getUsers()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        label.center = view.center
    }

}

//MARK: -TableViewDataSource & Delegate
 extension UserViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didTapUser(user: users[indexPath.row])
    }
}

//MARK: -UserPresenterDelegate
extension UserViewController: UserPresenterDelegate {
    func presentUsers(users: [User]) {
        self.users = users
        DispatchQueue.main.async {
            self.table.isHidden = false
            self.table.reloadData()
        }
    }
}
