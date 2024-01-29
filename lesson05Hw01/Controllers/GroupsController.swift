import UIKit

final class GroupsController: UITableViewController {
    
    private var data = [GroupsModel.Response.Group]()
    private let refresh = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        loadGroupsData()
    }
    
    private func setupTableView() {
        tableView.register(GroupsViewCell.self, forCellReuseIdentifier: "GroupsViewCellIdentifier")
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(loadGroupsData), for: .valueChanged)
        
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .white
    }
    
    @objc private func loadGroupsData() {
        APIManager.shared.getData(for: .groups) { [weak self] groups in
            DispatchQueue.main.async {
                self?.refresh.endRefreshing() // End the refreshing animation
            }
            
            guard let groups = groups as? [GroupsModel.Response.Group] else {
                print("error groups")
                return
            }
            
            self?.data = groups
            DispatchQueue.main.async {
                print("reload data groups")
                self?.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsViewCellIdentifier", for: indexPath) as? GroupsViewCell else {
            fatalError("Could not dequeue GroupsViewCell")
        }
        
        let group = data[indexPath.row]
        // Assuming that GroupsViewCell has a method configureWithGroup(_:)
        cell.configureWithGroup(group)
        return cell
    }
    
    // Add other UITableViewDelegate and UITableViewDataSource methods if necessary
}
