structure T = Thread(structure T = ThreadBase
                     structure RC = SelectReactorCore
                     structure C = ConfigPrintEverything)

structure CS = ChiralSocketFn(T)

structure CHTTPServer = HTTPServerFn(structure CS = CS structure T = T)
