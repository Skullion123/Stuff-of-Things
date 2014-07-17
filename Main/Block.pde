class Block {
  PVector Position;
  String blockType;
  
  public void Initialize(PVector Position, String block)
  {
    this.Position = Position;
    blockType = block;
  }
  
  public void Update()
  {
    
  }
  
  public void Draw()
  {
    if (blockType == "grass")
      fill(73, 250, 20);
    else if (blockType == "dirt")
      fill(142, 76, 14);
    else if (blockType == "stone")
      fill(160, 160, 160);
    else if (blockType == "bedrock")
      fill(0, 0, 0); 
     
     translate(Position.x, Position.y, Position.z);
      
    box(10);
    
    translate(-Position.x, -Position.y, -Position.z);
  }
}
