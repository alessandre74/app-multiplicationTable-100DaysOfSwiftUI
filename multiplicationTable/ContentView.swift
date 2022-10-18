//
//  ContentView.swift
//  multiplicationTable
//
//  Created by Alessandre Livramento on 12/10/22.
//

import SwiftUI

struct ContentView: View {
    @State private var selectGame = 2
    @State private var itenRandom = Int.random(in: 1...10)
    @State private var resultGame = 0
    @State private var amountPlay  = 1
    @State private var amountPlayed = 1
    @State private var countScore = 0
    @State private var startGame  = false
    @State private var gameOver = false
    @State private var itemsSelect = [Int]()
    @State private var tableItens = [Int]()

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            VStack {

                Text("Jogo da Tabuada")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                VStack {
                    //Screen start --
                    if !startGame {
                        VStack(spacing: 40) {
                            StepperView(title: "Qual tabuada deseja praticar ?", sizeTitle: 25, value: $selectGame, range: 2...12)

                            StepperView(title: "Quantas vezes deseja jogar ?", sizeTitle: 25, value: $amountPlay, range: 1...20)
                        }
                        .padding(.bottom, 40)


                        ButtonStartView(startGame: $startGame,
                                        resultGame: $resultGame,
                                        selectGame: $selectGame,
                                        itenRandom: itenRandom)
                        { result in
                            calculate(resultGame: result)
                        }
                    }

                    //Screen game --
                    if startGame {

                        GameTopView(selectGame: selectGame,
                                    amountPlay: amountPlay,
                                    itenRandom: $itenRandom,
                                    amountPlayed: $amountPlayed)

                        GameItensView(
                            amountPlay: amountPlay,
                            amountPlayed: $amountPlayed,
                            resultGame: $resultGame,
                            itemsSelect: $itemsSelect,
                            countScore: $countScore, reset: reset)
                    }
                }
                .foregroundColor(.color9)
                .frame(maxWidth: .infinity, maxHeight: 420)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .animation(.linear(duration: 1).delay(1), value: startGame)

                ScoreView(countScore: countScore, animation: startGame)
            }
            .padding(.horizontal)
            .alert("Fim", isPresented: $gameOver) {
                Button("Reiniciar", action: start)
            } message: {
                Text("Fim de Jogo! Voce obteve \(countScore) \(countScore == 1 ? "ponto" : "pontos") ")
            }

        }
    }

    func calculate(resultGame: Int) {
        if itemsSelect.count != 0 { return }

        itemsSelect.append(resultGame)

        for number in 1...10 {
            tableItens.append(selectGame * number)
        }

        while itemsSelect.count < 4 {
            let randomItem = tableItens.randomElement()!

            if !itemsSelect.contains(randomItem) {
                itemsSelect.append(randomItem)
            }
        }

        itemsSelect.shuffle()
    }

    func start() {
        selectGame = 2
        amountPlay = 1
        amountPlayed = 1
        countScore = 0
        itenRandom = Int.random(in: 1...10)
        itemsSelect = []
        tableItens = []
        startGame.toggle()
    }

    func reset() {
        if amountPlayed == amountPlay {
            gameOver.toggle()
            return
        }

        amountPlayed += 1
        itemsSelect = []
        tableItens = []
        itenRandom = Int.random(in: 1...10)
        resultGame = selectGame * itenRandom

        calculate(resultGame: resultGame)
    }
}

struct StepperView: View {
    var title: String
    var sizeTitle: CGFloat

    @Binding var value: Int
    @State var range: ClosedRange<Int>

    var body: some View {
        VStack {
            Text(title)
                .font(.system(size: 20).weight(.heavy))
                .foregroundStyle(.secondary)

            HStack {
                ButtonStepperView(
                    image: "minus",
                    fontSize: 12,
                    frameWidth: 12,
                    frameHeight: 12,
                    backgroundColor: .color9,
                    foregroucColor: .yellow,
                    paddingStroke: 2,
                    colorStroke: .color7
                    , lineWidthStroke: 2,
                    function: decrement
                )

                Spacer()

                Text("\(value)")

                Spacer()

                ButtonStepperView(
                    image: "plus",
                    fontSize: 12,
                    frameWidth: 12,
                    frameHeight: 12,
                    backgroundColor: .color9,
                    foregroucColor: .yellow,
                    paddingStroke: 2,
                    colorStroke: .color7
                    , lineWidthStroke: 2,
                    function: increment
                )
            }
            .font(.system(size: 40).weight(.semibold))
            .frame(width: 100)
            .foregroundColor(.yellow)
            .padding(.horizontal, 10)
            .background(Capsule())
            .padding(1)
            .background(Capsule().stroke(Color.color7, lineWidth: 4))
        }
    }

    func increment() {
        if value >= range.lowerBound && value < range.upperBound {
            value += 1
        }
    }

    func decrement() {
        if value > range.lowerBound && value <= range.upperBound {
            value -= 1
        }
    }
}

struct ButtonStepperView: View {
    var image: String
    var fontSize: CGFloat
    var frameWidth: CGFloat
    var frameHeight: CGFloat
    var backgroundColor: Color
    var foregroucColor: Color
    var paddingStroke: CGFloat
    var colorStroke: Color
    var lineWidthStroke: CGFloat
    let function: () -> Void

    var body: some View {
        VStack {
            Button {
                function()
            } label: {
                Image(systemName: image)
            }
            .font(.system(size: fontSize))
            .foregroundColor(foregroucColor)
            .frame(width: frameWidth, height: frameHeight)
            .background(Circle().fill(backgroundColor))
            .padding(paddingStroke)
            .background(Circle().stroke(colorStroke, lineWidth: lineWidthStroke))
        }
    }
}

struct ButtonStartView: View {
    @Binding var startGame: Bool
    @Binding var resultGame: Int
    @Binding var selectGame: Int
    @State var itenRandom: Int

    var calculate: (_ resultGame: Int) -> Void

    var body: some View {
        HStack {
            Button {
                startGame.toggle()
                resultGame = selectGame * itenRandom
                calculate(resultGame)
            } label: {
                Text("Iniciar")
            }
            .font(.system(size: 20).weight(.semibold))
            .foregroundColor(.yellow)
            .frame(width: 80, height: 80)
            .background(Color.color9)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.color7, lineWidth: 4))
            .opacity(startGame ? 0 : 1 )
            .disabled(startGame)
        }
    }
}

struct GameTopView: View {
    var selectGame: Int
    @State var amountPlay: Int
    @Binding var itenRandom: Int
    @Binding var amountPlayed: Int

    var body: some View {
        VStack(spacing: 10) {
            Text("Tabuada selecionada")
                .font(.system(size: 20).weight(.heavy))
                .foregroundStyle(.secondary)

            Text("\(selectGame)")
                .font(.system(size: 34).bold())
                .foregroundColor(.yellow)
                .padding(30)
                .background(Color.color9)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.color7, lineWidth: 4))

            Text("Jogo")
                .font(.system(size: 20).weight(.heavy))
                .foregroundStyle(.secondary)

            Text("\(amountPlayed)/\(amountPlay)")
                .font(.system(size: 24).weight(.semibold))
                .frame(width: 120, height: 50)
                .foregroundColor(.yellow)
                .background(Capsule())
                .padding(1)
                .background(Capsule().stroke(Color.color7, lineWidth: 4))
            Spacer()


            HStack {
                Text("Qual o resultado de  \(selectGame)  X")
                    .font(.system(size: 20).weight(.heavy))
                    .foregroundStyle(Color.secondary).opacity(0.8)

                Text("\(itenRandom)")
                    .font(.system(size: 20).weight(.heavy))
                    .foregroundStyle(Color.secondary).opacity(0.8)
                    .frame(width: 40, alignment: .leading)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct GameItensView: View {
    @State var tap = false
    @State var message = "message"
    @State var selectedItem = -1

    @State var amountPlay: Int

    @Binding var amountPlayed: Int
    @Binding var resultGame: Int
    @Binding var itemsSelect: [Int]
    @Binding var countScore: Int

    var reset: () -> Void

    var body: some View {
        HStack {
            ForEach(0..<itemsSelect.count, id: \.self){ number in

                Text("\(itemsSelect[number])")
                    .font(.system(size: 30).bold())
                    .foregroundColor(.yellow)
                    .frame(width: 60, height: 60)
                    .background(Circle().fill())
                    .padding(2)
                    .background(Circle().stroke(message == "checkmark" ? Color.color11 : Color.color10, lineWidth: number == selectedItem ? 4 : 0))
                    .shadow(radius: 4)
                    .onTapGesture {
                        tap.toggle()
                        selectedItemResult(_selectedItem: number)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                            tap.toggle()
                            selectedItem = -1
                            reset()
                        }
                    }
            }
        }
        .frame(maxWidth: .infinity)
        .disabled(tap)

        HStack {
            Image(systemName: message)
                .font(.system(size: 36).bold())
                .foregroundColor(message == "checkmark" ? Color.color11 : Color.color10)
                .opacity(message == "checkmark" || message == "xmark" ? 1 : 0)
                .scaleEffect(tap ? 1.6 : 1)
                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: tap)
        }
        .frame(maxWidth: .infinity, maxHeight: 60)
    }


    func selectedItemResult(_selectedItem: Int) {
        selectedItem = _selectedItem
        message = itemsSelect[selectedItem] == resultGame ? "checkmark" : "xmark"

        if message == "checkmark" {
            countScore += 1
        } else {
            countScore -= 1
        }
    }
}

struct ScoreView: View {
    var countScore: Int
    var animation: Bool

    var body: some View {
        HStack(spacing: 10) {
            Text("Pontuação:")

            Text("\(countScore)")
                .frame(width: 60, alignment: .leading)
        }
        .font(.title.bold())
        .foregroundColor(.white)
        .frame(maxWidth: .infinity )
        .opacity(animation ? 1 : 0)
        .animation(.linear(duration: 1).delay(1), value: animation)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
