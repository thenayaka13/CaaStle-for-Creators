//
//  ContentView.swift
//  CaaStle Creator
//
//  Created by Prajwal Nayaka on 28/10/23.
//

import SwiftUI
import SwiftData
import CoreData

// Landing Page - for iPhone 13 Pro
struct ContentView: View {
    @State private var showSignUpScreen = false

    var body: some View {
        if showSignUpScreen {
            SignUpView()
        } else {
            VStack {
                Spacer()
                Image("Final1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 500, height: 500)
                Spacer()
            }
            .background(Color.white)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    showSignUpScreen.toggle()
                }
            }
        }
    }
}

// 1. Login Page
struct SignUpView: View {
    @State private var currentImageIndex = 0
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showRegisterView = false
    @State private var isValidLogin = false
    @State private var showAlert = false

    @Environment(\.managedObjectContext) var viewContext

    // Assuming you have images named "slide1", "slide2", etc.
    let slideImages = ["slide1", "slide2", "slide3"]

    var body: some View {
        NavigationView {
            if showRegisterView {
                RegisterView(isShowingRegisterView: $showRegisterView, isValidLogin: $isValidLogin)
            } else if isValidLogin {
                HomeView()
            } else {
                ZStack {
                    Color.white.edgesIgnoringSafeArea(.all)
                    VStack(spacing: 20) {
                        // Slideshow
                        Image(slideImages[currentImageIndex])
                            .resizable()
                            .scaledToFit()
                            .frame(height: UIScreen.main.bounds.height / 2.5)
                            .animation(.default)
                            .onAppear(perform: startSlideshow)
                        
                        // Signup Form
                        VStack(spacing: 15) {
                            TextField("Email", text: $username)
                                .keyboardType(.emailAddress)
                                .foregroundColor(Color.white)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal, 20)
                            
                            SecureField("Password", text: $password)
                                .foregroundColor(Color.white)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal, 20)
                            
                            Button(action: {
                                validateLogin(email: username, password: password)
                            }) {
                                Text("Login")
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .alert(isPresented: $showAlert) {
                                Alert(title: Text("Error"), message: Text("Invalid Credentials"), dismissButton: .default(Text("OK")))
                            }
                            .padding(.horizontal, 20)
                            
                            Spacer()
                            
                            HStack {
                                Spacer()
                                Button(action: {
                                    showRegisterView.toggle()
                                }) {
                                    Text("Sign up")
                                        .underline()
                                        .padding(.trailing, 20)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func validateLogin(email: String, password: String) {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)

        do {
            let fetchedResults = try viewContext.fetch(fetchRequest)
            if fetchedResults.count > 0 {
                isValidLogin = true
            } else {
                showAlert = true
            }
        } catch {
            print("Failed to fetch items!")
            showAlert = true
        }
    }

    // Function to switch images for the slideshow every 2 seconds
    func startSlideshow() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            if currentImageIndex < slideImages.count - 1 {
                currentImageIndex += 1
            } else {
                currentImageIndex = 0
            }
        }
    }
}

// 3. Signup page
import CoreData

struct RegisterView: View {
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var ccc: String = ""
    @State private var showingAlert = false
    @State private var showHomeView = false
    
    @Binding var isShowingRegisterView: Bool
    @Binding var isValidLogin: Bool
    
    @Environment(\.managedObjectContext) var managedObjectContext  // Core Data context
    
    init(isShowingRegisterView: Binding<Bool>, isValidLogin: Binding<Bool>) {
        _isShowingRegisterView = isShowingRegisterView
        _isValidLogin = isValidLogin
    }

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            VStack(spacing: 10) {
                
                // Navigation controls
                HStack {
                    Button(action: {
                        isShowingRegisterView.toggle() // Toggles the view visibility
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.blue)
                            .padding(.leading, 10)
                            .padding(.top, 10)
                    }
                    Spacer()
                }
                
                // Logo
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                    .offset(y: -30)
                
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .padding(.vertical, 5)

                VStack(spacing: 10) {
                    TextField("Email", text: $username)
                        .keyboardType(.emailAddress)
                        .foregroundColor(Color.gray)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 20)
                        
                    SecureField("Password", text: $password)
                        .foregroundColor(Color.gray)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 20)
                    
                    SecureField("Confirm Password", text: $confirmPassword)
                        .foregroundColor(Color.gray)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 20)
                    
                    TextField("CaaStle Creator Code", text:$ccc)
                        .foregroundColor(Color.gray)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 20)
                        
                    Button(action: {
                        if self.password == self.confirmPassword {
                            let newUser = User(context: self.managedObjectContext)
                            newUser.email = self.username
                            newUser.password = self.password
                            newUser.ccc = self.ccc
                            do {
                                try self.managedObjectContext.save()
                                self.isValidLogin = true
                                self.isShowingRegisterView = false
                            } catch {
                                print("Failed to save user: \(error)")
                            }
                        } else {
                            print("Passwords don't match")
                            showingAlert.toggle()
                        }
                    }) {
                        Text("Register")
                            .padding(.horizontal, 40)
                            .padding(.vertical, 10)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Error"),
                              message: Text("Passwords don't match"),
                              dismissButton: .default(Text("OK")))
                    }
                    .padding(.horizontal, 20)

                    Spacer()
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            isShowingRegisterView = false
                        }) {
                            Text("Already have an account? Login")
                                .underline()
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.top, 10)
            }
        }
    }
}


import SwiftUI

// Define the CardView structure for posts
struct CardView: View {
    var title: String
    var date: String
    var bodyText: String
    var backgroundColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) { // Ensure consistent spacing
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.top, 10)

            if !date.isEmpty {
                Text(date)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
            }

            Text(bodyText)
                .font(.body)
                .foregroundColor(.white)
                .padding([.horizontal, .bottom], 10) // Ensure consistent padding
        }
        .frame(maxWidth: .infinity, minHeight: 150, alignment: .leading) // Use alignment to ensure text is aligned to the left
        .background(backgroundColor)
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
}

// HomeView structure unchanged, except for using CardView
struct HomeView: View {
    @State private var isBroadcastFeedActive = true
    @State private var isReceiptViewActive = false
    @State private var showFRPView: Bool = false
    @State private var showChatView: Bool = false
    @State private var showProfileView: Bool = false
    @State private var showMenuView: Bool = false
    @State private var username: String = "NSJ@gmail.com"

    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    HStack {
                        NavigationLink(destination: ProfileView(), isActive: $showProfileView) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(.leading, 20)
                                .onTapGesture {
                                    showProfileView.toggle()
                                }
                        }
                        Spacer()
                        Button(action: {
                            showChatView.toggle()
                        }) {
                            Image(systemName: "message")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(.trailing, 20)
                        }
                    }
                    .padding(.top, 50)

                    ScrollView {
                        VStack(alignment: .leading) {
                            Text("Welcome, Prajwal!")
                                .font(.title2)
                                .bold()
                                .padding(.top, 10)
                                .padding(.leading, 10)

                            CardView(title: "Referral fees deposited", date: "11/9/2023", bodyText: "The referral fees of $600 for the month of October 2023 has been successfully deposited in your account", backgroundColor: Color.blue)

                            CardView(title: "Winter Collection Launched", date: "11/5/2023", bodyText: "The Winter collection of 2023 has been released by BCBG and Express. Tap to check it out!", backgroundColor: Color.green)
                    
                            CardView(title: "Creator of the Week", date: "11/1/2023", bodyText: "Madison Lee has redefined sustainable fashion on our platform with her unique posts, driving a surge in rental engagement. Tap to read more!", backgroundColor: Color.blue)
                            
                            CardView(title: "Sweepstakes", date: "11/7/2023", bodyText: "Stay tuned to see who wins the big prize in our upcoming sweepstakes contest on 13th November!", backgroundColor: Color.green)
                            
                            CardView(title: "Tips to engage your audience", date: "11/3/2023", bodyText: "Want to increase your user engagemenet? Tap here to find out some tips and tricks by our in-house marketing managers!", backgroundColor: Color.blue)
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()

                    BottomTabBar(isBroadcastFeedActive: $isBroadcastFeedActive, isReceiptViewActive: $isReceiptViewActive, showFRPView: $showFRPView, showMenuView: $showMenuView)
                }
            }

            // Chat Support View
            if showChatView {
                ChatSupportView(username: $username, showChatView: $showChatView)
            }
        }
    }
}

struct SectionView: View {
    let title: String
    let text: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .bold()
                .padding(.top)
            Text(text)
        }
    }
}

struct BottomTabBar: View {
    @Binding var isBroadcastFeedActive: Bool
    @Binding var isReceiptViewActive: Bool
    @Binding var showFRPView: Bool
    @Binding var showMenuView: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(Color.white)
                .shadow(radius: 5)
                .frame(height: 70)
                .padding(.horizontal, 15)
                .offset(y: -10)

            HStack(spacing: UIScreen.main.bounds.width / 6) {
                Button(action: {
                    isBroadcastFeedActive = true
                    isReceiptViewActive = false
                    showMenuView = false
                }) {
                    VStack {
                        Image(systemName: "antenna.radiowaves.left.and.right")
                        Text("Timeline")
                            .font(.caption)
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .background(isBroadcastFeedActive ? RoundedRectangle(cornerRadius: 20).foregroundColor(Color.white).shadow(radius: 5) : nil)
                }

                NavigationLink(destination: FRPView(), isActive: $showFRPView) {
                    Button(action: {
                        showFRPView = true
                    }) {
                        VStack {
                            Image(systemName: "doc.on.doc")
                            Text("FRP")
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .background(isReceiptViewActive ? RoundedRectangle(cornerRadius: 20).foregroundColor(Color.white).shadow(radius: 5) : nil)
                    }
                }

                NavigationLink(destination: MenuView(), isActive: $showMenuView) {
                    VStack {
                        Image(systemName: "list.dash")
                        Text("Menu")
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .background(showMenuView ? RoundedRectangle(cornerRadius: 20).foregroundColor(Color.white).shadow(radius: 5) : nil)
                }
            }
            .padding(.bottom, 20)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


// 4 FRP
import SwiftUI
import QuickLook

struct FRPView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var showPreview: Bool = false
    @State private var downloadedFileURL: URL?
    @State private var isSorted: Bool = false
    @State private var showFilterModal = false
    @State private var statements: [Statement] = [
        Statement(month: "August", year: "2023"),
        Statement(month: "July", year: "2023")
    ]

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("FRP")
                    .font(.title)
                    .padding(.top, 10)

                Text("Latest Statement")
                    .font(.title2)
                    .bold()
                    .padding(.top, 10)

                StatementDownloadView(month: "September", year: "2023", showPreview: $showPreview, downloadedFileURL: $downloadedFileURL)
                    .padding(.top, 8)
                
                Spacer().frame(height: 30)
                
                Text("Previous Statements")
                    .font(.title2)
                    .bold()

                ForEach(isSorted ? statements.sorted(by: { $0.month > $1.month }) : statements, id: \.id) { statement in
                    StatementDownloadView(month: statement.month, year: statement.year, showPreview: $showPreview, downloadedFileURL: $downloadedFileURL)
                        .padding(.top, 8)
                }

                Spacer()

                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(Color.white)
                        .shadow(radius: 5)
                        .frame(height: 70)
                        .padding(.horizontal, 15)

                    HStack(spacing: 50) {
                        Button(action: {
                            isSorted.toggle()
                        }) {
                            VStack {
                                Image(systemName: "arrow.up.arrow.down")
                                Text("Sort")
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(RoundedRectangle(cornerRadius: 20).foregroundColor(Color.white).shadow(radius: 5))
                        }

                        Button(action: {
                            showFilterModal = true
                        }) {
                            VStack {
                                Image(systemName: "slider.horizontal.3")
                                Text("Filter")
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(RoundedRectangle(cornerRadius: 20).foregroundColor(Color.white).shadow(radius: 5))
                        }
                        .sheet(isPresented: $showFilterModal) {
                            FilterView(statements: $statements)
                        }
                    }
                }
                .padding(.bottom, 20)
            }
            .padding(.leading, 30)
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
        .sheet(isPresented: $showPreview) {
            if let fileURL = downloadedFileURL {
                QuickLookView(url: fileURL)
            }
        }
    }
}

struct Statement: Identifiable {
    let id = UUID()
    let month: String
    let year: String
}

struct FilterView: View {
    @Binding var statements: [Statement]
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedMonth: String = ""
    @State private var selectedYear: String = ""

    var body: some View {
        NavigationView {
            Form {
                Picker("Month", selection: $selectedMonth) {
                    ForEach(["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"], id: \.self) {
                        Text($0)
                    }
                }

                Picker("Year", selection: $selectedYear) {
                    ForEach(["2021", "2022", "2023"], id: \.self) {
                        Text($0)
                    }
                }

                Button("Filter") {
                    if !selectedMonth.isEmpty && !selectedYear.isEmpty {
                        statements = statements.filter { $0.month == selectedMonth && $0.year == selectedYear }
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationBarTitle("Filter Statements", displayMode: .inline)
        }
    }
}

struct FRPView_Previews: PreviewProvider {
    static var previews: some View {
        FRPView()
    }
}


struct QuickLookView: UIViewControllerRepresentable {
    var url: URL

    func makeUIViewController(context: Context) -> UINavigationController {
        let previewController = QLPreviewController()
        previewController.dataSource = context.coordinator
        
        let navigationController = UINavigationController(rootViewController: previewController)
        
        // Create a "Back" button and set its action to dismiss the preview
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: context.coordinator, action: #selector(Coordinator.dismissPreview))
        previewController.navigationItem.leftBarButtonItem = backButton

        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, QLPreviewControllerDataSource {
        var parent: QuickLookView

        init(_ parent: QuickLookView) {
            self.parent = parent
        }

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }

        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return parent.url as QLPreviewItem
        }
        
        // Dismiss the QuickLook preview when "Back" button is tapped
        @objc func dismissPreview() {
            if let controller = UIApplication.shared.windows.first?.rootViewController {
                controller.dismiss(animated: true, completion: nil)
            }
        }
    }
}


struct StatementDownloadView: View {
    let month: String
    let year: String
    @Binding var showPreview: Bool
    @Binding var downloadedFileURL: URL?

    var body: some View {
        HStack {
            Text("\(month) \(year)")
                .font(.title3)

            Spacer()

            Button(action: {
                downloadData(month: month, year: year)
            }) {
                Image(systemName: "arrow.down.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 24)
                    .foregroundColor(.blue)
            }
            .padding(.trailing, 10)
        }
        .padding(.vertical, 8)
    }

    func downloadData(month: String, year: String) {
        guard let url = URL(string: "http://192.168.29.253:3000/download/\(month)%20\(year)") else { return }

        let downloadTask = URLSession.shared.downloadTask(with: url) { (location, response, error) in
            guard let location = location else {
                print("Download error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            let fileManager = FileManager.default
            let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let destinationURL = documentsDirectoryURL.appendingPathComponent("\(month) \(year).xlsx")

            try? fileManager.removeItem(at: destinationURL)

            do {
                try fileManager.moveItem(at: location, to: destinationURL)
                DispatchQueue.main.async {
                    self.showPreview = true
                    self.downloadedFileURL = destinationURL
                }

            } catch {
                print("File saving error: \(error.localizedDescription)")
            }
        }
        downloadTask.resume()
    }
}

// 5. Chat/Support landing
struct ChatSupportView: View {
    @Binding var username: String
    @Binding var showChatView: Bool
    @State private var showChatWindow = false

    var body: some View {
        VStack(alignment: .leading) {  // Alignment set to left for VStack
            HStack {
                Button(action: {
                    showChatView.toggle()
                }) {
                    Image(systemName: "arrow.left")
                        .padding()
                }
                Spacer()
            }
            Text("Support")
                .font(.title)
                .padding(.top, 2)
                .padding(.leading, 20)
            Text("Hi, \(String(username.split(separator: "@").first ?? "User"))!")
                .font(.title)
                .padding(.top, 50)
                .padding(.leading, 20)
            Text("What can we do for you?")
                .font(.title2)
                .padding(.top, 10)
                .padding(.leading, 20)
            
            // Center the button just below the text
            HStack {
                Spacer() // This will push the button to the center
                Button(action: {showChatWindow.toggle()}) {
                    Text("Chat with us")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Spacer() // This will push the button to the center
            }
            .padding(.top, 20)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showChatWindow) {
            WindowView(isWindowViewActive: $showChatWindow)
        }
    }
}

//6. Chat Window
import SwiftUI

struct WindowView: View {
    @Binding var isWindowViewActive: Bool
    @State private var message: String = ""
    @State private var messages: [(text: String, date: Date)] = []

    var body: some View {
        VStack(spacing: 15) {
            // Top bar with title and close button
            HStack {
                Text("Chat Support")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white) // Changed text color to white
                Spacer()
                Button(action: {
                    isWindowViewActive.toggle()
                }) {
                    Image(systemName: "xmark")
                        .padding()
                        .foregroundColor(.white) // Changed close button color to white
                }
            }
            .padding(.horizontal)
            
            // Scrollable chat area
            ScrollView {
                let groupedMessages = Dictionary(grouping: messages, by: { Calendar.current.startOfDay(for: $0.date) })
                let sortedDates = groupedMessages.keys.sorted()

                ForEach(sortedDates, id: \.self) { date in
                    Text(date, style: .date)
                        .font(.caption)
                        .padding(5)
                        .background(Color.gray.opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.vertical, 5)

                    ForEach(groupedMessages[date]!, id: \.text) { msg in
                        HStack {
                            if false {  // This condition is for received messages. Currently set to false to always show as sent.
                                VStack(alignment: .leading) {
                                    Text(msg.text)
                                        .padding(10)
                                        .background(Color.gray)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                    Text(msg.date, style: .time) // Displaying the time
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                            } else {
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text(msg.text)
                                        .padding(10)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                    Text(msg.date, style: .time) // Displaying the time
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                    }
                }
            }
            
            // Text input and send button
            HStack {
                TextField("Enter message", text: $message)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 10)
                Button(action: {
                    if !message.isEmpty {
                        messages.append((text: message, date: Date()))
                        message = ""
                    }
                }) {
                    Text("Send")
                        .padding(10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
        }
        .padding(.top, 10)
        .background(Color.black.edgesIgnoringSafeArea(.all)) // Changed background color to black
    }
}

//7.Profile View
struct ProfileView: View {
    // Sample data for demonstration purposes
    let profileImage = "person.circle.fill"
    let username = "Test Test"
    let email = "nsj@email.com"
    let phone = "636-129-928"
    let plansize = "5-Plan"
    let validupto = "23/10/2024"
    let accountman = "Stephanie Ma"
    
    @State private var showSignUp = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: profileImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .padding(.leading, 20)
                    .padding(.top, 10)

                VStack(alignment: .leading) {
                    Text(username)
                        .font(.headline)
                    Text(email)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(phone)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }

            Text("Active Subscription")
                .font(.title2)
                .padding(.leading, 20)

            Text("Account Manager")
                .font(.title3)
                .bold()
                .padding(.leading, 20)
            
            Text(accountman)
                .padding(.horizontal, 20)
            
            Text("Plan Size")
                .font(.title3)
                .bold()
                .padding(.leading, 20)
            
            Text(plansize)
                .padding(.horizontal, 20)
            
            Text("Valid Upto")
                .font(.title3)
                .bold()
                .padding(.leading, 20)
            
            Text(validupto)
                .padding(.horizontal, 20)
            
            Spacer()

            HStack {
                Button("Settings") {
                    // Navigate to settings or perform other actions
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.leading, 20)

                Spacer()

                NavigationLink(destination: SignUpView(), isActive: $showSignUp) {
                    Button("Logout") {
                        showSignUp = true
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding(.trailing, 20)
            }

        }
        .navigationBarTitle("Profile", displayMode: .inline)
    }
}

// Menu View
struct MenuView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer().frame(height: 10) // Provides a little padding from the top
                VStack(spacing: 10) {
                    MenuItem(icon: "dollarsign.circle", text: "My Finances")
                    MenuItem(icon: "person.3.fill", text: "My Users")
                    MenuItem(icon: "bubble.left", text: "My Support Requests")
                    MenuItem(icon: "arrow.up.circle", text: "My Growth")
                    MenuItem(icon: "gearshape", text: "My Service")
                }
                Spacer() // Pushes the content to the top
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .foregroundColor(.blue)
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarBackButtonHidden(false)
        }
    }
}

struct MenuItem: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
            Text(text)
        }
        .padding(.vertical, 5)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading)
    }
}
