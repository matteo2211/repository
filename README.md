# Food Tracker - Apple Watch App

Un'app Apple Watch dedicata per registrare gli alimenti consumati e calcolare le calorie giornaliere.

## Caratteristiche Principali

### 🍎 Registrazione Alimenti
- Database completo con oltre 100 alimenti italiani
- Categorie organizzate: Frutta, Verdure, Cereali, Proteine, Latticini, Snack, Bevande
- Interfaccia ottimizzata per Apple Watch con emoji intuitive
- Selezione quantità tramite slider (10-500g)

### 📊 Calcolo Calorie
- Calcolo automatico delle calorie basato sulla quantità
- Visualizzazione calorie giornaliere in tempo reale
- Somma totale sempre visibile nella schermata principale

### 📈 Cronologia e Statistiche
- Grafico settimanale delle calorie consumate
- Visualizzazione storica per data
- Codifica colori per livelli calorici:
  - Rosso: < 500 kcal
  - Arancione: 500-1500 kcal
  - Verde: 1500-2000 kcal
  - Blu: 2000-2500 kcal
  - Viola: > 2500 kcal

### 💾 Persistenza Dati
- Salvataggio automatico tramite UserDefaults
- Dati conservati tra le sessioni
- Eliminazione entry con swipe

## Struttura del Progetto

```
FoodTracker WatchKit App/
├── FoodTrackerApp.swift          # App principale con TabView
├── ContentView.swift             # Schermata principale
├── Views/
│   ├── AddFoodView.swift         # Interfaccia aggiunta alimenti
│   └── HistoryView.swift         # Cronologia e statistiche
├── Models/
│   └── FoodModels.swift          # Modelli dati (Food, FoodEntry, FoodTracker)
├── Data/
│   └── FoodDatabase.swift        # Database alimenti con calorie
└── Assets.xcassets/              # Icone e colori app
```

## Tecnologie Utilizzate

- **SwiftUI**: Framework UI moderno e reattivo
- **WatchKit**: APIs specifiche per Apple Watch
- **UserDefaults**: Persistenza dati locale
- **Combine**: Gestione stato reattivo con @Published

## Requisiti di Sistema

- watchOS 9.0+
- Apple Watch Series 4 o successivo
- Xcode 15.0+
- Swift 5.0+

## Installazione e Utilizzo

1. Apri il progetto in Xcode
2. Seleziona il target "FoodTracker WatchKit App"
3. Connetti il tuo Apple Watch
4. Compila e installa l'app

## Utilizzo dell'App

### Aggiungere un Alimento
1. Tocca il pulsante "Aggiungi Cibo" nella schermata principale
2. Seleziona una categoria scorrendo orizzontalmente
3. Scegli l'alimento dalla lista
4. Regola la quantità con lo slider
5. Conferma con "Aggiungi"

### Visualizzare la Cronologia
1. Naviga alla tab "Cronologia"
2. Visualizza il grafico settimanale
3. Seleziona una data specifica per vedere i dettagli
4. Scorri la lista degli alimenti consumati

### Eliminare una Entry
1. Nella schermata principale o cronologia
2. Swipe verso sinistra sull'elemento
3. Tocca "Elimina"

## Database Alimenti

Il database include alimenti tipici della cucina italiana con valori calorici accurati per 100g:

- **Frutta**: Mela, Banana, Arancia, Fragole, etc.
- **Verdure**: Pomodoro, Zucchine, Spinaci, Broccoli, etc.
- **Cereali**: Pasta, Riso, Pane, Avena, etc.
- **Proteine**: Pollo, Salmone, Uova, Legumi, etc.
- **Latticini**: Latte, Yogurt, Formaggi, etc.
- **Snack**: Frutta secca, Cioccolato, Biscotti, etc.
- **Bevande**: Acqua, Caffè, Succhi, Vino, etc.

## Funzionalità Future

- [ ] Integrazione con HealthKit
- [ ] Obiettivi calorici personalizzati
- [ ] Notifiche promemoria
- [ ] Sincronizzazione con iPhone
- [ ] Esportazione dati
- [ ] Macro-nutrienti (proteine, carboidrati, grassi)

## Contribuire

Per contribuire al progetto:
1. Fork del repository
2. Crea un branch per la tua feature
3. Commit delle modifiche
4. Push al branch
5. Apri una Pull Request

## Licenza

Questo progetto è rilasciato sotto licenza MIT. Vedi il file LICENSE per i dettagli.

---

Sviluppato con ❤️ per Apple Watch
