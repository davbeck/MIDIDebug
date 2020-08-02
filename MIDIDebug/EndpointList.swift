//
//  EndpointList.swift
//  MIDIDebug
//
//  Created by David Beck on 8/3/20.
//  Copyright © 2020 David Beck. All rights reserved.
//

import SwiftUI
import MIDIKit

struct EndpointList: View {
	@EnvironmentObject var controller: MIDIController
	
    var body: some View {
		List {
			Section(header: Text("Sources")) {
				ForEach(MIDIEndpoint.allSources) { device in
					Toggle((try? device.displayName()) ?? "(Source)", isOn: self.$controller[connected: device])
				}
			}
			Section(header: Text("Destinations")) {
				ForEach(MIDIEndpoint.allDestinations) { device in
					Toggle((try? device.displayName()) ?? "(Destination)", isOn: self.$controller[connected: device])
				}
			}
		}
    }
}

struct EndpointList_Previews: PreviewProvider {
    static var previews: some View {
        EndpointList()
			.environmentObject(MIDIController.shared)
    }
}
