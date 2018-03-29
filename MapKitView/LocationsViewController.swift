import UIKit
import CoreData

class LocationsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var MyTableView: UITableView!
    var titleArr = [String]()
    var subtitleArr = [String]()
    var lonArr = [Double]()
    var latArr = [Double]()
    
    var chosentitle = ""
    var chosensubtitle = ""
    var chosenlon:Double=0
    var chosenlat:Double=0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MyTableView.delegate = self
        MyTableView.dataSource = self
        FetchFromCoreData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        FetchFromCoreData()
    }
    
    func FetchFromCoreData (){
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Locations")
        request.returnsObjectsAsFaults = false
        do{
        let results = try Context.fetch(request)
            if results.count > 0 {
                self.titleArr.removeAll(keepingCapacity: false)
                self.subtitleArr.removeAll(keepingCapacity: false)
                self.latArr.removeAll(keepingCapacity: false)
                self.lonArr.removeAll(keepingCapacity: false)
                for result in results  as! [NSManagedObject] {
                    if let title = result.value(forKey: "title") as? String{
                        self.titleArr.append(title)
                    }
                    if let subtitle = result.value(forKey: "subtitle") as? String{
                        self.subtitleArr.append(subtitle)
                    }
                    if let long = result.value(forKey: "lon") as? Double{
                        self.lonArr.append(long)
                    }
                    if let lat = result.value(forKey: "lat") as? Double{
                        self.latArr.append(lat)
                    }
                }
            }else {
                print("Empty Array")
            }
        }catch{
            print("Error")
        }
        self.MyTableView.reloadData()
    }
    
    
    @IBAction func GoToVC(_ sender: Any) {
        performSegue(withIdentifier: "Go", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subtitleArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = titleArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenlat = latArr[indexPath.row]
        chosenlon = lonArr[indexPath.row]
        chosentitle = titleArr[indexPath.row]
        chosensubtitle = subtitleArr[indexPath.row]
        performSegue(withIdentifier: "Go", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Go" {
            let destination = segue.destination as! ViewController
            destination.transmittedlat = chosenlat
            destination.transmittedlon = chosenlon
            destination.transmittedtitle = chosentitle
            destination.transmittedsubtitle = chosensubtitle
        }
    }
}
