#Desk Organizer Deluxe :: Daniel Esteban Lahti :: Tillämpad Programmering

# ::: To-Do ::: #
#---------------#

#Klart med allt!

# SKRIV OM INI-filer i rapporten!

# ::: Libraries ::: #
#-------------------#
require 'fileutils'
require 'colorize'

# ::: Variabler & Konstanter ::: #
#--------------------------------#
$deskDir = ENV["HOME"] + "/Desktop/"
$deskItems = Dir.glob("#{$deskDir}*")

$folderNames = ["Texts","Videos","Music","Images","Art","Programs","Folders"]

textExtensions = ".txt.odt.pdf"
videoExtensions = ".mp4.mkv.mov.avi"
musicExtensions = ".wav.mp3.m4a"
imageExtensions = ".jpg.jpeg.png.gif"
artExtensions = ".kra.ps.blend"
executableExtensions = ".exe.bat.cmd.run.1f1.lnk.url.kys.mat."
$extensions = [textExtensions, videoExtensions, musicExtensions, imageExtensions, artExtensions, executableExtensions, "misc"]

# ::: Hjälpfunktioner ::: #
#-------------------------#

#Beskrivning: Skriver ut text så det ser ut som att en människa skriver
#
#Argument 1: String - Det man vill skriva ut
#
#Exempel 1: "Hejsan" #=> Hejsan (Fast skrivet bokstav för bokstav)
def write(string)
    for index in (0...string.length).to_a
      print string[index]
      sleep(0.01)
    end
    puts
end

#Beskrivning: Tar bort tomma mappar på skrivbordet
#
#Argument 1: Array - Elementen i arrayen är sökvägar som är i klassen strängar
#
#Exempel 1: ["C:\Daniel\Desktop\Tom Mapp","C:\Daniel\Desktop\Full Mapp"] #=> Tar bort "C:\Daniel\Desktop\Tom Mapp"
def deleteEmptyFolders(deskItems)
    i = 0
    while i < deskItems.length
        if !File.file?(deskItems[i]) && Dir.empty?(deskItems[i])
            puts " -deleted empty folder "+"#{getFile(deskItems[i])}".yellow
            FileUtils.rm_rf(deskItems[i])
            deskItems.delete_at(i)
        end
        i += 1
    end
end

#Beskrivning: Skapar mappar på skrivbordet utifrån en array med mappnamn
#
#Argument 1: Array - Elementen i arrayen är strings (namn på mappar som ska skapas)
#Argument 2: String - Sökvägen till användarens skrivbord
#Argument 3: Array - Elementen i arrayen är strängar av alla filers sökvägar på skrivbordet
#
#Exempel 1: ["Texter","Bilder"], "C:/Users/Daniel/Desktop/", ["Homework","Bilder","Spel"] #=> Skapar mappen "Texter"
def createFolders(folderNames, deskDir, deskItems)
    i = 0
    while i < folderNames.length
        if !deskItems.to_s.include? folderNames[i]
            Dir.mkdir(deskDir + folderNames[i])
            puts " -created folder "+"#{folderNames[i]}".yellow
        end
        i += 1
    end
end

#Beskrivning: Ger tillbaka namnet på en fil utifrån en sökväg
#
#Argument 1: String - en sträng av en sökväg
#
#Return: String - namn på fil inklusive dess extension
#
#Exempel 1: "C:\Users\Daniel\Desktop\Minecraft.exe" #=> "Minecraft.exe"
#Exempel 2: "D:\Downloads\Homework\RubyProgram.rb" #=> "RubyProgram.rb"
#Exempel 3: "C:\Users\LukasSkåregård\RoligaMappar\Tom Mapp(3)" #=> "Tom Mapp(3)"
def getFile(dir)
    file = ""
    i = -1
    while dir[i] != "/"
        file += dir[i]
        i -= 1
    end
    return file.reverse
end
 
#Beskrivning: Ger tillbaka en extension utifrån ett filnamn
#
#Argument 1: String - namnet på filen
#
#Return: String - filens extension
#
#Exempel 1: "Minecraft.exe" #=> "exe"
def getExtension(string)
    extension = ""
    i = -1
    if !string.include? "."
        return "misc"
    end
    while string[i] != "."
        extension += string[i]
        i -= 1
    end
    return extension.reverse
end

#Loopar igenom alla filer på skrivbordet, märker av deras extensions, och sätter in filer i korresponderande mappar
def organize(doDeleteEmptyFolders)
    if doDeleteEmptyFolders
        deleteEmptyFolders($deskItems)
    end
    createFolders($folderNames, $deskDir, $deskItems)
    
    extensionIndex = 0 
    while extensionIndex < $extensions.length
        itemIndex = 0
        while itemIndex < $deskItems.length
            if $extensions[extensionIndex].include? getExtension(getFile($deskItems[itemIndex]))
                if !$folderNames.include? getFile($deskItems[itemIndex])
                    puts " -moved file "+"#{getFile($deskItems[itemIndex])}".blue+" to folder "+"#{$folderNames[extensionIndex]}".yellow
                    FileUtils.mv $deskItems[itemIndex], "#{$deskDir}#{$folderNames[extensionIndex]}"
                end
            end
            itemIndex += 1
        end
        extensionIndex += 1
    end
end

#Organiserar endast specifierade filtyper
def customOrganize1(customFileTypes)
    createFolders($folderNames, $deskDir, $deskItems)
    
    extensionIndex = 0
    while extensionIndex < $extensions.length
        itemIndex = 0
        while itemIndex < $deskItems.length
            if $extensions[extensionIndex].include? getExtension(getFile($deskItems[itemIndex]))
                if !$folderNames.include? getFile($deskItems[itemIndex])
                    if customFileTypes.include? getExtension(getFile($deskItems[itemIndex]))
                        puts " -moved file "+"#{getFile($deskItems[itemIndex])}".blue+" to folder "+"#{$folderNames[extensionIndex]}".yellow
                        FileUtils.mv $deskItems[itemIndex], "#{$deskDir}#{$folderNames[extensionIndex]}"
                    end
                end
            end
            itemIndex += 1
        end
        extensionIndex += 1
    end
end

#Skapar en mapp med specifierat namn och stoppar in filer med specifierade extensions i den
def customOrganize2(customFolderName, customFileTypes)
    createFolders([customFolderName], $deskDir, $deskItems)
        itemIndex = 0
        while itemIndex < $deskItems.length
            if customFileTypes.include? getExtension(getFile($deskItems[itemIndex]))
                if !customFolderName.include? getFile($deskItems[itemIndex])
                    puts " -moved file "+"#{getFile($deskItems[itemIndex])}".blue+" to folder "+"#{customFolderName}".yellow
                    FileUtils.mv $deskItems[itemIndex], "#{$deskDir}#{customFolderName}"
                end
            end
            itemIndex += 1
        end
end

#Skapar en mapp som heter "Desktop Folder" och flyttar alla filer på skrivbordet till den mappen
def customOrganize3()
    createFolders(["Desktop Folder"], $deskDir, $deskItems)
    itemIndex = 0 #Vilken fil på skrivbordet vi ligger på (inom en array som innehåller alla filer på skrivbordet)
    
    while itemIndex < $deskItems.length
        if getExtension(getFile($deskItems[itemIndex])) != "ini" #Lägg till support ifall det redan finns en desktop mapp
            FileUtils.mv $deskItems[itemIndex], "#{$deskDir}Desktop Folder/"
            puts " -moved file "+"#{getFile($deskItems[itemIndex])}".blue+" to "+"Desktop folder".yellow
        end  
        itemIndex += 1
    end
end

#Slutmeddelande + stänger programmet
def exitMessage()
    write("exiting...")
    sleep(1)
    exit
end

# ::: Mainfunktion :: Input-loop ::: #
#------------------------------------#

#Input-loop med User-Input för att kunna navigera genom olika sorteringsinställningar
def main()
    write("Hello "+"#{getFile(ENV["HOME"])}".red+"!")
    sleep(0.7)
    write("Welcome to "+"< Desk ".red+"Organizer ".blue+"Deluxe >".yellow+"\nWould you rather run a full desktop organize or a custom organize method?\n"+" [full/custom]".green)
    userInput = gets.chomp
    organized = false
    while userInput != "quit"

        case userInput.downcase
        #Full inställning
        when "full" 
            while !organized
                write("Would you like to delete empty folders?\n"+" [yes/no]".green)
                userChoice = gets.chomp
                if "yes".include? userChoice.downcase
                    write("Deleting empty folders and organizing entire desktop...")
                    sleep(1)
                    organize(true)
                    organized = true
                elsif "no".include? userChoice.downcase
                    write("Organizing entire desktop...")
                    sleep(1)
                    organize(false)
                    organized = true;
                else
                    write("Unknown command, did you mean "+"[yes/no] ".green+"?")
                    sleep(1.5)
                end
            end
        #Custom inställningar
        when "custom"
            while !organized
                write("How would you like to organize your desktop?\n"+" [1] ".green+"Specify file type(s) to organize\n"+" [2] ".green+"Create folder and specify which files it will include\n"+" [3] ".green+"Create folder out of current desktop items")
                userChoice = gets.chomp

                case userChoice
                when "1"
                    write("You have chosen "+"[1]".green+".\nSpecify file type(s) to organize.\nExample: "+"[.txt.pdf.mp3]".green)
                    customFileTypes = gets.chomp
                    write("Organizing specified files...")
                    sleep(1)
                    customOrganize1(customFileTypes)
                    organized = true
                when "2"
                    write("You have chosen "+"[2]".green+".\nSpecify new folder name.")
                    customFolderName = gets.chomp
                    write("Specify file type(s) to move to folder "+"#{customFolderName}".yellow+".\nExample: "+"[.txt.pdf.mp3]".green)
                    customFileTypes = gets.chomp
                    write("Organizing specified file types into folder "+"#{customFolderName}".yellow+"...")
                    sleep(1)
                    customOrganize2(customFolderName, customFileTypes)
                    organized = true
                when "3"
                    write("You have chosen "+"[3]".green+".\nAre you sure you want to move everything on the desktop to one folder?\n"+" [yes/no]".green)
                    userConfirm = gets.chomp
                    if "yes".include? userConfirm.downcase
                        write("Moving desktop items into one folder...")
                        sleep(1)
                        customOrganize3()
                        organized = true
                    elsif "no".include? userConfirm.downcase              
                    else
                        write("Unknown command, did you mean "+"[yes/no]".green+"?")
                        userConfirm = get.chomp
                    end
                else
                    write("Unknown command, did you mean "+"[1/2/3]".green+"?")
                end
            end      
        else
            write("Unknown command, did you mean "+"[full/custom/quit]".green+"?")
            userInput = gets.chomp
        end
        #Bekräftelse att programmet har funkat
        if organized
            puts "------------------------------------------------------\n| Organize complete! You may now exit safely. "+"[quit]".green+" |\n------------------------------------------------------"
            userInput = gets.chomp
        end
    end
    exitMessage()
end

main()