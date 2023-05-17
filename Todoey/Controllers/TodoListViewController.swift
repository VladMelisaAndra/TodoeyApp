import UIKit
import AVFoundation
import UserNotifications

class TodoListViewController: UITableViewController {

    var audioPlayer: AVAudioPlayer?
    var itemArray = [ItemData]()
    var userLoggedIn: String?
    var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    func scheduleLocalNotification(forTaskTitle taskTitle: String, withTimeInterval timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = "It's time to complete your task: \(taskTitle)"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(identifier: "taskReminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }


    
    func playSound() {
        if let soundURL = Bundle.main.url(forResource: "save", withExtension: "mp3") {
            do {
                print("Sound played")
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
            } catch {
                print("Error, could not play sound: \(error)")
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                print("Notification authorization granted")
            } else {
                print("Notification authorization denied")
            }
        }
        
        dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(userLoggedIn!)
        
        self.performSegue(withIdentifier: "fromTodoListGoToMotivation", sender: self)
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        
        loadItems()
    }

    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // nr of rows in tableview
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    // MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //  print(itemArray[indexPath.row]) // which cell is selected
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    // MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = ItemData()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            print("Trying to play sound")
            self.playSound()

            let taskTitle = textField.text ?? ""
            let timeInterval: TimeInterval = 300 // time in seconds
            self.scheduleLocalNotification(forTaskTitle: taskTitle, withTimeInterval: timeInterval)

            self.saveItems()
        }

        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK - Model Manipulation Methods
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error while encoding item array, \(error)")
        }
        
        self.tableView.reloadData() // forces the tableview to call its Datasource Methods again
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([ItemData].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        itemArray = []
        saveItems()
    }
    
}



