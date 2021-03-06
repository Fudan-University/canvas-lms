import UiConfig from "./ui_config";
import filterFromNode from "./filter_from_node";

export default function(xml) {
  var limits = xml.find('limits');

  var config = new UiConfig({
    maxUploads: limits.attr('maxUploads'),
    maxFileSize: limits.attr('maxFileSize'),
    maxTotalSize: limits.attr('maxTotalSize')
  });

  var filters = xml.find('fileFilters').children();

  for(var i=0, l=filters.length; i<l; i++) {
    var filter = filterFromNode(filters[i]);
    config.addFileFilter(filter);
  }
  return config;
};
