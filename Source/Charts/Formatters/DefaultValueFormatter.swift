//
//  DefaultValueFormatter.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation

/// The default value formatter used for all chart components that needs a default
@objc(ChartDefaultValueFormatter)
open class DefaultValueFormatter: NSObject, ValueFormatter
{
    public typealias Block = (
        _ value: Double,
        _ entry: ChartDataEntry,
        _ dataSetIndex: Int,
        _ viewPortHandler: ViewPortHandler?) -> String
    
    @objc open var block: Block?
    
    @objc open var hasAutoDecimals: Bool
    
    @objc open var formatter: NumberFormatter?
    {
        willSet
        {
            hasAutoDecimals = false
        }
    }
    
    open var decimals: Int?
    {
        didSet
        {
            setupDecimals(decimals: decimals)
        }
    }

    private func setupDecimals(decimals: Int?)
    {
        if let digits = decimals
        {
            formatter?.minimumFractionDigits = digits
            formatter?.maximumFractionDigits = digits
            formatter?.usesGroupingSeparator = true
        }
    }
    
    public override init()
    {
        formatter = NumberFormatter()
        formatter?.usesGroupingSeparator = true
        decimals = 1
        hasAutoDecimals = true

        super.init()
        setupDecimals(decimals: decimals)
    }
    
    @objc public init(formatter: NumberFormatter)
    {
        self.formatter = formatter
        hasAutoDecimals = false

        super.init()
    }
    
    @objc public init(decimals: Int)
    {
        formatter = NumberFormatter()
        formatter?.usesGroupingSeparator = true
        self.decimals = decimals
        hasAutoDecimals = true

        super.init()
        setupDecimals(decimals: decimals)
    }
    
    @objc public init(block: @escaping Block)
    {
        self.block = block
        hasAutoDecimals = false

        super.init()
    }

    /// This function is deprecated - Use `init(block:)` instead.
    // DEC 11, 2017
    @available(*, deprecated, message: "Use `init(block:)` instead.")
    @objc public static func with(block: @escaping Block) -> DefaultValueFormatter
    {
        return DefaultValueFormatter(block: block)
    }
    
    open func stringForValue(_ value: Double,
                             entry: ChartDataEntry,
                             dataSetIndex: Int,
                             viewPortHandler: ViewPortHandler?) -> String
    {
        if let block = block {
            return block(value, entry, dataSetIndex, viewPortHandler)
        } else {
            formatter?.numberStyle = .decimal
            formatter?.maximumFractionDigits = 1
            formatter?.decimalSeparator = "."
//            print(modf(value).0, modf(value).1)
            //check phan thua cua 1 so thap phan, neu phan thua lon hon 0 > hien thi double
            if modf(value).1 > 0 {
                return formatter?.string(from: NSNumber(floatLiteral: value)) ?? ""
            }
            //else hien thi int
            else {
                return "\(Int(value))"
            }
        }
    }
}
