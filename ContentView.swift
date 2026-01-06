// AppCalco

// https://pollinations.ai/

import SwiftUI


struct ContentView: View {
    @State private var busqueda = ""
    @State private var urlImagen: URL?
    @State private var opacidad: Double = 0.3
    
    // NUEVO ESTADO: Para controlar el tiempo de espera entre peticiones
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
                                    .saturation(0) // Blanco y negro
                                    .contrast(2.0) // Líneas fuertes
                                    .opacity(opacidad)
                            } else if fase.error != nil {
                                // Si falla por límite, este mensaje ayuda
                                Text("Error al cargar. Espera un poco antes de reintentar.")
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
                            // Al volver, si todavía estamos en tiempo de espera, el botón de inicio estará bloqueado
                            urlImagen = nil
                        }
                        .buttonStyle(.bordered)
                    }
                } else {
                    // --- INICIO ---
                    VStack(spacing: 20) {
                        Image(systemName: "pencil.and.outline").font(.largeTitle)
                        Text("Escribe qué quieres calcar").bold()
                        Text("Para evitar errores, espera unos segundos entre dibujos.").font(.caption).foregroundStyle(.gray)
                        
                        TextField("Ej: casa, perro, sol...", text: $busqueda)
                            .textFieldStyle(.roundedBorder)
                            .padding()

                        // EL BOTÓN INTELIGENTE
                        Button(action: prepararImagen) {
                            HStack {
                                if enEspera {
                                    // Mostramos cuenta atrás si está bloqueado
                                    Image(systemName: "hourglass")
                                    Text("Espera \(segundosRestantes)s...")
                                } else {
                                    Text("Generar Dibujo")
                                        .bold()
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            // Cambiamos el color si está en espera
                            .background(busqueda.isEmpty || enEspera ? .gray : .blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        // Bloqueamos el botón si no hay texto O si estamos en espera
                        .disabled(busqueda.isEmpty || enEspera)
                    }
                    .padding()
                }
            }
            .navigationTitle("Aprende a Dibujar")
        }
    }

    func prepararImagen() {
        // 1. Activamos el bloqueo de seguridad
        iniciarCuentaAtras()
        
        // 2. Preparamos el texto
        let texto = busqueda.lowercased().trimmingCharacters(in: .whitespaces)
        
        var traduccion = texto
        // Pequeño diccionario para ayudar a la IA
        let diccionario = [
            "casa": "house",
            "perro": "dog",
            "gato": "cat",
            "barco": "boat",
            "avion": "airplane"
        ]
        if let trad = diccionario[texto] { traduccion = trad }
        
        // 3. Creamos el "Hechizo"
        let promptFinal = "simple black and white outline of a \(traduccion), coloring book style, white background, basic shapes, no shading"
        
        // 4. Creamos la URL con un número aleatorio (seed) para que siempre sea un dibujo nuevo
        let encoded = promptFinal.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        urlImagen = URL(string: "https://image.pollinations.ai/prompt/\(encoded)?nologo=true&seed=\(Int.random(in: 1...9999))")
    }
    
    // FUNCIÓN PARA GESTIONAR LA ESPERA
    func iniciarCuentaAtras() {
        enEspera = true
        segundosRestantes = 4 // Esperamos 4 segundos
        
        // Creamos un temporizador que resta 1 segundo cada segundo
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if segundosRestantes > 1 {
                segundosRestantes -= 1
            } else {
                // Cuando llega a 0, desbloqueamos el botón
                timer.invalidate()
                enEspera = false
                segundosRestantes = 0
            }
        }
    }
}


#Preview {
    ContentView()
}
