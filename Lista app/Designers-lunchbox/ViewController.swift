import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var ideas: [NSManagedObject] = []
    
    // MARK: - View Life Cycle
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
        // SORTING
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Project.nimi), ascending: true)]
        
        
        do {
            ideas = try managedContext.fetch(fetchRequest)
        }   catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        //tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "IdeaListCell", for: indexPath)
        
//        cell.textLabel?.text = oneIdea.value(forKeyPath: "nimi") as? String
//        cell.detailTextLabel?.text = oneIdea.value(forKeyPath: "nimi") as? String
        
        var content = cell.defaultContentConfiguration()

        // Configure content.
        content.image = UIImage(systemName: "star")
        content.text = oneIdea.value(forKeyPath: "nimi") as? String
        content.secondaryText = "ADD DATE() HERE"
        

        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.frame.size.height = 80
        
        // Customize appearance.
        content.imageProperties.tintColor = .red
        content.imageProperties.maximumSize = CGSize(width: 40, height: 40)

      

        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      ideas.remove(at: indexPath.row)
      
      let indexPaths = [indexPath]
      tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
}

