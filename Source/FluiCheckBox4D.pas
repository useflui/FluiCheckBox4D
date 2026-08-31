unit FluiCheckBox4D;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Winapi.GDIPAPI, Winapi.GDIPOBJ;

type
  TFluiLabelPosition = (lpLeft, lpRight, lpTop, lpBottom);

  TFluiCheckBox4D = class(TCustomControl)
  private
    FChecked: Boolean;
    FRounding: Integer;
    FBorderColor: TColor;
    FColorStart: TColor;
    FColorEnd: TColor;
    FColorCheckedStart: TColor;
    FColorCheckedEnd: TColor;
    FCheckedColor: TColor; // Keep for backward compatibility/fallback
    FCheckmarkColor: TColor;
    FLabelPosition: TFluiLabelPosition;
    FCaption: string;
    FOnCheckedChanged: TNotifyEvent;
    FUseGradient: Boolean;
    FBoxSize: Integer;
    FCheckmarkWidth: Single;

    procedure SetChecked(const Value: Boolean);
    procedure SetRounding(const Value: Integer);
    procedure SetBorderColor(const Value: TColor);
    procedure SetColorStart(const Value: TColor);
    procedure SetColorEnd(const Value: TColor);
    procedure SetColorCheckedStart(const Value: TColor);
    procedure SetColorCheckedEnd(const Value: TColor);
    procedure SetCheckedColor(const Value: TColor);
    procedure SetCheckmarkColor(const Value: TColor);
    procedure SetLabelPosition(const Value: TFluiLabelPosition);
    procedure SetCaption(const Value: string);
    procedure SetUseGradient(const Value: Boolean);
    procedure SetBoxSize(const Value: Integer);
    procedure SetCheckmarkWidth(const Value: Single);

    function CreateRoundPath(Rect: TGPRectF; Radius: Single): TGPGraphicsPath;
    procedure DrawCheckmark(Graphics: TGPGraphics; Rect: TGPRectF);
    function GetGDIPlusStyle(AStyle: TFontStyles): Integer;
  protected
    procedure Paint; override;
    procedure Click; override;
    procedure Resize; override;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property BoxSize: Integer read FBoxSize write SetBoxSize default 18;
    property CheckmarkWidth: Single read FCheckmarkWidth write SetCheckmarkWidth;
    property UseGradient: Boolean read FUseGradient write SetUseGradient default True;
    property Checked: Boolean read FChecked write SetChecked default False;
    property Rounding: Integer read FRounding write SetRounding default 4;
    property BorderColor: TColor read FBorderColor write SetBorderColor default clSilver;
    property ColorStart: TColor read FColorStart write SetColorStart default clWhite;
    property ColorEnd: TColor read FColorEnd write SetColorEnd default $00F0F0F0;
    property ColorCheckedStart: TColor read FColorCheckedStart write SetColorCheckedStart default $00FF9D3C;
    property ColorCheckedEnd: TColor read FColorCheckedEnd write SetColorCheckedEnd default $00FF8000;
    property CheckedColor: TColor read FCheckedColor write SetCheckedColor default $00FF8000;
    property CheckmarkColor: TColor read FCheckmarkColor write SetCheckmarkColor default clWhite;
    property LabelPosition: TFluiLabelPosition read FLabelPosition write SetLabelPosition default lpRight;
    property Caption: string read FCaption write SetCaption;

    property Align;
    property Anchors;
    property Color;
    property Constraints;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnCheckedChanged: TNotifyEvent read FOnCheckedChanged write FOnCheckedChanged;
  end;

procedure Register;

implementation

{ TFluiCheckBox4D }

constructor TFluiCheckBox4D.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle + [csOpaque, csParentBackground];
  DoubleBuffered := True;
  Width := 150;
  Height := 25;
  FRounding := 4;
  FBorderColor := clSilver;
  FColorStart := clWhite;
  FColorEnd := $00F0F0F0;
  FColorCheckedStart := $00FF9D3C;
  FColorCheckedEnd := $00FF8000;
  FCheckedColor := $00FF8000;
  FCheckmarkColor := clWhite;
  FLabelPosition := lpRight;
  FCaption := 'FluiCheckBox4D';
  FChecked := False;
  FUseGradient := True;
  FBoxSize := 18;
  FCheckmarkWidth := 2.0;
end;

procedure TFluiCheckBox4D.Click;
begin
  Checked := not Checked;
  inherited;
end;

procedure TFluiCheckBox4D.CMFontChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TFluiCheckBox4D.CMTextChanged(var Message: TMessage);
begin
  inherited;
  FCaption := Text;
  Invalidate;
end;

function TFluiCheckBox4D.CreateRoundPath(Rect: TGPRectF; Radius: Single): TGPGraphicsPath;
var
  D: Single;
begin
  Result := TGPGraphicsPath.Create;
  D := Radius * 2;
  if D > Rect.Width then D := Rect.Width;
  if D > Rect.Height then D := Rect.Height;
  if D <= 0 then D := 1;

  Result.AddArc(Rect.X, Rect.Y, D, D, 180, 90);
  Result.AddArc(Rect.X + Rect.Width - D, Rect.Y, D, D, 270, 90);
  Result.AddArc(Rect.X + Rect.Width - D, Rect.Y + Rect.Height - D, D, D, 0, 90);
  Result.AddArc(Rect.X, Rect.Y + Rect.Height - D, D, D, 90, 90);
  Result.CloseFigure;
end;

procedure TFluiCheckBox4D.DrawCheckmark(Graphics: TGPGraphics; Rect: TGPRectF);
var
  Pen: TGPPen;
  Pts: array[0..2] of TGPPointF;
begin
  Pen := TGPPen.Create(ColorRefToARGB(ColorToRGB(FCheckmarkColor)), FCheckmarkWidth);
  try
    Pen.SetStartCap(LineCapRound);
    Pen.SetEndCap(LineCapRound);
    Pen.SetLineJoin(LineJoinRound);

    Pts[0].X := Rect.X + Rect.Width * 0.25;
    Pts[0].Y := Rect.Y + Rect.Height * 0.5;
    Pts[1].X := Rect.X + Rect.Width * 0.45;
    Pts[1].Y := Rect.Y + Rect.Height * 0.75;
    Pts[2].X := Rect.X + Rect.Width * 0.75;
    Pts[2].Y := Rect.Y + Rect.Height * 0.3;

    Graphics.DrawLines(Pen, PGPPointF(@Pts), 3);
  finally
    Pen.Free;
  end;
end;

function TFluiCheckBox4D.GetGDIPlusStyle(AStyle: TFontStyles): Integer;
begin
  Result := FontStyleRegular;
  if fsBold in AStyle then Result := Result or FontStyleBold;
  if fsItalic in AStyle then Result := Result or FontStyleItalic;
  if fsUnderline in AStyle then Result := Result or FontStyleUnderline;
  if fsStrikeOut in AStyle then Result := Result or FontStyleStrikeout;
end;

procedure TFluiCheckBox4D.Paint;
var
  Graphics: TGPGraphics;
  Path: TGPGraphicsPath;
  Brush: TGPBrush;
  Pen: TGPPen;
  BoxRect, TextRect: TGPRectF;
  TextFormat: TGPStringFormat;
  TextBrush: TGPBrush;
  GdipFont: TGPFont;
  Family: TGPFontFamily;
begin
  Graphics := TGPGraphics.Create(Canvas.Handle);
  try
    Graphics.SetSmoothingMode(SmoothingModeAntiAlias);
    Graphics.SetTextRenderingHint(TextRenderingHintClearTypeGridFit);

    // Calculate layout based on FBoxSize
    case FLabelPosition of
      lpLeft:
        begin
          BoxRect := MakeRect(Width - FBoxSize - 2, (Height - FBoxSize) / 2, FBoxSize, FBoxSize);
          TextRect := MakeRect(2.0, 0.0, Width - FBoxSize - 6, Height);
        end;
      lpRight:
        begin
          BoxRect := MakeRect(2.0, (Height - FBoxSize) / 2, FBoxSize, FBoxSize);
          TextRect := MakeRect(FBoxSize + 6, 0.0, Width - FBoxSize - 6, Height);
        end;
      lpTop:
        begin
          BoxRect := MakeRect((Width - FBoxSize) / 2, Height - FBoxSize - 2, FBoxSize, FBoxSize);
          TextRect := MakeRect(0.0, 2.0, Width, Height - FBoxSize - 4);
        end;
      lpBottom:
        begin
          BoxRect := MakeRect((Width - FBoxSize) / 2, 2.0, FBoxSize, FBoxSize);
          TextRect := MakeRect(0.0, FBoxSize + 4, Width, Height - FBoxSize - 4);
        end;
    end;

    // Draw Box Background
    Path := CreateRoundPath(BoxRect, FRounding);
    try
      if FChecked then
      begin
        if FUseGradient then
          Brush := TGPLinearGradientBrush.Create(
            BoxRect,
            ColorRefToARGB(ColorToRGB(FColorCheckedStart)),
            ColorRefToARGB(ColorToRGB(FColorCheckedEnd)),
            LinearGradientModeVertical
          )
        else
          Brush := TGPSolidBrush.Create(ColorRefToARGB(ColorToRGB(FColorCheckedStart)));
      end
      else
      begin
        if FUseGradient then
          Brush := TGPLinearGradientBrush.Create(
            BoxRect,
            ColorRefToARGB(ColorToRGB(FColorStart)),
            ColorRefToARGB(ColorToRGB(FColorEnd)),
            LinearGradientModeVertical
          )
        else
          Brush := TGPSolidBrush.Create(ColorRefToARGB(ColorToRGB(FColorStart)));
      end;
      
      try
        Graphics.FillPath(Brush, Path);
      finally
        Brush.Free;
      end;

      // Draw Box Border
      Pen := TGPPen.Create(ColorRefToARGB(ColorToRGB(FBorderColor)), 1);
      try
        Graphics.DrawPath(Pen, Path);
      finally
        Pen.Free;
      end;

      // Draw Checkmark
      if FChecked then
        DrawCheckmark(Graphics, BoxRect);

    finally
      Path.Free;
    end;

    // Draw Caption
    if FCaption <> '' then
    begin
      TextBrush := TGPSolidBrush.Create(ColorRefToARGB(ColorToRGB(Font.Color)));
      TextFormat := TGPStringFormat.Create;
      Family := TGPFontFamily.Create(Font.Name);
      GdipFont := TGPFont.Create(Family, Font.Size, GetGDIPlusStyle(Font.Style), UnitPoint);
      try
        TextFormat.SetAlignment(StringAlignmentNear);
        TextFormat.SetLineAlignment(StringAlignmentCenter);
        if FLabelPosition in [lpTop, lpBottom] then
          TextFormat.SetAlignment(StringAlignmentCenter);

        Graphics.DrawString(FCaption, -1, GdipFont, TextRect, TextFormat, TextBrush);
      finally
        GdipFont.Free;
        Family.Free;
        TextFormat.Free;
        TextBrush.Free;
      end;
    end;

  finally
    Graphics.Free;
  end;
end;

procedure TFluiCheckBox4D.Resize;
begin
  inherited;
  Invalidate;
end;

procedure TFluiCheckBox4D.SetBoxSize(const Value: Integer);
begin
  if FBoxSize <> Value then
  begin
    FBoxSize := Value;
    Invalidate;
  end;
end;

procedure TFluiCheckBox4D.SetCheckmarkWidth(const Value: Single);
begin
  if FCheckmarkWidth <> Value then
  begin
    FCheckmarkWidth := Value;
    Invalidate;
  end;
end;

procedure TFluiCheckBox4D.SetBorderColor(const Value: TColor);
begin
  if FBorderColor <> Value then
  begin
    FBorderColor := Value;
    Invalidate;
  end;
end;

procedure TFluiCheckBox4D.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    Text := Value;
    Invalidate;
  end;
end;

procedure TFluiCheckBox4D.SetChecked(const Value: Boolean);
begin
  if FChecked <> Value then
  begin
    FChecked := Value;
    Invalidate;
    if Assigned(FOnCheckedChanged) then
      FOnCheckedChanged(Self);
  end;
end;

procedure TFluiCheckBox4D.SetCheckedColor(const Value: TColor);
begin
  if FCheckedColor <> Value then
  begin
    FCheckedColor := Value;
    FColorCheckedStart := Value; // Sync for consistency
    Invalidate;
  end;
end;

procedure TFluiCheckBox4D.SetColorCheckedEnd(const Value: TColor);
begin
  if FColorCheckedEnd <> Value then
  begin
    FColorCheckedEnd := Value;
    Invalidate;
  end;
end;

procedure TFluiCheckBox4D.SetColorCheckedStart(const Value: TColor);
begin
  if FColorCheckedStart <> Value then
  begin
    FColorCheckedStart := Value;
    FCheckedColor := Value; // Sync for consistency
    Invalidate;
  end;
end;

procedure TFluiCheckBox4D.SetCheckmarkColor(const Value: TColor);
begin
  if FCheckmarkColor <> Value then
  begin
    FCheckmarkColor := Value;
    Invalidate;
  end;
end;

procedure TFluiCheckBox4D.SetColorEnd(const Value: TColor);
begin
  if FColorEnd <> Value then
  begin
    FColorEnd := Value;
    Invalidate;
  end;
end;

procedure TFluiCheckBox4D.SetColorStart(const Value: TColor);
begin
  if FColorStart <> Value then
  begin
    FColorStart := Value;
    Invalidate;
  end;
end;

procedure TFluiCheckBox4D.SetLabelPosition(const Value: TFluiLabelPosition);
begin
  if FLabelPosition <> Value then
  begin
    FLabelPosition := Value;
    Invalidate;
  end;
end;

procedure TFluiCheckBox4D.SetRounding(const Value: Integer);
begin
  if FRounding <> Value then
  begin
    FRounding := Value;
    Invalidate;
  end;
end;

procedure TFluiCheckBox4D.SetUseGradient(const Value: Boolean);
begin
  if FUseGradient <> Value then
  begin
    FUseGradient := Value;
    Invalidate;
  end;
end;

procedure Register;
begin
  RegisterComponents('Flui', [TFluiCheckBox4D]);
end;

end.
