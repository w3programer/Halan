import UIKit
class OrdersVc: UIViewController {
    @IBOutlet weak var customCollectionView: UICollectionView!
    @IBOutlet var ordersTable: UITableView!
    var orders = [ordersModel]()
    var orderStatue = "1"
    let tabsArray = [NSLocalizedString("Current", comment: "Current"), NSLocalizedString("Previous", comment: "Previous"),NSLocalizedString("Canceled", comment: "Canceled") ]
    override func viewDidLoad()
    {
        super.viewDidLoad()
        customCollectionView.isScrollEnabled = false
        customCollectionView.reloadData()
        self.getData()
    }
    func getData() {
        var urlstr = ""
        if Helper.isDriver() == true{
           urlstr = Config.viewdriverOrder+self.orderStatue+"/\(Helper.getuserid())"
        }else{
            urlstr = Config.viewClientOrder+self.orderStatue+"/\(Helper.getuserid())"
        }
        Api.ordersApi(url: urlstr) { (error:Error?,data:[ordersModel]?) in
            self.orders  = data!
            self.ordersTable.reloadData()
            }
    }
}
// MARK: - UICollectionViewDataSource, UICollectionViewDelegate Methods
extension OrdersVc : UICollectionViewDataSource, UICollectionViewDelegate
{
    //MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.tabsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToBarCell", for: indexPath) as! BarCollectionViewCell
        cell.titleLabel.text = self.tabsArray[indexPath.row]
        return cell
    }

    //MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        //For initially highlighting the first cell of "customCollectionView" when ViewController is loaded
        guard let _ = collectionView.indexPathsForSelectedItems?.first, indexPath.row != 0 else
        {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
            return
        }
}
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)

        if indexPath.row == 0 {
            self.orderStatue = "1"
            self.getData()
        }else if indexPath.row == 1{
            self.orderStatue = "4"
        self.getData()
        }else if indexPath.row == 2{
            self.orderStatue = "2"
            self.getData()
        }
        //print("\(self.tabsArray[indexPath.row]) Pressed")
    }
}
extension OrdersVc: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
//////////extention table
extension OrdersVc :UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell" ,for: indexPath) as! OrderCell
        cell.orderDate.text = orders[indexPath.row].order_start_from_minute
        cell.client_location.text = orders[indexPath.row].client_location
        cell.market_location.text = orders[indexPath.row].market_location
        cell.cost.text = orders[indexPath.row].cost

        return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.orderStatue == "1"{
            self.performSegue(withIdentifier: "activeSegue", sender: self)
        }else{
            self.performSegue(withIdentifier: "OrderDetailesSegue", sender: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OrderDetailesSegue" {
            let destinationVC = segue.destination as! OrderDetailesVC
            destinationVC.dataarr = orders[(ordersTable.indexPathForSelectedRow?.row)!]
        }else if segue.identifier  == "activeSegue" {
                let destinationVC = segue.destination as! CurentOrder
                destinationVC.dataarr = orders[(ordersTable.indexPathForSelectedRow?.row)!]
        }
    }

}











