import UIKit
import CoreData

class AddTaskViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext!
    
    @IBOutlet weak var enterTaskFieldName: UITextField!
    @IBOutlet weak var enterPriorityTextField: UITextField!
    
    @IBOutlet weak var designView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        context = appDelegate.persistentContainer.viewContext
        // Do any additional setup after loading the view.
    
        showKeyBoard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        designView.layer.cornerRadius = 100.0
        designView.layer.borderWidth = 0.5;
    }
    
    func showKeyBoard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(hideKeyBoard))
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func hideKeyBoard() {
        view.endEditing(true)
    }
    
    
    @IBAction func saveTaskButton(_ sender: UIButton) {
        
        if(enterPriorityTextField.text == "" || enterPriorityTextField.text == nil || enterTaskFieldName.text == "" || enterTaskFieldName.text == nil){
            let alert = UIAlertController(title: "Error", message: "Task Name and Priority will not empty", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else {
            
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            print(path)
            let url = URL(fileURLWithPath: path)
            
            print("url path =\(url)")

                let task = TaskManager(context: context)
                task.taskName = enterTaskFieldName.text?.capitalized ?? "0"
                task.taskPriority = Int16(enterPriorityTextField.text ?? "")!

                appDelegate.saveContext()
                enterPriorityTextField.text = ""
                enterTaskFieldName.text = ""
            }
            
        }
        
        
        
        
    }
    

