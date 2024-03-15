const mongoose=require("mongoose");
const playerSchema = require("./player");

const roomSchema   =new mongoose.Schema({
    occupancy:{type :Number,default:2},
    maxrounds:{type:Number,default:6 },
    currentround:{required:true,type:Number,default:1 },
    players:[playerSchema],
    isjoin:{type:Boolean,default:true},
    turn:playerSchema,
    turnindex :{type:Number,default:0},
});
const roomModel=mongoose.model('room',roomSchema);
module.exports=roomModel;