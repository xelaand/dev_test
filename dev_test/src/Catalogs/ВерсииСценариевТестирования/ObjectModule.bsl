
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕСли;	
	
	Если НЕ ЗначениеЗаполнено(Автор) Тогда
		Автор = ПользователиКлиентСервер.ТекущийПользователь();
	КонецЕсли;	
	Если НЕ ЗначениеЗаполнено(ДатаСоздания) Тогда
		ДатаСоздания = Текущаядата();
	КонецЕсли;	
КонецПроцедуры
