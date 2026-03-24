//
//  ContentView.swift
//  CoreImageExample7Exposure
//
//  Created by Quanpeng Yang on 3/23/26.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var originalImage = UIImage(named: "forest") ?? UIImage(systemName: "sun.max.fill")!
    @State private var filteredImage: UIImage?
    
    // EV (Exposure Value) - typically -10.0 to 10.0
    // 0.0 is the original image. Each +1.0 doubles the light.
    @State private var ev: Float = 0.0
    
    let context = CIContext()

    var body: some View {
        VStack(spacing: 25) {
            Text("Exposure Adjustment")
                .font(.headline)

            Image(uiImage: filteredImage ?? originalImage)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 350)
                .cornerRadius(15)
                .shadow(radius: 5)

            VStack(alignment: .leading) {
                HStack {
                    Text("Exposure (EV):")
                    Spacer()
                    Text(String(format: "%.2f", ev))
                        .monospacedDigit()
                        .bold()
                }
                
                Slider(value: $ev, in: -4.0...4.0)
                    .tint(.orange)
                    .onChange(of: ev) { applyExposure() }
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(12)

            Spacer()
        }
        .padding()
        .onAppear { applyExposure() }
    }

    func applyExposure() {
        let filter = CIFilter.exposureAdjust()
        guard let inputCIImage = CIImage(image: originalImage) else { return }
        
        filter.inputImage = inputCIImage
        filter.ev = ev // Set the Exposure Value
        
        if let outputImage = filter.outputImage {
            // Exposure adjustment doesn't change the image boundary
            if let cgImage = context.createCGImage(outputImage, from: inputCIImage.extent) {
                filteredImage = UIImage(cgImage: cgImage)
            }
        }
    }
}
