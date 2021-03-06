
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем СтароеЗначение;

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	СтароеЗначение = Константы.ОграничиватьДоступНаУровнеЗаписейУниверсально.Получить();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Значение <> СтароеЗначение Тогда // Изменено.
		// Обновление параметров сеанса.
		// Требуется для того, чтобы администратор не выполнял перезапуск.
		УстановленныеПараметры = Новый Массив;
		УправлениеДоступомСлужебный.УстановкаПараметровСеанса("", УстановленныеПараметры);
	КонецЕсли;
	
	Если Значение И Не СтароеЗначение Тогда // Включено.
		УправлениеДоступомСлужебный.УстановитьОбновлениеДоступа(Истина);
	КонецЕсли;
	
	Если Не Значение И СтароеЗначение Тогда // Выключено.
		УправлениеДоступомСлужебный.ВключитьЗаполнениеДанныхДляОграниченияДоступа();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
