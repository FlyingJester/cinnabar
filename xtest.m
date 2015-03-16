:- module xtest.
:- interface.

% This module is a test environment.
% We are currently testing:

% Reparenting a window.

:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module xlib.
:- import_module bool.

main(!IO) :-
    io.write_string("Beginning X11 reparenting test. You should see a blue window inside a red window.\n", !IO),
    xlib.open_display(0, Display, Success, !IO),
    
    xlib.default_root_window(Display, RootWindow),

    xlib.create_color(Display, 1.0, 0.5, 0.5, Red),
    xlib.create_color(Display, 0.5, 0.5, 1.0, Blue),
    xlib.create_color(Display, 1.0, 1.0, 1.0, White),
    xlib.create_color(Display, 0.0, 0.0, 0.0, Black),
    (
        Success = no,
        io.write_string("Error opening X11 display.\n", !IO)
    ;
        Success = yes,
        io.write_string("Opened display on screen 0.\n", !IO),
        xlib.create_simple_window(Display, RootWindow, xlib.location(16, 16), xlib.size(206, 236), White, Red, Parent, !IO),
        xlib.create_simple_window(Display, RootWindow, xlib.location(32, 32), xlib.size(200, 200), Black, Blue, Child, !IO),
        
        xlib.reparent_window(Display, Child, Parent, 2, 32, !IO),
        
        xlib.map_window(Display, Parent, !IO),
        xlib.map_window(Display, Child, !IO),
        
        % Wait for an event.
        xlib.next_event(Display, Event, !IO)
    ).
