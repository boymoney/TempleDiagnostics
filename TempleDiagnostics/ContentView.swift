import SwiftUI

// Main view of the application
struct ContentView: View {
    // State variable to track the selected diet, default is keto
    @State private var selectedDiet: DietType = .keto
    // State variable to track whether the diet menu is being shown
    @State private var showingDietMenu = false

    var body: some View {
        // NavigationView provides a way to present a stack of views
        NavigationView {
            ZStack {
                // CameraView displays the camera interface, binding the selected diet
                CameraView(selectedDiet: $selectedDiet)
                    .edgesIgnoringSafeArea(.all) // Make the camera view extend to the edges of the screen
                
                VStack {
                    HStack {
                        // Button to show the diet selection menu
                        Button(action: {
                            self.showingDietMenu.toggle() // Toggle the state to show/hide the menu
                        }) {
                            Image(systemName: "line.horizontal.3") // Hamburger menu icon
                                .font(.title) // Set the font size
                                .padding() // Add padding around the button
                                .background(Color.white) // Set the background color to white
                                .clipShape(Circle()) // Clip the button to a circular shape
                        }
                        .sheet(isPresented: $showingDietMenu) {
                            // Show the DietSelectionView when the button is pressed
                            DietSelectionView(selectedDiet: $selectedDiet)
                        }
                        
                        Spacer()
                    }
                    .padding() // Add padding to the HStack

                    Spacer()
                }
                // Text overlay positioned based on coordinates
                               
            }
            .navigationBarHidden(true) // Hide the navigation bar
        }
    }
}

// View for selecting a diet
struct DietSelectionView: View {
    // Binding to the selected diet from ContentView
    @Binding var selectedDiet: DietType
    // Environment variable to manage presentation mode
    @Environment(\.presentationMode) var presentationMode

    // List of available diets
    let diets: [DietType] = [.keto, .vegan, .vegetarian, .carnivore, .atkins, .weightWatchers, .lowCarb, .paleo, .mediterranean, .dash, .pescatarian, .flexitarian, .whole30, .rawVegan, .zone]

    var body: some View {
        VStack {
            // List of diet options
            List(diets, id: \.self) { diet in
                Text(diet.rawValue) // Display the diet name
                    .onTapGesture {
                        selectedDiet = diet // Update the selected diet when tapped
                        presentationMode.wrappedValue.dismiss() // Dismiss the view
                    }
            }
        }
    }
}
