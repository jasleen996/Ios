import UIKit
import CoreData

class ViewController: UIViewController , UITableViewDelegate , UITableViewDataSource, UITabBarDelegate  {
    
     
    var taskList:Array = [Any]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
   
    var context: NSManagedObjectContext!
    
    @IBOutlet weak var taskTableView: UITableView!
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        context = appDelegate.persistentContainer.viewContext
        fetchData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = appDelegate.persistentContainer.viewContext
        // Do any additional setup after loading the view.
    }

    
    func fetchData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskManager")
        
        // add Sort descriptor
        let nameSortDescriptor = NSSortDescriptor(key: "taskName", ascending: true)
        let prioritySortDescriptor = NSSortDescriptor(key: "taskPriority", ascending: true)
        
        request.sortDescriptors = [
            prioritySortDescriptor,
            nameSortDescriptor
        ]
        
        taskList.removeAll()
        
        do {
            let result = try context.fetch(request)
            print("DATA : \(result)")
            for data in result as! [NSManagedObject] {
            taskList.append(data)
            print("offline music data \(taskList)")
            
            }
        
            taskTableView.reloadData()
        }
        catch{
            print("error")
        }
        
    }
    
    
 
    //MARK - TASK MANAGER TABLE VIEW FUNCTION
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return  taskList.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell") as! TaskTableViewCell
        let data:NSManagedObject = taskList[indexPath.row] as! NSManagedObject
        cell.taskName.text = data.value(forKey:"taskName") as? String
        cell.taskPriority.text = "This task having Priority No - \(data.value(forKey:"taskPriority")!) "
        
        return cell
      }
    
      
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    let data:NSManagedObject = taskList[indexPath.row] as! NSManagedObject
        delete(data: data, title: data.value(forKey: "taskName") as! String)

    self.taskTableView.reloadData()

    }
    
    
    func delete(data : NSManagedObject , title : String ) {
          
        let context = appDelegate.persistentContainer.viewContext
        context.delete(data)
        
        do {
            try context.save()
                  fetchData()
                  self.taskTableView.reloadData()
            }
        catch {
                print("Error to delete from coreData")
            }
    }
}
