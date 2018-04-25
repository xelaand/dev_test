

//Функция предназначена для получения максимального уровня для иерархических справочников
//	стрИмяСправочника - строка содержащая имя справочника. Например, "Номенклатура"
//	чМаксУровень - максимально возможное значение иерархии
//  Возвращаемое значение - текущее максимальное число уровней иерархии.
//  (при наличие только одной группы вернется значение = 1)
//  (при наличие только одного элемента в справочнике с иерархией элементов вернется значение = 1)
Функция ПолучитьТекущийМаксимальныйУровеньИерархии(ИмяСправочника,МаксУровень=100) экспорт
	стрТаблицы = "Справочник."+ИмяСправочника;
	ОбъектМетаданных = Метаданные.Справочники.Найти(ИмяСправочника);
	Если ОбъектМетаданных = Неопределено Тогда
		//не найдена таблица справочника
		Возврат Неопределено;
	Иначе
		Если  ОбъектМетаданных.ОграничиватьКоличествоУровней Тогда
			МаксУровень = ОбъектМетаданных.КоличествоУровней;
		КонецЕсли;	
	КонецЕсли;
	Запрос = Новый Запрос();
	стрВыбор = "";
	стрРодители="";
	Для Сч=1 По МаксУровень Цикл
		стрРодители = стрРодители+".Родитель";
		стрВыбор = стрВыбор +" КОГДА (ТаблицаCИерархией"+ стрРодители+") ЕСТЬ NULL ТОГДА "+Строка(Сч-1);
	КонецЦикла;		
	ТекстЗапроса = "ВЫБРАТЬ МАКСИМУМ(ВЫБОР "+стрВыбор+" ИНАЧЕ 0 КОНЕЦ) КАК Уровень
	| ИЗ "+стрТаблицы+" КАК ТаблицаCИерархией";
	Если ОбъектМетаданных.ВидИерархии = Метаданные.СвойстваОбъектов.ВидИерархии.ИерархияГруппИЭлементов Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|ГДЕ ТаблицаCИерархией.ЭтоГруппа = ИСТИНА";
	КонецЕсли; 
	Запрос.Текст = ТекстЗапроса;
	Результат = Запрос.Выполнить();				
	Если Результат.Пустой() Тогда
		Возврат 0;
	Иначе
		Выборка = Результат.Выбрать();
		Если Выборка.Следующий() Тогда
			Уровень = Выборка.Уровень;
			Если Уровень=NULL Тогда
				Возврат 0;
			Иначе
				Возврат Уровень;
			КонецЕсли;
		КонецЕсли;
		Возврат 0;
	КонецЕсли;
КонецФункции


Функция КоличествоЭлементовВГруппе(ИмяСправочника) экспорт
	
	МаксУровень = ПолучитьТекущийМаксимальныйУровеньИерархии(ИмяСправочника);
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(т.Ссылка) КАК Кол,
	|	т.Родитель КАК Ссылка,
	|	т.Родитель.Родитель КАК Родитель
	|ПОМЕСТИТЬ г1
	|ИЗ
	|	Справочник."+ИмяСправочника+" КАК т
	|ГДЕ
	|	т.ЭтоГруппа = ЛОЖЬ
	|	И т.ПометкаУдаления = ЛОЖЬ
	|
	|СГРУППИРОВАТЬ ПО
	|	т.Родитель,
	|	т.Родитель.Родитель
	|";
	
	ТекстЗапросаОбъединение = 
	"ВЫБРАТЬ
	|	г1.Ссылка КАК Ссылка,
	|	г1.Кол КАК Кол
	|ПОМЕСТИТЬ КоличествоПоГруппам
	|ИЗ
	|	г1 КАК г1";
	
	Для Индекс = 2 по МаксУровень Цикл
		
		Ур = Формат(Индекс,"ЧГ=");
		УрПред = Формат(Индекс-1,"ЧГ=");
		
		ТекстЗапроса = ТекстЗапроса +
		";
		|ВЫБРАТЬ
		|	г.Ссылка КАК Ссылка,
		|	г.Родитель КАК Родитель,
		|	СУММА(г"+УрПред+".Кол) КАК Кол
		|ПОМЕСТИТЬ г"+Ур+"
		|ИЗ
		|	Справочник."+ИмяСправочника+" КАК г
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ г"+УрПред+" КАК г"+УрПред+"
		|		ПО (г"+УрПред+".Родитель = г.Ссылка)
		|ГДЕ
		|	г.ЭтоГруппа = ИСТИНА
		|	И г.ПометкаУдаления = ЛОЖЬ
		|
		|СГРУППИРОВАТЬ ПО
		|	г.Ссылка,
		|	г.Родитель
		|";
		
		ТекстЗапросаОбъединение = ТекстЗапросаОбъединение +
		"
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	г"+Ур+".Ссылка,
		|	г"+Ур+".Кол
		|ИЗ
		|	г"+Ур+" КАК г"+Ур;

		
	КонецЦикла;	
	
	ТекстЗапроса = ТекстЗапроса + 
	";
	|" + ТекстЗапросаОбъединение+
	"
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КоличествоПоГруппам.Ссылка КАК Ссылка,
	|	СУММА(КоличествоПоГруппам.Кол) КАК Кол
	|ИЗ
	|	КоличествоПоГруппам КАК КоличествоПоГруппам
	|ГДЕ
	|	КоличествоПоГруппам.Ссылка В(&Группы)
	|
	|СГРУППИРОВАТЬ ПО
	|	КоличествоПоГруппам.Ссылка";
	
	
	Возврат ТекстЗапроса;
	
	
КонецФункции	

