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
    @Published var urlString: String = ""
    
    func fetch(s: String) {
        getFetchCodes(trainNumber: s)
        print(urlString)
    }
  
    private func secondFetch(url: URL) {
        print("URL USATO: " + url.absoluteString)
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in guard let data = data else{
            return
        }
        //Convert To JSON
        do{
            let solutions = try JSONDecoder().decode(TrainDetails.self, from: data)
            DispatchQueue.main.async {
                self?.trainStatus = solutions
            }
        }
        catch{
            print(error)
        }
        }
        task.resume()
    }
    
    private func getFetchCodes(trainNumber: String) {
        guard let url = URL(string: "http://www.viaggiatreno.it/viaggiatrenonew/resteasy/viaggiatreno/cercaNumeroTreno/" + trainNumber) else {
            return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in guard let data = data, error == nil else{
            return
        }
            //Convert To JSON
            do{
                let solutions = try JSONDecoder().decode(UrlCodes.self, from: data)
                print(solutions)
                guard let url = URL(string: (self?.getUrl(u: solutions)) as! String) else { return }
                self?.secondFetch(url: url)
            }
            catch{
                print(error)
            }
        }
        task.resume()
    }
    
   // private func getFetchCodes()
 
    private func getUrl(u: UrlCodes) -> String {
        let urlString = "http://www.viaggiatreno.it/viaggiatrenonew/resteasy/viaggiatreno/andamentoTreno/" + String(u.codLocOrig) + "/" + String(u.numeroTreno) + "/" + String(u.dataPartenza)
        return urlString
    }
    
    //8619 - MILANO CENTRALE|8619-S01700-1633557600000 input
    private func string2UrlCode(s: String) -> UrlCodes {
        let str = s.replacingOccurrences(of: "\n", with: "").split(separator: "|")
        let data = str[1].split(separator: "-")
        let urlCode = UrlCodes(numeroTreno: String(data[0]), codLocOrig: String(data[1]), descLocOrig: "", dataPartenza: Int(data[2])!, corsa: "", h24: false)
        return urlCode
    }
}



struct TrainDetails: Hashable, Codable {
    let tipoTreno: String
    let orentamento: String?
    let codiceCliente: Int?
    let fermateSoppresso: String?
    let dataPartenza: String?
    let fermate: [Fermata]
    let anormalita: String?
    let provvedimenti: String?
    let segnalazioni: String?
    let oraUltimoRilevamento: Int?
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
    let effettiva: Int?
    let ritardo: Double
    let partenzaTeoricaZero: String?
    let arrivoTeoricoZero: String?
    let partenza_teorica: Int?
    let arrivo_teorico: Int?
    let isNextChanged: Bool
    let partenzaReale: Int?
    let arrivoReale: Int?
    let ritardoPartenza: Double
    let ritardoArrivo: Double
    let progressivo: Double
    let binarioEffettivoArrivoCodice: String?
    let binarioEffettivoArrivoTipo: String?
    let binarioEffettivoArrivoDescrizione: String?
    let binarioProgrammatoArrivoCodice: String?
    let binarioProgrammatoArrivoDescrizione: String?
    let binarioEffettivoPartenzaCodice: String?
    let binarioEffettivoPartenzaTipo: String?
    let binarioEffettivoPartenzaDescrizione: String? //Binario da usare per le partenze credo
    let binarioProgrammatoPartenzaCodice: String?
    let binarioProgrammatoPartenzaDescrizione: String?
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
