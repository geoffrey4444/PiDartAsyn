//
//  ContentView.swift
//  Shared
//
//  Created by Geoffrey Lovelace on 5/17/22.
//

import SwiftUI

struct ContentView: View {
    @State var hits: Int = 0
    @State var thrown: Int = 0
    @State var toThrow: Int = 1
    @State var toBeThrown: Int = 0
    func throwBatchOfDarts(batch_to_throw: Int) async -> Int {
        var batch_thrown = 0
        var batch_hits = 0
        while batch_thrown < batch_to_throw {
            let x = Double.random(in: 0...1)
            let y = Double.random(in: 0...1)
            if (x * x + y * y < 1.0) {
                batch_hits += 1
            }
            batch_thrown += 1
        }
        return batch_hits
    }

    func throwDarts() async {
        let to_be_thrown_this_batch = Int(pow(Double(10), Double(toThrow)))
        toBeThrown += to_be_thrown_this_batch
        let batch_hits = await throwBatchOfDarts(batch_to_throw: to_be_thrown_this_batch)
        hits += batch_hits
        thrown += to_be_thrown_this_batch
    }
    var body: some View {
        VStack {
            Text("\(hits) hits")
            Text("\(thrown) throws")
            Text("π ≈ \(thrown == 0 ? 0 : 4.0 * (Double(hits) / Double(thrown)))")
                .padding()
            Stepper(value: $toThrow, in: 1...10) {
                Text("Next: 1e\(toThrow)")
            }
            Button("Throw darts") {
                Task {
                    await throwDarts()
                }
            }
            ProgressView(value: toBeThrown == 0 ? 0.0 : Double(thrown)/Double(toBeThrown)).padding()
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
