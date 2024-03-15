const mongoose=require("mongoose");

const playerSchema=new mongoose.Schema({
    nickname:{type:String,trim:true},
    socketid:{type:String},
    points:{type:Number,default:0},
    playertype:{required:true,type:String}
});
module.exports=playerSchema;