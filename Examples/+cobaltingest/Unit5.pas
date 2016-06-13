unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, pngimage;

type
  TForm5 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Image24: TImage;
    Label15: TLabel;
    Label16: TLabel;
    Panel4: TPanel;
    Image1: TImage;
    Image2: TImage;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Image4: TImage;
    Image11: TImage;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel3: TPanel;
    Shape7: TShape;
    Label14: TLabel;
    Panel7: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel17: TPanel;
    Panel19: TPanel;
    Panel16: TPanel;
    Panel20: TPanel;
    Panel21: TPanel;
    Panel22: TPanel;
    Panel23: TPanel;
    Image5: TImage;
    Label4: TLabel;
    Panel24: TPanel;
    Panel25: TPanel;
    Panel34: TPanel;
    Panel35: TPanel;
    Panel26: TPanel;
    Panel27: TPanel;
    Panel32: TPanel;
    Shape1: TShape;
    ListBox1: TListBox;
    SaveDialog1: TSaveDialog;
    procedure Panel12Click(Sender: TObject);
    procedure Panel12MouseEnter(Sender: TObject);
    procedure Panel13MouseEnter(Sender: TObject);
    procedure Panel12MouseLeave(Sender: TObject);
    procedure Panel13MouseLeave(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DoLBChange;
    procedure Panel13Click(Sender: TObject);
  private
    { Private declarations }
  public
        { Public declarations }

  end;

var
  Form5: TForm5;

implementation

uses Unit1;

function NewListBoxProc1(wnd:HWND; uMsg:UINT; wParam:WPARAM; lParam:LPARAM):integer; stdcall;
begin
  result:=CallWindowProc(Pointer(GetWindowLong(wnd,GWL_USERDATA)),wnd,uMsg,wParam,lParam);
    case uMsg of
        LB_ADDSTRING,LB_INSERTSTRING,LB_DELETESTRING,LB_RESETCONTENT,
        LB_GETSEL,LB_SETCURSEL,LB_SELECTSTRING:
                    form5.DoLBChange;
    end;
end;


{$R *.dfm}

procedure TForm5.DoLBChange;
begin
form1.Label14.Caption:=listbox1.Items.Strings[0];
end;



procedure TForm5.FormCreate(Sender: TObject);
begin
  SetWindowLong(listbox1.Handle,GWL_USERDATA,
  SetWindowLong(listbox1.Handle, GWL_WNDPROC, LPARAM(@NewListBoxProc1)));
end;

procedure TForm5.Panel12Click(Sender: TObject);
begin
close;
end;

procedure TForm5.Panel12MouseEnter(Sender: TObject);
begin
(sender as TPanel).Color:=$00151515;
end;

procedure TForm5.Panel12MouseLeave(Sender: TObject);
begin
(sender as TPanel).Color:=$00101010;
end;

procedure TForm5.Panel13Click(Sender: TObject);
begin
if savedialog1.Execute then listbox1.Items.SaveToFile(savedialog1.FileName);
end;

procedure TForm5.Panel13MouseEnter(Sender: TObject);
begin
(sender as TPanel).Color:=$00151515;
end;

procedure TForm5.Panel13MouseLeave(Sender: TObject);
begin
(sender as TPanel).Color:=$00101010;
end;

end.
