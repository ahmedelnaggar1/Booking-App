//This class will handle the rendering of a TShow

//Author: Ahmed El-Naggar
//aelna0@eq.edu.au

unit CRender;

interface

uses Vcl.Forms, Vcl.ExtCtrls, CShow, System.Generics.Collections, CSeat, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
     Vcl.Graphics, Vcl.Controls, Vcl.Dialogs; //TFrame, TShape

type
    TRender = class

    private

        main_frame  : TFrame; // The frame to render on to
        show        : TShow; // The show to render

        shapes      : TObjectList<TShape>; // The shapes for the seats

        seat_height : Integer;
        seat_width  : Integer;

        function create_seat(width : Integer; height : Integer; left : Integer; Top : Integer; seat_num : Integer; taken : Boolean) : TShape;

        procedure on_mouse_up(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); // Handle the user clicking on a seat

    published

        constructor create(main_frame: TFrame; show : TShow);
        destructor destroy();

        function draw() : Boolean;

end;

implementation

constructor TRender.create(main_frame : TFrame; show : TShow);
begin

    self.main_frame := main_frame;
    self.main_frame.Width  := 320;
    self.main_frame.Height := 240;

    self.show := show;

    self.shapes := TObjectList<Tshape>.Create();

    self.seat_height := 17;
    self.seat_width  := 17;

end;

destructor TRender.destroy();
var shapes : TShape;
begin
    //Free all shapes to prevent memory leak
    for shapes in self.shapes do
        shapes.Free();
end;


function TRender.draw() : Boolean;
{
    Renders the seats to the frame main_frame
    Return:
        result (Boolean): Was the rendering successful or not
}

var stage             : TShape;
var seats             : TObjectList<TSeat>;
var seat              : TSeat;
var count             : Integer;

var num_premium       : Integer; // Number of premium seats
var current_seat      : Integer;

begin
  
    // Set the size of the frame to 320 x 240
    self.main_frame.Width  := 320;
    self.main_frame.Height := 240;

    // Create the stage
    stage := TShape.Create(main_frame);
    stage.Width     := 96;
    stage.Height    := 153;

    stage.Left      := 112;
    stage.Top       := 0;

    stage.Parent := main_frame;

    stage.Shape := stRectangle;
    stage.Show();

    shapes.Add(stage);

    seats := self.show.get_seats();

    count := 0;

    // Premium seats are those that are close to the stage
    // For the sides:
    // let h = height of seat, hs = height of stage
    // x: number of seats on one side
    // x = hs/h
    // Total seats on both sides = x * 2

    // Find premium seats : 23 seats
    // Sides
    // Left side

    // Premium seats = perimeter of the shape
    num_premium := stage.Height + stage.Width;

    current_seat := 0;

    for count := 0 to Trunc( (stage.Height * 17) / (self.seat_height * self.seat_height) ) do
    begin
        //Left side
        self.shapes.Add( self.create_seat(17, 17, 90, count * 17, count, seats[count].is_taken()) );
        current_seat := current_seat + 1;

        //Right side
        self.shapes.Add( self.create_seat(17, 17, stage.Left + stage.Width + 4, count * 17, count, seats[current_seat].is_taken()) );

        current_seat := current_seat + 1;
    end;

    // Bottom side
    for count := 0 to Round( (stage.Width * 17) / (self.seat_width * self.seat_width) )-2 do
    begin
    
        self.shapes.Add( self.create_seat(17, 17, 90 + (count * 17) + 27, stage.Height + 2, count, seats[current_seat].is_taken()) ); // +27 for padding from left
        current_seat := current_seat + 1;
    end;

end;


function TRender.create_seat(width: Integer; height: Integer; left: Integer; top: Integer; seat_num : Integer; taken : Boolean): TShape;
{
    Creates the seat to be rendered
    Parameters:
        width       (Integer): The width of the seat
        height      (Integer): The height of the seat
        left        (Integer): Position from the left, x units
        top         (Integer): Position from the top, x units
        seat_num    (Integer): The seat ID
        taken       (Boolean): Is the seat taken by a Guest
    Return:
        temp_shape (TShape): The final shape object
}
var temp_shape : TShape;
begin
    temp_shape           := TShape.Create(self.main_frame);
    temp_shape.Width     := width;
    temp_shape.Height    := height;
    temp_shape.Parent    := self.main_frame;
    temp_shape.Shape     := stRectangle;

    temp_shape.Left      := left;
    temp_shape.Top       := top;

    temp_shape.OnMouseUp := self.on_mouse_up;

    if (taken) then temp_shape.Brush.Color := clRed;
    
    temp_shape.Show();

    Result := temp_shape;
end;

procedure TRender.on_mouse_up(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var shape : TShape;
begin

    shape := Sender as Tshape;

    // Check if seat is taken
        //Two ways to do this, easiest way would be to just check the colour
        //clRed = taken

    // If not, select it
    // Selected seat = seat

end;

end.
