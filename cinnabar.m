:- module cinnabar.
:- interface.

:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module xlib.
:- import_module int.
:- import_module maybe.

% cinnabar.clear_event_type
%------------------------------------------------------------------------------%

% Designed to replace the following C statement:
%   while(XCheckTypeEvent(Display, EventType, &Event));

:- pred cinnabar.clear_event_type(xlib.display::in, xlib.event_enum::in, maybe(xlib.xevent)::in, maybe(xlib.xevent)::out) is det.

cinnabar.clear_event_type(Display::in, EventType::in, PreviousEvent::in, Event::out) :-
    (
      if
        xlib.check_typed_event(Display, EventType, NewEvent)
      then
        cinnabar.clear_event_type(Display, EventType, yes(NewEvent), Event)
      else
        Event = PreviousEvent
    ).

% cinnabar.handle_event
%------------------------------------------------------------------------------%

:- func cinnabar.size_min_one(xlib.size::in) = (xlib.size::out) is det.
cinnabar.size_min_one(Size::in) = (Out::out) :-
    Out = xlib.size(max(Size^w, 1), max(Size^h, 1)).

:- pred cinnabar.handle_event(xlib.display::in, xlib.window::in) is semidet.
:- pred cinnabar.handle_event(xlib.display::in, xlib.window::in, xlib.xevent::in) is semidet.

cinnabar.handle_event(Display::in, RootWindow::in) :-
    xlib.next_event(Display, Event),
    (
      if
         (xlib.event_type(Event) = yes(button_press), xlib.event_window(Event) = yes(Window))
      then
        xlib.grab_pointer(Display, Window),
        cinnabar.handle_event(Display, RootWindow, Event)
      else
         cinnabar.handle_event(Display, RootWindow)
    ).

% When we are in the middle of a mouse button press. 
cinnabar.handle_event(Display::in, RootWindow::in, StartingEvent::in) :-
    xlib.peek_event(Display, Event),
    
    % If we will not have a StartingEvent next call, pop the event.
    % Don't include button_press, the next call will take care of it.
    (
        xlib.event_type(Event) = yes(EventType),
        (EventType = motion_notify ; EventType = button_release),
        xlib.next_event(Display, PopEvent)
    ),
    (
        % The event is a successive motion notification. Pop the event and handle
        xlib.event_type(Event) = yes(motion_notify),
        xlib.event_window(Event) = yes(Window),

        % Calculate the difference in location from this event and the starting event.
        xlib.location_difference(xlib.event_location(Event), xlib.event_location(StartingEvent), Difference),
        xlib.window_attributes(Display, Window, Info),
        (
            xlib.event_button(Event) = left_button,
            xlib.location_addition(Difference, Info^location, NewLocation),
            xlib.bound_window(Display, Window, NewLocation, Info^size)
        ;
            xlib.event_button(Event) = right_button,
            xlib.bound_window(Display, Window, Info^location, 
                cinnabar.size_min_one(xlib.size(Difference^x + Info^size^w, Difference^y + Info^size^h)))
        ;
            xlib.event_button(Event) = middle_button
        )
    ;
        xlib.event_type(Event) = yes(button_release),
        xlib.ungrab_pointer(Display),
        cinnabar.handle_event(Display, RootWindow)
    ;
        % The event is unhandled. Just ignore it.
        (
            xlib.event_type(Event) = no ;
            xlib.event_type(Event) = yes(key_press) ;
            xlib.event_type(Event) = yes(key_release) ;
            xlib.event_type(Event) = yes(button_press)
        ),
        cinnabar.handle_event(Display, RootWindow)
    ).



% cinnabar.init_events
%------------------------------------------------------------------------------%

% Used to grab a display and root window, as well as mark which events to grab
:- pred cinnabar.init_x(xlib.display::out, xlib.window::out) is semidet.

cinnabar.init_x(Display, Window) :-
    xlib.open_display(0, Display),    
    xlib.default_root_window(Display, Window),
    xlib.grab_button(Display, Window, left_button),
    xlib.grab_button(Display, Window, right_button).

% main
%------------------------------------------------------------------------------%

main(!IO) :-
    (
  if
   cinnabar.init_x(Display, Window)
  then 
    (
      if
        cinnabar.handle_event(Display, Window)
      then
        io.write_string("Cinnabar Closing.\n", !IO)
      else
        io.write_string("Error retrieving event.\n", !IO)
    )
   else 
    io.write_string("Error could not open display for screen 0\n", !IO)
    ),
    io.write_string("Hello, World!\n", !IO).
