//
//  DetailViewController.swift
//  DANA
//
//  Created by Littman Library on 3/15/22.
//

import UIKit

class DetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var tableView: UITableView!
    var timer = Timer()
    var counter = 0
    var architect = Architects_Firms()
    var building = Buildings()
    var publicart = PublicArts()
    var publicspace = PublicSpaces()
    var mapLoctn = GeoLocations()
    var locationdetailmodel = GeoLocationViewModel()
    var type = ""
    var arrays = [Dict]()
    var imageArray = [ImageModel]()
    var detailDict: [String:String] = [:]
    struct Dict {
        let key: String
        let Value: String
    }
    @IBOutlet weak var scrollingView: UIScrollView!
    @IBOutlet weak var detailimageView: UIImageView!
    var frame = CGRect.zero
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        pageControl.numberOfPages = 0
        pageControl.pageIndicatorTintColor = UIColor.red
        if self.traitCollection.userInterfaceStyle == .dark{
            pageControl.currentPageIndicatorTintColor = UIColor.white
        }else{
            pageControl.currentPageIndicatorTintColor = UIColor.black
        }
        
        scrollingView.delegate = self
        self.navigationController?.navigationBar.backItem?.backBarButtonItem?.title = ""
        if danaHelper.checkNetworkConnection(){
            setImageforMap()
        }else{
            self.danaNetworkAlert()
        }
        setUI()
    }

   
        func setUI(){
            switch type{
            case textConstants.architectViewTitle:
                if let title = architect.title{
                    let dict = Dict(key:"Title" , Value:title )
                    arrays.append(dict)
                    
                }
                if let subject = architect.subject{
                    let dict = Dict(key:"Subject" , Value:subject )
                    arrays.append(dict)
                }
                if let occupation = architect.occupation{
                    let dict = Dict(key:"Occupation" , Value:occupation )
                    arrays.append(dict)
                }
                if let description = architect.descriptions{
                    let dict = Dict(key:"Description" , Value:description )
                    arrays.append(dict)
                }
                if let biography = architect.biography{
                    let dict = Dict(key:"Biography" , Value:biography )
                    arrays.append(dict)
                }
                if let bibliography = architect.bibilography{
                    let dict = Dict(key:"Bibliography" , Value:bibliography )
                    arrays.append(dict)
                }
                
            case textConstants.buildingsTitle:
                if let title = building.title{
                    let dict = Dict(key:"Title" , Value:title )
                    arrays.append(dict)
                    
                }
                if let subject = building.subject{
                    let dict = Dict(key:"Subject" , Value:subject )
                    arrays.append(dict)
                }
                if let state = building.state{
                    let dict = Dict(key:"State" , Value:state )
                    arrays.append(dict)
                }
                if let condition = building.condition{
                    let dict = Dict(key:"Condition" , Value:condition )
                    arrays.append(dict)
                }
                if let descriptions = building.descriptions{
                    let dict = Dict(key:"Description" , Value:descriptions )
                    arrays.append(dict)
                }
                if let bibliography = building.bibliography{
                    let dict = Dict(key:"Bibliography" , Value:bibliography )
                    arrays.append(dict)
                }
                
            case textConstants.publicartTitle:
                if let title = publicart.title{
                    let dict = Dict(key:"Title" , Value:title )
                    arrays.append(dict)
                    
                }
                if let subject = publicart.subject{
                    let dict = Dict(key:"Subject" , Value:subject )
                    arrays.append(dict)
                }
                if let state = publicart.state{
                    let dict = Dict(key:"State" , Value:state )
                    arrays.append(dict)
                }
                if let creator = publicart.creator{
                    let dict = Dict(key:"Creator" , Value:creator )
                    arrays.append(dict)
                }
                if let descriptions = publicart.descriptions{
                    let dict = Dict(key:"Description" , Value:descriptions )
                    arrays.append(dict)
                }
                if let bibliography = publicart.bibliography{
                    let dict = Dict(key:"Bibliography" , Value:bibliography )
                    arrays.append(dict)
                }
            case textConstants.publicspaceTitle:
                if let title = publicspace.title{
                    let dict = Dict(key:"Title" , Value:title )
                    arrays.append(dict)
                    
                }
                if let subject = publicspace.subject{
                    let dict = Dict(key:"Subject" , Value:subject )
                    arrays.append(dict)
                }
                if let state = publicspace.state{
                    let dict = Dict(key:"State" , Value:state )
                    arrays.append(dict)
                }
                if let condition = publicspace.condition{
                    let dict = Dict(key:"Condition" , Value:condition )
                    arrays.append(dict)
                }
                if let description = publicspace.descriptions{
                    let dict = Dict(key:"Description" , Value:description )
                    arrays.append(dict)
                }
                if let bibliography = publicspace.bibliography{
                    let dict = Dict(key:"Bibliography" , Value:bibliography )
                    arrays.append(dict)
                }
            case textConstants.mapViewTitle:
                if let title = mapLoctn.title{
                    let dict = Dict(key:"Title" , Value:title )
                    arrays.append(dict)
                    
                }
                if let address = mapLoctn.address{
                    let dict = Dict(key:"Address" , Value:address)
                    arrays.append(dict)
                }
                if let description = mapLoctn.mapdescription{
                    let dict = Dict(key:"Description" , Value:description)
                    arrays.append(dict)
                }
                if let state = mapLoctn.state{
                    let dict = Dict(key:"State" , Value:state)
                    arrays.append(dict)
                }
                if let conditionhistory = mapLoctn.conditionhistory{
                    let dict = Dict(key:"Condition History" , Value:conditionhistory)
                    arrays.append(dict)
                }
                if let style = mapLoctn.style{
                    let dict = Dict(key:"Style" , Value:style)
                    arrays.append(dict)
                }
                if let bibliography = mapLoctn.bibliography{
                    let dict = Dict(key:"Bibliography" , Value:bibliography )
                    arrays.append(dict)
                }

            default:
                print("no items")
            }
            
            
        }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let backBarBtnItem = UIBarButtonItem()
        backBarBtnItem.title = type
        navigationController?.navigationBar.backItem?.backBarButtonItem = backBarBtnItem
    }
    
        func setImageforMap() {
            let indicatorView = danaHelper.activityIndicator(style: .large,
                                                             center: self.view.center)
            indicatorView.style = UIActivityIndicatorView.Style.large
            indicatorView.color = .red
            DispatchQueue.main.async {
                self.view.addSubview(indicatorView)
                indicatorView.startAnimating()
            }
            detailimageView.contentMode = UIView.ContentMode.scaleToFill
           
            switch type{
            case textConstants.mapViewTitle:
                if mapLoctn.fileurl != nil {
                    fetchImagesofselecteditem(mapLoctn.fileurl!) { [self]_imgArray in
                        if _imgArray.count > 0
                        {
                            imageArray = _imgArray
                            setupScreens()
                            indicatorView.stopAnimating()
                        }else{
                            self.detailimageView.image = UIImage(named:textConstants.placeholderImage)
                            pageControl.numberOfPages = 0
                            indicatorView.stopAnimating()
                        }
                    }
                }
                case textConstants.architectViewTitle:
                    if architect.fileUrl != nil {
                        fetchImagesofselecteditem(architect.fileUrl!) { [self]_imgArray in
                            if _imgArray.count > 0
                            {
                                imageArray = _imgArray
                                setupScreens()
                                indicatorView.stopAnimating()
                            }else{
                                self.detailimageView.image = UIImage(named:textConstants.placeholderImage)
                                pageControl.numberOfPages = 0
                                indicatorView.stopAnimating()
                            }
                        }
                    }
                
            case textConstants.buildingsTitle:
                if building.fileUrl != nil {
                    fetchImagesofselecteditem(building.fileUrl!) { [self]_imgArray in
                        if _imgArray.count > 0
                        {
                            imageArray = _imgArray
                            setupScreens()
                            indicatorView.stopAnimating()
                        }else{
                            self.detailimageView.image = UIImage(named:textConstants.placeholderImage)
                            pageControl.numberOfPages = 0
                            indicatorView.stopAnimating()
                        }
                    }
                }
            case textConstants.publicartTitle:
                if publicart.fileUrl != nil {
                    fetchImagesofselecteditem(publicart.fileUrl!) { [self]_imgArray in
                        if _imgArray.count > 0
                        {
                            imageArray = _imgArray
                            setupScreens()
                            indicatorView.stopAnimating()
                        }else{
                            self.detailimageView.image = UIImage(named:textConstants.placeholderImage)
                            pageControl.numberOfPages = 0
                            indicatorView.stopAnimating()
                        }
                    }
                }
            case textConstants.publicspaceTitle:
                if publicspace.fileUrl != nil {
                    fetchImagesofselecteditem(publicspace.fileUrl!) { [self]_imgArray in
                        if _imgArray.count > 0
                        {
                            imageArray = _imgArray
                            setupScreens()
                            indicatorView.stopAnimating()
                        }else{
                            self.detailimageView.image = UIImage(named:textConstants.placeholderImage)
                            pageControl.numberOfPages = 0
                            indicatorView.stopAnimating()
                        }
                    }
                }
                    default:
                        print("")
                    }
            scrollingView.delegate = self
        }

    func setupScreens() {
        self.pageControl.numberOfPages = 0
        if imageArray.count > 1{
            self.pageControl.numberOfPages = imageArray.count
            self.pageControl.currentPage = 0
        }
       
        for index in 0..<imageArray.count {
            frame.origin.x = scrollingView.frame.size.width * CGFloat(index)
            frame.size = scrollingView.frame.size
            let imgView = UIImageView(frame: frame)
            imgView.af.setImage(withURL: URL(string:imageArray[index].file_urls.fullsize)!)
            self.scrollingView.addSubview(imgView)
        }
        scrollingView.contentSize = CGSize(width: (scrollingView.frame.size.width * CGFloat(imageArray.count)), height: scrollingView.frame.size.height)
        scrollingView.delegate = self
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DANADetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: textConstants.detailCell, for: indexPath) as! DANADetailTableViewCell
        cell.detailtitleLabel.text =  arrays[indexPath.row].key
        cell.detaildescriptionLabel?.text = arrays[indexPath.row].Value
        if(arrays[indexPath.row].key == "Bibliography"){
            if(self.traitCollection.userInterfaceStyle == .dark){
                cell.detaildescriptionLabel.attributedText = arrays[indexPath.row].Value.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "HelveticaNeue", size: 18.0), csscolor: "D3D3D3", lineheight: 2, csstextalign: "justify")
            }else
            {
                cell.detaildescriptionLabel.attributedText = arrays[indexPath.row].Value.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "HelveticaNeue", size: 18.0), csscolor: "555555", lineheight: 2, csstextalign: "justify")
            }
           
        }
        cell.selectionStyle = .none
        
        return cell;
       
    }

}


extension String {
    public var convertHtmlToNSAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else {
            return nil
        }
        do {
            return try NSAttributedString(data: data,options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
    public func convertHtmlToAttributedStringWithCSS(font: UIFont? , csscolor: String , lineheight: Int, csstextalign: String) -> NSAttributedString? {
          guard let font = font else {
              return convertHtmlToNSAttributedString
          }
          let modifiedString = "<style>body{font-family: '\(font.fontName)'; font-size:\(font.pointSize)px; color: \(csscolor); line-height: \(lineheight)px; text-align: \(csstextalign); }</style>\(self)";
          guard let data = modifiedString.data(using: .utf8) else {
              return nil
          }
          do {
              return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
          }
          catch {
              print(error)
              return nil
          }
      }
  }
extension DetailViewController{
    
    func fetchImagesofselecteditem(_ endUrl: String, completionHandler: @escaping (_ imgArray:Array<ImageModel>) -> (Void)) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        locationdetailmodel.makeFetchimagesApiCall(context: context,fileUrl:endUrl) {imgArray in
       
            completionHandler(imgArray)
        }
        
    }
    func danaNetworkAlert(){
       // Create new Alert
        let dialogMessage = UIAlertController(title: "No Internet Connection", message: textConstants.danaNetworkMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
         })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
   }
}
