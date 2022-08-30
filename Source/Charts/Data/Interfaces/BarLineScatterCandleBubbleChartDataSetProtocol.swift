//
//  BarLineScatterCandleBubbleChartDataSetProtocol.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import CoreGraphics

@objc
public protocol BarLineScatterCandleBubbleChartDataSetProtocol: ChartDataSetProtocol
{
    // MARK: - Data functions and accessors
    
    // MARK: - Styling functions and accessors
    
    var highlightColor: NSUIColor { get set }
    var highlightHappening: NSUIColor { get set }
    var highlightIncoming: NSUIColor { get set }
    var highlightCancelled: NSUIColor { get set }
    var highlightLineWidth: CGFloat { get set }
    var highlightLineDashPhase: CGFloat { get set }
    var highlightLineDashLengths: [CGFloat]? { get set }
}
