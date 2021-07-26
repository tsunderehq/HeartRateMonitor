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
    
    func makeUIView(context: Context) -> LineChartView {
        chart.noDataText = "No Data Available"
        return chart
    }
    
    func updateUIView(_ uiView: LineChartView, context: Context) {
        let chartDataEntries: [ChartDataEntry] = self.viewModel.messages.map {
            return ChartDataEntry(x: $0["time"] ?? 0,
                                  y: $0["heartRate"] ?? 0)
        }
        let set = LineChartDataSet(entries: chartDataEntries)
        set.colors = ChartColorTemplates.material()
        let data = LineChartData(dataSet: set)
        data.setValueFont(.systemFont(ofSize: 7, weight: .light))
        chart.data = data
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
