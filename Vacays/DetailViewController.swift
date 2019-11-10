

import UIKit

class DetailViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    let imagePicker = UIImagePickerController()

    private lazy var imgbtn : UIButton = {
        let img = UIButton.init()
        img.imageView?.contentMode = .scaleAspectFill
        img.addTarget(self, action: #selector(imgbtnClick), for: UIControl.Event.touchUpInside)
        return img
    }()
    
    private lazy var titlelb : UITextField = {
        let lb = UITextField.init()
        lb.textAlignment = NSTextAlignment.center
        lb.delegate = self
        return lb
    }()
    
    private lazy var locationlb : UITextField = {
        let lb = UITextField.init()
        lb.textAlignment = NSTextAlignment.center
        lb.delegate = self
        lb.placeholder = "Please enter the longitude"

        return lb
    }()
    
    private lazy var locationlb1 : UITextField = {
        let lb = UITextField.init()
        lb.textAlignment = NSTextAlignment.center
        lb.delegate = self
        lb.placeholder = "Please enter latitude"
        return lb
    }()
    
    private lazy var costlb : UITextField = {
        let lb = UITextField.init()
        lb.textAlignment = NSTextAlignment.center
        lb.delegate = self

        return lb
    }()
    
    private lazy var datelb : UIButton = {
        let lb = UIButton.init()
        lb.setTitleColor(UIColor.black, for: UIControl.State.normal)
        lb.addTarget(self, action: #selector(pickClick), for: UIControl.Event.touchUpInside)
        return lb
    }()
    
    private lazy var remarklb : UITextView = {
        let lb = UITextView.init()
        lb.textAlignment = NSTextAlignment.center
        lb.delegate = self
        return lb
    }()
    
    var item : Int?

    @objc func imgbtnClick() {
        self.imagePicker.modalPresentationStyle = .fullScreen

        DispatchQueue.main.async {
            let alert = UIAlertController.init(title: NSLocalizedString("prompt", comment: ""), message: "", preferredStyle: UIAlertController.Style.actionSheet)
            
            alert.addAction(UIAlertAction.init(title: NSLocalizedString("Photo Gallery", comment: ""), style: UIAlertAction.Style.default, handler: { (action) in
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
            }))
            
            alert.addAction(UIAlertAction.init(title: NSLocalizedString("Camera", comment: ""), style: UIAlertAction.Style.default, handler: { (action) in
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            }))
            
            alert.addAction(UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.cancel, handler: { (action) in
                
            }))

            self.present(alert, animated: true) {
                
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        configureView()
        self.imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        view.addSubview(self.imgbtn)
        self.imgbtn.frame = CGRect.init(x: 0, y:CGFloat(NavigationHeight) , width:SCREEN_WIDTH , height: SCREEN_WIDTH)
        
        view.addSubview(self.titlelb)
        self.titlelb.frame = CGRect.init(x: 0, y: CGFloat(NavigationHeight) + 5 + SCREEN_WIDTH, width: SCREEN_WIDTH, height: 20)
        
        view.addSubview(self.locationlb)
        self.locationlb.frame = CGRect.init(x: 0, y: self.titlelb.y + self.titlelb.height + 5, width: SCREEN_WIDTH/2, height: 20)
        
        view.addSubview(self.locationlb1)
        self.locationlb1.frame = CGRect.init(x: SCREEN_WIDTH/2, y: self.titlelb.y + self.titlelb.height + 5, width: SCREEN_WIDTH/2, height: 20)
        
        view.addSubview(self.costlb)
        self.costlb.frame = CGRect.init(x: 0, y: self.locationlb.y + self.locationlb.height + 5, width: SCREEN_WIDTH, height: 20)
        
        view.addSubview(self.datelb)
        self.datelb.frame = CGRect.init(x: 0, y: self.costlb.y + self.costlb.height + 5, width: SCREEN_WIDTH, height: 20)
        
        view.addSubview(self.remarklb)
        self.remarklb.frame = CGRect.init(x: 0, y: self.datelb.y + self.datelb.height + 5, width: SCREEN_WIDTH, height: 50)
        
        let arr = NSArray(contentsOfFile: NSHomeDirectory() + "/Documents/col.plist")
        let json : String = arr?.firstObject as! String
        let coordinateData = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        do{
            let model = try decoder.decode(VacationCodable.self, from: coordinateData)
            let data = NSData.init(base64Encoded: model.imgdata, options: NSData.Base64DecodingOptions.init())
            let img : UIImage = UIImage.init(data: data! as Data) ?? UIImage.init(named: "jia")!
            
            self.imgbtn.setImage(img, for: UIControl.State.normal)
            self.titlelb.text    = model.title
            self.locationlb.text = model.latitude
            self.locationlb1.text = model.Longitude
            self.costlb.text     = model.cost
            self.datelb.setTitle(model.date, for: .normal)
            self.remarklb.text   = model.remark
        }catch {
            
        }
  
        let datePicker = UIDatePicker()
        datePicker.center = self.view.center
        datePicker.tag = 1
        datePicker.isHidden = true
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePicker.maximumDate = Date(timeInterval:3*24*60*60,since:Date())
        self.view.addSubview(datePicker)
        datePicker.addTarget(self, action: #selector(pickchangeClick), for: .valueChanged)
    }
    
    @objc func pickClick() {
        let datePicker = self.view.viewWithTag(1)as! UIDatePicker
        datePicker.isHidden = false
       
    }
    
    @objc func pickchangeClick() {
        let datePicker = self.view.viewWithTag(1)as! UIDatePicker
        datePicker.isHidden = false
        let date = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateAndTime = dateFormatter.string(from: date)
        self.datelb.setTitle(dateAndTime, for: UIControl.State.normal)
    }
    
 
    func savedate()  {
        
        let _data = self.imgbtn.currentImage?.pngData()
        let _encodedImageStr = _data?.base64EncodedString()
        
        let model = VacationCodable.init(title: self.titlelb.text ?? "", latitude: self.locationlb.text ?? "",Longitude: self.locationlb1.text ?? "", cost: self.costlb.text ?? "", date: self.datelb.titleLabel?.text ?? "", remark: self.remarklb.text ?? "", imgdata: _encodedImageStr ?? "")
        
        do{
            let data = try JSONEncoder().encode(model)
            let json = String(data: data, encoding: .utf8)
            
            let array = NSArray(objects: json ?? "")
            let filePath:String = NSHomeDirectory() + "/Documents/col.plist"
            array.write(toFile: filePath, atomically: true)

        }catch {
            
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -SCREEN_HEIGHT/2)
        }
        let datePicker = self.view.viewWithTag(1)as! UIDatePicker
        datePicker.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }
        savedate()
        let datePicker = self.view.viewWithTag(1)as! UIDatePicker
        datePicker.isHidden = true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        UIView.animate(withDuration: 0.3) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -SCREEN_HEIGHT/2)
        }
        let datePicker = self.view.viewWithTag(1)as! UIDatePicker
        datePicker.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }
        savedate()
        let datePicker = self.view.viewWithTag(1)as! UIDatePicker
        datePicker.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.remarklb.resignFirstResponder()
    }
    

    var detailItem: NSDate? {
        didSet {
            // Update the view.
//            configureView()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        
        DispatchQueue.main.async {
            self.imgbtn.setImage(pickedImage, for: UIControl.State.normal)
            self.savedate()
        }
        self.dismiss(animated: true, completion: nil)
    }
}


