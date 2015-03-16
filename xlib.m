:- module xlib.
:- interface.

:- import_module maybe.
:- import_module bool.
:- import_module list.
:- import_module io.

% A fairly terrible, custom-made Xlib binding for Mercury.
% Unless something is pretty trivial in C (for instance, xlib.event_window),
%  just wrap Xlib as is.
%------------------------------------------------------------------------------%

:- type xlib.display.
:- type xlib.window.
:- type xlib.xevent.

:- type xlib.event_enum.
:- type xlib.event_enum ---> key_press ; key_release ; motion_notify ; button_press ; button_release ; expose.
:- type xlib.event_mask ---> no_event_mask ; exposure_mask.

:- type xlib.mouse_button.
:- type xlib.mouse_button ---> left_button ; right_button ; middle_button.

:- type xlib.location ---> xlib.location(x::int, y::int).
:- type xlib.size ---> xlib.size(w::int, h::int).
:- type xlib.window_info ---> xlib.window_info(location::xlib.location, size::xlib.size).

:- type xlib.graphic_context.
:- type xlib.color.

%------------------------------------------------------------------------------%

:- pred xlib.location_difference(xlib.location::in, xlib.location::in, xlib.location::out) is det.
:- pred xlib.location_addition(xlib.location::in, xlib.location::in, xlib.location::out) is det.

:- pred xlib.outer_bound(xlib.location::in, xlib.size::in, xlib.location::out) is det.
:- pred xlib.outer_bound(xlib.size::in, xlib.location::out) is det.

:- pred xlib.size_addition(xlib.size::in, xlib.size::in, xlib.size::out) is det.

% Display and Screen info
%------------------------------------------------------------------------------%

:- pred xlib.open_display(int::in, xlib.display::out, bool::out, io::di, io::uo) is det.

:- pred xlib.close_display(xlib.display::in, io::di, io::uo) is det.

:- pred xlib.default_root_window(xlib.display::in, xlib.window::out) is det.

:- pred xlib.flush(xlib.display::in, io::di, io::uo) is det.

% Window Management
%------------------------------------------------------------------------------%

% unspecified location, unspecified color, parent is root
:- pred xlib.create_simple_window(xlib.display::in, xlib.size::in, xlib.window::out, io::di, io::uo) is det.

% unspecified location, unspecified color
:- pred xlib.create_simple_window(xlib.display::in, xlib.window::in, xlib.location::in, xlib.size::in, xlib.window::out, io::di, io::uo) is det.

% parent is root
:- pred xlib.create_simple_window(xlib.display::in, xlib.location::in, xlib.size::in, xlib.color::in, xlib.color::in, xlib.window::out, io::di, io::uo) is det.

:- pred xlib.create_simple_window(xlib.display::in, xlib.window::in, xlib.location::in, xlib.size::in, xlib.color::in, xlib.color::in, xlib.window::out, io::di, io::uo) is det.

:- pred xlib.map_window(xlib.display::in, xlib.window::in, io::di, io::uo) is det.

:- pred xlib.add_to_event_mask(xlib.display::in, xlib.window::in, xlib.event_mask::in, io::di, io::uo) is det.
:- pred xlib.set_event_mask(xlib.display::in, xlib.window::in, xlib.event_mask::in, io::di, io::uo) is det.

:- pred xlib.raise_window(xlib.display::in, xlib.window::in, io::di, io::uo) is det.

:- pred xlib.bound_window(xlib.display::in, xlib.window::in, xlib.location::in, xlib.size::in, io::di, io::uo) is det.
:- pred xlib.bound_window(xlib.display::in, xlib.window::in, int::in, int::in, int::in, int::in, io::di, io::uo) is det.

:- pred xlib.reparent_window(xlib.display::in, xlib.window::in, xlib.window::in, xlib.location::in, io::di, io::uo) is det.
:- pred xlib.reparent_window(xlib.display::in, xlib.window::in, xlib.window::in, int::in, int::in, io::di, io::uo) is det.

% Window Info
%------------------------------------------------------------------------------%

:- pred xlib.window_attributes(xlib.display::in, xlib.window::in, xlib.window_info::out) is det.
:- pred xlib.window_attributes(xlib.display::in, xlib.window::in, int::out, int::out, int::out, int::out) is det.

% Event Management
%------------------------------------------------------------------------------%

% Note that the event grabbing functions only work when ALT is pressed. This will be fixed/extended later.
:- pred xlib.grab_key(xlib.display::in, xlib.window::in, string::in, int::in, io::di, io::uo) is det.
:- pred xlib.grab_button(xlib.display::in, xlib.window::in, xlib.mouse_button::in, io::di, io::uo) is det.

:- pred xlib.peek_event(xlib.display::in, xlib.xevent::out, io::di, io::uo) is det.
:- pred xlib.next_event(xlib.display::in, xlib.xevent::out, io::di, io::uo) is det.

:- pred xlib.grab_pointer(xlib.display::in, xlib.window::in, io::di, io::uo) is det.
:- pred xlib.ungrab_pointer(xlib.display::in, io::di, io::uo) is det.

:- pred xlib.check_typed_event(xlib.display::in, xlib.event_enum::in, xlib.xevent::out, io::di, io::uo) is det.

% Event Info
%------------------------------------------------------------------------------%

:- func xlib.event_type(xlib.xevent::in) = (maybe(xlib.event_enum)::out) is det.
:- func xlib.event_button(xlib.xevent::in) = (xlib.mouse_button::out) is det.
:- func xlib.event_window(xlib.xevent::in) = (maybe(xlib.window)::out) is det.
:- func xlib.event_location(xlib.xevent::in) = (xlib.location::out) is det.

% Drawing Management
%------------------------------------------------------------------------------%

:- pred xlib.create_color(xlib.display::in, float::in, float::in, float::in, float::in, xlib.color::out) is det.
:- pred xlib.create_color(xlib.display::in, float::in, float::in, float::in, xlib.color::out) is det.
:- pred xlib.default_graphic_context(xlib.display::in, xlib.graphic_context::out) is det.

:- pred xlib.set_foreground(xlib.display::in, xlib.graphic_context::in, xlib.color::in, io::di, io::uo) is det.
:- pred xlib.set_background(xlib.display::in, xlib.graphic_context::in, xlib.color::in, io::di, io::uo) is det.

% Drawing
%------------------------------------------------------------------------------%

:- pred xlib.fill_rectangle(xlib.display::in, xlib.window::in, xlib.graphic_context::in, xlib.location::in, xlib.size::in, io::di, io::uo) is det.
:- pred xlib.draw_string(xlib.display::in, xlib.window::in, xlib.graphic_context::in, xlib.location::in, string::in, io::di, io::uo) is det.
:- pred xlib.draw_string(xlib.display::in, xlib.window::in, xlib.graphic_context::in, int::in, int::in, string::in, io::di, io::uo) is det.

% Fonts
%------------------------------------------------------------------------------%

:- pred xlib.font_names(xlib.display::in, string::in, list(string)::out) is det.

%------------------------------------------------------------------------------%

:- implementation.
:- import_module int.

:- pragma foreign_decl("C", "#include <X11/Xlib.h>").
:- pragma foreign_decl("C", "enum XLIB_Mouse {XLMR_MouseLeftButton = 1, XLMR_MouseMiddleButton, XLMR_MouseRightButton};").

%------------------------------------------------------------------------------%

:- type xlib.display ---> xlib.display(c_pointer).

:- pragma foreign_type("C", xlib.xevent, "XEvent").
:- pragma foreign_type("C", xlib.window, "Window").
:- pragma foreign_type("C", xlib.graphic_context, "GC").
:- pragma foreign_type("C", xlib.color, "XColor").

% xlib.location_difference
%------------------------------------------------------------------------------%

xlib.location_difference(A::in, B::in, Out::out) :-
    Out = xlib.location(A^x - B^x, A^y - B^y).

% xlib.location_addition
%------------------------------------------------------------------------------%

xlib.location_addition(A::in, B::in, Out::out) :-
    Out = xlib.location(A^x + B^x, A^y + B^y).


% xlib.size_addition
%------------------------------------------------------------------------------%

xlib.size_addition(A::in, B::in, Out::out) :-
    Out = xlib.size(A^w + B^w, A^h + B^h).

% xlib.outer_bound
%------------------------------------------------------------------------------%

xlib.outer_bound(Origin::in, Size::in, Location::out) :-
    Location = xlib.location(Origin^x + Size^w, Origin^y + Size^h).

xlib.outer_bound(Size::in, Location::out) :- xlib.outer_bound(xlib.location(0, 0), Size, Location).

% xlib.event_enum
%------------------------------------------------------------------------------%

:- pragma foreign_enum("C", xlib.event_enum/0,
    [key_press - "KeyPress", 
     key_release - "KeyRelease", 
     motion_notify - "MotionNotify",
     button_press - "ButtonPress",
     button_release - "ButtonRelease",
     expose - "Expose"]).

% xlib.mouse_button
%------------------------------------------------------------------------------%

:- pragma foreign_enum("C", xlib.mouse_button/0,
    [left_button - "XLMR_MouseLeftButton", 
     right_button - "XLMR_MouseRightButton", 
     middle_button - "XLMR_MouseMiddleButton"]).

% xlib.event_mask
%------------------------------------------------------------------------------%

:- pragma foreign_enum("C", xlib.event_mask/0,
    [no_event_mask - "0", 
     exposure_mask - "ExposureMask"]).
     
%------------------------------------------------------------------------------%
% Display and Screen info
%------------------------------------------------------------------------------%

% xlib.open_display
%------------------------------------------------------------------------------%

:- pred xlib.ropen_display(int::in, int::in, xlib.display::out, int::out, io::di, io::uo) is det.

xlib.open_display(ScreenNumber::in, Disp::out, SuccessOut::out, IOi::di, IOo::uo) :-
    xlib.ropen_display(ScreenNumber, 0, Disp, Success, IOi, IOo),
    (
      if
        Success = 1
      then
        SuccessOut = yes
      else
        SuccessOut = no
    ).

:- pragma foreign_proc("C", xlib.ropen_display(ScreenNumber::in, Dummy::in, Disp::out, S::out, IOi::di, IOo::uo),
    [will_not_call_mercury, promise_pure],
    "Disp = XOpenDisplay(ScreenNumber); S = (Disp!=NULL)").

% xlib.close_display
%------------------------------------------------------------------------------%

:- pragma foreign_proc("C", xlib.close_display(Disp::in, IOi::di, IOo::uo),
    [will_not_call_mercury, promise_pure],
    "XCloseDisplay(Disp);").

% xlib.default_root_window
%------------------------------------------------------------------------------%

:- pragma foreign_proc("C", xlib.default_root_window(Disp::in, W::out),
    [will_not_call_mercury, promise_pure],
    "W = DefaultRootWindow(Disp);").

% xlib.flush
%------------------------------------------------------------------------------%

:- pragma foreign_proc("C", xlib.flush(D::in, IOi::di, IOo::uo),
    [will_not_call_mercury, promise_pure],
    "XFlush(D);").

%------------------------------------------------------------------------------%
% Window Management
%------------------------------------------------------------------------------%

% xlib.create_simple_window
%------------------------------------------------------------------------------%

xlib.create_simple_window(Display, Size, Window, !IO) :-
    xlib.default_root_window(Display, RootWindow),
    xlib.create_simple_window(Display, RootWindow, xlib.location(16, 16), Size, Window, !IO).

xlib.create_simple_window(Display, Location, Size, Fg, Bg, Window, !IO) :-
    xlib.default_root_window(Display, RootWindow),
    xlib.create_simple_window(Display, RootWindow, Location, Size, Fg, Bg, Window, !IO).

:- func xlib.window_is_none(xlib.window::in) = (int::out) is det.
:- pred xlib.create_simple_window(xlib.display::in, xlib.window::in, int::in, int::in, int::in, int::in, int::in, xlib.window::out, io::di, io::uo) is det.
:- pred xlib.create_simple_window(xlib.display::in, xlib.window::in, int::in, int::in, int::in, int::in, int::in, xlib.color::in, xlib.color::in, xlib.window::out, io::di, io::uo) is det.

:- pragma foreign_proc("C", xlib.window_is_none(W::in) = (R::out),
    [will_not_call_mercury, promise_pure, thread_safe],
    "R = (W==None);").

:- pragma foreign_proc("C", xlib.create_simple_window(D::in, Win::in, X::in, Y::in, W::in, H::in, Border::in, Fg::in, Bg::in, OutWindow::out, IOi::di, IOo::uo),
    [will_not_call_mercury, promise_pure],
    "OutWindow = XCreateSimpleWindow(D, Win, X, Y, W, H, Border, Fg.pixel,  Bg.pixel);").

:- pragma foreign_proc("C", xlib.create_simple_window(D::in, Win::in, X::in, Y::in, W::in, H::in, Border::in, OutWindow::out, IOi::di, IOo::uo),
    [will_not_call_mercury, promise_pure],
    "OutWindow = XCreateSimpleWindow(D, Win, X, Y, W, H, Border, BlackPixel(D, DefaultScreen(D)), WhitePixel(D, DefaultScreen(D)));").

xlib.create_simple_window(Display::in, Win::in, Location::in, Size::in, OutWindow::out, IOi::di, IOo::uo) :-
    xlib.create_simple_window(Display, Win, Location^x, Location^y, Size^w, Size^h, 1, OutWindow, IOi, IOo).
    
xlib.create_simple_window(Display::in, Win::in, Location::in, Size::in, Fg::in, Bg::in, OutWindow::out, IOi::di, IOo::uo) :-
    xlib.create_simple_window(Display, Win, Location^x, Location^y, Size^w, Size^h, 1, Fg, Bg, OutWindow, IOi, IOo).


% xlib.map_window
%------------------------------------------------------------------------------%

:- pragma foreign_proc("C", xlib.map_window(D::in, W::in, IOi::di, IOo::uo),
    [will_not_call_mercury, promise_pure],
    "XMapWindow(D, W);").


% xlib.add_to_event_mask
%------------------------------------------------------------------------------%

:- pragma foreign_proc("C", xlib.add_to_event_mask(D::in, Win::in, Mask::in, IOi::di, IOo::uo),
    [will_not_call_mercury, promise_pure],
    "{
        XWindowAttributes attributes;
        XGetWindowAttributes(D, Win, &attributes);
        XSelectInput(D, Win, attributes.your_event_mask|Mask);
    }").

% xlib.set_event_mask
%------------------------------------------------------------------------------%

:- pragma foreign_proc("C", xlib.set_event_mask(D::in, Win::in, Mask::in, IOi::di, IOo::uo),
    [will_not_call_mercury, promise_pure],
    "XSelectInput(D, Win, Mask);").

% xlib.raise_window
%------------------------------------------------------------------------------%

:- pragma foreign_proc("C", xlib.raise_window(D::in, W::in, IOi::di, IOo::uo),
    [will_not_call_mercury, promise_pure],
    "XRaiseWindow(D, W);").

        
% xlib.bound_window
%------------------------------------------------------------------------------%

xlib.bound_window(D::in, W::in, Location::in, Size::in, IOi::di, IOo::uo) :- 
    xlib.bound_window(D, W, Location^x, Location^y, Size^w, Size^h, IOi, IOo).

:- pragma foreign_proc("C", xlib.bound_window(D::in, Win::in, X::in, Y::in, W::in, H::in, IOi::di, IOo::uo),
    [will_not_call_mercury, promise_pure],
    "XMoveResizeWindow(D, Win, X, Y, W, H);").
        
% xlib.reparent_window
%------------------------------------------------------------------------------%

:- pragma foreign_proc("C", xlib.reparent_window(D::in, Child::in, Parent::in, X::in, Y::in, IOi::di, IOo::uo),
    [will_not_call_mercury, promise_pure],
    "XReparentWindow(D, Child, Parent, X, Y);").
              
xlib.reparent_window(Display, Child, Parent, Loc, !IO) :-
    xlib.reparent_window(Display, Child, Parent, Loc^x, Loc^y, !IO).


%------------------------------------------------------------------------------%
% Window Info
%------------------------------------------------------------------------------%

% xlib.window_attributes
%------------------------------------------------------------------------------%

% Get the X, Y, W, H separately
:- pragma foreign_proc("C", xlib.window_attributes(D::in, Win::in, X::out, Y::out, W::out, H::out),
    [will_not_call_mercury, promise_pure],
    "{
        XWindowAttributes attributes;
        XGetWindowAttributes(D, Win, &attributes);
        X = attributes.x;
        Y = attributes.y;
        W = attributes.width;
        H = attributes.height;
    }").

% Gather the attributes together
xlib.window_attributes(Display, Window, WindowInfo) :-
    xlib.window_attributes(Display, Window, X, Y, W, H),
    Position = xlib.location(X, Y),
    Size = xlib.size(W, H),
    WindowInfo = xlib.window_info(Position, Size).

%------------------------------------------------------------------------------%
% Event Management
%------------------------------------------------------------------------------%


% xlib.grab_key
%------------------------------------------------------------------------------%

:- pragma foreign_proc("C", xlib.grab_key(Disp::in, W::in, Key::in, Mod::in, IOi::di, IOo::uo),
    [will_not_call_mercury, promise_pure],
    "XGrabKey(Disp,  XStringToKeysym(Key), Mod, W, True, GrabModeAsync, GrabModeAsync);").

% xlib.grab_button
%------------------------------------------------------------------------------%

:- pragma foreign_proc("C", xlib.grab_button(Disp::in, W::in, Button::in, IOi::di, IOo::uo),
    [will_not_call_mercury, promise_pure],
    "XGrabButton(Disp, Button, Mod1Mask, W, True, ButtonPressMask, GrabModeAsync, GrabModeAsync, None, None);").

% xlib.next_event
%------------------------------------------------------------------------------%

:- pragma foreign_proc("C", xlib.next_event(Disp::in, Ev::out, IOi::di, IOo::uo),
    [will_not_call_mercury, promise_pure],
    "XNextEvent(Disp, &Ev);").

% xlib.peek_event
%------------------------------------------------------------------------------%

:- pragma foreign_proc("C", xlib.peek_event(Disp::in, Ev::out, IOi::di, IOo::uo),
    [will_not_call_mercury, promise_pure],
    "XPeekEvent(Disp, &Ev);").

% xlib.grab_pointer
%------------------------------------------------------------------------------%

:- pragma foreign_proc("C", xlib.grab_pointer(D::in, W::in, IOi::di, IOo::uo),
    [will_not_call_mercury, promise_pure],
    "XGrabPointer(D, W, True, PointerMotionMask|ButtonReleaseMask, GrabModeAsync, GrabModeAsync, None, None, CurrentTime);").
        
% xlib.ungrab_pointer
%------------------------------------------------------------------------------%

:- pragma foreign_proc("C", xlib.ungrab_pointer(D::in, IOi::di, IOo::uo),
    [will_not_call_mercury, promise_pure],
    "XUngrabPointer(D, CurrentTime);").

% xlib.check_typed_event
%------------------------------------------------------------------------------%

:- pragma foreign_proc("C", xlib.check_typed_event(D::in, EvType::in, Ev::out, IOi::di, IOo::uo),
    [will_not_call_mercury, promise_pure],
    "XCheckTypedEvent(D, EvType, &Ev);").

%------------------------------------------------------------------------------%
% Event Info
%------------------------------------------------------------------------------%

% xlib.event_type
%------------------------------------------------------------------------------%

:- func xlib.can_handle_event_type(xlib.xevent::in) = (int::out) is det.
:- func xlib.event_type_naive(xlib.xevent::in) = (xlib.event_enum::out) is det.

:- pragma foreign_proc("C", xlib.can_handle_event_type(Ev::in) = (H::out),
    [will_not_call_mercury, promise_pure, thread_safe],
    "H = ((Ev.type==KeyPress) || (Ev.type==KeyRelease) || (Ev.type==MotionNotify) || (Ev.type==ButtonPress) || (Ev.type==Expose));").

:- pragma foreign_proc("C", xlib.event_type_naive(Ev::in) = (T::out),
    [will_not_call_mercury, promise_pure, thread_safe],
    "T = Ev.type;").

xlib.event_type(Ev) = (M) :-
    (
      if
        can_handle_event_type(Ev) = 1
      then
        M = yes(event_type_naive(Ev))
      else
        M = no
    ).

% xlib.event_button
%------------------------------------------------------------------------------%

:- pragma foreign_proc("C", xlib.event_button(Ev::in) = (Button::out),
    [will_not_call_mercury, promise_pure, thread_safe],
    "Button = Ev.xbutton.button;").

% xlib.event_window
%------------------------------------------------------------------------------%

:- func xlib.event_always_window(xlib.xevent::in) = (xlib.window::out) is det.

:- pragma foreign_proc("C", xlib.event_always_window(Ev::in) = (W::out),
    [will_not_call_mercury, promise_pure, thread_safe],
    "switch(Ev.type){
        case MapNotify:
            W = Ev.xmap.window;
            break;
        case UnmapNotify:
            W = Ev.xunmap.window;
            break;
        case ReparentNotify:
            W = Ev.xreparent.window;
            break;
        case ConfigureNotify:
            W = Ev.xconfigure.window;
            break;      
        case ConfigureRequest:
            W = Ev.xconfigurerequest.window;
            break;
        case ResizeRequest:  
            W = Ev.xresizerequest.window;
            break;
        default:
        W = Ev.xany.window;
    }
    ").

xlib.event_window(Ev::in) = (W::out) :-
    (
      if
        xlib.window_is_none(xlib.event_always_window(Ev)) = 1
      then
        W = no
      else
        W = yes(xlib.event_always_window(Ev))
    ).
    

% xlib.event_location
%------------------------------------------------------------------------------%

:- pred xlib.event_location_xy(xlib.xevent::in, int::out, int::out) is det.

:- pragma foreign_proc("C", xlib.event_location_xy(Ev::in, X::out, Y::out),
    [will_not_call_mercury, promise_pure, thread_safe],
    "X = Ev.xbutton.x_root; Y = Ev.xbutton.x_root;").

xlib.event_location(Ev) = (Location) :-
    xlib.event_location_xy(Ev, X, Y),
    Location = xlib.location(X, Y).

%------------------------------------------------------------------------------%
% Drawing Management
%------------------------------------------------------------------------------%

% xlib.create_color
%------------------------------------------------------------------------------%

xlib.create_color(D, R, G, B, Color) :- xlib.create_color(D, R, G, B, 1.0, Color).

:- pragma foreign_proc("C", xlib.create_color(D::in, R::in, G::in, B::in, A::in, Color::out),
    [will_not_call_mercury, promise_pure],
    " Color.red = 65535*R;
      Color.green = 65535*G;
      Color.blue = 65535*B;
      Color.flags = DoRed|DoGreen|DoBlue;
      XAllocColor(D, DefaultColormap(D, DefaultScreen(D)), &Color);").

% xlib.default_graphic_context
%------------------------------------------------------------------------------%

:- pragma foreign_proc("C", xlib.default_graphic_context(D::in, Gc::out),
    [will_not_call_mercury, promise_pure],
    "Gc = DefaultGC(D, DefaultScreen(D));").

% xlib.set_foreground
%------------------------------------------------------------------------------%

:- pragma foreign_proc("C", xlib.set_foreground(D::in, Gc::in, Color::in, IOi::di, IOo::uo),
    [will_not_call_mercury, promise_pure],
    "XSetForeground(D, Gc, Color.pixel);").
    
% xlib.set_background
%------------------------------------------------------------------------------%

:- pragma foreign_proc("C", xlib.set_background(D::in, Gc::in, Color::in, IOi::di, IOo::uo),
    [will_not_call_mercury, promise_pure],
    "XSetBackground(D, Gc, Color.pixel);").

%------------------------------------------------------------------------------%
% Drawing
%------------------------------------------------------------------------------%

% xlib.fill_rectangle
%------------------------------------------------------------------------------%

:- pred xlib.fill_rectangle(xlib.display::in, xlib.window::in, xlib.graphic_context::in, int::in, int::in, int::in, int::in, IOi::di, IOo::uo) is det.
:- pragma foreign_proc("C", xlib.fill_rectangle(D::in, Win::in, Gc::in, X::in, Y::in, W::in, H::in, IOi::di, IOo::uo),
    [will_not_call_mercury, promise_pure],
    "XFillRectangle(D, Win, Gc, X, Y, W, H);").

xlib.fill_rectangle(D::in, W::in, Gc::in, Loc::in, Size::in, IOi::di, IOo::uo) :-
    xlib.fill_rectangle(D, W, Gc, Loc^x, Loc^y, Size^w, Size^h, IOi, IOo).
    
% xlib.draw_string
%------------------------------------------------------------------------------%

xlib.draw_string(D::in, Win::in, Gc::in, Loc::in, Msg::in, IOi::di, IOo::uo) :-
    xlib.draw_string(D, Win, Gc, Loc^x, Loc^y, Msg, IOi, IOo).
    
:- pragma foreign_proc("C", xlib.draw_string(D::in, Win::in, Gc::in, X::in, Y::in, Msg::in, IOi::di, IOo::uo),
    [will_not_call_mercury, promise_pure],
    "XDrawString(D, Win, Gc, X, Y, Msg, strlen(Msg))!=0;").
    
%------------------------------------------------------------------------------%
% Fonts
%------------------------------------------------------------------------------%

% xlib.font_names
%------------------------------------------------------------------------------%

:- pragma foreign_proc("C", xlib.font_names(D::in, Pattern::in, List::out),
    [may_call_mercury, promise_pure],
    "{
        int n_fonts;
        char **fonts = XListFonts(D, Pattern, 0xFFFF, &n_fonts);
        
        List = MR_list_empty();
        
        if(n_fonts && (fonts!=NULL)){
            for(int i = 0; i<n_fonts; i++){
                MR_String font;
                MR_make_aligned_string_copy_saved_hp(font, fonts[i], NULL);
                List = MR_list_cons((MR_Word)font, List);
            }
        }
    }").


%------------------------------------------------------------------------------%
