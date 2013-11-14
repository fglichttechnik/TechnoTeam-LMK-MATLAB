function LMK_saveXMLData(evaluatedData, dir_name)
%AUTHOR: Jan Winter, Sandy Buschmann, Robert Franke TU Berlin, FG Lichttechnik,
%	j.winter@tu-berlin.de, www.li.tu-berlin.de
%LICENSE: free to use at your own risk. Kudos appreciated.
%
% Saves last measurement (.mat data) into a xml file using the functions
% mat2struct, struct2xml and parseXML.
%
% Input:    evaluatedData = LMK_image_Metadata object
%           dir_name      = name of target directory


disp('Saving XML data...');

% make a struct of evaluated data:
measStruct = mat2struct(evaluatedData);
% measStruct = measStruct(1,4);

dataMatch = 0;
count_LMKData = 0;
xml_path = [dir_name, '\', measStruct(1,2).Name, '.xml']

% check if xml already exists in target directory:
if exist(xml_path, 'file') 
    disp('file exists, parsing xml...');
    % parse XML data into a struct
    xmlStruct = parseXML(xml_path);    
    % check if LMKData set already exists in xmlStruct
    [~, a] = size(xmlStruct);
    for i = 1 : a
        if strcmp(xmlStruct(1,i).Name, measStruct(1,2).Name)
            [~, b] = size(xmlStruct(1,i).Children);
            for j = 1 : b
               if strcmp(xmlStruct(1,i).Children(1,j).Name, measStruct(1,2).Children(1,4).Name)
                    count_LMKData = count_LMKData +1;
                    [~, c] = size(xmlStruct(1,i).Children(1,j).Children);
                    for k = 1 : c   
                        if strcmp(xmlStruct(1,i).Children(1,j).Children(1,k).Name, ...
                                    measStruct(1,2).Children(1,4).Children(1,2).Name)   
                            if strcmp(xmlStruct(1,i).Children(1,j).Children(1,k).Attributes(1,1).Value, ...
                                    measStruct(1,2).Children(1,4).Children(1,2).Attributes(1,1).Value)
                                dataMatch = 1;
                                % overwrite new LMKData
                                xmlStruct(1,i).Children(1,j) = measStruct(1,2).Children(1,4);
                                newStruct = xmlStruct;
                                % save XML
                                struct2xml(newStruct, dir_name);
                                return
                            end
                            break
                        end
                    end
                    continue
                end
            end
        end
        continue
    end
else
    newStruct = measStruct;
    % save XML
    struct2xml(newStruct, dir_name);
end

if dataMatch == 0 && count_LMKData ~=0
    % add new LMKData at the end of the struct 
    xmlStruct(1,2).Children(1,(count_LMKData+2)*2) = measStruct(1,2).Children(1,4);
    newStruct = xmlStruct;
    % save XML
    struct2xml(newStruct, dir_name);
end

end