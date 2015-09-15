ip = wifi.sta.getip()
print(ip)
------------
wifi.setmode(wifi.STATION)
wifi.sta.config("MosabR","mosab107")
ip = wifi.sta.getip()
print(ip)
------------

--AC initial vars
temp = 19
fan = 0
--assign input pins 
p58 = 11 --GPIO9
p59 = 12 --GPIO10
p5 = 3 --GPIO0
p6 = 1 --GPIO5
p7 = 2 --GPIO4
--assign output pins
pwr = 0 --GPIO16
fan = 6 --GPIO12
up = 7 --GPIO13
down = 5 -- GPIO14
----------------

--configure input pins as pullup
gpio.mode(p59, gpio.INPUT, gpio.PULLUP)
gpio.mode(p58, gpio.INPUT, gpio.PULLUP)
gpio.mode(p5, gpio.INPUT, gpio.PULLUP)
gpio.mode(p6, gpio.INPUT, gpio.PULLUP)
gpio.mode(p7, gpio.INPUT, gpio.PULLUP)
--configure output pins
gpio.mode(pwr, gpio.OUTPUT)
gpio.mode(fan, gpio.OUTPUT)
gpio.mode(up, gpio.OUTPUT)
gpio.mode(down, gpio.OUTPUT)
--------------

srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
        local buf = "";
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
        local _GET = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                _GET[k] = v
            end
        end
        buf = buf.."<h1> AC Controller </h1>";
        buf = buf.."<p>Switch power <a href=\"?pin=pwr\"><button>POWER</button></a>&nbsp;</p>";
	buf = buf.."<h1> </h1>";
	buf = buf.."<h1> </h1>";
        buf = buf.."<p>Change fan <a href=\"?pin=fan\"><button>FAN</button></a>&nbsp;</p>";
	buf = buf.."<p>Change temp <a href=\"?pin=down\"><button>-</button></a>&nbsp;<a href=\"?pin=up\"><button>+</button></a></p>";
        local _on,_off = "",""
        if(_GET.pin == "pwr")then
              gpio.write(pwr, gpio.HIGH);
              gpio.write(pwr, gpio.LOW);
        elseif(_GET.pin == "fan")then
              gpio.write(fan, gpio.HIGH);
              gpio.write(fan, gpio.LOW);
        elseif(_GET.pin == "up")then
              gpio.write(up, gpio.HIGH);
              gpio.write(up, gpio.LOW);
        elseif(_GET.pin == "down")then
              gpio.write(down, gpio.HIGH);
              gpio.write(down, gpio.LOW);
        end
        client:send(buf);
        client:close();
	
        collectgarbage();
    end)
end)
