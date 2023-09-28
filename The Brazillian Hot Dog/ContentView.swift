//
//  ContentView.swift
//  The Brazillian Hot Dog
//
//  Created by Vladimir Cezar on 2023-09-28.
//

import SwiftUI


struct HotDog: Identifiable {
  let basePrice = 10
  
  var id = UUID()
  var hasFries: Bool = false
  var hasKetchup: Bool = false
  var hasMustard: Bool = false
  var price: Int {
    basePrice +
    (hasFries ? 3 : 0) +
    (hasKetchup ? 2 : 0) +
    (hasMustard ? 1 : 0)
  }
}

struct ContentView: View {
  @State private var addFries: Bool = false
  @State private var addKetchup: Bool = false
  @State private var addMustard: Bool = false
  @State private var order: [HotDog] = [
    HotDog(hasFries: true, hasKetchup: true, hasMustard: true)
  ]
  
  private var total: Int {
    order.reduce(0) { partialResult, item in
      partialResult + item.price
    }
  }
  
  private var rowNumber = 0
  
  var body: some View {
    TabView {
      NavigationView {
        VStack {
          Form {
            Toggle(isOn: $addFries) {
              Text("Add Julienne fries")
            }
            Toggle(isOn: $addKetchup) {
              Text("Add Ketchup")
            }
            Toggle(isOn: $addMustard) {
              Text("Add Mustard")
            }
          }
          .navigationTitle("Brazilian Hot Dogs")
          .toolbar {
            Button {
              let hotDog = HotDog (
                hasFries: addFries,
                hasKetchup: addKetchup,
                hasMustard: addMustard
              )
              order.append(hotDog)
            } label: {
              Image(systemName: "cart.badge.plus")
                .symbolRenderingMode(.multicolor)
            }
          }
        }
      }
      .tabItem {
        Label("Menu", systemImage: "menucard")
      }
      
      NavigationView {
        List {
          
          Section {
            ForEach(order) { item in
              HotDogRow(hotdog: item)
            }
            .onDelete { indexSet in
              order.remove(atOffsets: indexSet)
            }
          }
          Section {
            HStack {
              Text("Total:")
                .font(.largeTitle)
              Spacer()
              Text("$\(total)")
                .font(.largeTitle)
            }
          }
        }
        .navigationTitle("Order")
      }
      .tabItem {
        Label("Order", systemImage: "cart")
      }
    }
  }
}

struct HotDogRow: View {
  var hotdog: HotDog
  var body: some View {
    HStack () {
      if hotdog.hasFries {
        IngredientView(title: "Fries", color: .orange)
      }
      if hotdog.hasKetchup {
        IngredientView(title: "Ketchup", color: .red)
      }
      if hotdog.hasMustard {
        IngredientView(title: "Mustard", color: .yellow)
      }
      Spacer()
      Text("$\(hotdog.price)")
        .font(.largeTitle)
    }
  }
}

#Preview {
  ContentView()
}

struct IngredientView: View {
  var title: String
  var color: Color
  var firstLetter: String {
    String(title.uppercased().first ?? "-")
  }
  
  var body: some View {
    Text(firstLetter)
      .font(.title)
      .foregroundColor(.white)
      .padding()
      .background(
        Circle()
          .foregroundColor(color)
      )
  }
}
