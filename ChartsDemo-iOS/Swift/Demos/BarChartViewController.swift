//
//  BarChartViewController.swift
//  ChartsDemo-iOS
//
//  Created by Jacob Christie on 2017-07-09.
//  Copyright © 2017 jc. All rights reserved.
//

#if canImport(UIKit)
    import UIKit
#endif
import Charts
#if canImport(UIKit)
    import UIKit
#endif

class BarChartViewController: DemoBaseViewController {
    
    @IBOutlet var chartView: BarChartView!
    @IBOutlet var sliderX: UISlider!
    @IBOutlet var sliderY: UISlider!
    @IBOutlet var sliderTextX: UITextField!
    @IBOutlet var sliderTextY: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Bar Chart"
        
        self.options = [.toggleValues,
                        .toggleHighlight,
                        .animateX,
                        .animateY,
                        .animateXY,
                        .saveToGallery,
                        .togglePinchZoom,
                        .toggleData,
                        .toggleBarBorders]
        
        self.setup(barLineChartView: chartView)
        
        chartView.delegate = self
        
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = false
        
        chartView.maxVisibleCount = 60
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.labelSelectedTextColor = .red
        xAxis.granularity = 1
        xAxis.labelCount = 7
//        xAxis.valueFormatter = DayAxisValueFormatter(chart: chartView)
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.negativeSuffix = " $"
        leftAxisFormatter.positiveSuffix = " $"
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelCount = 8
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinimum = 0 // FIXME: HUH?? this replaces startAtZero = YES
        
        let rightAxis = chartView.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.labelCount = 8
        rightAxis.valueFormatter = leftAxis.valueFormatter
        rightAxis.spaceTop = 0.15
        rightAxis.axisMinimum = 0
        
        let l = chartView.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .circle
        l.formSize = 9
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4
//        chartView.legend = l

        let marker = XYMarkerView(color: UIColor(white: 180/250, alpha: 1),
                                  font: .systemFont(ofSize: 12),
                                  textColor: .white,
                                  insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8),
                                  xAxisValueFormatter: chartView.xAxis.valueFormatter!)
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartView.marker = marker
        
//        chartView.scrollToValueBar(point: .init(x: 5, y: 8), after: 0.3)
        
        sliderX.value = 12
        sliderY.value = 50
        slidersValueChanged(nil)
    }
    
    override func updateChartData() {
        if self.shouldHideData {
            chartView.data = nil
            return
        }
        
//        self.setDataCount(Int(sliderX.value) + 1, range: UInt32(sliderY.value))
        setData()
    }
    
    let yValue: [BarChartDataEntry] = [
//        BarChartDataEntry(x: 0, y: 4, date: "31/05"),
        BarChartDataEntry(x: 1, y: 0, data: BarChartDisplayType.base, date: "01/06"),
        BarChartDataEntry(x: 2, y: 6.5, data: BarChartDisplayType.base, date: "02/06"),
        BarChartDataEntry(x: 3, y: 1, data: BarChartDisplayType.happening, date: "03/06"),
        BarChartDataEntry(x: 4, y: 1, data: BarChartDisplayType.base, date: "04/06"),
        BarChartDataEntry(x: 5, y: 8, data: BarChartDisplayType.base, date: "05/06"),
        BarChartDataEntry(x: 6, y: 1, data: BarChartDisplayType.rating, date: "06/06"),
        BarChartDataEntry(x: 7, y: 1, data: BarChartDisplayType.incoming, date: "07/06"),
        BarChartDataEntry(x: 8, y: 3, data: BarChartDisplayType.base, date: "08/06"),
        BarChartDataEntry(x: 9, y: 1, data: BarChartDisplayType.cancelled,date: "09/06"),
        BarChartDataEntry(x: 10, y: 4, data: BarChartDisplayType.base, date: "10/06"),
    ]
    
    func setData() {
        let set = BarChartDataSet.init(entries: yValue, label: "Diem")
        //set mau khi chon bar
        
        let colors = yValue.map { entry -> UIColor in
            if let type = entry.data as? BarChartDisplayType {
                switch type {
                case .base:
                    return .init(hexString: "#F1DAFF")
                case .rating:
                    return .init(hexString: "#F1DAFF")
                case .happening:
                    return .init(hexString: "#AAF1C6")
                case .incoming:
                    return .init(hexString: "#A3DAFF")
                case .cancelled:
                    return .init(hexString: "#DCDCDC")
                }
            }
            return .clear
        }
        
        set.highlightColor = .systemPink
        set.highlightIncoming = .blue
        set.highlightCancelled = .gray
        set.highlightHappening = .green
//        set.colors = [.systemPurple, .blue, .red, .green, .yellow, .red, .brown, .yellow, .orange, .clear]
        set.colors = colors
        set.valueFont = UIFont.systemFont(ofSize: 12, weight: .semibold)
        set.ratingFont = UIFont.systemFont(ofSize: 9, weight: .semibold)
        set.valueTextColor = .init(hexString: "#5B2E89")
        set.ratingText = "alo"
        set.ratingTextColor = .red
        let data = BarChartData(dataSet: set)
        //width cua 1 bar
        data.barWidth = 0.72
        
        chartView.data = data
    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        let start = 1
        
        let yVals = (start..<start+count+1).map { (i) -> BarChartDataEntry in
            let mult = range + 1
            let val = Double(arc4random_uniform(mult))
            if arc4random_uniform(100) < 25 {
                return BarChartDataEntry(x: Double(i), y: val, icon: UIImage(named: "icon"))
            } else {
                return BarChartDataEntry(x: Double(i), y: val)
            }
        }
        
        var set1: BarChartDataSet! = nil
        if let set = chartView.data?.first as? BarChartDataSet {
            set1 = set
            set1.replaceEntries(yVals)
            chartView.data?.notifyDataChanged()
            chartView.notifyDataSetChanged()
        } else {
            set1 = BarChartDataSet(entries: yVals, label: "The year 2017")
            set1.colors = ChartColorTemplates.material()
            set1.drawValuesEnabled = false
            
            let data = BarChartData(dataSet: set1)
            data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
            data.barWidth = 0.9
            chartView.data = data
        }
        
//        chartView.setNeedsDisplay()
    }
    
    override func optionTapped(_ option: Option) {
        super.handleOption(option, forChartView: chartView)
    }
    
    // MARK: - Actions
    @IBAction func slidersValueChanged(_ sender: Any?) {
        sliderTextX.text = "\(Int(sliderX.value + 2))"
        sliderTextY.text = "\(Int(sliderY.value))"
        
        self.updateChartData()
    }
    
    override func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
//        chartValueNothingSelected(chartView)
//        chartView.indexSelected = Int(entry.x)
//        chartView.isSelecting = (chartView.indexSelected, true)
//        chartView.xAxis.isSelecting = (chartView.indexSelected, true)
        print("selected index \(chartView.indexSelected) \(entry.data)")
    }
    
    override func chartValueNothingSelected(_ chartView: ChartViewBase) {
//        chartView.isSelecting = (chartView.indexSelected, false)
//        chartView.xAxis.isSelecting = (chartView.indexSelected, false)
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
