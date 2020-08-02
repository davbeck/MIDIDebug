//
//  SendPacketView.swift
//  MIDIDebug
//
//  Created by David Beck on 8/4/20.
//  Copyright © 2020 David Beck. All rights reserved.
//

import SwiftUI
import MIDIKit

struct SendPacketView: View {
	@EnvironmentObject var controller: MIDIController
	
	@State var status: MIDIStatus = MIDIStatus.noteOn
	@State var channel: UInt8 = 1
	@State var note: UInt8 = 0
	@State var intensity: UInt8 = 1
	
	var body: some View {
		HStack(spacing: 20) {
			Picker(selection: $status, label: Text("Status").layoutPriority(1).fixedSize()) {
				ForEach(MIDIStatus.allCases, id: \.self) { status in
					Text(status.localizedDescription)
				}
			}.layoutPriority(1).fixedSize()
			Picker(selection: $channel, label: Text("Channel").layoutPriority(1).fixedSize()) {
				ForEach(UInt8(1)...16, id: \.self) { channel in
					Text("\(channel)")
				}
			}.layoutPriority(1).fixedSize()
			Picker(selection: $note, label: Text("Note").layoutPriority(1).fixedSize()) {
				ForEach(UInt8(0)...127, id: \.self) { note in
					Text("\(note)")
				}
			}.layoutPriority(1).fixedSize()
			Picker(selection: $intensity, label: Text("Intensity").layoutPriority(1).fixedSize()) {
				ForEach(UInt8(0)...127, id: \.self) { intensity in
					Text("\(intensity)")
				}
			}.layoutPriority(1).fixedSize()
			
			Spacer().frame(minWidth: 20)
			
			Button("Send") {
				controller.send(status: status, channel: self.channel, note: note, intensity: intensity)
			}
		}
		.lineLimit(1)
		.padding()
	}
}

struct SendPacketView_Previews: PreviewProvider {
    static var previews: some View {
        SendPacketView()
			.environmentObject(MIDIController.shared)
    }
}
