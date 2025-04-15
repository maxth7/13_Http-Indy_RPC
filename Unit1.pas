unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  System.NetEncoding,
  Xml.XMLDoc, Xml.XMLIntf,
  System.StrUtils,
  System.Generics.Collections;
const
  URL_LOCAL_SERVER='http://localhost:8080/';

type
  TForm1 = class(TForm)
    IdHTTP1: TIdHTTP;
    MemoMess: TMemo;
    GetAllFuctions: TButton;
    MemoOutParseXML: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    GroupBox1: TGroupBox;
    ComboBoxFunc: TComboBox;
    LabelNumberFunctions: TLabel;

    procedure GetAllFuctionsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBoxFuncChange(Sender: TObject);
  private


    function GetNameFuctions : string;
    function DecompressString(const Input: string): string;
    procedure ParseXML(const AXML: string);
    procedure FillComboBoxFromString(CommaSeparatedString: string);
    function GetFunction(GetRequest: string): string;

    function FillTDictionary(const AXML: string): TDictionary<string, string>;
    procedure OutInMemo(MemoOutParseXML: TMemo;
              Dictionary: TDictionary<string, string>);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
procedure TForm1.FillComboBoxFromString(CommaSeparatedString: string);
var
  StringList: TStringList;
  i: Integer;
begin
  StringList := TStringList.Create;
  try
    ComboBoxFunc.Items.Clear;
    StringList.Delimiter := ',';
    StringList.DelimitedText := CommaSeparatedString;

    for i := 0 to StringList.Count - 1 do
    begin
       if StringList[i]<>'*' then
       begin
         ComboBoxFunc.Items.Add(StringList[i]);
       end;

    end;
   ComboBoxFunc.Text:=ComboBoxFunc.Items[0];
   LabelNumberFunctions.Caption:='Total functions on the server:'
                                  +IntToStr(ComboBoxFunc.Items.Count);
  finally
    StringList.Free;
  end;
end;
procedure TForm1.GetAllFuctionsClick(Sender: TObject);
var
  Base64Content: string;
  DecodedContent: string;
  FirstChar: string;
begin
    try
      begin
       GetAllFuctions.Enabled:=false;
       MemoOutParseXML.Clear;
       MemoMess.Clear;
       DecodedContent:=DecompressString(GetNameFuctions);
       if Length(DecodedContent) > 0 then
        begin
         MemoMess.Lines.Add('Got a list of functions: '+DecodedContent);
         FillComboBoxFromString(DecodedContent);
        end
        else
        begin
          ShowMessage('The line is empty');
        end;
      end
  except
    on E: Exception do
    begin
      GetAllFuctions.Enabled:=true;
      MemoMess.Lines.Add('Error: ' + E.Message);
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    MemoMess.Clear;
end;

function TForm1.GetNameFuctions : string;
begin
    Result := IdHTTP1.Get(URL_LOCAL_SERVER+'0');
end;

  procedure TForm1.ComboBoxFuncChange(Sender: TObject);
  var
   SelectedIndex: Integer;
   SelectedItem: string;
   DecodedContent: string;
   ContentTDictionary: TDictionary<string, string>;
 begin
  SelectedIndex := ComboBoxFunc.ItemIndex;
  if SelectedIndex <> -1 then
  begin
    SelectedItem :=URL_LOCAL_SERVER
                    +  IntToStr(SelectedIndex+1);
    DecodedContent:=DecompressString(GetFunction(SelectedItem));
    MemoMess.Lines.Add(DecodedContent);
    ContentTDictionary := FillTDictionary(DecodedContent);
    try
      OutInMemo(MemoOutParseXML, ContentTDictionary);
     finally
     ContentTDictionary.Free;
   end;
  end
  else
  begin
    ShowMessage('Please select an item from the list.');
  end;
  end;

function TForm1.GetFunction(GetRequest: string): string;
begin
  Result := IdHTTP1.Get(GetRequest);
end;

function TForm1.DecompressString(const Input: string): string;
begin
    Result:= TNetEncoding.Base64.Decode(Input);
end;

procedure TForm1.ParseXML(const AXML: string);
var
  XMLDocument: IXMLDocument;
  RootNode, INNNode, AccountNumberNode, BICNode, PaymentPurposeNode, AmountNode: IXMLNode;
begin
  MemoOutParseXML.Clear;
  XMLDocument := LoadXMLData(AXML);
  RootNode := XMLDocument.DocumentElement;
  INNNode := RootNode.ChildNodes.FindNode('INN');
  if Assigned(INNNode) then
  MemoOutParseXML.Lines.Add('INN: ' + INNNode.Text);
  AccountNumberNode := RootNode.ChildNodes.FindNode('AccountNumber');
  if Assigned(AccountNumberNode) then
  MemoOutParseXML.Lines.Add('AccountNumber: ' + AccountNumberNode.Text);
  BICNode := RootNode.ChildNodes.FindNode('BIC');
  if Assigned(BICNode) then
   MemoOutParseXML.Lines.Add('BIC: ' + BICNode.Text);

  PaymentPurposeNode := RootNode.ChildNodes.FindNode('PaymentPurpose');
  if Assigned(PaymentPurposeNode) then
     MemoOutParseXML.Lines.Add( 'PaymentPurpose: ' + PaymentPurposeNode.Text);

   AmountNode := RootNode.ChildNodes.FindNode('Amount');
  if Assigned(AmountNode) then
   MemoOutParseXML.Lines.Add('Amount: ' + AmountNode.Text);

end;
function TForm1.FillTDictionary(const AXML: string): TDictionary<string, string>;
var
  XMLDoc: IXMLDocument;
  RootNode, ChildNode: IXMLNode;
  DecodedContent: TDictionary<string, string>;
  I: Integer;
begin
  DecodedContent := TDictionary<string, string>.Create;
  try
    XMLDoc := TXMLDocument.Create(nil);
    XMLDoc.LoadFromXML(AXML);
    XMLDoc.Active := True;
    RootNode := XMLDoc.DocumentElement;
    for I := 0 to RootNode.ChildNodes.Count - 1 do
    begin
      ChildNode := RootNode.ChildNodes[I];
      DecodedContent.Add(ChildNode.NodeName, ChildNode.Text);
    end;
    Result := DecodedContent;
  except
    DecodedContent.Free;
    raise; // Passing the exception on
  end;
end;

 procedure TForm1.OutInMemo(MemoOutParseXML: TMemo;
             Dictionary: TDictionary<string, string>);
var
  Key: string;
begin
  MemoOutParseXML.Clear;
  for Key in Dictionary.Keys do
  begin
    MemoOutParseXML.Lines.Add(Key + ': ' + Dictionary[Key]);
  end;
end;

end.
