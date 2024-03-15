require("dotenv").config()
const express=require("express");
const http=require("http");
const  mongoose  = require("mongoose");
const Room=require("./models/room.js")
const app=express();
const port=process.env.PORT||3000;
var server=http.createServer(app);
var io=require("socket.io")(server);
//middle ware
app.use(express.json())
const DB=process.env.API_KEY;

console.log(process.env.API_KEY)
io.on('connection',(socket)=>{
    socket.on("createroom",async({nickname})=>{
        //room is created

        try {
            let room=new Room();
            let player={socketid:socket.id,nickname:nickname,playertype:'X'}
            room.players.push(player);
            room.turn=player;
            room= await room.save();
           const roomid=room._id.toString();
           socket.join(roomid);
           io.to(roomid).emit("createroomsuccess",room);
           console.log(room)
        } catch (e) {
            console.log(e);
        }
        //player is taken to the next screen
        
    });

    socket.on("joinroom",async({nickname,roomid})=>{
        try {
            if(!roomid.match(/^[0-9a-fA-F]{24}$/)){
                socket.emit('erroroccured','Please enter a valid room ID')
                return;
            }
            let room=await Room.findById(roomid);
            if(room.isjoin){
                let player={socketid:socket.id,nickname:nickname,playertype:'O'}

                socket.join(roomid);
                room.players.push(player);
                room.isjoin=false;
                room= await room.save();
                io.to(roomid).emit("joinroomsuccess",room);
                io.to(roomid).emit("updateplayers",room.players);
                io.to(roomid).emit("updateroom",room);
            }else{
                socket.emit('erroroccured','The game is in progress, try again later');
            }
        } catch (error) {
            console.log(error);
        }
    });

    socket.on('tap',async({index,roomid})=>{

        try {
            let room=await Room.findById(roomid);
            let choice=room.turn.playertype;
            if(room.turnindex==0){
                room.turn=room.players[1];
                room.turnindex=1;
            }else{
                room.turn=room.players[0];
                room.turnindex=0;
            }
            await room.save();
            io.to(roomid).emit('tapped',{index,choice,room});
        } catch (error) {
            console.log(e);
        }
    });

   socket.on('winner',async({winnersocketid,roomId})=>{
    try {
        let room=await Room.findById(roomid);
        room.players.find((playerr)=>playerr.socketid==winnersocketid);
        player.points+=1;
        room= await room.save();
        if(player.points>=room.maxrounds){
            io.to(roomid).emit('endgame',player);
        }else{
            io.to(roomid).emit('pointincrease',player);
        }
    } catch (error) {
        console.log(e);
    }
   })
});
mongoose.connect(DB).then(()=>{console.log("Connection Successfull")}).catch((e)=>{
    console.log(e)
});

server.listen(port,()=>{
    console.log("server started and running port "+port)
})

