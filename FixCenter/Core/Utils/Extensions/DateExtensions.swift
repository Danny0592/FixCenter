//
//  DateExtensions.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import Foundation

extension Date {
    /// Calcula la cantidad de días transcurridos desde una fecha específica hasta la fecha actual (self).
    /// - Parameter date: La fecha de referencia inicial.
    /// - Returns: Número de días enteros de diferencia.
    func daysSince(_ date: Date) -> Int {
        Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    
    /// Indica si la fecha corresponde al día de hoy.
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    /// Indica si la fecha corresponde al día de ayer.
    var isYesterday: Bool {
        Calendar.current.isDateInYesterday(self)
    }
}


