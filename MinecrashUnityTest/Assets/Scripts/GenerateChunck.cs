using UnityEngine;
using System.Collections;

public class GenerateChunck : MonoBehaviour {

	// constatnts
	public const int BLOCKSIZE = 32;
	public const int BLOCKSOLIDSIZE = 29;
	public const int CHUNCKSIZE = 32;

	public const int BLOCKTYPEAIR = 0;
	public const int BLOCKTYPEDIRT = 1;
	public const int BLOCKTYPESTONE = 2;
	public const int BLOCKTYPEOBSIDIAN = 3;
	public const int BLOCKTYPEGRASS = 4;
	public const int BLOCKTYPEBEDROCK = 5;
	public const int BLOCKTYPEWOOD = 6;
	public const int BLOCKTYPELEAVES = 7;



	//variables and arrays
	int[,,] chunkArray;

	void Start () {
		initArray ();
		clearArray ();
		populateArray ();
		drawArray ();
	}

	private void initArray()
	{
		chunkArray = new int[CHUNCKSIZE, CHUNCKSIZE, CHUNCKSIZE];
	}

	private void clearArray()
	{
		for (int arrayX = 0; arrayX < CHUNCKSIZE; arrayX ++)
		{
			for (int arrayY = 0; arrayY < CHUNCKSIZE; arrayY ++)
			{
				for (int arrayZ = 0; arrayZ < CHUNCKSIZE; arrayZ ++)
				{
					setArrayBlock(arrayX, arrayY, arrayZ, BLOCKTYPEAIR);
				}
			}
		}
	}

	private void setArrayBlock(int blockX, int blockY, int blockZ, int blockType)
	{
		chunkArray[blockX, blockY, blockZ] = blockType;
	}

	private void populateArray()
	{
		setArrayLayer(0, BLOCKTYPEBEDROCK);
		setArrayLayer(1, BLOCKTYPEAIR);
		setArrayLayer(2, BLOCKTYPEAIR);
		setArrayLayer(3, BLOCKTYPEAIR);
		setArrayLayer(4, BLOCKTYPEAIR);
		setArrayLayer(5, BLOCKTYPEAIR);
		setArrayLayer(6, BLOCKTYPEAIR);
		setArrayLayer(7, BLOCKTYPEAIR);
		setArrayLayer(8, BLOCKTYPEAIR);
		setArrayLayer(9, BLOCKTYPEAIR);
		setArrayLayer(10, BLOCKTYPEAIR);
		setArrayLayer(11, BLOCKTYPEAIR);
		setArrayLayer(12, BLOCKTYPEAIR);
		setArrayLayer(13, BLOCKTYPEAIR);
		setArrayLayer(14, BLOCKTYPEAIR);
		setArrayLayer(15, BLOCKTYPEAIR);
		setArrayLayer(16, BLOCKTYPEGRASS);
		setArrayLayer(17, BLOCKTYPEDIRT);
		setArrayLayer(18, BLOCKTYPEDIRT);
		setArrayLayer(19, BLOCKTYPEDIRT);
		setArrayLayer(20, BLOCKTYPESTONE);
		setArrayLayer(21, BLOCKTYPESTONE);
		setArrayLayer(22, BLOCKTYPESTONE);
		setArrayLayer(23, BLOCKTYPESTONE);
		setArrayLayer(24, BLOCKTYPESTONE);
		setArrayLayer(25, BLOCKTYPESTONE);
		setArrayLayer(26, BLOCKTYPESTONE);
		setArrayLayer(27, BLOCKTYPESTONE);
		setArrayLayer(28, BLOCKTYPESTONE);
		setArrayLayer(29, BLOCKTYPESTONE);
		setArrayLayer(30, BLOCKTYPEOBSIDIAN);
		setArrayLayer(31, BLOCKTYPEBEDROCK);
		setArrayBlock(4, 15, 4, BLOCKTYPEDIRT);
	}

	private void setArrayLayer(int layerY, int blockType)
	{
		for (int arrayX = 0; arrayX < CHUNCKSIZE; arrayX ++)
		{
			for (int arrayZ = 0; arrayZ < CHUNCKSIZE; arrayZ ++)
			{
				setArrayBlock(arrayX, layerY, arrayZ, blockType);
			}
		}
	}

	private void drawArray()
	{
		for (int arrayX = 0; arrayX < CHUNCKSIZE; arrayX ++)
		{
			for (int arrayY = 0; arrayY < CHUNCKSIZE; arrayY ++)
			{
				for (int arrayZ = 0; arrayZ < CHUNCKSIZE; arrayZ ++)
				{
					if (chunkArray[arrayX, arrayY, arrayZ] != BLOCKTYPEAIR)
					{
						//getFill(chunkArray[arrayX][arrayY][arrayZ]);
						//updateCollision(arrayX, arrayY, arrayZ);
						if (checkSurroundings(arrayX, arrayY, arrayZ))
							drawCubeWithColor(arrayX * BLOCKSIZE, arrayY * BLOCKSIZE, arrayZ * BLOCKSIZE, BLOCKSOLIDSIZE, getFill(chunkArray[arrayX, arrayY, arrayZ]));
					}
				}
			}
		}
	}

	private bool checkSurroundings(int arrayX, int arrayY, int arrayZ)
	{ 
		if (arrayX == 0 || arrayX == 31 || arrayY == 0 || arrayY == 31 || arrayZ == 0 || arrayZ == 31)
			return true;
		else if (checkArrayEmpty(arrayX + 1, arrayY, arrayZ) || checkArrayEmpty(arrayX - 1, arrayY, arrayZ))
			return true;
		else if (checkArrayEmpty(arrayX, arrayY + 1, arrayZ) || checkArrayEmpty(arrayX, arrayY - 1, arrayZ))
			return true; 
		else if (checkArrayEmpty(arrayX, arrayY, arrayZ + 1) || checkArrayEmpty(arrayX, arrayY, arrayZ - 1))
			return true;
		else
			return false;
	}

	private bool checkArrayEmpty(int arrayX, int arrayY, int arrayZ)
	{
		return (getArrayBlock(arrayX, arrayY, arrayZ) == 0);
	}

	private void drawCubeWithColor(int xPosition, int yPosition, int zPosition, int blockSize, Color color)
	{
		GameObject cube = GameObject.CreatePrimitive(PrimitiveType.Cube);
		cube.AddComponent<Rigidbody>();
		cube.transform.position = new Vector3(xPosition, yPosition, zPosition);
		cube.transform.localScale = new Vector3(blockSize, blockSize, blockSize);
		cube.renderer.material.color = color;
	}

	private Color getFill(int blockType)
	{
		if (blockType == BLOCKTYPEDIRT)
			return new Color(51, 25, 0);
		else if (blockType == BLOCKTYPEGRASS)
			return new Color(10, 250, 15);
		else if (blockType == BLOCKTYPESTONE)
			return new Color(125, 125, 125);
		else if (blockType == BLOCKTYPEOBSIDIAN) 
			return new Color(13, 0, 25);
		else if (blockType == BLOCKTYPEBEDROCK) 
			return new Color(10, 10, 10);
		else if (blockType == BLOCKTYPEWOOD) 
			return new Color(102, 51, 0);
		else if (blockType == BLOCKTYPELEAVES)
			return new Color(51, 102, 0); 
		else
			return new Color(0, 0, 0);
	}

	private int getArrayBlock(int blockX, int blockY, int blockZ)
	{
		
		if (blockX < 0 || blockX > 31 || blockY < 0 || blockY > 31 || blockZ < 0 || blockZ > 31)  
			return BLOCKTYPEAIR;
		else
			return chunkArray[blockX, blockY, blockZ];
	}


}
