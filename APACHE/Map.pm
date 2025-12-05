package Apache::Ocsinventory::Plugins::Language::Map;
 
use strict;
 
use Apache::Ocsinventory::Map;
$DATA_MAP{language} = {
   mask => 0,
   multi => 1,
   auto => 1,
   delOnReplace => 0,
   sortBy => 'ID',
   writeDiff => 0,
   cache => 0,
   fields => {}
};
1;