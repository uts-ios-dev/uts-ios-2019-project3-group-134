var GetContent = function() {};
GetContent.prototype = {
    run: function(arguments) {
        arguments.completionFunction({"URL": document.URL, "source": document.getElementsByTagName('html')[0].innerHTML});
    }
};
var ExtensionPreprocessingJS = new GetContent;
