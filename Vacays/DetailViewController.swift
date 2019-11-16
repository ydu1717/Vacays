

import UIKit
import CoreLocation

class DetailViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    let imagePicker = UIImagePickerController()

    private lazy var imgbtn : UIButton = {
        let img = UIButton.init()
        img.imageView?.contentMode = .scaleAspectFill
        img.backgroundColor = UIColor.gray
        img.addTarget(self, action: #selector(imgbtnClick), for: UIControl.Event.touchUpInside)
        return img
    }()
    
    private lazy var tool : UIToolbar = {
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        return toolbar
    }()
    
    private lazy var titlelb : UITextField = {
        let lb = UITextField.init()
        lb.textAlignment = NSTextAlignment.center
        lb.delegate = self
        lb.backgroundColor = UIColor.lightGray
        lb.returnKeyType = UIReturnKeyType.done
        
        lb.inputAccessoryView = self.tool
        return lb
    }()
    
    private lazy var locationlb : UILabel = {
        let lb = UILabel.init()
        lb.textAlignment = NSTextAlignment.center
//        lb.delegate = self
//        lb.placeholder = "longitude"
        lb.backgroundColor = UIColor.lightGray
//        lb.returnKeyType = UIReturnKeyType.done
//        lb.inputAccessoryView = self.tool
//        lb.isEditing = false
        return lb
    }()
    
    private lazy var locationlb1 : UILabel = {
        let lb = UILabel.init()
        lb.textAlignment = NSTextAlignment.center
//        lb.delegate = self
//        lb.placeholder = "latitude"
        lb.backgroundColor = UIColor.lightGray
//        lb.returnKeyType = UIReturnKeyType.done
//        lb.inputAccessoryView = self.tool
//        lb.isEditing = false

        return lb
    }()
    
    private lazy var addresslb : UIButton = {
        let lb = UIButton.init()
        lb.backgroundColor = UIColor.lightGray
        lb.setTitleColor(UIColor.black, for: UIControl.State.normal)
        lb.addTarget(self, action: #selector(addressClick), for: UIControl.Event.touchUpInside)
        return lb
    }()
    
    private lazy var costlb : UITextField = {
        let lb = UITextField.init()
        lb.textAlignment = NSTextAlignment.center
        lb.delegate = self
        lb.backgroundColor = UIColor.lightGray
        lb.textColor = UIColor.brown
        lb.returnKeyType = UIReturnKeyType.done
        lb.inputAccessoryView = self.tool

        return lb
    }()
    
    private lazy var datelb : UIButton = {
        let lb = UIButton.init()
        lb.backgroundColor = UIColor.lightGray
        lb.setTitleColor(UIColor.black, for: UIControl.State.normal)
        lb.addTarget(self, action: #selector(pickClick), for: UIControl.Event.touchUpInside)
        return lb
    }()
    
    private lazy var remarklb : UITextView = {
        let lb = UITextView.init()
        lb.textAlignment = NSTextAlignment.center
        lb.delegate = self
        lb.backgroundColor = UIColor.lightGray
        lb.inputAccessoryView = self.tool

        return lb
    }()
    
    private lazy var scroll : UIScrollView = {
        let scroll = UIScrollView.init()
//        scroll.
        return scroll
    }()
    
    private var originY: CGFloat = 0
    
    var socrestring = "0"
    
    var starview : ScoreView?
    
    var item : Int = 0

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
      
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeUI), name: NSNotification.Name(rawValue: "ChangeUINOfitication"), object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = UIColor.black
        self.imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        view.addSubview(self.scroll)
        self.scroll.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        
        self.scroll.addSubview(self.imgbtn)
        self.imgbtn.frame = CGRect.init(x: 0, y:CGFloat(NavigationHeight) , width:SCREEN_WIDTH , height: SCREEN_WIDTH/2)
        
        self.scroll.addSubview(self.titlelb)
        self.titlelb.frame = CGRect.init(x: 20, y: CGFloat(NavigationHeight) + 5 + SCREEN_WIDTH/2, width: SCREEN_WIDTH - 40, height: 50)
        
        self.scroll.addSubview(self.addresslb)
        self.addresslb.frame = CGRect.init(x: 20, y: self.titlelb.y + self.titlelb.height + 5, width: SCREEN_WIDTH/2, height: 50)
        
        self.scroll.addSubview(self.locationlb)
        self.locationlb.frame = CGRect.init(x: self.addresslb.x + self.addresslb.width + 5, y: self.titlelb.y + self.titlelb.height + 5, width: SCREEN_WIDTH/4 - 25, height: 50)
        
        self.scroll.addSubview(self.locationlb1)
        self.locationlb1.frame = CGRect.init(x: self.locationlb.x + self.locationlb.width, y: self.titlelb.y + self.titlelb.height + 5, width: SCREEN_WIDTH/4 - 25, height: 50)
        
        self.scroll.addSubview(self.costlb)
        self.costlb.frame = CGRect.init(x: 20, y: self.locationlb.y + self.locationlb.height + 5, width: SCREEN_WIDTH-40, height: 50)
        
        self.scroll.addSubview(self.datelb)
        self.datelb.frame = CGRect.init(x: 20, y: self.costlb.y + self.costlb.height + 5, width: SCREEN_WIDTH-40, height: 50)
        
        self.starview = ScoreView.init(frame: CGRect.init(x: 20, y: self.datelb.y + self.datelb.height + 5, width: SCREEN_WIDTH-40, height: 100), starCount: 8, currentStar: 2, rateStyle: .half) { (current) -> (Void) in
            print(current)
            self.socrestring = "\(current)"
            self.savedate()
        }
        self.starview?.numberOfStar = 5
        self.scroll.addSubview(self.starview!)
        
        self.scroll.addSubview(self.remarklb)
        self.remarklb.frame = CGRect.init(x: 20, y: self.starview!.y + self.starview!.height + 5, width: SCREEN_WIDTH-40, height: 50)
        
        self.scroll.contentSize = CGSize.init(width: SCREEN_WIDTH, height: self.remarklb.y + self.remarklb.height + 20)
        
        
        let arr = NSArray(contentsOfFile: NSHomeDirectory() + "/Documents/col.plist")
        let json : String = arr?[self.item] as! String
        let coordinateData = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        do{
            let model = try decoder.decode(VacationCodable.self, from: coordinateData)
            let data = NSData.init(base64Encoded: model.imgdata, options: NSData.Base64DecodingOptions.init())
            let img : UIImage = UIImage.init(data: data! as Data) ?? UIImage.init(named: "jia")!
            
            self.imgbtn.setImage(img, for: UIControl.State.normal)
            self.titlelb.text     = model.title
            self.addresslb.setTitle(model.address, for: UIControl.State.normal)
            self.locationlb.text  = model.latitude
            self.locationlb1.text = model.Longitude
            self.costlb.text      = model.cost
            self.datelb.setTitle(model.date, for: .normal)
            self.remarklb.text    = model.remark
            self.starview?.selectNumberOfStar = Float(CGFloat(Double(model.score ?? "0")!))
            self.title = model.title
        }catch {
            
        }
        
        let datePicker = UIDatePicker()
        datePicker.frame = CGRect.init(x: 20, y: SCREEN_HEIGHT - 200, width: SCREEN_WIDTH - 40, height: 200)
        datePicker.tag = 1
        datePicker.isHidden = true
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePicker.maximumDate = Date(timeInterval:3*24*60*60,since:Date())
        self.view.addSubview(datePicker)
        datePicker.addTarget(self, action: #selector(pickchangeClick), for: .valueChanged)
        
    }
    
    @objc func addressClick() {
        let alert = UIAlertController.init(title: "Please enter the address", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { (tf) in
            tf.placeholder = "Please enter the address"
        }
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) in
            
        }))
        alert.addAction(UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
            let tf : UITextField = (alert.textFields?.first!)!
            self.addresslb.setTitle(tf.text ?? "", for: UIControl.State.normal)
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(tf.text ?? "", completionHandler: { (placeMarks, error) in
                if  (error != nil || (placeMarks?.count == 0)) {

                }else{
//                    for placeMark in placeMarks!{
//                        print("name = \(placeMark.name ?? ""),country = \(placeMark.locality),postalCode = \(placeMark.postalCode),ISOcountryCode = \(placeMark.isoCountryCode)")
//                    }
                    let firstPlaceMark = placeMarks!.first
                    if let location = firstPlaceMark!.location?.coordinate{
                        self.locationlb.text = "\(location.latitude)"
                        self.locationlb1.text = "\(location.longitude)"
                    }
                    self.savedate()
                }
            })
        }))
        self.present(alert, animated: true) {
            
        }
        
    }
    
    @objc func keyboardWillAppear(notification: NSNotification) {

        let keyboardinfo = notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey]
        let keyboardheight:CGFloat = (keyboardinfo as AnyObject).cgRectValue.size.height
       
        UIView.animate(withDuration: 0.3) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardheight)
        }
    }
    
     @objc func keyboardWillDisappear(notification:NSNotification){

        UIView.animate(withDuration: 0.3) {
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }
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
        
        let vaarr = NSArray(contentsOfFile: NSHomeDirectory() + "/Documents/col.plist")
        let muarr = NSMutableArray.init(capacity: vaarr!.count)
        
        let model = VacationCodable.init(title: self.titlelb.text ?? "", latitude: self.locationlb.text ?? "",Longitude: self.locationlb1.text ?? "",address:"", cost: self.costlb.text ?? "", date: self.datelb.titleLabel?.text ?? "", remark: self.remarklb.text ?? "", imgdata: _encodedImageStr ?? "" ,score: self.socrestring)
        
        do{
            for (i,item) in (vaarr?.enumerated())! {
                if i == self.item {
                    let data = try JSONEncoder().encode(model)
                    let json = String(data: data, encoding: .utf8)
                    muarr.add(json as Any)
                }else {
                    muarr.add(item)
                }
            }
            let array = NSArray.init(array: muarr)

            let filePath:String = NSHomeDirectory() + "/Documents/col.plist"
            array.write(toFile: filePath, atomically: true)

        }catch {
            
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        UIView.animate(withDuration: 0.3) {
//            self.view.transform = CGAffineTransform(translationX: 0, y: -SCREEN_HEIGHT/2)
//        }
        let datePicker = self.view.viewWithTag(1)as! UIDatePicker
        datePicker.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        UIView.animate(withDuration: 0.3) {
//            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
//        }
        savedate()
        let datePicker = self.view.viewWithTag(1)as! UIDatePicker
        datePicker.isHidden = true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {

//        UIView.animate(withDuration: 0.3) {
//            self.view.transform = CGAffineTransform(translationX: 0, y: -SCREEN_HEIGHT/2)
//        }
        let datePicker = self.view.viewWithTag(1)as! UIDatePicker
        datePicker.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
//        UIView.animate(withDuration: 0.3) {
//            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
//        }
        savedate()
        let datePicker = self.view.viewWithTag(1)as! UIDatePicker
        datePicker.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.remarklb.resignFirstResponder()
        self.titlelb.resignFirstResponder()
        self.locationlb.resignFirstResponder()
        self.locationlb1.resignFirstResponder()
        self.costlb.resignFirstResponder()
    }
    
    @objc func doneButtonAction() {
        self.remarklb.resignFirstResponder()
        self.titlelb.resignFirstResponder()
        self.locationlb.resignFirstResponder()
        self.locationlb1.resignFirstResponder()
        self.costlb.resignFirstResponder()
    }
    

    var detailItem: NSDate? {
        didSet {

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
    
    @objc func changeUI()  {
        
        self.scroll.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        self.imgbtn.frame = CGRect.init(x: 0, y:CGFloat(NavigationHeight) , width:SCREEN_WIDTH , height: SCREEN_WIDTH/2)
        self.titlelb.frame = CGRect.init(x: 20, y: CGFloat(NavigationHeight) + 5 + SCREEN_WIDTH/2, width: SCREEN_WIDTH - 40, height: 50)
        self.addresslb.frame = CGRect.init(x: 20, y: self.titlelb.y + self.titlelb.height + 5, width: SCREEN_WIDTH/2, height: 50)
        self.locationlb.frame = CGRect.init(x: self.addresslb.x + self.addresslb.width + 5, y: self.titlelb.y + self.titlelb.height + 5, width: SCREEN_WIDTH/4 - 25, height: 50)
        self.locationlb1.frame = CGRect.init(x: self.locationlb.x + self.locationlb.width, y: self.titlelb.y + self.titlelb.height + 5, width: SCREEN_WIDTH/4 - 25, height: 50)
        self.costlb.frame = CGRect.init(x: 20, y: self.locationlb.y + self.locationlb.height + 5, width: SCREEN_WIDTH-40, height: 50)
        
        self.datelb.frame = CGRect.init(x: 20, y: self.costlb.y + self.costlb.height + 5, width: SCREEN_WIDTH-40, height: 50)
        self.starview?.frame = CGRect.init(x: 20, y: self.datelb.y + self.datelb.height + 5, width: SCREEN_WIDTH-40, height: 100)
        self.remarklb.frame = CGRect.init(x: 20, y: self.starview!.y + self.starview!.height + 5, width: SCREEN_WIDTH-40, height: 50)
        
        self.scroll.contentSize = CGSize.init(width: SCREEN_WIDTH, height: self.remarklb.y + self.remarklb.height + 20)
    }
    
    //MARK :
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        do {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1)
            {
                if SCREEN_WIDTH != size.width
                {
                    SCREEN_WIDTH  = size.width
                    SCREEN_HEIGHT = size.height
                    UIView.animate(withDuration: 0.5)
                    {
                        self.scroll.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
                        self.imgbtn.frame = CGRect.init(x: 0, y:CGFloat(NavigationHeight) , width:SCREEN_WIDTH , height: SCREEN_WIDTH/2)
                        self.titlelb.frame = CGRect.init(x: 20, y: CGFloat(NavigationHeight) + 5 + SCREEN_WIDTH/2, width: SCREEN_WIDTH - 40, height: 50)
                        self.addresslb.frame = CGRect.init(x: 20, y: self.titlelb.y + self.titlelb.height + 5, width: SCREEN_WIDTH/2, height: 50)
                        self.locationlb.frame = CGRect.init(x: self.addresslb.x + self.addresslb.width + 5, y: self.titlelb.y + self.titlelb.height + 5, width: SCREEN_WIDTH/4 - 25, height: 50)
                        self.locationlb1.frame = CGRect.init(x: self.locationlb.x + self.locationlb.width, y: self.titlelb.y + self.titlelb.height + 5, width: SCREEN_WIDTH/4 - 25, height: 50)
                        self.costlb.frame = CGRect.init(x: 20, y: self.locationlb.y + self.locationlb.height + 5, width: SCREEN_WIDTH-40, height: 50)

                        self.datelb.frame = CGRect.init(x: 20, y: self.costlb.y + self.costlb.height + 5, width: SCREEN_WIDTH-40, height: 50)
                        self.starview?.frame = CGRect.init(x: 20, y: self.datelb.y + self.datelb.height + 5, width: SCREEN_WIDTH-40, height: 100)
                        self.remarklb.frame = CGRect.init(x: 20, y: self.starview!.y + self.starview!.height + 5, width: SCREEN_WIDTH-40, height: 50)

                        self.scroll.contentSize = CGSize.init(width: SCREEN_WIDTH, height: self.remarklb.y + self.remarklb.height + 20)

                    }
                }
            }
        }
    }
}


