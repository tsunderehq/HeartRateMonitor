//
//  ChartView.swift
//  HeartRateMonitor
//
//  Created by Hiroya Kawase on 2021/07/23.
//

import SwiftUI
#if os(iOS)
import Charts
#endif

struct ChartView: View {
    var body: some View {
        LineChart()
    }
}

struct LineChart : UIViewRepresentable {
    @EnvironmentObject var viewModel: ViewModel
    private let chart = LineChartView()
    private let dataSet = LineChartDataSet()
    
    func makeUIView(context: Context) -> LineChartView {
        chart.noDataText = "No Data Available"
        chart.xAxis.drawAxisLineEnabled = false
        chart.xAxis.valueFormatter = ElapsedTimeAxisValueFormatter()
        chart.xAxis.granularityEnabled = true
        chart.xAxis.granularity = 1.0
        chart.rightAxis.enabled = false
        chart.leftAxis.drawAxisLineEnabled = false
        chart.leftAxis.granularityEnabled = true
        chart.leftAxis.granularity = 1.0
        chart.legend.enabled = false

        dataSet.circleRadius = 3.0
        dataSet.circleColors = [UIColor.red]
        dataSet.lineWidth = 2.0
        dataSet.colors = [UIColor.red.withAlphaComponent(0.6)]
        dataSet.highlightEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.mode = .cubicBezier
        dataSet.drawFilledEnabled = true
        
        return chart
    }
    
    func updateUIView(_ uiView: LineChartView, context: Context) {
        if self.viewModel.messages.count != 0 {
            let chartDataEntry = ChartDataEntry(x: (self.viewModel.messages.last!["time"] ?? 0) / 1000,
                                                y: self.viewModel.messages.last!["heartRate"] ?? 0)
            dataSet.append(chartDataEntry)
            chart.data = LineChartData(dataSet: dataSet)
            chart.animate(xAxisDuration: CATransaction.animationDuration(), easingOption: .linear)
        }
    }
    
    static func dismantleUIView(_ uiView: LineChartView, coordinator: Coordinator) {}
}

class ElapsedTimeAxisValueFormatter: AxisValueFormatter {
    let componentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    func stringForValue(_ time: TimeInterval, axis: AxisBase?) -> String {
        let formattedString = componentsFormatter.string(from: time)!
        return formattedString
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
            .environmentObject(ViewModel())
    }
}
