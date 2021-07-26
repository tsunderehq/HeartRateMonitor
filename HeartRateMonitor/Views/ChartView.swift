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

struct LineChart : UIViewRepresentable {
    @EnvironmentObject var viewModel: ViewModel
    private let chart = LineChartView()
    private let dataSet = LineChartDataSet()
    
    
    func makeUIView(context: Context) -> LineChartView {
        // chart settings
        chart.noDataText = "No Data Available"
        chart.xAxis.drawAxisLineEnabled = false
        chart.rightAxis.enabled = false
        chart.leftAxis.drawAxisLineEnabled = false
        chart.leftAxis.granularityEnabled = true
        chart.leftAxis.granularity = 1.0
        chart.legend.enabled = false
        
        dataSet.circleRadius = 2.0
        dataSet.drawValuesEnabled = false
        dataSet.mode = .cubicBezier
        
        return chart
    }
    
    func updateUIView(_ uiView: LineChartView, context: Context) {
        if self.viewModel.messages.count != 0 {
            let chartDataEntry = ChartDataEntry(x: (self.viewModel.messages.last!["time"] ?? 0),
                                                y: self.viewModel.messages.last!["heartRate"] ?? 0)
            dataSet.append(chartDataEntry)
            chart.data = LineChartData(dataSet: dataSet)
            chart.animate(xAxisDuration: CATransaction.animationDuration(), easingOption: .linear)
        }
    }
    
    static func dismantleUIView(_ uiView: LineChartView, coordinator: Coordinator) {}
}

struct ChartView: View {
    var body: some View {
        LineChart()
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
            .environmentObject(ViewModel())
    }
}
