
{**************************************************************************************************}
{                                                                                                  }
{ Version: 1.4 (2008-10-10)                                                                        }
{   Added: CheckAbort, AbortWorkerThread, AbortLastWorkerThread, AbortAllWorkerThreads             }
{                                                                                                  }
{ Version: 1.3a (2008-07-11)                                                                       }
{   Added: EExternalAbort support (_RaiseAbortInThread, etc)                                       }
{                                                                                                  }
{ Version: 1.2 (2008-06-15)                                                                        }
{   Added: support for run-time packages                                                           }
{   Added: TContext is no longer needed                                                            }
{   Added: small stack buffer is allocated directly on the stack. No GetMem/FreeMem needed         }
{   Added: better exception handling                                                               }
{                                                                                                  }
{ Version: 1.1 (2008-05-30)                                                                        }
{   Fixed: compatibility with different Delphi versions                                            }
{   Fixed: bugs in exception handling implementation                                               }
{                                                                                                  }
{ Version: 1.0 (2008-05-15)                                                                        }
{   Initial release                                                                                }
{                                                                                                  }
{**************************************************************************************************}

{ $DEFINE DEBUG_TASKSEX}

{$A+,B-,C-,D-,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$IFDEF DEBUG_TASKSEX}
  {$D+,C+}
{$ENDIF DEBUG_TASKSEX}
{$UNDEF SUPPORTS_EXPERIMENTAL}
{$UNDEF SUPPORTS_DEPRECATED}
{$UNDEF SUPPORTS_RAISEOUTER}
{$IFDEF CONDITIONALEXPRESSIONS}
  {$IF Declared(RTLVersion) and (RTLVersion >= 18.0)} // unsure
    {$DEFINE SUPPORTS_EXPERIMENTAL}
  {$IFEND}
  {$IF Declared(RTLVersion) and (RTLVersion >= 14.0)}
    {$DEFINE SUPPORTS_DEPRECATED}
  {$IFEND}
{$ENDIF}
{$IFDEF VER200} // D2009
  {$DEFINE SUPPORTS_RAISEOUTER}
{$ENDIF}

unit TasksEx
{$IFNDEF TASKSEXPLUGIN}{$IFDEF SUPPORTS_EXPERIMENTAL}
experimental
{$ENDIF SUPPORTS_EXPERIMENTAL}{$ENDIF TASKSEXPLUGIN};

interface

{$IFNDEF TASKSEXPLUGIN}

uses
  SysUtils, Classes;

{ __ DECLARATIONS ____________________________________________________________ }

type
  // Errors in this unit
  ETasksExError = class(Exception);
    // Error while aborting thread
    EAbortRaiseError = class(ETasksExError);

  // Raised in worked thread at aborting
  EExternalAbort = class(EAbort)
  private
    FTID: Cardinal;
    class function Create: EExternalAbort;
  public
    property ThreadID: Cardinal read FTID;
  end;

  // Deprecated, do not use. For compatibility only.
  TContext = class end
  {$IFDEF SUPPORTS_DEPRECATED} deprecated {$ENDIF SUPPORTS_DEPRECATED};
  // P.S. Why cann't I have "TContext = type integer deprecated;"?

{$WARNINGS OFF} // disable "deprecated" warning

{ __ MAIN ROUTINES ___________________________________________________________ }

// Switch to some worker thread, returns task ID (you can pass Task ID to AbortWorkerThread)
function  EnterWorkerThread: Cardinal;
// Switch back to main thread.
procedure LeaveWorkerThread(ADeprecated: TContext = nil);
// Checks for abort conditions. Raises EExternalAbort.
procedure CheckAbort;

{

  Recommended construction is:

  EnterWorkerThread;
  try
    CheckAbort;
    ... // do some work
    CheckAbort;
    ... // do some work
    CheckAbort;
    ... // do some work
  finally
    LeaveWorkerThread;
  end;

}

// Raises EExternalAbort in last launched worker thread
procedure AbortLastWorkerThread;
// Raises EExternalAbort in all worker threads
procedure AbortAllWorkerThreads;
// Raises EExternalAbort in specific worker thread.
procedure AbortWorkerThread(const ATaskID: Cardinal);
{
  REMARKS.
  The exception will be raised only inside CheckAbort calls and only for
  registered worker threads.
}

{

  Examples:

  1. Cancel all work threads when user hits "Cancel" button:

  // Do some work
  procedure TForm1.Button1Click(Sender: TObject);
  begin
    try
      EnterWorkerThread;
      try
        CheckAbort;
        ... // do some work
        CheckAbort;
        ... // do some work
        CheckAbort;
        ... // do some work
      finally
        LeaveWorkerThread;
      end;
    except
      on EExternalAbort do Exit; // Work was aborted by user
      on Exception do
        ... // Process error (show message, etc)
    end;
  end;

  // Cancel all work
  procedure TForm1.Button2Click(Sender: TObject);
  begin
    AbortAllWorkerThreads;
  end;

  2. Cancel specific work when user hits "Cancel" button:

  var
    TaskID: THandle;

  // Do some work
  procedure TForm1.Button1Click(Sender: TObject);
  begin
    try
      TaskID := EnterWorkerThread;
      try
        CheckAbort;
        ... // do some work
        CheckAbort;
        ... // do some work
        CheckAbort;
        ... // do some work
      finally
        LeaveWorkerThread;
      end;
    except
      on EExternalAbort do Exit; // Work was aborted by user
      on Exception do
        ... // Process error (show message, etc)
    end;
  end;

  // Cancel the specific work
  procedure TForm1.Button2Click(Sender: TObject);
  begin
    AbortWorkerThread(TaskID);
  end;

}

// Registers any thread (TThread, CreateThread, etc) as worker thread.
// Once registered you can abort it with AbortXXX functions above.
procedure RegisterAsWorkerThread(const AThreadID: Cardinal);
procedure UnregisterAsWorkerThread(const AThreadID: Cardinal);

{

  Examples:

  1. Abort specific TThread:

  // Initiate work in external thread
  procedure TForm1.Button1Click(Sender: TObject);
  begin
    MyThread := TMyThread.Create(False);
  end;

  // Wait for thread (optional, you can use try/except inside TMyThread.Execute)
  procedure TForm1.Button2Click(Sender: TObject);
  begin
    MyThread.WaitFor;
    if MyThread.FatalException is EExternalAbort then
      // Work was aborted by user
    else  
      ... // Process error (show message, etc)
    FreeAndNil(MyThread);
  end;

  // Do some work
  procedure TMyThread.Execute;
  begin
    RegisterAsWorkerThread(GetCurrentThreadID);
    try
      CheckAbort;
      ... // do some work
      CheckAbort;
      ... // do some work
      CheckAbort;
      ... // do some work
    finally
      UnregisterAsWorkerThread(GetCurrentThreadID);
    end;
  end;

  // Cancel the specific work
  procedure TForm1.Button2Click(Sender: TObject);
  begin
    AbortWorkerThread(MyThread.ThreadID);
  end;

  2. Abort specific BeginThread:

  var
    TaskID: Cardinal;
  
  // Initiate work in external thread
  procedure TForm1.Button1Click(Sender: TObject);
  begin
    BeginThread(nil, 0, ThreadFunc, nil, 0, TaskID);
  end;

  // Do some work
  function ThreadFunc(Parameter: Pointer): Integer; 
  begin
    Result := 0;
    try
      RegisterAsWorkerThread(GetCurrentThreadID);
      try
        CheckAbort;
        ... // do some work
        CheckAbort;
        ... // do some work
        CheckAbort;
        ... // do some work
      finally
        UnregisterAsWorkerThread(GetCurrentThreadID);
      end;
    except
      on EExternalAbort do Exit; // Work was aborted by user
      on Exception do
        ... // Process error (show message, etc)
    end;
  end;

  // Cancel the specific work
  procedure TForm1.Button2Click(Sender: TObject);
  begin
    AbortWorkerThread(TaskID);
  end;

}

{ __ TOOLS ___________________________________________________________________ }

var
  { Called at except handler in worker thread. }
  { You can use this proc to log information about exception in worker thread. }
  LogCurrentException: procedure = nil;

  { Called before "raise" in main thread when reraising exception. }
  { You can use this proc to indicate "skip exception logging". }
  BeforeReraise: procedure = nil;

// ! DO NOT USE ROUTINES BELOW UNTIL YOU REALLY KNOW WHAT ARE YOU DOING !

// Raises EExternalAbort in another thread.
procedure _RaiseAbortInThread(AThread: TThread); overload; {$IFDEF SUPPORTS_EXPERIMENTAL} experimental; {$ENDIF}
procedure _RaiseAbortInThread(AThreadID: Cardinal); overload; {$IFDEF SUPPORTS_EXPERIMENTAL} experimental; {$ENDIF}
(*

  1. AbortWorkerThread(Cardinal) differs from _RaiseAbortInThread(Cardinal).

  AbortWorkerThread raises exception only inside CheckAbort and only when user
  code is executed in the thread (for external threads - code between
  RegisterAsWorkerThread/UnregisterAsWorkerThread). I.e. AbortWorkerThread is
  fully safe.

  _RaiseAbortInThread raises exception at _ANY_ time.
  It can be your destructor. It can be immediately after call to constructor but
  before assignment (I := TSomeObject.Create;). It potentialy dangerous and can
  lead to resource leaks.

  It is MUCH preffered to register thread as task and use AbortWorkerThread
  instead.

  2. Thread's handle must have the THREAD_QUERY_INFORMATION,
  THREAD_SUSPEND_RESUME, THREAD_GET_CONTEXT, THREAD_SET_CONTEXT access rights to
  the thread.

  3. These abort functions _can not interrupt any kernel-mode code_. If you call
  _RaiseAbortInThread while working thread executes (for example) sleep() then
  exception will be raised immediately _after_ sleep. The sleep itself can not
  be interrupted. If you are using sleep() then replace it with
  WaitForSingleObject and use the following code:

    // In abort proc:
    _RaiseAbortInThread(TaskHandle);
    SetEvent(AbortKernelFunction);

    ...

    // In worker thread:
    WaitForSingleObject(AbortKernelFunction, 60000);
    // instead of sleep(60000);

  For WaitForSingleObject use WaitForMultiplyObjects:

    // In abort proc:
    _RaiseAbortInThread(TaskHandle);
    SetEvent(AbortKernelFunction);

    // In worker thread (pseudo-code):
    WaitForMultiplyObjects([Event, AbortKernelFunction], 60000);
    // instead of WaitForSingleObject(Event, 60000);

  And so on.

*)

{$WARNINGS ON}

{$ENDIF TASKSEXPLUGIN}

implementation

uses
  Windows, Messages,
  {$IFNDEF TASKSEXPLUGIN}
    Forms, AsyncCalls
  {$ELSE TASKSEXPLUGIN}
    SysUtils, LangExtIntf
  {$ENDIF TASKSEXPLUGIN};

{$IFNDEF TASKSEXPLUGIN}

const
  // Buffer size in bytes for small stack buffer.
  // This value can be anything reasonable,
  // but I just wanted SizeOf(TMainThreadContext) to be exactly 128 bytes.
  SmallStackSize = 48;

type
  PMainThreadContext = ^TMainThreadContext;
  TMainThreadContext = packed record
    PrevContext: Cardinal;          // used only in main thread to put contexts
                                    // from all calls to queue

    Reserved: LongInt;              // reserved for MainThreadEntered
    MainThreadOpenBlockCount: LongInt;

    IntructionPointer: Pointer;
    BasePointer: Pointer;
    RetAddr: Pointer;

    WorkerBasePointer: Pointer;
    WorkerStackPointerStart: Pointer;
    ContextRetAddr: Pointer;

    WorkerRegEBX, WorkerRegEDI, WorkerRegESI: Pointer;
    ThreadRegEBX, ThreadRegEDI, ThreadRegESI: Pointer;

    StackBufferCount: Longint;
    StackBuffer: Pointer;

    Exception: Exception;           // exception that occured in worker thread.
                                    // nil = no exception
    LastError: Cardinal;            // thread's GetLastError value

    WorkerThreadID: Cardinal;       // worker thread's ID

    // Use SmallStackBuffer when stack size is less than SmallStackSize
    // else use StackBuffer
    SmallStackBuffer: array[0..SmallStackSize-1] of Byte;
  end;

const
  // This value MUST be multiply of 4 (four)!
  SizeOfTMainThreadContext = SizeOf(TMainThreadContext);

var
  { Calculated at unit's initialization. }
  { Those are needed for run-time packages support. }
  System_HandleFinally: Pointer;
  System_HandleAutoException: Pointer;
  // List of worker threads. Used for AbortXXX funcs.
  WorkerThreadsIDs: TList;
  AbortedThreadIDs: TList;
  // For synchronizing access to lists
  WorkerThreadsCS: TRTLCriticalSection;
  // = True after AbortAllWorkerThreads, = False after EnterWorkerThread
  // Required, becuase threads may be not started due to limited thread pool
  // If thread not started then it is not in WorkerThreadsIDs => unable to cancel it
  AbortingAllThreads: Boolean;

resourcestring
  RsEnterWorkerThreadError = 'TasksEx.EnterWorkerThread() was called outside of the main thread.';
  RsLeaveWorkerNestedError = 'Unpaired call to TasksEx.LeaveWorkerThread().';
  RsLeaveWorkerThreadError = 'TasksEx.LeaveWorkerThread() was called outside of the worker thread.';
  RsErrorDuplicatingHandle = 'TasksEx.ReadHandle(): unable to duplicate thread''s handle: %s';
  RsErrorRaisingAbortExcep = 'TasksEx._RaiseAbortInThread(): unable to raise exception in external thread (it is recommended to restart application immediately):'#13#10'%s';

// _____________________________________________________________________________


{ Temp storage for pointer to var MainThreadContext }

{

  Context variable MainThreadContext is allocated on the stack.
  So all function must somehow save pointer to this variable.
  Temp storage is used for this purpose in all functions.

  In worker thread temp context is setuped and cleared by
  InternalExecuteInWorkerTread (before and after executing user code).
  LeaveWorkerThread can pick up pointer to MainThreadContext from temp storage.
  Nested calls to EnterWorkerThread also uses temp storage.

  In main thread pointer to MainThreadContext is stored in registers inside
  EnterWorkerThread. But all registers are lost when
  try/ExecuteInWorkerTread/finally block raises an exeption.
  In order to preserve the pointer EnterWorkerThread setups temp storage before
  "try" and clears it inside "finally" block.
  We can have multiply calls to EnterWorkerThread (second call call be executed
  by user while first call waits for first worker thread completion and runs
  message pumping cycle). So in main thread we must "queue" pointers to
  MainThreadContext while using temp storage. PrevContext field is used for this
  purpose.

  No additional synchronization is needed cause temp storage is thread-safe and
  data from different threads allocated on threads' stacks => it do not overlap.

}

threadvar
  FContext: PMainThreadContext;

// Clears temp storage. nil value is used to detect invalid calls to
// EnterWorkerThread inside non-main thread.
procedure ClearTempContext;
var
  H: Cardinal;
begin
  // In DLL any work with threadvar lead to loose of GetLastResult's value
  H := GetLastError;
  FContext := nil;
  SetLastError(H);
end;

// Setups temp storage. Preserves EAX to simplify asm-code.
function SetTempContext(Temp: PMainThreadContext): Pointer;
var
  H: Cardinal;
begin
  H := GetLastError;
  FContext := Temp;
  SetLastError(H);
  // Set EAX = var MainThreadContext
  Result := Temp;
end;

// Reads temp storage.
function GetTempContext: PMainThreadContext;
var
  H: Cardinal;
begin
  H := GetLastError;
  Result := FContext;
  SetLastError(H);
end;

// _____________________________________________________________________________

// Registers any thread (TThread, CreateThread, etc) as worker thread.
procedure RegisterAsWorkerThread(const AThreadID: Cardinal);
begin
  if (WorkerThreadsIDs = nil) or (AThreadID = 0) then
    Exit;
  EnterCriticalSection(WorkerThreadsCS);
  try
    if WorkerThreadsIDs = nil then
      Exit;
    if WorkerThreadsIDs.IndexOf(Pointer(AThreadID)) < 0 then
      WorkerThreadsIDs.Add(Pointer(AThreadID));
  finally
    LeaveCriticalSection(WorkerThreadsCS);
  end;
end;

// Unregister thread as worker thread
procedure UnregisterAsWorkerThread(const AThreadID: Cardinal);
var
  X: Integer;
begin
  if WorkerThreadsIDs = nil then
    Exit;
  EnterCriticalSection(WorkerThreadsCS);
  try
    if WorkerThreadsIDs = nil then
      Exit;
    X := WorkerThreadsIDs.IndexOf(Pointer(AThreadID));
    while X >= 0 do
    begin
      WorkerThreadsIDs.Delete(X);
      X := WorkerThreadsIDs.IndexOf(Pointer(AThreadID));
    end;
    X := AbortedThreadIDs.IndexOf(Pointer(AThreadID));
    while X >= 0 do
    begin
      AbortedThreadIDs.Delete(X);
      X := AbortedThreadIDs.IndexOf(Pointer(AThreadID));
    end;
  finally
    LeaveCriticalSection(WorkerThreadsCS);
  end;
end;

// _____________________________________________________________________________

// Retrieves real handle from pseudo a one
function _RealHandle(const AHandle: THandle): THandle;
var
  H: Cardinal;
  E: EOSError;
begin
  if not DuplicateHandle(GetCurrentProcess, AHandle, GetCurrentProcess, @Result, 0, False, DUPLICATE_SAME_ACCESS) then
  begin
    H := GetLastError;
    E := EOSError.CreateFmt(RsErrorDuplicatingHandle, [SysErrorMessage(H)]);
    E.ErrorCode := H;
    {$IFDEF SUPPORTS_RAISEOUTER}
    Exception.RaiseOuterException(E);
    {$ELSE}
    raise E;
    {$ENDIF}
  end;
end;

// Returns real handle of current thread
function GetCurrentThreadHandle: THandle;
begin
  Result := _RealHandle(GetCurrentThread);
end;

// _____________________________________________________________________________

{ Main code }

{ Called from worker thread. Initializes user code between Enter/LeaveWorkerThread. }
procedure InternalExecuteInWorkerTread(Param: Pointer);
asm
  push ebp

  { Backup worker thread state }
  mov edx, OFFSET @@Leave
  mov [eax].TMainThreadContext.ContextRetAddr, edx
  mov [eax].TMainThreadContext.WorkerBasePointer, ebp
  mov [eax].TMainThreadContext.WorkerStackPointerStart, esp

  { Backup worker thread registers }
  mov [eax].TMainThreadContext.WorkerRegEBX, ebx
  mov [eax].TMainThreadContext.WorkerRegEDI, edi
  mov [eax].TMainThreadContext.WorkerRegESI, esi

  { Switch to the thread state }
  mov ebp, [eax].TMainThreadContext.BasePointer

  { Switch to the thread registers }
  mov ebx, [eax].TMainThreadContext.ThreadRegEBX
  mov edi, [eax].TMainThreadContext.ThreadRegEDI
  mov esi, [eax].TMainThreadContext.ThreadRegESI

  { Setup temp storage: save var MainThreadContext for LeaveWorkerThread
  { and nested calls to EnterWorkerThread }
  call SetTempContext

  { Restore GetLastResult }
  mov ecx, [eax].TMainThreadContext.LastError
  push ecx
  call SetLastError

  { Jump to the user's worker code }
  call GetTempContext
  mov edx, [eax].TMainThreadContext.IntructionPointer
  mov eax, [eax].TMainThreadContext.WorkerThreadID
  jmp edx

  { LeaveMainThread() will jump to this address after it has restored the main
    thread state. }
@@Leave:

  { Clear temp storage }
  call ClearTempContext
  pop ebp
end;

{ Wrapper for InternalExecuteInWorkerTread }

type
  PParams = ^TParams;
  TParams = record
              Param: PMainThreadContext;
              Finished: Boolean;
            end;

{ Called from worker thread. Handles exceptions in user code and signals to }
{ main thread about end of work. }
function ExecuteInWorkerThreadWrapper(Param: INT_PTR): INT_PTR;
// TLocalAsyncProcEx = function(Param: INT_PTR): INT_PTR;
var
  P: PParams;
  ThreadID: Cardinal;
begin
  P := PParams(Pointer(Param));
  try
    Result := 0;   // not used for now
    try
      ThreadID := GetCurrentThreadId;
      RegisterAsWorkerThread(ThreadID);
      try
        PMainThreadContext(P^.Param).WorkerThreadID := GetCurrentThreadId;
        InternalExecuteInWorkerTread(P^.Param);
      finally
        UnregisterAsWorkerThread(ThreadID);
      end;
      Result := 1; // not used for now
    except
      P^.Param^.Exception := AcquireExceptionObject;
    end;
  finally
    P^.Finished := True;
    // Wake up main thread from Application.HandleMessage
    PostThreadMessage(MainThreadId, WM_NULL, 0, 0);
  end;
end;

{ Called from main thread. }
{ Executes InternalExecuteInWorkerTread in worker thread. }
{ Preserves EAX to simplify asm-code. }
function ExecuteInWorkerThread(Param: PMainThreadContext): Pointer;
var
  A: IAsyncCall;
  P: TParams;
  E: Exception;
begin
  try
    P.Finished := False;
    P.Param := Param;

    { Execute user code in another thread. }
    A := LocalAsyncCallEx(ExecuteInWorkerThreadWrapper, INT_PTR(@(P)));

    { Waits for end of user's code work. Do pump message cycle while waiting. }
    while not P.Finished do
      Application.HandleMessage;

    { Reraise exception if one occcured in worker thread. }
    E := Param^.Exception;
    Param^.Exception := nil;
    if E <> nil then
    begin
      if Assigned(BeforeReraise) then
        BeforeReraise;
      {$IFDEF SUPPORTS_RAISEOUTER}
      Exception.RaiseOuterException(E);
      {$ELSE}
      raise E;
      {$ENDIF}
    end;

  finally
    // Set EAX = var MainThreadContext
    Result := Param;
  end;
end;

procedure EnterWorkerThreadError;
begin
  {$IFDEF SUPPORTS_RAISEOUTER}
  Exception.RaiseOuterException(ETasksExError.Create(RsEnterWorkerThreadError));
  {$ELSE}
  raise ETasksExError.Create(RsEnterWorkerThreadError);
  {$ENDIF}
end;

procedure LeaveWorkerThreadError;
begin
  {$IFDEF SUPPORTS_RAISEOUTER}
  Exception.RaiseOuterException(ETasksExError.Create(RsLeaveWorkerThreadError));
  {$ELSE}
  raise ETasksExError.Create(RsLeaveWorkerThreadError);
  {$ENDIF}
end;

procedure LeaveWorkerNestedError;
begin
  {$IFDEF SUPPORTS_RAISEOUTER}
  Exception.RaiseOuterException(ETasksExError.Create(RsLeaveWorkerNestedError));
  {$ELSE}
  raise ETasksExError.Create(RsLeaveWorkerNestedError);
  {$ENDIF}
end;

// Preserves EAX
function ZeroMemory(P: Pointer; Count: Integer): Pointer;
begin
  FillChar(P^, Count, 0);
  Result := P;
end;

function InitStackBuffer(MainThreadContext: PMainThreadContext; Count: Integer): Pointer;
begin
  MainThreadContext^.StackBufferCount := Count;
  if Count > 0 then
  begin
    if Count > SmallStackSize then
    begin
      GetMem(MainThreadContext^.StackBuffer, Count);
      ZeroMemory(MainThreadContext^.StackBuffer, Count);
      Result := MainThreadContext^.StackBuffer;
    end
    else
      Result := @MainThreadContext^.SmallStackBuffer;
  end
  else
    Result := nil;
end;

function DoneStackBuffer(MainThreadContext: PMainThreadContext): Pointer;
var
  H: Cardinal;
begin
  H := GetLastError;
  try
    if MainThreadContext^.StackBuffer <> nil then
      FreeMem(MainThreadContext^.StackBuffer);
  finally
    ZeroMemory(MainThreadContext, SizeOfTMainThreadContext);
    SetLastError(H);
    Result := MainThreadContext;
  end;
end;

function GetStackBuffer(MainThreadContext: PMainThreadContext): Pointer;
begin
  if MainThreadContext^.StackBufferCount > SmallStackSize then
    Result := MainThreadContext.StackBuffer
  else
    Result := @MainThreadContext^.SmallStackBuffer;
end;

function GetMainThreadId: LongWord;
begin
  Result := MainThreadId;
end;

{$WARNINGS OFF}
procedure LeaveWorkerThread(ADeprecated: TContext);
{$WARNINGS ON}
asm
  { Called in worker thread }

  { Check if we are in the worker thread }
  call GetCurrentThreadId
  mov ecx, eax
  call GetMainThreadId
  mov edx, eax
  cmp edx, ecx
  je @@ThreadError

  { Get saved var MainThreadError }
  call GetTempContext

  { Nested call? Nothing to do }
  test eax, eax
  jz @@NestedError
  mov ecx, [eax].TMainThreadContext.MainThreadOpenBlockCount
  dec ecx
  js @@NestedError
  mov [eax].TMainThreadContext.MainThreadOpenBlockCount, ecx
  test ecx, ecx
  jnz @@Leave

  { Save GetLastError }
  push eax
  call GetLastError
  mov edx, eax
  pop eax

  { Save the current registers for the return, the compiler might have
    generated code that changed the registers in the worker code. }
  mov [eax].TMainThreadContext.LastError, edx
  mov [eax].TMainThreadContext.ThreadRegEBX, ebx
  mov [eax].TMainThreadContext.ThreadRegEDI, edi
  mov [eax].TMainThreadContext.ThreadRegESI, esi
  { Restore worker thread registers }
  mov ebx, [eax].TMainThreadContext.WorkerRegEBX
  mov edi, [eax].TMainThreadContext.WorkerRegEDI
  mov esi, [eax].TMainThreadContext.WorkerRegESI
  mov ecx, eax

  { Detect if the finally block is called by System._HandleFinally.
    In that case an exception was raised in the WorkerThread-Block. The
    TasksEx.ExecuteInWorkerThreadWrapper function will handle the exception and
    the thread switch for us. This will also restore the EBP register. }
  mov eax, [esp + $04] // finally return address // todo: adjust for 64 bit ?
  mov edx, System_HandleFinally
  cmp eax, edx
  jl @@NoException
  mov edx, System_HandleAutoException
  cmp eax, edx
  jl @@InException
@@NoException:

  { Backup the return addresses }
  pop edx // procedure return address

  mov eax, ecx
  mov [eax].TMainThreadContext.RetAddr, edx

  { Pop all items from the stack that are between ESP and MainStackPointerStart
    to an internal buffer that is pushed back on the stack in the
    "EnterMainThread" leave-code. }
  mov ecx, [eax].TMainThreadContext.WorkerStackPointerStart
  mov edx, ecx
  sub edx, esp
  or edx, edx
  jz @@IgnoreCopyStackLoop
  push eax
  push edx             // Count => Stack
  call InitStackBuffer // returns EAX=Pointer to first item
  mov edx, eax
  pop ecx              // Stack => Count
  pop eax

@@CopyStackLoop:
  pop ebp
  mov [edx], ebp
  add edx, 4 // todo: adjust for 64 bit ?
  sub ecx, 4 // todo: adjust for 64 bit ?
  jnz @@CopyStackLoop

@@IgnoreCopyStackLoop:

  { Restore the main thread state }
  mov ebp, [eax].TMainThreadContext.WorkerBasePointer
  mov edx, [eax].TMainThreadContext.ContextRetAddr

  { Return to InternalExecuteInWorkerTread }
  jmp edx

@@ThreadError:
  call LeaveWorkerThreadError

@@NestedError:
  call LeaveWorkerNestedError

@@InException:
  // Here user can log info about exception for EurekaLog, JCL, etc...
  mov edx, LogCurrentException
  test edx, edx
  jz @@SkipLog
  xor eax, eax
  call edx
@@SkipLog:
  call ClearTempContext
  
@@Leave:
end;

{$WARNINGS OFF}
function EnterWorkerThread: Cardinal;
{$WARNINGS ON}
asm
  { Called from main thread or worker thread (nested call). }

  { There is nothing to do if we are already in the worker thread }
  call GetCurrentThreadId
  mov ecx, eax
  call GetMainThreadId
  cmp eax, ecx
  jne @@InWorkerThread

  { Cancel "abort all" condition }
  xor eax, eax
  mov AbortingAllThreads, al

  { Take the return address from the stack to "clean" the stack }
  pop ecx

  { var MainThreadContext: TMainThreadContext }
  { Allocate MainThreadContext on the stack and prepare it }
  mov edx, SizeOfTMainThreadContext
  sub esp, edx
  mov eax, esp
  push ecx
  call ZeroMemory
  pop ecx

  { Save thread's GetLastError }
  call GetLastError;
  mov edx, eax
  mov eax, esp

  { Backup the current thread state }
  mov [eax].TMainThreadContext.LastError, edx
  mov [eax].TMainThreadContext.IntructionPointer, ecx
  mov [eax].TMainThreadContext.BasePointer, ebp
  { Backup the current thread registers }
  mov [eax].TMainThreadContext.ThreadRegEBX, ebx
  mov [eax].TMainThreadContext.ThreadRegEDI, edi
  mov [eax].TMainThreadContext.ThreadRegESI, esi

  { Nested call control }
  inc [eax].TMainThreadContext.MainThreadOpenBlockCount
  mov ebx, eax

  { Backup previous context var and store pointer to new var MainThreadContext }
  call GetTempContext
  mov edx, eax
  mov eax, ebx
  mov [eax].TMainThreadContext.PrevContext, edx
  call SetTempContext

  { Begin try/finally }
@@Try:
  xor eax, eax
  push ebp
  push OFFSET @@HandleFinally
  push dword ptr fs:[eax]
  mov fs:[eax], esp

  { Execute InternalExecuteInWorkerThread(@MainThreadContext) in worker thread }
  mov eax, ebx
  call ExecuteInWorkerThread

  { Clean up try/finally }
  xor eax, eax
  pop edx
  pop ecx
  pop ecx
  mov fs:[eax], edx

  { Restore thread state }
  mov eax, ebx
  mov ebp, [eax].TMainThreadContext.BasePointer

  { Search for new place for var MainThreadContext }
  { If stack size is small (less than SizeOfTMainThreadContext) then place new
    var just after old var. We must guarantee that restoring backuped stack will
    not damage our stack-variable MainThreadContext. }
  mov ecx, [eax].TMainThreadContext.StackBufferCount
  cmp ecx, SizeOfTMainThreadContext
  jg @@Move
  mov ecx, SizeOfTMainThreadContext
@@Move:
  sub ebx, ecx
  sub ecx, 4 // todo: adjust for 64 bit ?

  { Move var MainThreadContext to the new location }
@@Copy:
  mov edx, [eax]
  mov [ebx], edx
  add eax, 4 // todo: adjust for 64 bit ?
  add ebx, 4 // todo: adjust for 64 bit ?
  sub ecx, 4 // todo: adjust for 64 bit ?
  jns @@Copy
  mov edx, SizeOfTMainThreadContext
  sub ebx, edx

  { Clean up var (zeroing memory is optional) }
  add esp, edx

  { Now, we can not call any function. If we call something then stack can we
    rewrited and new variable MainThreadContext will be damaged. }

  { Push the backuped stack items back to the stack }
  mov eax, ebx
  mov ecx, [eax].TMainThreadContext.StackBufferCount
  sub ecx, 4
  js @@IgnoreRestoreStack
  push ecx
  call GetStackBuffer
  pop ecx
  mov edx, ecx
  add eax, edx // move to buffer end
@@RestoreStack:
  mov edx, [eax]
  sub eax, 4 // todo: adjust for 64 bit ?
  push edx
  sub ecx, 4 // todo: adjust for 64 bit ?
  jns @@RestoreStack
@@IgnoreRestoreStack:
  { Put return address back to the stack }
  mov eax, ebx
  mov edx, [eax].TMainThreadContext.RetAddr
  push edx

  { End try/finally }
@@Finally:
  // In exception case: EAX is restored from temp storage in @@HandleFinally block

  { Pop one item from queue }
  { If there is only one pending call to EnterWorkerThread then this will }
  { clean the temp storage }
  mov ebx, eax
  mov eax, [eax].TMainThreadContext.PrevContext
  call SetTempContext
  mov eax, ebx

  { Restore thread registers }
  mov ebx, [eax].TMainThreadContext.ThreadRegEBX
  mov edi, [eax].TMainThreadContext.ThreadRegEDI
  mov esi, [eax].TMainThreadContext.ThreadRegESI
  mov ecx, [eax].TMainThreadContext.LastError

  { Restore GetLastError's value }
  push eax
  push ecx
  call SetLastError
  pop eax

  { var MainThreadContext not needed now, so we can finalize it }
  call DoneStackBuffer
  xor eax, eax

  ret

@@HandleFinally:
  jmp System.@HandleFinally
  { Read pointer to var MainThreadContext from temp storage }
  call GetTempContext
  jmp @@Finally
@@LeaveFinally:
  xor eax, eax
  ret

@@InWorkerThread:
  { Adjust "nested call" control }
  call GetTempContext
  test eax, eax
  jz @@ThreadError
  inc [eax].TMainThreadContext.MainThreadOpenBlockCount
  xor eax, eax
  ret

@@ThreadError:
  { raise exception }
  call EnterWorkerThreadError
end;

{ EExternalAbort }

class function EExternalAbort.Create: EExternalAbort;
begin
  Result := inherited Create('');
  Result.FTID := GetCurrentThreadId;
end;

// $W- (in unit's header) has the same effect
{$STACKFRAMES OFF}

procedure RaiseExternalAbort;
begin
  {$IFDEF SUPPORTS_RAISEOUTER}
  Exception.RaiseOuterException(EExternalAbort.Create);
  {$ELSE}
  raise EExternalAbort.Create;
  {$ENDIF}
end;

// Requires WinME/Win2k minimum
function OpenThread(dwDesiredAccess: DWORD; bInheritHandle: BOOL;
  dwThreadId: DWORD): THANDLE; stdcall; external kernel32;

procedure _RaiseAbortInThread(AThreadID: Cardinal); overload;
const
  THREAD_TERMINATE            = $0001;
  THREAD_SUSPEND_RESUME       = $0002;
  THREAD_GET_CONTEXT          = $0008;
  THREAD_SET_CONTEXT          = $0010;
  THREAD_SET_INFORMATION      = $0020;
  THREAD_QUERY_INFORMATION    = $0040;
  THREAD_SET_THREAD_TOKEN     = $0080;
  THREAD_IMPERSONATE          = $0100;
  THREAD_DIRECT_IMPERSONATION = $0200;
  THREAD_ALL_ACCESS           = STANDARD_RIGHTS_REQUIRED or SYNCHRONIZE or $3FF;
var
  Context: Windows.TContext;
  Handle: THandle;
begin
  try
    Handle := OpenThread(SYNCHRONIZE or THREAD_QUERY_INFORMATION or THREAD_SUSPEND_RESUME or THREAD_GET_CONTEXT or THREAD_SET_CONTEXT, False, AThreadID);
    if Handle = 0 then
      RaiseLastOSError;
    try
      FillChar(Context, SizeOf(Context), 0);
      Context.ContextFlags := CONTEXT_CONTROL;
      if SuspendThread(Handle) = DWORD(-1) then
        RaiseLastOSError;
      try
        if not GetThreadContext(Handle, Context) then
          RaiseLastOSError;
        Context.Eip := DWord(@RaiseExternalAbort);
        if not SetThreadContext(Handle, Context) then
          RaiseLastOSError;
      finally
        if ResumeThread(Handle) = DWORD(-1) then
          RaiseLastOSError;
      end;
    finally
      CloseHandle(Handle);
    end;
  except
    on E: Exception do
      {$IFDEF SUPPORTS_RAISEOUTER}
      Exception.RaiseOuterException(EAbortRaiseError.CreateFmt(RsErrorRaisingAbortExcep, [E.Message]));
      {$ELSE}
      raise EAbortRaiseError.CreateFmt(RsErrorRaisingAbortExcep, [E.Message]);
      {$ENDIF}
  end;
end;

procedure _RaiseAbortInThread(AThread: TThread); overload;
begin
  _RaiseAbortInThread(AThread.Handle);
end;

procedure CheckAbort;
  procedure AbortThread(const ID: Cardinal);
  begin
    UnregisterAsWorkerThread(ID);
    RegisterAsWorkerThread(ID);
    RaiseExternalAbort;
  end;

var
  ID: Cardinal;
begin
  ID := GetCurrentThreadId;
  if AbortingAllThreads then
    AbortThread(ID);
  if (WorkerThreadsIDs = nil) or (AbortedThreadIDs = nil) then
    Exit;
  EnterCriticalSection(WorkerThreadsCS);
  try
    if (WorkerThreadsIDs = nil) or (AbortedThreadIDs = nil) then
      Exit;
    if AbortedThreadIDs.IndexOf(Pointer(ID)) >= 0 then
      AbortThread(ID);
  finally
    LeaveCriticalSection(WorkerThreadsCS);
  end;
end;

procedure AbortWorkerThread(const ATaskID: Cardinal);
begin
  if (WorkerThreadsIDs = nil) or (AbortedThreadIDs = nil) or (ATaskID = 0) then
    Exit;
  EnterCriticalSection(WorkerThreadsCS);
  try
    if (WorkerThreadsIDs = nil) or (AbortedThreadIDs = nil) then
      Exit;
    if WorkerThreadsIDs.IndexOf(Pointer(ATaskID)) >= 0 then
      AbortedThreadIDs.Add(Pointer(ATaskID));
  finally
    LeaveCriticalSection(WorkerThreadsCS);
  end;
end;

procedure AbortLastWorkerThread;
begin
  if (WorkerThreadsIDs = nil) or (AbortedThreadIDs = nil) then
    Exit;
  EnterCriticalSection(WorkerThreadsCS);
  try
    if (WorkerThreadsIDs = nil) or (AbortedThreadIDs = nil) then
      Exit;
    if WorkerThreadsIDs.Count > 0 then
      AbortWorkerThread(Cardinal(WorkerThreadsIDs[WorkerThreadsIDs.Count - 1]));
  finally
    LeaveCriticalSection(WorkerThreadsCS);
  end;
end;

procedure AbortAllWorkerThreads;
var
  X: Integer;
begin
  AbortingAllThreads := True;
  if (WorkerThreadsIDs = nil) or (AbortedThreadIDs = nil) then
    Exit;
  EnterCriticalSection(WorkerThreadsCS);
  try
    if (WorkerThreadsIDs = nil) or (AbortedThreadIDs = nil) then
      Exit;
    for X := 0 to WorkerThreadsIDs.Count - 1 do
      AbortWorkerThread(Cardinal(WorkerThreadsIDs[X]));
  finally
    LeaveCriticalSection(WorkerThreadsCS);
  end;
end;

// Checks for "jmp ADDR" dummy.
function ConvertAddress(Addr: DWord): Pointer;
type
  TJMPCode = packed record
    JMPOpCode: Word;
    JMPPtr: PDWord;
  end;
  PJMPCode = ^TJMPCode;
var
  JMP: PJMPCode;
begin
  Result := Pointer(Addr);
  JMP := PJMPCode(Addr);
  if JMP^.JMPOpCode = $25FF then
    Result := Pointer(JMP^.JMPPtr^);
end;

procedure Init;
var
  P1, P2: DWord;
begin
  FillChar(WorkerThreadsCS, SizeOf(WorkerThreadsCS), 0);
  // Is there a way to get those pointers in native Pascal?
  asm
    mov eax, OFFSET System.@HandleFinally
    mov P1, eax
    mov eax, OFFSET System.@HandleAutoException
    mov P2, eax
  end;
  System_HandleFinally := ConvertAddress(P1);
  System_HandleAutoException := ConvertAddress(P2);
  InitializeCriticalSection(WorkerThreadsCS);
  WorkerThreadsIDs := TList.Create;
  AbortedThreadIDs := TList.Create;
end;

procedure Done;
begin
  EnterCriticalSection(WorkerThreadsCS);
  try
    FreeAndNil(WorkerThreadsIDs);
    FreeAndNil(AbortedThreadIDs);
  finally
    LeaveCriticalSection(WorkerThreadsCS);
  end;
  DeleteCriticalSection(WorkerThreadsCS);
  FillChar(WorkerThreadsCS, SizeOf(WorkerThreadsCS), 0);
end;

initialization
  Init;

finalization
  Done;

// _____________________________________________________________________________

{$ELSE TASKSEXPLUGIN}
// _____________________________________________________________________________

type
  TTasksExExtension = class(TInterfacedObject, ILanguageExtension)
  public
    function AlterContent(Services: ILanguageExtensionServices; Content: IString): LongBool; stdcall;
    function AlterContentSecondPass(Services: ILanguageExtensionServices; Content: IString): LongBool; stdcall;
    procedure CompileProject(ProjectFilename: PAnsiChar); stdcall;
    procedure GenerateExportStreams(Services: ILanguageExtensionServices); stdcall;
  end;

{ TTasksExExtension }

procedure TTasksExExtension.CompileProject(ProjectFilename: PAnsiChar);
begin
end;

function TTasksExExtension.AlterContent(Services: ILanguageExtensionServices;
  Content: IString): LongBool;

  // SysUtils (modified)
  function StringReplace(const S, OldPattern, NewPattern: WideString; var AModified: Boolean): WideString;
  var
    SearchStr, Patt, NewStr: WideString;
    Offset: Integer;
  begin
    SearchStr := WideUpperCase(S);
    Patt := WideUpperCase(OldPattern);
    if Pos(Patt, SearchStr) = 0 then
    begin
      Result := S;
      Exit;
    end;
    AModified := True;
    NewStr := S;
    Result := '';
    while SearchStr <> '' do
    begin
      Offset := Pos(Patt, SearchStr);
      if Offset = 0 then
      begin
        Result := Result + NewStr;
        Break;
      end;
      Result := Result + Copy(NewStr, 1, Offset - 1) + NewPattern;
      NewStr := Copy(NewStr, Offset + Length(OldPattern), MaxInt);
      SearchStr := Copy(SearchStr, Offset + Length(Patt), MaxInt);
    end;
  end;

  // JclWideStrings
  procedure StrSwapByteOrder(Str: PWideChar);
  asm
         PUSH    ESI
         PUSH    EDI
         MOV     ESI, EAX
         MOV     EDI, ESI
         XOR     EAX, EAX // clear high order byte to be able to use 32bit operand below
  @@1:
         LODSW
         OR      EAX, EAX
         JZ      @@2
         XCHG    AL, AH
         STOSW
         JMP     @@1
  @@2:
         POP     EDI
         POP     ESI
  end;

type
  TEncode = (enANSI, enUTF8, enUTF16, enUTF16rev);
const
  // JclUnicode
  BOM_LSB_FIRST = WideChar($FEFF);
  BOM_MSB_FIRST = WideChar($FFFE);
  BOM_UTF8: String = #$EF#$BB#$BF;
var
  S, BOM: AnsiString;
  W: WideString;
  Len: Cardinal;
  Encode: TEncode;
  Modified: Boolean;
begin
  { BDS 2006 or newer: Unicode BOM is included in the Content }
  SetString(S, Content.GetString(Len), Len);
  if Length(S) < 4 then
  begin
    Result := False;
    Exit;
  end;
  BOM := Copy(S, 1, 2);
  if CompareMem(Pointer(S), Pointer(BOM_UTF8), Length(BOM_UTF8))  then
  begin
    W := UTF8Decode(Copy(S, 4, MaxInt));
    Encode := enUTF8;
  end
  else
  if BOM = BOM_LSB_FIRST then
  begin
    S := Copy(S, 3, MaxInt);
    SetLength(W, Length(S) shr 1);
    Move(Pointer(S)^, Pointer(W)^, Length(W) shl 1);
    StrSwapByteOrder(Pointer(W));
    Encode := enUTF16rev;
  end
  else
  if BOM = BOM_MSB_FIRST then
  begin
    S := Copy(S, 3, MaxInt);
    SetLength(W, Length(S) shr 1);
    Move(Pointer(S)^, Pointer(W)^, Length(W) shl 1);
    Encode := enUTF16;
  end
  else
  begin
    W := S;
    Encode := enANSI;
  end;
  Modified := False;

  // ' + ' is pasted to prevent source modifying
  // while recompile plugin with plugin already installed and worked
  W := StringReplace(W, 'begin' + '_thread', 'EnterWorkerThread; try', Modified);
  W := StringReplace(W, 'end' + '_thread', 'finally LeaveWorkerThread; end;', Modified);
  W := StringReplace(W, 'begin' + '_main', 'EnterMainThread; try', Modified);
  W := StringReplace(W, 'end' + '_main', 'finally LeaveMainThread; end;', Modified);

  if Modified then
  begin
    case Encode of
      enANSI:
        S := W;
      enUTF8:
        S := BOM_UTF8 + UTF8Encode(W);
      enUTF16:
        begin
          W := BOM_MSB_FIRST + W;
          SetLength(S, Length(W) shl 1);
          Move(Pointer(W)^, Pointer(S)^, Length(S));
        end;
      enUTF16rev:
        begin
          StrSwapByteOrder(Pointer(W));
          W := BOM_LSB_FIRST + W;
          SetLength(S, Length(W) shl 1);
          Move(Pointer(W)^, Pointer(S)^, Length(S));
        end;
    end;
    Content.SetString(Pointer(S), Length(S));
    Result := True;
  end
  else
    Result := False;
end;

function TTasksExExtension.AlterContentSecondPass(Services: ILanguageExtensionServices; Content: IString): LongBool;
begin
  Result := False;
end;

procedure TTasksExExtension.GenerateExportStreams(Services: ILanguageExtensionServices);
begin
end;

{--------------------------------------------------------------------------------------------------}

procedure RegisterLanguageExtensions;
begin
  DLangExt_RegisterExtension(TTasksExExtension.Create);
end;
                                  
initialization
  RegisterLanguageExtensionProc := RegisterLanguageExtensions;

{$ENDIF TASKSEXPLUGIN}

end.
