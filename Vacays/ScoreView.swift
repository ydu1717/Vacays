

import UIKit

public enum rateStyle: Int {
    case  all     = 0
    case  half    = 1
    case  custom  = 2
}

public typealias CountCompleteBackBlock = (_ currentCount:Float)->(Void)

@IBDesignable
public class ScoreView: UIView {
    
    @IBInspectable public var numberOfStar:UInt = 5
    public var selectNumberOfStar:Float = 0{
        didSet{
            if oldValue == selectNumberOfStar {
                return
            }
            if selectNumberOfStar < 0 {
                selectNumberOfStar = 0
            }else if selectNumberOfStar > Float(numberOfStar){
                selectNumberOfStar = Float(numberOfStar)
            }
            
            if let currentStarBack = callback {
                currentStarBack(selectNumberOfStar)
            }
            layoutSubviews()
        }
    }
    @IBInspectable public var isAnimation:Bool = true
    @IBInspectable public var isSupportTap:Bool = true
    
    public var callback:CountCompleteBackBlock?
    public var selectStarUnit:rateStyle = .all
    fileprivate var backgroundView:UIView!
    fileprivate var foreView:UIView!
    fileprivate var starWidth:CGFloat!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public convenience init(frame: CGRect,starCount:UInt?,currentStar:Float?,rateStyle:rateStyle?,isAnimation:Bool? = true,complete:@escaping CountCompleteBackBlock) {
        self.init(frame: frame)
        callback = complete
        numberOfStar = starCount ?? 5
        selectNumberOfStar = currentStar ?? 0
        selectStarUnit = rateStyle ?? .all
        self.isAnimation = isAnimation!
        setupUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
        let animationTimeInterval = isAnimation ? 0.2 : 0
        UIView.animate(withDuration: animationTimeInterval) {
            self.foreView.frame = CGRect(x: 0, y: 0, width: self.starWidth * CGFloat(self.selectNumberOfStar), height: self.bounds.size.height)
        }
    }
    
}


extension ScoreView{
    
    public func update() {
        setupUI()
    }
    
    fileprivate func setupUI(){
        
        clearAll()
        starWidth =  self.bounds.size.width/CGFloat(numberOfStar)
        self.backgroundView = self.creatStarView(image: #imageLiteral(resourceName: "star_bg"))
        self.foreView = self.creatStarView(image: #imageLiteral(resourceName: "star_fore"))
        
        self.foreView.frame = CGRect(x: 0, y: 0, width: starWidth * CGFloat(selectNumberOfStar), height: self.bounds.size.height)
        self.addSubview(self.backgroundView)
        self.addSubview(self.foreView)
        setTap()
    }
    
    fileprivate func setTap() {
        if isSupportTap {
            let tap = UITapGestureRecognizer(target: self, action: #selector(ScoreView.tapStar(sender:)))
            self.addGestureRecognizer(tap)
        }
    }
    
    fileprivate func creatStarView(image:UIImage) -> UIView {
        
        let view =  UIView(frame:self.bounds)
        view.clipsToBounds = true
        view.backgroundColor = UIColor.clear
        
        for i in 0...numberOfStar {
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x:CGFloat(i) * starWidth, y: 0, width: starWidth, height: self.bounds.size.height)
            imageView.contentMode = .scaleAspectFit
            view.addSubview(imageView)
        }
        
        return view
    }
    
    func clearAll(){
        
        for view in self.subviews{
            view.removeFromSuperview()
        }
        
        if let taps = self.gestureRecognizers {
            for tap in taps{
                self.removeGestureRecognizer(tap)
            }
        }
        
    }
}

extension ScoreView{
    
    @objc func tapStar(sender:UITapGestureRecognizer){
        let  tapPoint = sender.location(in: self)
        let  offset   = tapPoint.x
        let  selctCount = offset/starWidth
        switch selectStarUnit {
        case .all:
            selectNumberOfStar = ceilf(Float(selctCount))
            break
        case .half:
            selectNumberOfStar = roundf(Float(selctCount)) > Float(selctCount) ? ceilf(Float(selctCount)) :  ceilf(Float(selctCount)) - 0.5
            break
        default:
            selectNumberOfStar = Float(selctCount)
            break
        }
    }
}

