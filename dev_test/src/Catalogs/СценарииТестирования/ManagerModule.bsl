
#Если Сервер Или ВнешнееСоединение Тогда

	Функция РеквизитыВерсии(Сценарий) экспорт

		Рез = Новый Структура("Описание,УсловияДо,Версия,ДатаСодания,Статус,Автор");

		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	т.Описание КАК Описание,
		|	т.УсловияДо КАК УсловияДо,
		|	т.ДатаСоздания КАК ДатаСоздания,
		|	т.Статус КАК Статус,
		|	т.Автор КАК Автор
		|ИЗ
		|	Справочник.ВерсииСценариевТестирования КАК т
		|ГДЕ
		|	т.Ссылка = &Ссылка");
		Запрос.УстановитьПараметр("Ссылка", Сценарий);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ЗаполнитьЗначенияСвойств(Рез, Выборка);
		КонецЕсли;

		Возврат Рез;

	КонецФункции

	Функция ПоследняяВерсия(Сценарий) экспорт

		Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СценарииТестированияВерсии.Код КАК МаксВерсия,
		|	СценарииТестированияВерсии.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ВерсииСценариевТестирования КАК СценарииТестированияВерсии
		|ГДЕ
		|	СценарииТестированияВерсии.Владелец = &Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	МаксВерсия УБЫВ");
		Запрос.УстановитьПараметр("Ссылка", Сценарий);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Возврат Выборка.Ссылка;
		Иначе
			Возврат 0;
		КонецЕсли;

	КонецФункции

	Функция ПредставлениеСценария(Версия) экспорт

		РеквизитыВерсии = РеквизитыВерсии(Версия);

		История = "
			|<HTML>
			|<HEAD>
			|<META content=""text/html; charset=utf-8"" http-equiv=Content-Type></META>
			|<META name=GENERATOR content=""MSHTML 11.00.9600.16518""></META>
			|<STYLE type=""text/css"">
			|   table {
			|		border-collapse: collapse; /*убираем пустые промежутки между ячейками*/
			|		border: 1px solid grey; /*устанавливаем для таблицы внешнюю границу серого цвета толщиной 1px*/}
			|	th {
			|		padding: 10px;
			|		border: 1px solid grey;
			|		font-weight: bold;
			|		}
			|	td {
			|		padding: 10px;
			|		border: 1px solid grey;
			|		}
			|
			|</STYLE>
			|</HEAD>
			|<BODY>";

		История = История + "<b>Статус: </b>" + Строка(РеквизитыВерсии.Статус);

		История = История + "<h4>Описание</h4>";
		стрОписание = РеквизитыВерсии.Описание;
		Если ЗначениеЗаполнено(стрОписание) Тогда
			стрОписание = РаботаСHTML.УдалитьНедопустимыеСимволы(стрОписание);
			стрОписание = РаботаСHTML.ПреобразоватьСтрокуВHTML(стрОписание);
		КонецЕсли;

		История = История + стрОписание;
		История = История + "<br>";
		
		История = История + "<h4>Предварительные условия</h4>";
		
		стрОписание = РеквизитыВерсии.УсловияДо;
		Если ЗначениеЗаполнено(стрОписание) Тогда
			стрОписание = РаботаСHTML.УдалитьНедопустимыеСимволы(стрОписание);
			стрОписание = РаботаСHTML.ПреобразоватьСтрокуВHTML(стрОписание);
		КонецЕсли;
		
		История = История + стрОписание;
		История = История + "<br>";
		
		История = История + ПолучитьПрисоединенныеФайлыHTML(Версия);
		История = История + "<br>";
		
		История = История + "<h4>Шаги</h4>";
		
		История = История + "<table>";
		История = История + "
		|<tr>
		|  <th>№ шага</th>
		|  <th>Действие</th>
		|  <th>Результат</th>
		|  <th>Роль</th>
		|</tr>";
		Для каждого Шаг из Версия.Шаги Цикл
			История = История + "
			|<tr>
			|  <td>" + Шаг.НомерСтроки + "</td>
			|  <td>" + РаботаСHTML.ПреобразоватьСтрокуВHTML(Шаг.Шаг) + "</td>
			|  <td>" + РаботаСHTML.ПреобразоватьСтрокуВHTML(Шаг.Результат) + "</td>
			|  <td>" + РаботаСHTML.ПреобразоватьСтрокуВHTML(Шаг.Роль) + "</td>
			|</tr>";
			
		КонецЦикла;
		
		История = История + "</table>";
		
		История = История + "
		|</BODY></HTML>";

		Возврат История;

	КонецФункции

	Функция ПрисоединенныеФайлыВерсии(Версия) экспорт

		МассивФайлов = Новый Массив;

//		Запрос = Новый Запрос;
//		Запрос.Текст = "ВЫБРАТЬ
//			|	т.ПрисоединенныйФайл КАК ПрисоединенныйФайл
//			|ИЗ
//			|	Справочник.СценарииТестирования.ПрисоединенныеФайлы КАК т
//			|ГДЕ
//			|	т.Ссылка = &Ссылка
//			|	И т.Версия = &Версия";
//
//		Запрос.УстановитьПараметр("Ссылка", Сценарий);
//		Запрос.УстановитьПараметр("Версия", Версия);
//		Выборка = Запрос.Выполнить().Выбрать();
//
//		Пока Выборка.Следующий() Цикл
//			МассивФайлов.Добавить(Выборка.ПрисоединенныйФайл);
//		КонецЦикла;

		Возврат МассивФайлов;

	КонецФункции

	Функция ПолучитьПрисоединенныеФайлыHTML(Версия)

		СтрокаКартинкиСрепка = "data:image/png;base64,"
			+ Base64Строка(БиблиотекаКартинок.КоллекцияСкрепка.ПолучитьДвоичныеДанные());

		МассивФайлов = ПрисоединенныеФайлыВерсии(Версия);

		КоличествоФайлов = МассивФайлов.Количество();
		СтрокаКоличествоФайлов = ?(КоличествоФайлов = 0, "", " (" + КоличествоФайлов
			+ ")");

		стрПрисоединенныеФайлы = Нстр("ru = 'Присоединенные файлы'; en = 'Attached files'");

		Файлы = "<P><A href=""ПрисоединенныеФайлы""><b>" + стрПрисоединенныеФайлы
			+ СтрокаКоличествоФайлов + "</b></A></P>";

		Если КоличествоФайлов > 0 Тогда

			Файлы = Файлы + "<P>";

			Для Каждого Элемент Из МассивФайлов Цикл
				Файлы = Файлы + "<IMG border=0 src=""" + СтрокаКартинкиСрепка
					+ """/> <A href=""ПрисоединенныйФайл" + Элемент.УникальныйИдентификатор()
					+ """>" + Элемент + "</A><br>";
			КонецЦикла;

			Файлы = Файлы + "</p>"
		КонецЕсли;

		Возврат Файлы;

	КонецФункции

#КонецЕсли
