// AppCalco
// https://pollinations.ai/

import SwiftUI

struct ContentView: View {
    @State private var busqueda = ""
    @State private var urlImagen: URL?
    @State private var opacidad: Double = 0.3
    
    // NUEVO ESTADO: Para elegir si queremos un dibujo extra fácil
    @State private var modoFacil = false
    
    @State private var enEspera = false
    @State private var segundosRestantes = 0

    var body: some View {
        NavigationStack {
            VStack {
                if let url = urlImagen {
                    // --- MODO CALCO ---
                    VStack {
                        AsyncImage(url: url) { fase in
                            if let imagen = fase.image {
                                imagen
                                    .resizable()
                                    .scaledToFit()
                                    .saturation(0)
                                    .contrast(2.0)
                                    .opacity(opacidad)
                            } else if fase.error != nil {
                                Text("Error al cargar. Espera un poco.")
                                    .foregroundStyle(.red)
                                    .padding()
                            } else {
                                VStack {
                                    ProgressView()
                                    Text("Dibujando...").font(.caption)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.white)
  
                        VStack(spacing: 8) {
                            Text("Ajustar transparencia para calcar")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.secondary)
                            
                            Slider(value: $opacidad, in: 0.05...0.8)
                        }
                        .padding()
                        
                        Button("Volver para hacer otro") {
                            urlImagen = nil
                        }
                        .buttonStyle(.bordered)
                    }
                } else {
                    // --- INICIO ---
                    VStack(spacing: 20) {
                        Image(systemName: "pencil.and.outline").font(.largeTitle)
                        Text("Escribe qué quieres calcar").bold()
                        
                        TextField("Ej: casa, perro, sol...", text: $busqueda)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)

                        // --- NUEVA OPCIÓN: MODO FÁCIL ---
                        Toggle(isOn: $modoFacil) {
                            VStack(alignment: .leading) {
                                Text("Dibujo para principiantes")
                                    .fontWeight(.medium)
                                Text("Líneas más gruesas y formas simples")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                        }
                        .padding(.horizontal)
                        .tint(.blue)
                        
                        Button(action: prepararImagen) {
                            HStack {
                                if enEspera {
                                    Image(systemName: "hourglass")
                                    Text("Espera \(segundosRestantes)s...")
                                } else {
                                    Text("Generar Dibujo")
                                        .bold()
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(busqueda.isEmpty || enEspera ? .gray : .blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .disabled(busqueda.isEmpty || enEspera)
                        .padding(.horizontal)
                        
                        Text("Para evitar errores, espera unos segundos entre dibujos.")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    .padding()
                }
            }
            .navigationTitle("Aprende a Dibujar")
        }
    }

    func prepararImagen() {
        iniciarCuentaAtras()
        
        let texto = busqueda.lowercased().trimmingCharacters(in: .whitespaces)
        var traduccion = texto
        
        let diccionario = [
            "casa": "house", "perro": "dog", "gato": "cat",
            "barco": "boat", "avion": "airplane", "sol": "sun"
        ]
        
        if let trad = diccionario[texto] { traduccion = trad }
        
        // --- LÓGICA DEL HECHIZO ---
        // Si el modo fácil está activo, pedimos menos líneas y formas geométricas
        let estilo = modoFacil
            ? "extremely simple minimalist outline for toddlers, very thick lines, basic geometric shapes, no details, white background"
            : "simple black and white outline, coloring book style, white background, basic shapes, no shading"
        
        let promptFinal = "\(estilo) of a \(traduccion)"
        
        let encoded = promptFinal.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        urlImagen = URL(string: "https://image.pollinations.ai/prompt/\(encoded)?nologo=true&seed=\(Int.random(in: 1...9999))")
    }
    
    func iniciarCuentaAtras() {
        enEspera = true
        segundosRestantes = 4
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if segundosRestantes > 1 {
                segundosRestantes -= 1
            } else {
                timer.invalidate()
                enEspera = false
                segundosRestantes = 0
            }
        }
    }
}
