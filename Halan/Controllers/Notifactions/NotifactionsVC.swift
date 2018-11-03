import UIKit

class NotifactionsVC: UIViewController,UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var NotifactionTable: UITableView!
    var notifactionarr = [Notifactions]()
    
    lazy var refresher : UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handlerefresh), for: .valueChanged)
        return refresher
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        NotifactionTable.tableFooterView = UIView()
        if Helper.isguest() == false{
            NotifactionTable.addSubview(refresher)
            self.handlerefresh()

        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.tabBarItem.badgeValue = "\(String(describing: self.notifactionarr.count))"
        self.navigationController?.tabBarItem.badgeColor = .red

    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifactionarr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotiViewCell" ,for: indexPath) as! NotiViewCell
        cell.Dateadd.text = notifactionarr[indexPath.row].order_date
        cell.cost.text = notifactionarr[indexPath.row].order_driver_cost
        cell.FromPoint.text = notifactionarr[indexPath.row].market_location
        cell.Topoint.text = notifactionarr[indexPath.row].client_location
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.performSegue(withIdentifier: "NotifactionSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "NotifactionSegue" {
            let destinationVC = segue.destination as! NotifactionsDetailes
            destinationVC.dataarr = notifactionarr[(NotifactionTable.indexPathForSelectedRow?.row)!]
        }
        
        
    }
    @objc private func handlerefresh(){
        self.refresher.endRefreshing()
        Api.NotifactionsApi{(error :Error?, data: [Notifactions]?) in
            self.notifactionarr = data!
            self.NotifactionTable.reloadData()
   
        }
    }
    


    
    
    
    
    
    

}
