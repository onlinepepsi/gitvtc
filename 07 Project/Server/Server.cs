﻿using System.Net;
using System.Net.Sockets;
using System.Text;

namespace Project
{
    internal class Server
    {
        internal class Table
        {
            public Socket socket;
            public String name;
            public Table(Socket _tableSocket, String _name)
            {
                socket = _tableSocket;
                name = _name;
                Console.WriteLine("Table " + _name + " connected");
                StartTable(socket);

            }
        }

        public static class Cook {
            public static void Start(Socket client) {
                Thread thread = new Thread(() => {
                    //Start
                    Console.WriteLine("Cook connected");
                    bool isClosed = false;
                    while (!isClosed)
                    {
                        if (!client.Connected) isClosed = true;
                        String receivedString; try { receivedString = GetStringData(client);}
                        catch (SocketException){Console.WriteLine("Cook closed");return;}
                        String command = (receivedString.Split(":"))[0]; 
                        String receivedData = "";try { receivedData = (receivedString.Split(":"))[1]; } catch (Exception) { }

                        switch (command)
                        {

                            case "Close":
                                isClosed = true;
                                Console.WriteLine("Cook closed");
                                client.Close();
                                break;
                            default:
                                Console.WriteLine("Cook sent: \""+receivedString+ "\"");
                                break;
                        }

                    }



                    //End
                });
                thread.Start();
            }

        }
        static List<Table> tables = new List<Table>();
        static void Main(string[] args)
        {

            IPEndPoint iep = new IPEndPoint(IPAddress.Parse("127.0.0.1"), 8888);
            Socket server = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            server.Bind(iep);
            server.Listen(99);
            
            new Thread(() => {
                Console.WriteLine("Ready");
                Socket client;
                String str;
                while (true) {
                    client = server.Accept();
                    str = GetStringData(client);

                    if (str.Split(":")[0].Equals("Table")) tables.Add(new Table(client, str.Split(":")[1]));
                    else if (str.Split(":")[0].Equals("Cook")) {
                        Cook.Start(client);
                    }
                }
            }).Start();


        }
        static void StartTable(Socket client)
        {
            Thread thread =new Thread(() => {
                //Start
                bool isClosed=false;
                while (!isClosed)
                {
                    if(!client.Connected)isClosed=true;
                    String receivedString;
                    try { receivedString = GetStringData(client); }
                    catch (SocketException)
                    {
                        Console.WriteLine("Table " + GetTable(client).name + " Closed");
                        
                        return;
                    }
                    String command = (receivedString.Split(":"))[0]; String receivedData = "";
                    try { receivedData = (receivedString.Split(":"))[1]; } catch (Exception) { }

                    switch (command)
                    {

                        case "SetTableName":
                            SetTableName(GetTable(client), receivedData);
                            break;
                        case "Close":
                            isClosed = true;
                            Console.WriteLine("Table " + GetTable(client).name + " closed");
                            client.Close();
                            break;
                        default:
                            NotifyTableMessage(GetTable(client), receivedString);
                            break;
                        
                    }
                    
                }
                


                //End
            });
            thread.Start();
            
        }




        static void NotifyTableMessage(Table _table, String _message)
        {
            Console.WriteLine("[Table " + _table.name + "]: \"" + _message + "\"");
        }
        static String GetStringData(Socket client)
        {
            byte[] bytes = new byte[1024];
            int bytesNumber=client.Receive(bytes);
            //Console.WriteLine("--Received--"+ Encoding.UTF8.GetString(bytes) + " "+(bytesNumber==0?"no byte":""));
            if (bytesNumber == 0) {
                Console.WriteLine("0 byte received");
                client.Close(); }
            return Encoding.UTF8.GetString(bytes).Substring(0,bytesNumber);
        }
        
        static void SendStringData(Socket client, String str)
        {
            byte[] bytes = new byte[1024];
            bytes = Encoding.UTF8.GetBytes(str);
            client.Send(bytes, bytes.Length, SocketFlags.None);
        }
        static void SetTableName(Table _table, String _name)
        {
            //Console.WriteLine("Table " + _table.name + " changed name to " + _name);
            _table.name = _name;
        }
        static Table GetTable(String _name)
        {
            foreach (Table table in tables)
            {
                if (table.name.Equals(_name)) return table;
                
            }
            return null;
        }
        static Table GetTable(Socket _socket)
        {
            foreach (Table table in tables)
            {
                if (table.socket == _socket) return table;
            }
            return null;
        }
        
    }
}