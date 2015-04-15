if ((_ref = window.tacit) == null) {
    window.tacit = {};
}

var Suggestions = function(suggestionsLoc) {
    return {

        /* given a structure, return a mutated structure*/
        mutate: function(structure) {
            // todo: do something smart here
            return structure
        },

        /* looks at current sketch in pad, and generates list of num mutations*/
        getSuggestions: function(num) {
            var structure = window.easel.pad.sketch.structure;
            var suggestions = []
            for (var i=0; i<num; i++) {
                suggestions.push(this.mutate(structure))
            }

            return suggestions             
        },

        /* given suggestions, loads them in $(suggestionsLoc) */
        loadSuggestions: function(suggestions) {
            console.log(suggestions)
        }   


    }

}

window.tacit.Suggestions = Suggestions