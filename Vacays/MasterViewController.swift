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
//    var objects = [Any]()
    var vacations : NSMutableArray?

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
        self.vacations = NSMutableArray.init()
        let arr = NSArray(contentsOfFile: NSHomeDirectory() + "/Documents/col.plist")
        for (i,_) in (arr!.enumerated()) {
            let json : String = arr?[i] as! String
            let coordinateData = json.data(using: .utf8)!
            let decoder = JSONDecoder()
            do{
                let model = try decoder.decode(VacationCodable.self, from: coordinateData)
                self.vacations?.add(model)
                
            }catch {
                
            }
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        refreshAction()
        
    }

    @objc
    func insertNewObject(_ sender: Any) {
        let model = VacationCodable.init(title:"Sky observation deck", latitude: "20.99" ,Longitude: "30.99", address:"", cost: "23", date: "October 1st", remark: "Sky glass slide", imgdata:"" ,score: "0")

        self.vacations!.insert(model, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
      
        let jsonarr = NSMutableArray.init()
        for (i,item) in (self.vacations?.enumerated())! {
            do{
                
                let data = try JSONEncoder().encode(self.vacations![i] as!VacationCodable)
                let json = String(data: data, encoding: .utf8)
                jsonarr.add(json ?? "")
                
            }catch {
                
            }
        }
        
        let array = NSArray.init(array: jsonarr)
        let filePath:String = NSHomeDirectory() + "/Documents/col.plist"
        array.write(toFile: filePath, atomically: true)
        
        
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
                controller.item = indexPath.row
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
        return self.vacations!.count
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
            
            
            
            let score = UIButton.init()
            score.setImage(UIImage.init(named: "star_fore"), for: UIControl.State.normal)
            score.frame = CGRect.init(x: 0, y: 0, width: 80, height: 40)
            score.setTitle(model.score, for: UIControl.State.normal)
            score.setTitleColor(UIColor.black, for: UIControl.State.normal)
            cell.accessoryView = score
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
            self.vacations?.removeObject(at: indexPath.row)
            self.refreshAction()
            let jsonarr = NSMutableArray.init()
            for (i,item) in (self.vacations?.enumerated())! {
                do{
                    
                    let data = try JSONEncoder().encode(self.vacations![i] as!VacationCodable)
                    let json = String(data: data, encoding: .utf8)
                    jsonarr.add(json ?? "")
                    
                }catch {
                    
                }
            }
            
            let array = NSArray.init(array: jsonarr)
            let filePath:String = NSHomeDirectory() + "/Documents/col.plist"
            array.write(toFile: filePath, atomically: true)
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

