import SwiftUI
import CodeScanner

struct ContentView: View {
        
    @Environment(\.openURL) private var openURL
    
    @State var torch: Bool = false;
    @State var url: URL? = nil;
    
    var body: some View {
        ZStack
        {
            CodeScannerView(codeTypes: [.qr], scanMode: .continuous, scanInterval: 5, simulatedData: "ekd34jojitb4xgs", isTorchOn: torch, completion: handleScan)
                .ignoresSafeArea()
            
            VStack{
                Spacer()
                HStack{
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white)
                        .frame(width: 50, height: 50)
                        .overlay(content: {
                            Image(systemName: torch ? "lightbulb" : "lightbulb.slash")
                            .resizable()
                            .foregroundColor(!torch ? .gray : .yellow)
                            .scaledToFit()
                            .frame(height: 30)
                        })
                    .onTapGesture {
                        torch = !torch
                    }
                }
                .padding(5)
            }.padding(5)
            
            if(url != nil) {
                Color.clear
                    .sheet(isPresented: .constant(true), content: {
                        SafariView(url: url!)
                            .onDisappear{
                                url = nil;
                            }
                    })
            }
        }
    }
                
    func handleScan(result: Result<ScanResult, ScanError>)
    {
        guard let data = try? result.get().string else { return; }
        guard let urlGuarded = URL(string: "http://192.168.49.240:5173/app/scanner/remote/?qr=" + data) else { return; }
        
        url = urlGuarded;
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

