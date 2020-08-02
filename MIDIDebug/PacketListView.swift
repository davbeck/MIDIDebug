//
//  PacketListView.swift
//  MIDIDebug
//
//  Created by David Beck on 8/3/20.
//  Copyright © 2020 David Beck. All rights reserved.
//

import SwiftUI
import MIDIKit

struct PacketListView: View {
	@EnvironmentObject var controller: MIDIController
	
	var body: some View {
		VStack(spacing: 0) {
			List(controller.receivedPackets) { packet in
				PacketRow(packet: packet)
			}
			
			SendPacketView()
		}
	}
}

struct PacketDataView: View {
	var packet: MIDIPacket
	
	@ViewBuilder
	var body: some View {
		if let status = packet.status {
			switch status {
			case .noteOn, .noteOff:
				Group {
					Text("Note: \(packet.data.1)")
					Text("Intensity: \(packet.data.2)")
				}
			case .polyphonicKeyPressure:
				Group {
					Text("Note: \(packet.data.1)")
					Text("Pressure: \(packet.data.2)")
				}
			case .controlChange:
				Group {
					Text("Control: \(packet.data.1)")
					Text("Value: \(packet.data.2)")
				}
			case .programChange:
				Text("Program: \(packet.data.1)")
			case .channelPressure:
				Text("Pressure: \(packet.data.1)")
			case .pitchBendChange:
				EmptyView()
			}
		} else {
			EmptyView()
		}
	}
}

struct PacketListView_Previews: PreviewProvider {
	static var previews: some View {
		PacketListView()
			.environmentObject(MIDIController.shared)
	}
}
