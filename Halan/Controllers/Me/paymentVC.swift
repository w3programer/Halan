import UIKit
class paymentVC: UIViewController {
    @IBOutlet var money: UITextField!
    
    let datePicker = UIDatePicker()
    @IBOutlet var transfareDate: UITextField!
    @IBOutlet var discountCode: UITextField!
    @IBOutlet var bank: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        showDatePicker()
    }
    
    @IBAction func sendPayment(_ sender: UIButton) {
        Api.driverPay(amount: self.money.text!, date: self.transfareDate.text!, bank: self.bank.text!, code: self.discountCode.text!) { (error:Error?, success:Bool) in
            let title:String = NSLocalizedString("report", comment: "")
            let message:String = NSLocalizedString("payment sent success", comment: "")
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert,animated: true)

            
        }
    }
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        transfareDate.inputAccessoryView = toolbar
        transfareDate.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        transfareDate.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
}
