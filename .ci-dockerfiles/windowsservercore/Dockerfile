FROM cirrusci/windowsservercore:2019

RUN choco install visualstudio2019buildtools -y --package-parameters "--add Microsoft.VisualStudio.Workload.VCTools;includeRecommended --locale en-US" \
  && choco install python3 -y \
  && choco install cmake -y --installargs 'ADD_CMAKE_TO_PATH=System'
