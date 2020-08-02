//
//  PacketBinaryView.swift
//  MIDIDebug
//
//  Created by David Beck on 8/3/20.
//  Copyright © 2020 David Beck. All rights reserved.
//

import SwiftUI
import MIDIKit

struct PacketBinaryView: View {
	var packet: MIDIPacket
	
	var body: some View {
		HStack {
			ForEach(packet.bytes, id: \.self) { byte in
				Text(byte.binaryDescription)
			}
		}
		.font(.system(.body, design: .monospaced))
	}
}

//struct PacketBinaryView_Previews: PreviewProvider {
//    static var previews: some View {
//        PacketBinaryView()
//    }
//}
