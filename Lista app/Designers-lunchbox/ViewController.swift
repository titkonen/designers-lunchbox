import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var ideas: [NSManagedObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Lista"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    // Fetching data from CoreData
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Project")
        
        do {
            ideas = try managedContext.fetch(fetchRequest)
        }   catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func addIdea(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New idea",
                                      message: "Add a new idea",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
        
            guard let textField = alert.textFields?.first,
              let tallennaIdea = textField.text else {
                return
            }
            self.save(nimi: tallennaIdea)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func save(nimi: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Project", in: managedContext)!
        
        let oneIdea = NSManagedObject(entity: entity, insertInto: managedContext)
        
        oneIdea.setValue(nimi, forKeyPath: "nimi")
        
        do {
            try managedContext.save()
            ideas.append(oneIdea)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    


}

    // MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
        return ideas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let oneIdea = ideas[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = oneIdea.value(forKeyPath: "nimi") as? String
        
        return cell
    }
}

