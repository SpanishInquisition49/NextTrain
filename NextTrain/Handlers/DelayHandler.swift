//
//  DelayHandler.swift
//  NextTrain
//
//  Created by Gabriele Scannagatti on 07/10/21.
//


//Stazione di partenza treno
//http://www.viaggiatreno.it/viaggiatrenonew/resteasy/viaggiatreno/cercaNumeroTrenoTrenoAutocomplete/[Numero Treno]
//8619 - MILANO CENTRALE|8619-S01700-1633557600000 output
//Dettagli stato treno
//http://www.viaggiatreno.it/viaggiatrenonew/resteasy/viaggiatreno/andamentoTreno/[Codice stazione (con S0)]/[Numero treno]/[Codice lungo che antani non so]

import Foundation

class TrainStatus: ObservableObject {
    @Published var trainStatus: TrainDetails? = nil
    @Published var urlCode: [UrlCodes] = []
    @Published var completedFirst: Bool = false
    @Published var completedSecond: Bool = false
    
    func fetch(s: String) {
        getFetchCodes(trainNumber: s)
        //print("URL: " + getUrl(codesForUrl: getUrlCodes(s: urlCode)))
        /*while(true) {
            if(!urlCode.isEmpty) {
                print(String(urlCode[0].numeroTreno) + " " + String(urlCode[0].codLocOrig) + " " + String(urlCode[0].descLocOrig))
            }
            else {
                print("Empty")
            }
        }*/
        guard let url = URL(string: getUrl()) else { return }
        secondFetch(url: url)
    }
  
    private func secondFetch(url: URL) {
        print("URL USATO: " + url.absoluteString)
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in guard let data = data, error == nil else{
            return
        }
        //Convert To JSON
        do{
            let solutions = try JSONDecoder().decode(TrainDetails.self, from: data)
            DispatchQueue.main.async {
                self?.trainStatus = solutions
                //self?.completedSecond = true
            }
        }
        catch{
            //print(error)
        }
        }
        task.resume()
    }
    
    private func getFetchCodes(trainNumber: String) {
        guard let url = URL(string: "https://www.viaggiatreno.it/viaggiatrenonew/resteasy/viaggiatreno/cercaNumeroTreno/" + trainNumber) else {
            return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in guard let data = data, error == nil else{
            print("ASS")
            return
        }
        //Convert To JSON
        do{
            print("AaAAAAAA")
            let solutions = try JSONDecoder().decode(UrlCodes.self, from: data)
            print("Res:" + solutions.descLocOrig + " " + solutions.codLocOrig + " | " + solutions.numeroTreno)
            DispatchQueue.main.async {
                self?.urlCode.append(solutions)
                //self?.completedSecond = true
            }
        }
        catch{
            print("ERRORE")
            print(error)
            print("FINE ERRORE")
        }
        }
        task.resume()
    }
    
   // private func getFetchCodes()
 
    private func getUrl() -> String {
        let urlString = "https://www.viaggiatreno.it/viaggiatrenonew/resteasy/viaggiatreno/andamentoTreno/" + String(urlCode[0].codLocOrig) + "/" + String(urlCode[0].numeroTreno) + "/" + String(urlCode[0].dataPartenza)
        return urlString
    }
}



struct TrainDetails: Hashable, Codable {
    let tipoTreno: String
    let orentamento: String?
    let codiceCliente: String
    let fermateSoppresso: String?
    let dataPartenza: String?
    let fermate: [Fermata]
    let anormalita: String?
    let provvedimenti: String?
    let segnalazioni: String?
    let oraUltimoRilevamento: Int
    let stazioneUltimoRilevamento: String
    let idDestinazione: String
    let idOrigine: String
    let cambiNumero: [NonSoCosaSia]
    let hasProvvedimenti: Bool
    let descOrientamento: [String]
    let compOraUltimoRilevamento: String
    let motivoRitardoPrevalente: String?
    let descrizioneVCO: String?
    let numeroTreno: Int
    let categoria: String
    let categoriaDescrizione: String?
    let origine: String
    let codOrigine: String?
    let destinazione: String
    let codDestinazione: String?
    let origineEstera: String?
    let destinazioneEstera: String?
    let oraPartenzaEstera: String?
    let oraArrivoEstera: String?
    let tratta: Int
    let regione: Int
    let origineZero: String
    let destinazioneZero: String
    let orarioPartenzaZero: Int
    let orarioArrivoZero: Int
    let circolante: Bool
    let binarioEffettivoArrivoCodice: String?
    let binarioEffettivoArrivoDescrizione: String?
    let binarioEffettivoArrivoTipo: String?
    let binarioProgrammatoArrivoCodice: String?
    let binarioProgrammatoArrivoDescrizione: String?
    let binarioEffettivoPartenzaCodice: String?
    let binarioEffettivoPartenzaDescrizione: String?
    let binarioEffettivoPartenzaTipo: String?
    let binarioProgrammatoPartenzaCodice: String?
    let binarioProgrammatoPartenzaDescrizione: String?
    let subTitle: String?
    let esisteCorsaZero: String
    let inStazione: Bool
    let haCambiNumero: Bool
    let nonPartito: Bool
    let provvedimento: Int
    let riprogrammazione: String?
    let orarioPartenza: Int
    let orarioArrivo: Int
    let stazionePartenza: String?
    let stazioneArrivo: String?
    let statoTreno: String?
    let corrispondenze: String?
    let servizi: [String]?
    let ritardo: Double
    let tipoProdotto: String?
    let compOrarioPartenzaZeroEffettivo: String
    let compOrarioArrivoZeroEffettivo: String
    let compOrarioPartenzaZero: String
    let compOrarioArrivoZero: String
    let compOrarioArrivo: String
    let compOrarioPartenza: String
    let compNumeroTreno: String
    let compOrientamento: [String]
    let compTipologiaTreno: String
    let compClassRitardoTxt: String
    let compClassRitardoLine: String
    let compImgRitardo2: String
    let compImgRitardo: String
    let compRitardo: [String]
    let compRitardoAndamento: [String]
    let compInStazionePartenza: [String]
    let compInStazioneArrivo: [String]
    let compOrarioEffettivoArrivo: String
    let compDurata: String
    let compImgCambiNumerazione: String
}

struct Fermata: Hashable, Codable {
    let orientamento: String?
    let kcNumTreno: String?
    let stazione: String
    let id: String
    let listaCorrispondenze: String?
    let programmata: Int
    let programmataZero: String?
    let effettiva: Int
    let ritardo: Double
    let partenzaTeoricaZero: String?
    let arrivoTeoricoZero: String?
    let partenza_teorica: Int
    let arrivo_teorico: Int?
    let isNextChanged: Bool
    let partenzaReale: Int
    let arrivoReale: Int?
    let ritardoPartenza: Double
    let ritardoArrivo: Double
    let progressivo: Double
    let binarioEffettivoArrivoCodice: String?
    let binarioEffettivoArrivoTipo: String?
    let binarioEffettivoArrivoDescrizione: String?
    let binarioProgrammatoArrivoCodice: String?
    let binarioProgrammatoArrivoDescrizione: String?
    let binarioEffettivoPartenzaCodice: String
    let binarioEffettivoPartenzaTipo: String
    let binarioEffettivoPartenzaDescrizione: String
    let binarioProgrammatoPartenzaCodice: String
    let binarioProgrammatoPartenzaDescrizione: String
    let tipoFermata: String
    let visualizzaPrevista: Bool
    let nextChanged: Bool
    let nextTrattaType: Int
    let actualFermataType: Int
}

struct NonSoCosaSia: Hashable, Codable {
    let nuovoNumeroTreno: String
    let stazione: String
}


//{"numeroTreno":"666","codLocOrig":"S06725","descLocOrig":"LIVORNO CENTRALE","dataPartenza":1633730400000,"corsa":"00666A","h24":false}
struct UrlCodes: Hashable, Codable {
    let numeroTreno: String
    let codLocOrig: String
    let descLocOrig: String
    let dataPartenza: Int
    let corsa: String
    let h24: Bool
}
