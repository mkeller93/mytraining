library training.web.ini_parser; 

class Section
{
  String name;
  List<Option> options;
  
  Section(String name)
  {
    this.name = name;
    options = new List<Option>();
  }
}

class Option
{
  String key;
  String value;
  
  Option(this.key, this.value);
}

class IniParser
{
  List<Section> sections = new List<Section>();
  
  void parseString(String file)
  {
    Section current = null;
    for(String line in file.split("/"))
    {     
      if (line.startsWith("[") && line.endsWith("]"))
      {
        if (current != null)
        {
          sections.add(current);          
        }
        
        String name = line.substring(1, line.length - 1);
        //print("Section: " + name);
        current = new Section(name);
      }
      else if (line != "" && line.startsWith("#") == false)
      {
        if (current != null)
        {
          String key = line.split("=").first;
          String value = line.split("=").last;
          
          //print("key: " + key + " value: " + value);
          
          Option o = new Option(key, value);
          current.options.add(o);
        }
      }
    }
    
    if (current != null)
    {
      sections.add(current);
    }
  }
  
}