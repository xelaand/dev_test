#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиОбновления

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра             = "РегистрСведений.НастройкиОбменаДаннымиXDTO";
	
	ТаблицаУзлыОбмена = ОбменДаннымиСервер.УзлыОбменаБСП();
	
	УзлыОбменаНеXDTO = Новый Массив;
	Для Каждого СтрокаУзлыОбменаБСП Из ТаблицаУзлыОбмена Цикл
		ИмяПланаОбмена = ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(СтрокаУзлыОбменаБСП.УзелИнформационнойБазы);
		Если ОбменДаннымиПовтИсп.ЭтоПланОбменаXDTO(ИмяПланаОбмена) Тогда
			Продолжить;
		КонецЕсли;
		
		УзлыОбменаНеXDTO.Добавить(СтрокаУзлыОбменаБСП);
	КонецЦикла;
	
	Для Каждого УзелОбменаНеXDTO Из УзлыОбменаНеXDTO Цикл
		ТаблицаУзлыОбмена.Удалить(УзелОбменаНеXDTO);
	КонецЦикла;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТаблицаУзлыОбмена.УзелИнформационнойБазы КАК УзелИнформационнойБазы
	|ПОМЕСТИТЬ ВТУзлыОбмена
	|ИЗ
	|	&ТаблицаУзлыОбмена КАК ТаблицаУзлыОбмена
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТУзлыОбмена.УзелИнформационнойБазы КАК УзелИнформационнойБазы
	|ИЗ
	|	ВТУзлыОбмена КАК ВТУзлыОбмена
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиОбменаДаннымиXDTO КАК НастройкиОбменаДаннымиXDTO
	|		ПО (НастройкиОбменаДаннымиXDTO.УзелИнформационнойБазы = ВТУзлыОбмена.УзелИнформационнойБазы)
	|ГДЕ
	|	(НастройкиОбменаДаннымиXDTO.УзелИнформационнойБазы ЕСТЬ NULL
	|			ИЛИ НастройкиОбменаДаннымиXDTO.ИмяПланаОбменаКорреспондента = """")");
	Запрос.УстановитьПараметр("ТаблицаУзлыОбмена", ТаблицаУзлыОбмена);
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Результат, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ОбработкаЗавершена = Истина;
	
	МетаданныеРегистра    = Метаданные.РегистрыСведений.НастройкиОбменаДаннымиXDTO;
	ПолноеИмяРегистра     = МетаданныеРегистра.ПолноеИмя();
	ПредставлениеРегистра = МетаданныеРегистра.Представление();
	ПредставлениеОтбора   = НСтр("ru = 'УзелИнформационнойБазы = ""%1""'");
	
	ДополнительныеПараметрыВыборкиДанныхДляОбработки = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыВыборкиДанныхДляОбработки();
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьИзмеренияНезависимогоРегистраСведенийДляОбработки(
		Параметры.Очередь, ПолноеИмяРегистра, ДополнительныеПараметрыВыборкиДанныхДляОбработки);
	
	Обработано = 0;
	Проблемных = 0;
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		Попытка
			
			УзелИнформационнойБазы = Выборка.УзелИнформационнойБазы;
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра);
			ЭлементБлокировки.УстановитьЗначение("УзелИнформационнойБазы", УзелИнформационнойБазы);
			Блокировка.Заблокировать();
			
			НаборЗаписей = СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.УзелИнформационнойБазы.Установить(УзелИнформационнойБазы);
			
			ПредставлениеОтбора = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ПредставлениеОтбора,
				УзелИнформационнойБазы);
			
			НаборЗаписей.Прочитать();
			
			Если НаборЗаписей.Количество() > 0 Тогда
				ТекущаяЗапись = НаборЗаписей[0];
			Иначе
				ТекущаяЗапись = НаборЗаписей.Добавить();
				ТекущаяЗапись.УзелИнформационнойБазы = УзелИнформационнойБазы;
			КонецЕсли;
			
			ТекущаяЗапись.ИмяПланаОбменаКорреспондента = ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(УзелИнформационнойБазы);
			
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			
			Обработано = Обработано + 1;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			Проблемных = Проблемных + 1;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обработать набор записей регистра ""%1"" с отбором %2 по причине:
				|%3'"), ПредставлениеРегистра, ПредставлениеОтбора, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеРегистра, , ТекстСообщения);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Если Не ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяРегистра) Тогда
		ОбработкаЗавершена = Ложь;
	КонецЕсли;
	
	Если Обработано = 0 И Проблемных <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедуре РегистрыСведений.НастройкиОбменаДаннымиXDTO.ОбработатьДанныеДляПереходаНаНовуюВерсию не удалось обработать некоторые записи узлов обмена (пропущены): %1'"), 
			Проблемных);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,
			, ,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедура РегистрыСведений.НастройкиОбменаДаннымиXDTO.ОбработатьДанныеДляПереходаНаНовуюВерсию обработала очередную порцию записей: %1'"),
			Обработано));
	КонецЕсли;
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли