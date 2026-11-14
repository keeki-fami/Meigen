//
//  MeigenWidgetLiveActivity.swift
//  MeigenWidgetExtension
//  
//  Created by keeki-fami on 2026/11/14
//  
//

import ActivityKit
import WidgetKit
import SwiftUI

struct MeigenWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct MeigenWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MeigenWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension MeigenWidgetAttributes {
    fileprivate static var preview: MeigenWidgetAttributes {
        MeigenWidgetAttributes(name: "World")
    }
}

extension MeigenWidgetAttributes.ContentState {
    fileprivate static var smiley: MeigenWidgetAttributes.ContentState {
        MeigenWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: MeigenWidgetAttributes.ContentState {
         MeigenWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: MeigenWidgetAttributes.preview) {
   MeigenWidgetLiveActivity()
} contentStates: {
    MeigenWidgetAttributes.ContentState.smiley
    MeigenWidgetAttributes.ContentState.starEyes
}
