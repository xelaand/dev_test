#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура обновляет данные регистра при полном обновлении вспомогательных данных.
// 
// Параметры:
//  ЕстьИзменения - Булево (возвращаемое значение) - если производилась запись,
//                  устанавливается Истина, иначе не изменяется.
//
Процедура ОбновитьДанныеРегистра(ЕстьИзменения = Неопределено) Экспорт
	
	Если Не УправлениеДоступомСлужебный.ОграничиватьДоступНаУровнеЗаписейУниверсально() Тогда
		Возврат;
	КонецЕсли;
	
	УправлениеДоступомСлужебный.ДействующиеПараметрыОграниченияДоступа(Неопределено,
		Ложь, Истина, ЕстьИзменения);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
