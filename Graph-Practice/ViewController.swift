//
//  ViewController.swift
//  Graph-Practice
//
//  Created by 大西玲音 on 2021/09/03.
//

import UIKit
import ScrollableGraphView

final class ViewController: UIViewController {
    
    private var linePlotData = [Int](1...100).shuffled().map { Double($0) }
    private var linePlotData2 = [Int](1...100).shuffled().map { Double($0) }
    private var linePlotData3 = [Int](1...100).shuffled().map { Double($0) }
    private var linePlotData4 = [Int](1...100).shuffled().map { Double($0) }
    private var linePlotData5 = [Int](1...100).shuffled().map { Double($0) }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.3)
        
        let frame = CGRect(x: 0,
                           y: 100,
                           width: self.view.frame.width,
                           height: self.view.frame.height - 200)
        let graphView = ScrollableGraphView(frame: frame, dataSource: self)
        graphView.rangeMin = linePlotData.min() ?? 0
        graphView.rangeMax = linePlotData.max() ?? 0
        graphView.backgroundFillColor = .clear
        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = true
        graphView.topMargin = 50
        graphView.dataPointSpacing = 50
        graphView.bottomMargin = 20
        
        let linePlot = createLine(color: .systemRed, identifier: "plotIdentifier")
        let dotPlot = createDot(color: .systemRed, identifier: "plotIdentifier")
        let linePlot2 = createLine(color: .systemBlue, identifier: "plotIdentifier2")
        let dotPlot2 = createDot(color: .systemBlue, identifier: "plotIdentifier2")
        
        let referenceLines = ReferenceLines()
        referenceLines.referenceLineLabelFont = .boldSystemFont(ofSize: 15)
        referenceLines.dataPointLabelFont = .boldSystemFont(ofSize: 15)
        referenceLines.referenceLineColor = .black
        referenceLines.dataPointLabelTopMargin = 30
        referenceLines.positionType = .absolute
        referenceLines.includeMinMax = false
        referenceLines.absolutePositions = [Int](0...100).filter { $0 % 10 == 0 }.map { Double($0) }
        
        graphView.addReferenceLines(referenceLines: referenceLines)
        graphView.addPlot(plot: linePlot)
        graphView.addPlot(plot: linePlot2)
        graphView.addPlot(plot: dotPlot)
        graphView.addPlot(plot: dotPlot2)
        
        self.view.addSubview(graphView)
        
    }
    
    private func createLine(color: UIColor, identifier: String) -> LinePlot {
        let linePlot = LinePlot(identifier: identifier)
        linePlot.lineColor = color
        linePlot.adaptAnimationType = .easeOut
        linePlot.animationDuration = 0.2
        return linePlot
    }
    
    private func createDot(color: UIColor, identifier: String) -> DotPlot {
        let dotPlot = DotPlot(identifier: identifier)
        dotPlot.dataPointType = .circle
        dotPlot.dataPointSize = 5
        dotPlot.dataPointFillColor = color
        dotPlot.adaptAnimationType = .easeOut
        dotPlot.animationDuration = 0.2
        return dotPlot
    }

}

extension ViewController: ScrollableGraphViewDataSource {
    
    func value(forPlot plot: Plot,
               atIndex pointIndex: Int) -> Double {
        switch plot.identifier {
            case "plotIdentifier":
                return linePlotData[pointIndex]
            case "plotIdentifier2":
                return linePlotData2[pointIndex]
            default:
                return 0.0
        }
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return "\(pointIndex)"
    }
    
    func numberOfPoints() -> Int {
        return linePlotData.count
    }
    
}
