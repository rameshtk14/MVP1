//
//  Presenter.swift
//  MVP
//
//  Created by RAMESH on 17/04/23.
//

import Foundation
import UIKit

typealias presenterDelegate =  UserPresenterDelegate & UIViewController

//MARK: -UserPresenterDelegate
protocol UserPresenterDelegate: AnyObject {
    func presentUsers(users: [User])
}

class UserPresenter {
    
    weak var delegate: presenterDelegate?
    let urlString = "https://jsonplaceholder.typicode.com/users"
    
    func getUsers() {
        guard let url = URL(string:urlString ) else { return }
        let task =  URLSession.shared.dataTask(with: url) { [weak self]
            data,response,error in
            guard let data = data , let _ = response else {
                return
            }
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                self?.delegate?.presentUsers(users: users)
            }catch let error {
                print("error:\(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    public func setViewDelegate(delegate: presenterDelegate) {
        self.delegate = delegate
    }
    
    func didTapUser(user: User) {
        let title = user.name
        let message = "has email \(user.email) and username \(user.name)"
        let alert = UIAlertController(title: title , message: message , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "dismiss", style: .cancel))
        delegate?.present(alert, animated: true)
    }
    
}
