//
//  QuoteSwipeView.swift
//  Meigen
//  
//  Created by keeki-fami on 2026/11/13
//  
//


import SwiftUI

struct QuoteSwipeView: View {
    let quotes: [Quote]
    let onSelect: (Quote) -> Void

    @State private var currentIndex = 0
    @State private var dragOffset: CGSize = .zero
    @State private var isAnimating = false
    @State private var imageStorageService = ImageStorageService()

    private let swipeThreshold: CGFloat = 100

    var body: some View {
        GeometryReader { geometry in
            if quotes.isEmpty {
                ContentUnavailableView(
                    "名言がありません",
                    systemImage: "quote.opening",
                    description: Text("名言を追加してください")
                )
            } else {
                ZStack {
                    // 次のカードを背後に表示
                    if quotes.count > 1 {
                        card(for: nextIndex)
                            .scaleEffect(0.94)
                            .offset(y: 12)
                            .allowsHitTesting(false)
                    }

                    // 現在のカード
                    card(for: currentIndex)
                        .offset(dragOffset)
                        .rotationEffect(
                            .degrees(Double(dragOffset.width / 20))
                        )
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    guard !isAnimating else { return }
                                    dragOffset = value.translation
                                }
                                .onEnded { value in
                                    guard !isAnimating else { return }

                                    if abs(value.translation.width)
                                        > swipeThreshold {
                                        swipeCard(
                                            width: value.translation.width,
                                            height: geometry.size.height
                                        )
                                    } else {
                                        withAnimation(.spring()) {
                                            dragOffset = .zero
                                        }
                                    }
                                }
                        )
                }
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.height
                )
                .overlay(alignment: .bottom) {
                    HStack {
                        Label("左へスワイプ", systemImage: "arrow.left")
                        Spacer()
                        Label("右へスワイプ", systemImage: "arrow.right")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 12)
                }
            }
        }
    }

    private var nextIndex: Int {
        (currentIndex + 1) % quotes.count
    }

    @ViewBuilder
    private func card(for index: Int) -> some View {
        let fileName = quotes[index].imageFilename
        if let image = imageStorageService.load(filename: fileName) {
            QuoteCardView(quote: quotes[index], image: image)
                .contentShape(RoundedRectangle(cornerRadius: 24))
                .onTapGesture {
                    onSelect(quotes[index])
                }
        } else {
            QuoteCardView(quote: quotes[index], image: nil)
                .contentShape(RoundedRectangle(cornerRadius: 24))
                .onTapGesture {
                    onSelect(quotes[index])
                }
        }
    }

    private func swipeCard(width: CGFloat, height: CGFloat) {
        guard !isAnimating else { return }

        isAnimating = true

        withAnimation(.easeIn(duration: 0.25)) {
            dragOffset = CGSize(
                width: width > 0 ? 600 : -600,
                height: 80
            )
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            currentIndex = (currentIndex + 1) % quotes.count
            dragOffset = .zero
            isAnimating = false
        }
    }
}
