# Food Tracker - Apple Watch App

Un'app Apple Watch avanzata per registrare gli alimenti consumati e monitorare calorie e macronutrienti con dati in tempo reale.

## 🎯 Caratteristiche Principali

### 🌐 **Dati Dinamici da Google Sheets**
- Caricamento automatico degli alimenti da Google Sheets CSV
- Database sempre aggiornato con nuovi alimenti
- Cache locale per accesso offline
- Aggiornamento automatico ogni 24 ore

### 🍎 **Registrazione Alimenti Completa**
- Database dinamico con alimenti italiani
- Categorie organizzate: Frutta, Verdure, Cereali, Proteine, Latticini, Snack, Bevande
- Interfaccia ottimizzata per Apple Watch con emoji intuitive
- Selezione quantità tramite slider (10-500g)
- Anteprima nutrizionale in tempo reale

### 📊 **Tracking Completo Macronutrienti**
- **Calorie**: Calcolo automatico basato su quantità
- **Proteine**: Monitoraggio grammi per grammi
- **Grassi**: Tracking dettagliato lipidi
- **Carboidrati**: Controllo carboidrati consumati
- Visualizzazione chip colorate per ogni macronutriente

### 📈 **Dashboard Nutrizione Avanzata**
- Schermata dedicata ai macronutrienti giornalieri
- Grafici a barre per ripartizione percentuale
- Selezione data per analisi storica
- Cards colorate per ogni nutriente
- Lista dettagliata alimenti con breakdown nutrizionale

### 📱 **Tre Schermate Principali**
1. **Home**: Riepilogo giornaliero e aggiunta rapida alimenti
2. **Nutrizione**: Dashboard completa macronutrienti con grafici
3. **Cronologia**: Trend settimanale e visualizzazione storica

### 💾 **Gestione Dati Intelligente**
- Persistenza locale con UserDefaults
- Cache alimenti per accesso offline
- Sincronizzazione automatica con Google Sheets
- Eliminazione entry con swipe gesture

## 🏗 Struttura del Progetto

```
FoodTracker WatchKit App/
├── FoodTrackerApp.swift          # App principale con TabView (3 tabs)
├── ContentView.swift             # Home con riepilogo giornaliero
├── Views/
│   ├── AddFoodView.swift         # Interfaccia aggiunta alimenti
│   ├── HistoryView.swift         # Cronologia e trend settimanale
│   └── NutritionSummaryView.swift # Dashboard macronutrienti
├── Models/
│   └── FoodModels.swift          # Modelli completi con macronutrienti
└── Assets.xcassets/              # Icone e configurazione colori
```

## 🔧 Tecnologie e Architettura

- **SwiftUI + Combine**: UI reattiva con @Published properties
- **WatchKit**: Ottimizzazione specifica Apple Watch
- **URLSession**: Download CSV da Google Sheets
- **UserDefaults**: Persistenza locale e cache
- **JSON Codable**: Serializzazione dati
- **Date/Calendar**: Gestione temporale avanzata

## 📊 Fonte Dati

L'app scarica i dati nutrizionali da:
```
https://docs.google.com/spreadsheets/d/1gfW5-oZqfTw8J3Ss5hsKAdRcMxlIHT_rEp56Gi7lUYA/export?format=csv&gid=939079319
```

**Formato CSV:**
```
Categoria, Nome, Tipo, Peso, Proteine, Grassi, Carboidrati, Acqua, Fibre, Calorie
```

**Campi utilizzati:**
- ✅ **Categoria**: Per organizzazione UI
- ✅ **Nome**: Nome alimento
- ✅ **Tipo**: Sottocategoria
- ✅ **Peso**: Peso di riferimento
- ✅ **Proteine**: Grammi per 100g
- ✅ **Grassi**: Grammi per 100g  
- ✅ **Carboidrati**: Grammi per 100g
- ✅ **Calorie**: Kcal per 100g
- ❌ **Acqua**: Ignorato
- ❌ **Fibre**: Ignorato

## 🎨 Design e UX

### **Codifica Colori Macronutrienti**
- 🔵 **Proteine**: Blu (`P 12.5g`)
- 🟠 **Grassi**: Arancione (`G 8.2g`)
- 🟢 **Carboidrati**: Verde (`C 45.1g`)
- 🔴 **Calorie**: Rosso (`285 kcal`)

### **Grafici Calorici Settimanali**
- 🔴 **< 500 kcal**: Sotto-alimentazione
- 🟠 **500-1500 kcal**: Basso intake
- 🟢 **1500-2000 kcal**: Range normale
- 🔵 **2000-2500 kcal**: Alto intake
- 🟣 **> 2500 kcal**: Eccesso calorico

## 📱 Utilizzo dell'App

### **1. Schermata Home**
- Visualizza calorie e macronutrienti giornalieri
- Lista alimenti consumati oggi con chip nutrizionali
- Pulsante "Aggiungi Cibo" (disabilitato se dati non caricati)
- Indicatori di caricamento e gestione errori

### **2. Aggiungere un Alimento**
1. Tocca "Aggiungi Cibo" dalla Home
2. Seleziona categoria (solo quelle con alimenti disponibili)
3. Scegli alimento dalla lista con anteprima nutrizionale
4. Regola quantità con slider (10-500g)
5. Vedi anteprima calorie e macronutrienti in tempo reale
6. Conferma con "Aggiungi"

### **3. Dashboard Nutrizione**
- Seleziona data con DatePicker
- Cards grandi per Calorie, Proteine, Grassi, Carboidrati
- Grafico a barre per ripartizione percentuale macronutrienti
- Lista dettagliata alimenti con breakdown P/G/C

### **4. Cronologia**
- Grafico settimanale calorie con codifica colori
- Selezione data per visualizzazione storica
- Lista alimenti per data selezionata con orario
- Macronutrienti per ogni entry

## ⚙️ Requisiti Tecnici

- **watchOS 9.0+**
- **Apple Watch Series 4+**
- **Xcode 15.0+**
- **Swift 5.0+**
- **Connessione Internet** (per primo caricamento e aggiornamenti)

## 🚀 Installazione

1. Clona il repository
2. Apri `FoodTracker.xcodeproj` in Xcode
3. Seleziona target "FoodTracker WatchKit App"
4. Connetti Apple Watch
5. Build & Run

## 🔄 Gestione Dati e Cache

### **Primo Avvio**
1. App tenta download CSV da Google Sheets
2. Parsing automatico dei dati nutrizionali
3. Cache locale in UserDefaults
4. Interfaccia si abilita dopo caricamento

### **Avvi Successivi**
1. Carica cache locale immediatamente
2. Controlla se cache > 24 ore
3. Se necessario, aggiorna in background
4. Mantiene funzionalità offline

### **Gestione Errori**
- Indicatori di caricamento durante download
- Messaggi di errore user-friendly
- Pulsante "Riprova" per retry manuale
- Fallback su cache locale se disponibile

## 🎯 Funzionalità Avanzate

### **Calcoli Nutrizionali Dinamici**
```swift
// Esempio calcolo per 150g di pasta
let calories = (food.calorie * 150) / 100  // 196 kcal
let proteine = (food.proteine * 150) / 100 // 11.2g
let grassi = (food.grassi * 150) / 100     // 1.7g  
let carboidrati = (food.carboidrati * 150) / 100 // 41.2g
```

### **Aggregazioni Temporali**
- Somme giornaliere per tutti i macronutrienti
- Trend settimanali calorie con visualizzazione grafica
- Filtri per data con Calendar integration
- Persistenza storica completa

## 🔮 Roadmap Futuro

- [ ] **HealthKit Integration**: Sync con app Salute iOS
- [ ] **Obiettivi Personalizzati**: Target calorici e macro
- [ ] **Notifiche Smart**: Promemoria e obiettivi
- [ ] **Sync iPhone**: Companion app iOS
- [ ] **Export Dati**: CSV/PDF reports
- [ ] **Micronutrienti**: Vitamine e minerali
- [ ] **Ricette**: Combinazioni alimenti
- [ ] **Barcode Scanner**: Aggiunta rapida prodotti

## 📄 Licenza

Progetto rilasciato sotto **MIT License**

---

**Sviluppato con ❤️ per Apple Watch** | *Real-time nutrition tracking made simple*
