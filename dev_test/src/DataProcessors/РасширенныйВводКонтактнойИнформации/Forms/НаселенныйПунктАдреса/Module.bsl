//// Форма параметризуется:
////
////      ИдентификаторНаселенногоПункта    - УникальныйИдентификатор - Идентификатор текущего объекта для определения и
////                                                                    редактирования частей формы.
////      НаселенныйПунктДетально           - Структура               - Описание населенного пункта в терминах варианта
////                                                                    классификатора. Используется, если не указан
////                                                                    идентификатор.
////      ФорматАдреса - Строка - Вариант адресного  классификатора,
////      СкрыватьНеактуальныеАдреса        - Булево - Флаг того, что при редактировании неактуальные адреса будут
////                                                   скрываться.
////      СервисКлассификатораНедоступен    - Булево - Необязательный флаг того, что поставщик на обслуживании.
////
////  Результат выбора:
////      Структура - поля:
////          * Идентификатор           - УникальныйИдентификатор - Выбранный населенный пункт.
////          * Представление           - Строка                  - Представление выбранного.
////          * НаселенныйПунктДетально - Структура               - Отредактированное описание населенного пункта.
////
//// -------------------------------------------------------------------------------------------------

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("НаселенныйПунктДетально", НаселенныйПунктДетально);
	ИспользоватьАвтоподбор = Истина;
	Если НаселенныйПунктДетально <> Неопределено Тогда
		
		ТипАдреса = НаселенныйПунктДетально.AddressType;
		Если НаселенныйПунктДетально.Свойство("Country")
			 И РаботаСАдресамиКлиентСервер.ЭтоОсновнаяСтрана(НаселенныйПунктДетально.Country) Тогда
			
			МуниципальныйРайон   = ПредставлениеУровняАдреса(НаселенныйПунктДетально, "MunDistrict", Ложь);
			Поселение            = ПредставлениеУровняАдреса(НаселенныйПунктДетально, "Settlement");
			ВнутригородскойРайон = ПредставлениеУровняАдреса(НаселенныйПунктДетально, "CityDistrict");
			Территория           = ПредставлениеУровняАдреса(НаселенныйПунктДетально, "Territory");
		Иначе
			ИспользоватьАвтоподбор = Ложь;
		КонецЕсли;
		
		Регион               = ПредставлениеУровняАдреса(НаселенныйПунктДетально, "Area");
		Район                = ПредставлениеУровняАдреса(НаселенныйПунктДетально, "District");
		НаселенныйПункт      = ПредставлениеУровняАдреса(НаселенныйПунктДетально, "Locality");
		Город                = ПредставлениеУровняАдреса(НаселенныйПунктДетально, "City");

	Иначе
		ТипАдреса = "Муниципальный";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОтобразитьПоляПоТипуАдреса();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипАдресаПриИзменении(Элемент)
	
	НаселенныйПунктДетально.AddressType = ?(ТипАдреса = "Муниципальный", РаботаСАдресамиКлиентСервер.МуниципальныйАдрес(), РаботаСАдресамиКлиентСервер.АдминистративноТерриториальныйАдрес());
	ОтобразитьПоляПоТипуАдреса();
	
КонецПроцедуры

&НаКлиенте
Процедура СубъектРФАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	АвтоПодборПоУровню(Текст, ДанныеВыбора, "Area", СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура РайонАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	АвтоПодборПоУровню(Текст, ДанныеВыбора, "District", СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура МуниципальныйРайонАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	АвтоПодборПоУровню(Текст, ДанныеВыбора, "MunDistrict", СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ГородАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	АвтоПодборПоУровню(Текст, ДанныеВыбора, "City", СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПоселениеАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	АвтоПодборПоУровню(Текст, ДанныеВыбора, "Settlement", СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ВнутригородскойРайонАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	АвтоПодборПоУровню(Текст, ДанныеВыбора, "CityDistrict", СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура НаселенныйПунктАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	АвтоПодборПоУровню(Текст, ДанныеВыбора, "Locality", СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ТерриторияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	АвтоПодборПоУровню(Текст, ДанныеВыбора, "Territory", СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура СубъектРФНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОткрытьФормуВыбораАдресныхОбъектов(Элемент, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура РайонНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОткрытьФормуВыбораАдресныхОбъектов(Элемент, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура МуниципальныйРайонНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОткрытьФормуВыбораАдресныхОбъектов(Элемент, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПоселениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОткрытьФормуВыбораАдресныхОбъектов(Элемент, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ГородНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОткрытьФормуВыбораАдресныхОбъектов(Элемент, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ВнутригородскойРайонНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОткрытьФормуВыбораАдресныхОбъектов(Элемент, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура НаселенныйПунктНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОткрытьФормуВыбораАдресныхОбъектов(Элемент, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ТерриторияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОткрытьФормуВыбораАдресныхОбъектов(Элемент, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура СубъектРФОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура РайонОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура МуниципальныйРайонОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ГородОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПоселениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ВнутригородскойРайонОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура НаселенныйПунктОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ТерриторияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура СубъектРФПриИзменении(Элемент)
	ИзменитьУровеньАдреса("Area", Регион);
КонецПроцедуры

&НаКлиенте
Процедура РайонПриИзменении(Элемент)
	ИзменитьУровеньАдреса("District", Район);
КонецПроцедуры

&НаКлиенте
Процедура МуниципальныйРайонПриИзменении(Элемент)
	ИзменитьУровеньАдреса("MunDistrict", МуниципальныйРайон);
КонецПроцедуры

&НаКлиенте
Процедура ГородПриИзменении(Элемент)
	ИзменитьУровеньАдреса("City", Город);
КонецПроцедуры

&НаКлиенте
Процедура ПоселениеПриИзменении(Элемент)
	ИзменитьУровеньАдреса("Settlement", Поселение);
КонецПроцедуры

&НаКлиенте
Процедура ВнутригородскойРайонПриИзменении(Элемент)
	ИзменитьУровеньАдреса("CityDistrict", ВнутригородскойРайон);
КонецПроцедуры

&НаКлиенте
Процедура НаселенныйПунктПриИзменении(Элемент)
	ИзменитьУровеньАдреса("Locality", НаселенныйПункт);
КонецПроцедуры

&НаКлиенте
Процедура ТерриторияПриИзменении(Элемент)
	ИзменитьУровеньАдреса("Territory", Территория);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	Закрыть(НаселенныйПунктДетально);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ИмяУровняПоНазваниюЭлемента(ИмяЭлемента)
	
	ИменаУровней = Новый Соответствие;
	ИменаУровней.Вставить("СубъектРФ", "Area");
	ИменаУровней.Вставить("Район", "District");
	ИменаУровней.Вставить("МуниципальныйРайон", "MunDistrict");
	ИменаУровней.Вставить("Город", "City");
	ИменаУровней.Вставить("Поселение", "Settlement");
	ИменаУровней.Вставить("ВнутригородскойРайон", "CityDistrict");
	ИменаУровней.Вставить("НаселенныйПункт", "Locality");
	ИменаУровней.Вставить("Территория", "Territory");
	
	Возврат ИменаУровней[ИмяЭлемента];
	
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуВыбораАдресныхОбъектов(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ИмяУровня = ИмяУровняПоНазваниюЭлемента(Элемент.Имя);
	
	РодительскийИдентификатор = ИдентификаторРодителяУровняАдреса(ИмяУровня, НаселенныйПунктДетально, ТипАдреса);
	Уровень = РаботаСАдресамиКлиентСервер.СопоставлениеНаименованиеУровнюАдреса(ИмяУровня);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ТипАдреса", ТипАдреса);
	ПараметрыОткрытия.Вставить("Уровень",   Уровень);
	ПараметрыОткрытия.Вставить("Родитель",  РодительскийИдентификатор);
	
	ОткрытьФорму("Обработка.РасширенныйВводКонтактнойИнформации.Форма.ВыборАдресаПоУровню", ПараметрыОткрытия, Элемент);
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОпределитьПоляАдреса()
	
	Регион               = ПредставлениеУровняАдреса(НаселенныйПунктДетально, "Area");
	Район                = ПредставлениеУровняАдреса(НаселенныйПунктДетально, "District");
	МуниципальныйРайон   = ПредставлениеУровняАдреса(НаселенныйПунктДетально, "MunDistrict");
	Город                = ПредставлениеУровняАдреса(НаселенныйПунктДетально, "City");
	Поселение            = ПредставлениеУровняАдреса(НаселенныйПунктДетально, "Settlement");
	ВнутригородскойРайон = ПредставлениеУровняАдреса(НаселенныйПунктДетально, "CityDistrict");
	НаселенныйПункт      = ПредставлениеУровняАдреса(НаселенныйПунктДетально, "Locality");
	Территория           = ПредставлениеУровняАдреса(НаселенныйПунктДетально, "Territory");

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеУровняАдреса(Адрес, ИмяУровня, ДобавлятьСокращение = Истина)
	
	Если Адрес.Свойство(ИмяУровня) И ЗначениеЗаполнено(Адрес[ИмяУровня]) Тогда
		Если ДобавлятьСокращение Тогда
			Сокращение = ?(ПустаяСтрока(Адрес[ИмяУровня +"Type"]), "", " " + Адрес[ИмяУровня +"Type"]);
			Возврат Адрес[ИмяУровня] + Сокращение;
		Иначе
			Возврат Адрес[ИмяУровня];
		КонецЕсли;
	КонецЕсли;
	
	Возврат "";
КонецФункции

&НаКлиенте
Процедура ОтобразитьПоляПоТипуАдреса()
	
	Если СтрСравнить(УправлениеКонтактнойИнформациейКлиентСервер.АдресЕАЭС(), ТипАдреса) <> 0 Тогда
		
		ЭтоМуниципальныйАдрес = РаботаСАдресамиКлиентСервер.ЭтоМуниципальныйАдрес(ТипАдреса);
		Элементы.Район.Видимость              = НЕ ЭтоМуниципальныйАдрес;
		Элементы.Город.Видимость              = НЕ ЭтоМуниципальныйАдрес;
		Элементы.МуниципальныйРайон.Видимость = ЭтоМуниципальныйАдрес;
		Элементы.Поселение.Видимость          = ЭтоМуниципальныйАдрес;
		
	Иначе
		
		Элементы.ТипАдреса.Видимость           = Ложь;
		Элементы.МуниципальныйРайон.Видимость  = Ложь;
		Элементы.Поселение.Видимость           = Ложь;
		Элементы.ВнутригородскойРайон.Видимость = Ложь;
		Элементы.Территория.Видимость           = Ложь;
		Элементы.СубъектРФ.Заголовок = НСтр("ru='Регион'");
		Элементы.СубъектРФ.КнопкаВыбора = Ложь;
		Элементы.Район.КнопкаВыбора = Ложь;
		Элементы.Город.КнопкаВыбора = Ложь;
		Элементы.НаселенныйПункт.КнопкаВыбора = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АвтоПодборПоУровню( Знач Текст, ДанныеВыбора, ИмяУровня, СтандартнаяОбработка)
	
	Если ИспользоватьАвтоподбор И ЗначениеЗаполнено(Текст) Тогда
		
		ДанныеВыбора = АвтоПодборВариантов(Текст, ИмяУровня, ТипАдреса, НаселенныйПунктДетально);
		СтандартнаяОбработка = НЕ ДанныеВыбора.Количество() > 0;
		Модифицированность = Истина;
		
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция АвтоПодборВариантов(Текст, ИмяУровня, ТипАдреса, НаселенныйПунктДетально)
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Если ЗначениеЗаполнено(Текст) Тогда
		
		РодительскийИдентификатор = ИдентификаторРодителяУровняАдреса(ИмяУровня, НаселенныйПунктДетально, ТипАдреса);
		
		Если НЕ ЗначениеЗаполнено(РодительскийИдентификатор) И СтрСравнить(ИмяУровня, "Area") <> 0 Тогда
			Возврат ДанныеВыбора;
		КонецЕсли;
		
		Уровень = РаботаСАдресамиКлиентСервер.СопоставлениеНаименованиеУровнюАдреса(ИмяУровня);
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Идентификатор", РодительскийИдентификатор);
		ДополнительныеПараметры.Вставить("ТипАдреса", ТипАдреса);
		ДополнительныеПараметры.Вставить("Уровень", Уровень);
		
		МодульАдресныйКлассификаторСлужебный = ОбщегоНазначения.ОбщийМодуль("АдресныйКлассификаторСлужебный");
		Результат = МодульАдресныйКлассификаторСлужебный.АдресныеОбъектыУровня(РодительскийИдентификатор, Уровень, ТипАдреса, Текст);
		Если Не Результат.Отказ Тогда
			ДанныеВыбора = Результат.Данные;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ДанныеВыбора;
	
КонецФункции

&НаСервереБезКонтекста
Функция ИдентификаторРодителяУровняАдреса(Знач ИмяУровня, Знач НаселенныйПунктДетально, Знач ТипАдреса)
	
	РодительскийИдентификатор = Неопределено;
	ИменаУровнейАдреса = РаботаСАдресамиКлиентСервер.ИменаУровнейАдреса(ТипАдреса, Ложь);
	Для каждого УровеньАдреса Из ИменаУровнейАдреса Цикл
		Если УровеньАдреса = ИмяУровня Тогда
			Возврат РодительскийИдентификатор;
		КонецЕсли;
		Если ЗначениеЗаполнено(НаселенныйПунктДетально[УровеньАдреса + "ID"]) Тогда
			РодительскийИдентификатор = НаселенныйПунктДетально[УровеньАдреса + "ID"];
		КонецЕсли;
	КонецЦикла;
	
	Возврат РодительскийИдентификатор;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаВыбора(Элемент, Знач ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ПустаяСтрока(ВыбранноеЗначение) Тогда
		ТекстПредупреждения = НСтр("ru = 'Выбор из списка недоступен, т.к в адресном классификаторе отсутствует информация о адресных сведениях.'");
		ПоказатьПредупреждение(, ТекстПредупреждения );
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура")
		 И ВыбранноеЗначение.Свойство("Идентификатор")
		 И ПустаяСтрока(ВыбранноеЗначение.Идентификатор) Тогда
		 СтандартнаяОбработка = Ложь;
			Возврат;
	КонецЕсли;
	
	СведенияОбАдресе = Новый Структура();
	СведенияОбАдресе.Вставить("Муниципальный", РаботаСАдресамиКлиентСервер.ЭтоМуниципальныйАдрес(ТипАдреса));
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		Если ВыбранноеЗначение.Отказ Или ПустаяСтрока(ВыбранноеЗначение.Идентификатор) Тогда
			Возврат;
		КонецЕсли;
		
		Идентификатор = ВыбранноеЗначение.Идентификатор;
		
	Иначе
		Идентификатор = ВыбранноеЗначение;
	КонецЕсли;
	СведенияОбАдресе.Вставить("Идентификатор", Идентификатор);
	
	СтандартнаяОбработка = Ложь;
	НаселенныйПунктДетально = НаселенныйПунктДетальноПоИдентификатору(СведенияОбАдресе);
	ОпределитьПоляАдреса();
	Элемент.ОбновитьТекстРедактирования();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НаселенныйПунктДетальноПоИдентификатору(ИдентификаторНаселенногоПункта)
	Возврат Обработки.РасширенныйВводКонтактнойИнформации.СписокРеквизитовНаселенныйПункт(ИдентификаторНаселенногоПункта);
КонецФункции

&НаКлиенте
Процедура ИзменитьУровеньАдреса(ИмяУровня, Значение)
	
	НаименованиеСокращение = УправлениеКонтактнойИнформациейКлиентСервер.НаименованиеСокращение(Значение);
	
	НаселенныйПунктДетально[ИмяУровня]          = НаименованиеСокращение.Наименование;
	НаселенныйПунктДетально[ИмяУровня + "Type"] = НаименованиеСокращение.Сокращение;
	НаселенныйПунктДетально[ИмяУровня + "ID"]   = "";
	
КонецПроцедуры

#КонецОбласти