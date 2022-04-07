import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterhomejobs/bloc/group_bottom_navigation_bloc.dart';
import 'package:flutterhomejobs/bloc/group_bottom_navigation_state.dart';
import 'package:flutterhomejobs/bloc/group_bottom_navigation_event.dart';
import 'package:flutterhomejobs/common/loading_indicator.dart';
import 'package:flutterhomejobs/model/group.dart';
import 'package:flutterhomejobs/payment/payment_create_page.dart';
import 'package:flutterhomejobs/payment/payment_list_item_widget.dart';
import 'package:flutterhomejobs/repository/group_repository.dart';
import 'package:pie_chart/pie_chart.dart';

class GroupDetailsPage extends StatefulWidget {
  final Group item;
  final GroupRepository groupRepository;

  GroupDetailsPage(this.groupRepository, this.item);

  @override
  _GroupDetailsPageState createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  Future<Null> _handleRefresh() async {
    BlocProvider.of<GroupBottomNavigationBloc>(context)
        .dispatch(PaymentDataLoading(this.widget.item.walletId));
    print("refresh");
    return null;
  }

  Future<Group> item;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupBottomNavigationBloc, GroupBottomNavigationState>(
        builder: (context, state) {
      if (state is PaymentDataUninitialized) {
        BlocProvider.of<GroupBottomNavigationBloc>(context)
            .dispatch(PaymentDataLoading(this.widget.item.walletId));
        return Center(
          child: LoadingIndicator(),
        );
      }

      var children = new List<Widget>();
      double sum = 0;
      double diff = 0;
      Color diffColor = Colors.green;
      var chart;

      if (state is PaymentDataError) {
        children.add(Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.error, color: Colors.red, size: 48),
                Text('Fehler beim Abfragen der Ausgaben!'),
                Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                RaisedButton(
                  child: Text('Neu laden'),
                  onPressed: _handleRefresh,
                )
              ]),
        ));
      } else if (state is PaymentDataLoaded) {
        if (state.items.isEmpty) {
          children.add(Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.check, color: Colors.green, size: 48),
                  Text('Keine Ausgaben vorhanden!'),
                  Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                  RaisedButton(
                    child: Text('Neu laden'),
                    onPressed: _handleRefresh,
                  )
                ]),
          ));
        } else {
          children.add(Flexible(
              child: SafeArea(
                  child: RefreshIndicator(
                      onRefresh: _handleRefresh,
                      child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                          padding: new EdgeInsets.symmetric(vertical: 8.0),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            if (index >= state.items.length) {
                              return null;
                            }

                            return PaymentListItemWidget(
                              paymentRepository:
                                  BlocProvider.of<GroupBottomNavigationBloc>(
                                          context)
                                      .paymentRepository,
                              item: state.items[index],
                              groupBottomNavigationBloc:
                                  BlocProvider.of<GroupBottomNavigationBloc>(
                                      context),
                            );
                          },
                          itemCount: state.items.length)))));

          Map<String, double> dataMap = new Map();
          List<Color> colorList = new List();

          for (int i = 0; i < state.items.length; i++) {
            dataMap[state.items[i].paymentCategory.name] = 0;
            if (!colorList.contains(hexToColor(state.items[i].paymentCategory.color))) {
              colorList.add(hexToColor(state.items[i].paymentCategory.color));
            }
          }

          for (int i = 0; i < state.items.length; i++) {
            sum += state.items[i].amount;
            dataMap[state.items[i].paymentCategory.name] += state.items[i].amount;
          }

          diff = this.widget.item.budget - sum;

          if (diff < 0) {
            diffColor = Colors.red;
          }

          chart = PieChart(
            dataMap: dataMap,
            animationDuration: Duration(milliseconds: 800),
            chartLegendSpacing: 32.0,
            chartRadius: MediaQuery.of(context).size.width / 2.7,
            showChartValuesInPercentage: false,
            showChartValues: true,
            showChartValuesOutside: false,
            chartValueBackgroundColor: Colors.grey[200],
            showLegends: true,
            legendPosition: LegendPosition.right,
            decimalPlaces: 2,
            colorList: colorList,
            showChartValueLabel: true,
            initialAngle: 0,
            chartValueStyle: defaultChartValueStyle.copyWith(
              color: Colors.blueGrey[900].withOpacity(0.9),
            ),
            chartType: ChartType.ring,
          );
        }
      }

      if (_selectedIndex == 0) {
        return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Ausgaben: ' + widget.item.name),
                bottom: TabBar(
                  tabs: <Widget>[
                    Tab(text: 'Details'),
                    Tab(text: 'Übersicht'),
                  ],
                ),
              ),
              body: TabBarView(children: [
                Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: children),
                ),
                Container(
                    child: Column(
                      children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: chart,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('Gesamt'),
                          ),
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(sum.toStringAsFixed(2) + ' €', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Text('Budget'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(this.widget.item.budget.toStringAsFixed(2) + ' €', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                      ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Text('Differenz'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(diff.toStringAsFixed(2) + ' €', style: TextStyle(fontWeight: FontWeight.bold, color: diffColor)),
                            ),
                      ]),
                  ],
                ))
              ]),
              bottomNavigationBar: BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.payment),
                      title: Text('Ausgaben'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.group),
                      title: Text('Mitglieder'),
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: Colors.amber[800],
                  onTap: _onItemTapped),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: createPayment,
                label: Text('Ausgabe erstellen'),
                icon: Icon(Icons.add),
                backgroundColor: Colors.amber[800],
              ),
            ));
      } else {
        return Scaffold(
          appBar: AppBar(
            title: Text('Mitglieder: ' + widget.item.name),
          ),
          body: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.payment),
                  title: Text('Ausgaben'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.group),
                  title: Text('Mitglieder'),
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.amber[800],
              onTap: _onItemTapped),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: addMember,
            label: Text('Mitglied hinzufügen'),
            icon: Icon(Icons.add),
            backgroundColor: Colors.amber[800],
          ),
        );
      }
    });
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      _selectedIndex = 0;
      BlocProvider.of<GroupBottomNavigationBloc>(context)
          .dispatch(PaymentGroupBottomNavigation());
    }
    if (index == 1) {
      _selectedIndex = 1;
      BlocProvider.of<GroupBottomNavigationBloc>(context)
          .dispatch(MemberGroupBottomNavigation());
    }
  }

  void createPayment() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentCreatePage(
                BlocProvider.of<GroupBottomNavigationBloc>(context)
                    .paymentRepository,
                BlocProvider.of<GroupBottomNavigationBloc>(context),
                this.widget.item.walletId)));
  }

  void addMember() {
    return;
  }

  @override
  void initState() {
    this.item = this.widget.groupRepository.getGroup(this.widget.item.id);
    _handleRefresh();
    super.initState();
  }

  /// Construct a color from a hex code string, of the format #RRGGBB.
  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
