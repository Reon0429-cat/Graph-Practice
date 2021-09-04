//
//  ViewController.swift
//  Graph-Practice
//
//  Created by 大西玲音 on 2021/09/03.
//

import UIKit
import ScrollableGraphView

final class ViewController: UIViewController {
    
    private let lines: [(color: UIColor, identifier: String, data: [Double])] = [
        (color: .red, identifier: "id1", data: [Int](1...100).shuffled().map { Double($0) }),
        (color: .blue, identifier: "id2", data: [Int](1...100).shuffled().map { Double($0) }),
        (color: .green, identifier: "id3", data: [Int](1...100).shuffled().map { Double($0) }),
        (color: .purple, identifier: "id4", data: [Int](1...100).shuffled().map { Double($0) }),
        (color: .yellow, identifier: "id5", data: [Int](1...100).shuffled().map { Double($0) }),
    ]
    
    private var graphView: ScrollableGraphView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createGraphView()
        lines.forEach { createLineDot(color: $0.color,
                                      identifier: $0.identifier) }
        createReferenceLines()
        self.view.addSubview(graphView)
        
    }
    
    private func createGraphView() {
        let frame = CGRect(x: 0,
                           y: 200,
                           width: self.view.frame.width,
                           height: self.view.frame.height - 400)
        graphView = ScrollableGraphView(frame: frame, dataSource: self)
        graphView.rangeMin = lines[0].data.min() ?? 0
        graphView.rangeMax = lines[0].data.max() ?? 0
        graphView.backgroundFillColor = .clear
        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = true
        graphView.topMargin = 50
        graphView.dataPointSpacing = 50
        graphView.bottomMargin = 20
    }
    
    private func createReferenceLines() {
        let referenceLines = ReferenceLines()
        referenceLines.referenceLineLabelFont = .boldSystemFont(ofSize: 15)
        referenceLines.dataPointLabelFont = .boldSystemFont(ofSize: 15)
        referenceLines.referenceLineColor = .black
        referenceLines.dataPointLabelTopMargin = 30
        referenceLines.positionType = .absolute
        referenceLines.includeMinMax = false
        referenceLines.absolutePositions = [Int](0...100).filter { $0 % 10 == 0 }.map { Double($0) }
        graphView.addReferenceLines(referenceLines: referenceLines)
    }
    
    private func createLineDot(color: UIColor, identifier: String) {
        let linePlot = createLine(color: color, identifier: identifier)
        let dotPlot = createDot(color: color, identifier: identifier)
        graphView.addPlot(plot: linePlot)
        graphView.addPlot(plot: dotPlot)
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
        for line in lines {
            if plot.identifier == line.identifier {
                return line.data[pointIndex]
            }
        }
        return 0.0
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return "\(pointIndex)"
    }
    
    func numberOfPoints() -> Int {
        return lines[0].data.count
    }
    
}
