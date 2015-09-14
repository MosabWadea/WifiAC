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
p58 = 11
p59 = 7
p5 = 11 --GPIO9
p6 = 12 --GPIO10
p7 = 8
--assign output pins
pwr = 0 --GPIO16
fan = 6 --GPIO12
up = 7 --GPIO13
down = 5 -- GPIO14
----------------

--configure input pins as pullup
gpio.mode(p59, gpio.INPUT, PULLUP)
gpio.mode(p58, gpio.INPUT, PULLUP)
gpio.mode(p5, gpio.INPUT, PULLUP)
gpio.mode(p6, gpio.INPUT, PULLUP)
gpio.mode(p7, gpio.INPUT, PULLUP)
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
        buf = buf.."<p>GPIO0 <a href=\"?pin=ON1\"><button>ON</button></a>&nbsp;<a href=\"?pin=OFF1\"><button>OFF</button></a></p>";
        buf = buf.."<p>GPIO2 <a href=\"?pin=ON2\"><button>ON</button></a>&nbsp;<a href=\"?pin=OFF2\"><button>OFF</button></a></p>";
        local _on,_off = "",""
        if(_GET.pin == "ON1")then
              gpio.write(led1, gpio.HIGH);
        elseif(_GET.pin == "OFF1")then
              gpio.write(led1, gpio.LOW);
        elseif(_GET.pin == "ON2")then
              gpio.write(led2, gpio.HIGH);
        elseif(_GET.pin == "OFF2")then
              gpio.write(led2, gpio.LOW);
        end
        client:send(buf);
        client:close();
        collectgarbage();
    end)
end)