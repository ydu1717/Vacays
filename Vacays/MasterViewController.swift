//
//  MasterViewController.swift


import UIKit


struct VacationCodable :Codable {
    
    var title : String
    var latitude : String
    var Longitude : String
    var address : String
    var cost : String
    var date : String
    var remark : String
    var imgdata : String
    var score    : String
    private enum CodingKeys : String , CodingKey {
        case title
        case latitude
        case Longitude
        case cost
        case date
        case remark
        case imgdata
        case address
        case score
    }
}

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [Any]()
    var vacations : NSArray?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = editButtonItem
        self.tableView.tableFooterView = UIView.init()

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshAction))

        navigationItem.rightBarButtonItems = [refreshButton,addButton]
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        if self.vacations?.count ?? 0 > 0 {
            self.objects = self.vacations as! [Any]
        }
        if self.objects.count <= 0 {
            self.objects = ["1"]
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        refreshAction()
//        print(self.vacations as Any)
    }

    @objc
    func insertNewObject(_ sender: Any) {
        objects.insert(NSDate(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        
    }
    
    @objc
    func refreshAction() -> Void {
        tableView.reloadData()
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
//                let object = objects[indexPath.row] as! NSDate
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
//                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let arr = NSArray(contentsOfFile: NSHomeDirectory() + "/Documents/col.plist")
        let json : String = arr?[indexPath.row] as! String
        let coordinateData = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        do{
            let model = try decoder.decode(VacationCodable.self, from: coordinateData)
            let data = NSData.init(base64Encoded: model.imgdata, options: NSData.Base64DecodingOptions.init())
            let img : UIImage = UIImage.init(data: data! as Data) ?? UIImage.init(named: "jia")!
            
            cell.imageView?.image = img
            cell.textLabel!.text = model.title
            cell.detailTextLabel?.text = model.remark
//            
//            let lb = UILabel.init()
//            lb.backgroundColor = UIColor.red
//            lb.frame = CGRect.init(x: SCREEN_WIDTH - 100, y: 10, width: 80, height: 30)
//            cell.contentView.addSubview(lb)
            
        }catch {
            
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

