import UIKit
import GPUImage

class ViewController: UIViewController {
    
    @IBOutlet weak var renderView: RenderView!
    var camera:Camera!
    var operation:BrightnessAdjustment!
    var filter: ImageProcessingOperation!
    @IBOutlet weak var flowlayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let array = ["Filter1", "Filter2", "Filter3", "Filter4", "Filter5"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.filter = BrightnessAdjustment()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        let nib = UINib(nibName: String(describing: CellCustom.self), bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: String(describing: CellCustom.self))
        
        // Do any additional setup after loading the view, typically from a nib.
        do {
            //            operation = BasicOperation(fragmentFunctionName: "passthroughFragment")
            
            camera = try Camera(sessionPreset: .vga640x480)
            camera.runBenchmark = true
            camera --> renderView
            camera.startCapture()
        } catch {
            fatalError("Could not initialize rendering pipeline: \(error)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dobright(_ sender: Any) {
        self.filter.removeAllTargets()
        self.filter = BrightnessAdjustment()
        self.camera.stopCapture()
        camera.removeAllTargets()
        camera.addTarget(self.filter)
        self.filter.addTarget(self.renderView)
        self.camera.startCapture()
        
        
    }
    
    @IBAction func doFilter2(_ sender: Any) {
        self.filter.removeAllTargets()
        self.filter = SwirlDistortion()
        self.camera.stopCapture()
        camera.removeAllTargets()
        camera.addTarget(self.filter)
        self.filter.addTarget(self.renderView)
        self.camera.startCapture()
    }
    
    @IBAction func doFilter3(_ sender: Any) {
        self.filter.removeAllTargets()
        self.filter = SketchFilter()
        self.camera.stopCapture()
        camera.removeAllTargets()
        camera.addTarget(self.filter)
        self.filter.addTarget(self.renderView)
        self.camera.startCapture()
    }
    
    @IBAction func doFilter4(_ sender: Any) {
        if let filter = self.filter as? BrightnessAdjustment {
            
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        //        guard let slider = sender as? UISlider else { return }
        //        operation.brightness = slider.value
    }
    
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CellCustom.self), for: indexPath) as! CellCustom
        cell.label.text = self.array[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 70, height: collectionView.bounds.size.height - 5)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.filter.removeAllTargets()
        
        self.camera.stopCapture()
        camera.removeAllTargets()
        
        
        if indexPath.row == 0 {
            self.filter = SwirlDistortion()
        }
        
        if indexPath.row == 1 {
            self.filter = SketchFilter()
        }
        if indexPath.row == 2 {
            self.filter = PolkaDot()
            
        }
        if indexPath.row == 3 {
            self.filter = Pixellate()
        }
        if indexPath.row == 4 {
            self.filter = SepiaToneFilter()
        }
        
        
        camera.addTarget(self.filter)
        self.filter.addTarget(self.renderView)
        self.camera.startCapture()
        
    }
    
    
}
