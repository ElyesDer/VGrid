//
//  VGrid.swift
//  VGrid
//
//  Created by Elyes Derouiche on 16/09/2024.
//
import SwiftUI

#Preview("Basic") {
    let content: [[String]] = [
        ["1","2","3","4"],
        ["5","6","7","8"]
    ]

    VStack {
        Text("Alignment | Container: Center - Item: Leading")
        VGrid(
            content,
            configuration: [
                [
                    .fixed(
                        ratio: 0.25,
                        height: 40,
                        alignment: .leading
                    )
                ]
            ],
            containerAlignment: .center,
            vSpacing: 4,
            hSpacing: 4
        ) { item in
            Group {
                Text("Item \(item)")
                    .foregroundColor(Color.black)
                    .padding(4)
                    .background(Color.orange)
                    .border(.black)
            }
        }

        Divider()

        Text("Alignment by Row")
        VGrid(
            content,
            configuration: [
                [
                    .fixed(
                        ratio: 0.25,
                        height: 40,
                        alignment: .leading
                    )
                ], [
                    .fixed(
                        ratio: 0.25,
                        height: 60,
                        alignment: .trailing
                    )
                ]
            ],
            containerAlignment: .center,
            vSpacing: 4,
            hSpacing: 4
        ) { item in
            Group {
                Text("Item \(item)")
                    .foregroundColor(Color.black)
                    .padding(4)
                    .background(Color.orange)
                    .border(.black)
            }
        }

        Divider()

        Text("Configuration By Group")
        VGrid(
            content,
            configuration: [
                [
                    .fixed(
                        ratio: 0.15,
                        height: 40,
                        alignment: .leading
                    ),
                    .fixed(
                        ratio: 0.29,
                        height: 60,
                        alignment: .top
                    )
                ]
            ],
            containerAlignment: .leading,
            vSpacing: 4,
            hSpacing: 4
        ) { item in
            Group {
                Text("Item \(item)")
                    .foregroundColor(Color.black)
                    .padding(4)
                    .background(Color.orange)
                    .border(.black)
            }
        }

        Divider()

        Text("Configuration By Item")
        VGrid(
            content,
            configuration: [
                [
                    .fixed(
                        ratio: 0.15,
                        height: 40,
                        alignment: .leading
                    ),
                    .fixed(
                        ratio: 0.30,
                        height: 60,
                        alignment: .top
                    ),
                    .fixed(
                        ratio: 0.4,
                        height: 30,
                        alignment: .top
                    ),
                    .fixed(
                        ratio: 0.15,
                        height: 60,
                        alignment: .top
                    )
                ]
            ],
            containerAlignment: .center,
            vSpacing: 4,
            hSpacing: 4
        ) { item in
            Group {
                Text("Item \(item)")
                    .foregroundColor(Color.black)
                    .padding(4)
                    .background(Color.orange)
                    .border(.black)
            }
        }

        Divider()

        Text("Configuration By Item / Row")
        VGrid(
            content,
            configuration: [
                [
                    .fixed(
                        ratio: 0.25,
                        height: 40,
                        alignment: .center
                    )
                ],
                [
                    .fixed(
                        ratio: 0.15,
                        height: 40,
                        alignment: .leading
                    ),
                    .fixed(
                        ratio: 0.30,
                        height: 60,
                        alignment: .bottom
                    ),
                    .fixed(
                        ratio: 0.4,
                        height: 30,
                        alignment: .top
                    ),
                    .fixed(
                        ratio: 0.15,
                        height: 60,
                        alignment: .top
                    )
                ],
            ],
            containerAlignment: .center,
            vSpacing: 4,
            hSpacing: 4
        ) { item in
            Group {
                Text("Item \(item)")
                    .foregroundColor(Color.black)
                    .padding(4)
                    .background(Color.orange)
                    .border(.black)
            }
        }
    }
}

@available(iOS 17.0, *)
#Preview("Expandable") {

    @Previewable
    @State
    var isExpanded: Bool = false

    let content: [[String]] = [
        ["1","2","3","4","5","6"],
        ["7","8","9","10","11","12"],
        ["13","14","15","16","17","18"],
        ["19","20","21","22","23","24"],
        ["25","26","27","28","29","30"],
    ]

    let containers: [[GridRow]] = [
        [
            .fixed(
                ratio: 0.166666,
                height: 60,
                alignment: .leading
            ),
            .fixed(
                ratio: 0.166666,
                height: 50,
                alignment: .top
            ),
            .fixed(
                ratio: 0.166666,
                height: 50,
                alignment: .center
            ),
            .fixed(
                ratio: 0.166666,
                height: 50,
                alignment: .bottom
            ),
            .fixed(
                ratio: 0.166666,
                height: 50,
                alignment: .topLeading
            ),
            .fixed(
                ratio: 0.166666,
                height: 50,
                alignment: .bottomTrailing
            ),
        ]
    ]

    ScrollView {
        VGrid(
            content,
            configuration: containers,
            containerAlignment: .center,
            contentHorizontalAlignment: .trailing,
            vSpacing: 4,
            hSpacing: 4,
            truncateAt: 3,
            isExpanded: $isExpanded,
            expandedContent: {
                VStack {
                    Text(isExpanded ? "Collapse" : "Expand")
                }
                .frame(height: 40)
                .frame(maxWidth: .infinity)
                .border(.blue)
                .animation(.easeInOut(duration: 0.5))
                .onTapGesture {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }
            }) { item in
                Group {
                    Text("Item \(item)")
                        .foregroundColor(Color.black)
                        .padding(4)
                        .background(Color.orange)
                        .border(.black)
                }
            }
    }
    .padding(4)
    .frame(width: 400)
}
