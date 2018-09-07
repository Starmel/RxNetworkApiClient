//
//  ViewController.swift
//  RxNetworkApiClient
//
//  Created by starmel on 09/07/2018.
//  Copyright (c) 2018 starmel. All rights reserved.
//

import UIKit
import RxNetworkApiClient
import RxSwift


class ViewController: UITableViewController {

    private var apiClient: ApiClient = ApiClientImp.defaultInstance(host: "https://jsonplaceholder.typicode.com")
    private var todos: [TodoEntity]? = nil


    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(onPullRefresh), for: .valueChanged)
        tableView.addSubview(refreshControl!)
        loadItems()
    }

    @objc func onPullRefresh() {
        loadItems()
    }

    private func loadItems() {
        _ = apiClient.execute(request: .todoList())
                .do(onSubscribed: {
                    self.refreshControl?.beginRefreshing()
                }, onDispose: {
                    self.refreshControl?.endRefreshing()
                })
                .observeOn(MainScheduler.instance)
                .subscribe(onSuccess: { (todos: [TodoEntity]) in
                    self.todos = todos
                    self.tableView.reloadData()
                }) { (error) in
                    print("ViewController: error = ", error)
                    self.showLoadingError()
                }
    }

    private func showLoadingError() {
        let alert = UIAlertController(title: "Loading error", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default))
        present(alert, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos?.count ?? 0
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = todos![indexPath.row].title
        return cell
    }
}

