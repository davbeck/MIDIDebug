//
//  PacketRow.swift
//  MIDIDebug
//
//  Created by David Beck on 8/3/20.
//  Copyright © 2020 David Beck. All rights reserved.
//

import SwiftUI
import MIDIKit

struct PacketRow: View {
	var packet: MIDIPacket
	
	var body: some View {
		VStack(alignment: .leading) {
			HStack(spacing: 10) {
				if let status = packet.status {
					Text(status.localizedDescription)
						.font(Font.body.bold())
				}
				Text("Ch. \(packet.channel + 1)")
				
				PacketDataView(packet: packet)
			}
			.font(Font.body)
			
			PacketBinaryView(packet: packet)
		}
	}
}

//struct PacketRow_Previews: PreviewProvider {
//    static var previews: some View {
//        PacketRow()
//    }
//}
