function [vr] = commonTerminationVIRMEN(vr)
%commonTerminationVIRMEN This function contains the common termination
%information for every virmen maze

fclose(vr.fid);
if vr.numTrials ~= 0 && vr.cellWrite
    [dataCell] = catCells(vr.pathTempMatCell,'data'); %#ok<NASGU>
    save(vr.pathMatCell,'dataCell');
    delete(vr.pathTempMatCell);
end
copyfile(vr.pathTempMat,vr.pathMat);
copyfile(vr.pathTempDat,vr.pathDat);
delete(vr.pathTempMat);
fid = fopen(vr.pathDat);
data = fread(fid,'float');
data = reshape(data,str2double(vr.exper.variables.reshapeSize),...
    numel(data)/str2double(vr.exper.variables.reshapeSize));
assignin('base','data',data);
save(vr.pathMat,'data','-append');
fclose(fid);

end

