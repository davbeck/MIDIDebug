//
//  ContentView.swift
//  MIDIDebug
//
//  Created by David Beck on 8/2/20.
//  Copyright © 2020 David Beck. All rights reserved.
//

import SwiftUI
import CoreMIDI
import Combine
import MIDIKit

class MIDIController: ObservableObject {
	static let shared = MIDIController()
	
	var observers: Set<AnyCancellable> = []
	
	@Published private var connectedEndpoints: Set<MIDIEndpoint> = [] {
		didSet {
			UserDefaults.standard.set(connectedEndpoints.compactMap { try? $0.uniqueID() }, forKey: "MIDIController.connectedEndpoints")
		}
	}
	
	subscript(connected endpoint: MIDIEndpoint) -> Bool {
		get {
			connectedEndpoints.contains(endpoint)
		}
		set(newValue) {
			if newValue {
				connectedEndpoints.insert(endpoint)
			} else {
				connectedEndpoints.remove(endpoint)
			}
		}
	}
	
	@Published var receivedPackets: [MIDIPacket] = []
	
	let client: MIDIClient
	let outputPort: MIDIOutputPort
	let inputPort: MIDIInputPort
	
	init() {
		self.client = try! MIDIClient(name: "MIDIDebug")
		self.outputPort = try! MIDIOutputPort(client: self.client, name: "MIDIDebug Output Port")
		self.inputPort = try! MIDIInputPort(client: self.client, name: "MIDIDebug Input Port")
		
		if let connectedEndpoints = UserDefaults.standard.array(forKey: "MIDIController.connectedEndpoints") as? [Int32] {
			self.connectedEndpoints = Set(connectedEndpoints.compactMap { try? MIDIEndpoint(uniqueID: $0) })
		} else {
			self.connectedEndpoints = Set(MIDIEndpoint.allSources + MIDIEndpoint.allDestinations)
		}
		
		inputPort.packetRecieved
			.receive(on: RunLoop.main)
			.sink { packet in
				self.receivedPackets.append(packet)
			}
			.store(in: &observers)
	}
	
	func connect() {
		for endpoint in MIDIEndpoint.allSources {
			guard connectedEndpoints.contains(endpoint) else { continue }
			print("connecting to", endpoint)
			
			try! inputPort.connect(source: endpoint)
		}
	}
	
	func send(status: MIDIStatus, channel: UInt8, note: UInt8, intensity: UInt8) {
		let packet = MIDIPacket(timeStamp: 0, bytes: [
			status.rawValue | channel,
			note,
			intensity
		])
		
		for endpoint in MIDIEndpoint.allDestinations {
			guard connectedEndpoints.contains(endpoint) else { continue }
			
			try! outputPort.send(packet, to: endpoint)
		}
	}
}

struct ContentView: View {
	@ObservedObject var controller = MIDIController.shared
	@State var isOn: Bool = true
	
	var body: some View {
		HSplitView {
			EndpointList()
			.frame(minWidth: 200, maxWidth: .infinity, maxHeight: .infinity)
			
			PacketListView()
				.frame(minWidth: 300, maxWidth: .infinity, maxHeight: .infinity)
		}
		.onAppear {
			controller.connect()
		}
		.environmentObject(controller)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
