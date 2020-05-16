import java.util.*;
import java.io.*;
import java.text.SimpleDateFormat;
import java.text.ParseException;




public class Reader{
	public static void main(String[] args) {
		SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy hh:mm:ss ");

		ArrayList<AnIDS> ids = new ArrayList<AnIDS>();
		ArrayList<Entry> entries = new ArrayList<Entry>();
		ArrayList<Entry> temp = new ArrayList<Entry>();
		ArrayList<Entry> correct = new ArrayList<Entry>();
		String s1 = "";

		try{
			//Scanner that reads from the file
			Scanner sc = new Scanner(new File("list.txt"));
			//While scan.hasNext allows us read through the entire file until the end 
			String topLine = sc.nextLine();
			while(sc.hasNext()){
				//read in a line
				s1 = sc.nextLine();
				
				AnIDS id = new AnIDS(s1);
				//save the line
				ids.add(id);
			}
			sc.close();
		}catch(FileNotFoundException ex){
			//print out th eerror
			System.out.println("Error: " + ex);
			System.exit(0);
		}
		String topLine2 = "";
		try{
			//Scanner that reads from the file
			Scanner scan = new Scanner(new File("data.txt"));
			//While scan.hasNext allows us read through the entire file until the end 
			topLine2 = scan.nextLine();
			while(scan.hasNext()){
				//read in a line
				s1 = scan.nextLine();
				
				Entry e = new Entry(s1);
				//save the line
				entries.add(e);
				//move to the next index
			}
			scan.close();
		}catch(FileNotFoundException ex){
			//print out th eerror
			System.out.println("Error: " + ex);
			System.exit(0);
		}
		Calendar cal1 = Calendar.getInstance();
		Calendar cal2 = Calendar.getInstance();
		Date d1;
		Date d2;
		int index = 0;
		int corInd = 0;

		for (int i = 0; i < ids.size(); i++) {
			for(int j = 0; j < entries.size(); j++){
				if((ids.get(i).animalId.equals(entries.get(j).animalId)) && (ids.get(i).timeIn.equals(entries.get(j).timeIn))){
					temp.add(entries.get(j));
				}
			}
			try{
				if(temp.size() > 1){
					index = 0;
					corInd = 0;
					d1 = sdf.parse(temp.get(0).timeOut);
					cal1.setTime(d1);
					index = 1;
					while(index < temp.size()){
						d2 = sdf.parse(temp.get(index).timeOut);
						cal2.setTime(d2);
						if(cal1.after(cal2)){
							d1 = d2;
							cal1.setTime(d1);
							corInd = index;
						}
						index++;
					}

					correct.add(temp.get(corInd));
				}else{
					correct.add(temp.get(0));
				}
			}catch (ParseException pe){
				System.out.println("x caught " + pe.getMessage());
			}

			temp.clear();
		}

		try{
			FileWriter write = new FileWriter("newData.csv");
			write.write(topLine2 + "\n");
			for (int i = 0; i < correct.size(); i++){
				write.write(correct.get(i).print());
			}
		}catch (IOException x) {
			System.out.println("x caught " + x.getMessage());
		}

	}
}

class AnIDS{
	public String animalId;
	public String timeIn;

	public AnIDS(String line){
		String [] props = line.split(",");

		animalId = props[0];
		timeIn = props[1];
	}
}


class Entry{
	public String animalId;
	public String name;
	public String timeIn;
	public String loc;
	public String inType;
	public String inCond;
	public String anType;
	public String inSex;
	public String inAge;
	public String inBreed;
	public String color;
	public String timeOut;
	public String dob;
	public String outType;
	public String outSubType;
	public String outSex;
	public String outAge;

	public Entry(String line){
		String [] props = line.split(";");
		animalId = props[0];
		name = props[1];
		timeIn = props[2];
		loc = props[3];
		inType = props[4];
		inCond = props[5];
		anType = props[6];
		inSex = props[7];
		inAge = props[8];
		inBreed = props[9];
		color = props[10];
		timeOut = props[11];
		dob = props[12];
		outType = props[13];
		outSubType = props[14];
		outSex = props[15];
		outAge = props[16];
	}

	public String print(){
	String p =  "\"" + animalId + "\"" + "," + "\"" + name + "\"" + "," + "\"" +timeIn + "\"" + "," +
					"\"" + loc + "\"" + "," + "\"" + inType +"\"" + "," + "\"" + inCond + "\"" +  "," +
					"\"" + anType + "\"" + "," + "\"" + inSex + "\"" + "," + "\"" + inAge + "\"" + "," + 
					"\"" + inBreed + "\"" + "," + "\"" + color + "\"" + "," + "\"" + timeOut + "\"" +"," +
					"\"" + dob + "\"" + "," + "\"" + outType + "\"" + "," + "\"" + outSubType + "\"" + "," +
					"\"" + outSex + "\"" + "," + "\"" + outAge + "\"" + "\n";
	return p;
	}

}