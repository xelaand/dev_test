

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПараметрыЦентраМониторинга = Новый Структура("КонтактнаяИнформация, КонтактнаяИнформацияКомментарий");
	ПараметрыЦентраМониторинга = ЦентрМониторингаСлужебный.ПолучитьПараметрыЦентраМониторинга(ПараметрыЦентраМониторинга);
	Контакты = ПараметрыЦентраМониторинга.КонтактнаяИнформация;
	Комментарий = ПараметрыЦентраМониторинга.КонтактнаяИнформацияКомментарий;
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей") Тогда
		МодульИнтернетПоддержкаПользователей = ОбщегоНазначения.ОбщийМодуль("ИнтернетПоддержкаПользователей");
		ДанныеАутентификации = МодульИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
		Если ДанныеАутентификации <> Неопределено Тогда
			Логин = ДанныеАутентификации.Логин;
		КонецЕсли;
	КонецЕсли;
	Если Параметры.Свойство("ПоЗапросу") Тогда
		ПоЗапросу = Истина;
		Элементы.Заголовок.Заголовок = НСтр("ru = 'Ранее Вы подписались на отправку анонимных обезличенных отчетов об использовании программы. В результате анализа предоставленных отчетов выявлены проблемы производительности. Если Вы готовы предоставить фирме ""1С"" копию Вашей информационной базы (может быть обезличена) для расследования проблем производительности, пожалуйста, укажите свои контактные данные, чтобы сотрудники фирмы ""1С"" могли с Вами связаться.
                                             |Если Вы откажетесь, никакие идентификационные данные не будут отправлены.'");
		Элементы.ФормаОтправить.Заголовок = НСтр("ru = 'Отправить контактную информацию'");
	Иначе
		Элементы.Комментарий.ПодсказкаВвода = НСтр("ru = 'Опишите проблему'");
		Элементы.ФормаОтказаться.Видимость = Ложь;
		Элементы.Контакты.АвтоОтметкаНезаполненного = Истина;
		Элементы.Комментарий.АвтоОтметкаНезаполненного = Истина;
	КонецЕсли;
	СброситьРазмерыИПоложениеОкна();    	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отправить(Команда) 
	Если Не КорректноЗаполнена() Тогда
		Возврат;
	КонецЕсли;
	НовыеПараметры = Новый Структура;
	НовыеПараметры.Вставить("ЗапросКонтактнойИнформации", 1);
	НовыеПараметры.Вставить("КонтактнаяИнформация", Контакты);
	НовыеПараметры.Вставить("КонтактнаяИнформацияКомментарий", Комментарий);
	НовыеПараметры.Вставить("ЛогинПортала", Логин);
	УстановитьПараметрыЦентраМониторинга(НовыеПараметры);
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура Отказаться(Команда)
	НовыеПараметры = Новый Структура;
	НовыеПараметры.Вставить("ЗапросКонтактнойИнформации", 0);
	НовыеПараметры.Вставить("КонтактнаяИнформация", "");
	НовыеПараметры.Вставить("КонтактнаяИнформацияКомментарий", Комментарий);
	УстановитьПараметрыЦентраМониторинга(НовыеПараметры);
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция КорректноЗаполнена()
	РезультатПроверки = Истина;
	Если ПоЗапросу Тогда
		Если ПустаяСтрока(Контакты)Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указана контактная информация.'"),,"Контакты");
			РезультатПроверки = Ложь;
		КонецЕсли; 
	Иначе 
		Если ПустаяСтрока(Контакты)Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указана контактная информация.'"),,"Контакты");
			РезультатПроверки = Ложь;
		КонецЕсли; 
		Если ПустаяСтрока(Комментарий)Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполнен комментарий.'"),,"Комментарий");
			РезультатПроверки = Ложь;
		КонецЕсли; 
	КонецЕсли;                	
	Возврат РезультатПроверки;		
КонецФункции

&НаСервере
Процедура СброситьРазмерыИПоложениеОкна()
	КлючСохраненияПоложенияОкна = ?(ПоЗапросу, "ПоЗапросу", "Самостоятельный");
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьПараметрыЦентраМониторинга(НовыеПараметры)
	ЦентрМониторингаСлужебный.УстановитьПараметрыЦентраМониторингаВнешнийВызов(НовыеПараметры);
КонецПроцедуры

#КонецОбласти