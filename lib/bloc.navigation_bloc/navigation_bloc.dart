import 'package:bloc/bloc.dart';
import '../screens/events_screen.dart';
import '../screens/logout_screen.dart';
import '../screens/read_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/write_screen.dart';
import '../screens/dashboard_screen.dart';



enum NavigationEvents{
  DashBoardClickedEvent,
  WriteClickedEvent,
  ReadClickedEvent,
  EventsClickedEvent,
  SettingsClickedEvent,
  LogoutClickedEvent,
}

abstract class NavigationStates{}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates>{

  @override
  NavigationStates get initialState => DashBoard();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event)async*{
    switch(event){

      case NavigationEvents.DashBoardClickedEvent:
            yield DashBoard();
            break;
      case NavigationEvents.WriteClickedEvent:
            yield WriteScreen();
            break;
      case NavigationEvents.ReadClickedEvent:
            yield ReadScreen();
            break;
      case NavigationEvents.EventsClickedEvent:
            yield EventsScreen();
            break;
      case NavigationEvents.SettingsClickedEvent:
            yield SettingsScreen();
            break;
      case NavigationEvents.LogoutClickedEvent:
            yield LogoutScreen();
            break;
    }

  }

}