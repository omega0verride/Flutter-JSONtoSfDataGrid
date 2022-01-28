import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  DemoState createState() => DemoState();
}

class DemoState extends State<App> {
  late JSONDataSource dataGridSource;

  @override
  void initState() {
    super.initState();
    dataGridSource =
        JSONDataSource(); // create a grid data source with the data
    dataGridSource.getData(); // get the data through a get request
    // dataGridSource.getLocalExample(); // get the local data
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('JSON to Flutter SfDataGrid'),
          ),
          body: Column(children: <Widget>[
            Expanded(
                child: SfDataGrid(
                  // set the data source
                  source: dataGridSource,
                  // set the column width by calculating the max size among the header cell and among the cells in column.
                  columnWidthMode: ColumnWidthMode.auto,
                  // make sure the property above (columnWidthMode.auto) is applied in all rows
                  columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
                  // add the columns array to the grid
                  columns: dataGridSource.gridColumnsList,
                  // *note that whatever changes you do to the data do not change
                  // the array/list or assign another list to columns property
                  // because it will change the address and the changes will
                  // not be reflected, this reference should never change, modify
                  // the list directly*
                )),
          ]),
        ));
  }
}

class JSONDataSource extends DataGridSource {
  // create an empty grid column list, it will be populated with data later on
  List<GridColumn> gridColumnsList = [];

  // create empty grid row list, it will be populated with data later on
  List<DataGridRow> dataRows = [];

  // *note that whatever changes you do to the data do not change
  // the array/list or assign another list to columns property
  // because it will change the address and the changes will
  // not be reflected, this reference should never change, modify
  // the list directly*

  var data; // variable to hold json data

  JSONDataSource([var data]) {
    // data is optional since you can create the source without initial data
    if (data != null) {
      // update only if data is not null
      updateData(data: data);
    }
  }

  void updateData({required var data}) {
    // get array of keys
    generateColumns(data[0].keys.toList());
    dataRows.clear(); // remove the previous data and add the new one

    for (var row in data) {
      List<DataGridCell> _cells = [];
      for (var key in row.keys.toList()) {
        _cells.add(DataGridCell(columnName: key.toString(), value: row[key]));
      }
      dataRows.add(DataGridRow(cells: _cells));
    }

    notifyListeners(); // signal an update
  }

  // generate the list of grd columns based on the array of table headers
  void generateColumns(var headers) {
    gridColumnsList.clear();
    for (var h in headers) {
      gridColumnsList.add(
        GridColumn(
            columnName: h.toString(),
            autoFitPadding: EdgeInsets.all(12.0),
            label: Container(
                padding: EdgeInsets.all(12.0),
                alignment: Alignment.center,
                child: Text(
                  h.toString(),
                ))),
      );
    }
  }

  // get local json for testing
  List<Map> getLocalExample() {
    var d = [
      {"userId": 1, "id": 1, "title": "quidem molestiae enim"},
      {"userId": 1, "id": 2, "title": "sunt qui excepturi placeat culpa"},
      {"userId": 1, "id": 3, "title": "omnis laborum odio"},
      {
        "userId": 1,
        "id": 4,
        "title": "non esse culpa molestiae omnis sed optio"
      },
      {"userId": 1, "id": 5, "title": "eaque aut omnis a"},
      {"userId": 1, "id": 6, "title": "natus impedit quibusdam illo est"},
      {"userId": 1, "id": 7, "title": "quibusdam autem aliquid et et quia"},
      {"userId": 1, "id": 8, "title": "qui fuga est a eum"},
      {"userId": 1, "id": 9, "title": "saepe unde necessitatibus rem"},
      {"userId": 1, "id": 10, "title": "distinctio laborum qui"},
      {
        "userId": 2,
        "id": 11,
        "title": "quam nostrum impedit mollitia quod et dolor"
      },
      {
        "userId": 2,
        "id": 12,
        "title": "consequatur autem doloribus natus consectetur"
      }
    ];
    data = d;
    updateData(data: data);
    return data;
  }

  // make get request to get json data
  void getData() async {
    var url = Uri.parse('https://jsonplaceholder.typicode.com/albums');
    get(url).then((Response response) {
      data = jsonDecode(response.body);
      updateData(data: data);
    });
  }

  @override
  List<DataGridRow> get rows => dataRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(12.0),
            child: Text(
              e.value.toString(),
            ),
          );
        }).toList());
  }
}