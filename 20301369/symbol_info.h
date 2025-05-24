#pragma once
#include <string>
#include <vector>
using namespace std;

class symbol_info {
private:
    string name;
    string type;       // VARIABLE/FUNCTION/ARRAY
    string data_type;  // int/float/void
    int array_size;    // -1 if not array
    vector<string> param_types;  // For functions
public:
    symbol_info(string n, string t, string dt="", int as=-1, vector<string> pt={})
        : name(n), type(t), data_type(dt), array_size(as), param_types(pt) {}

    string get_name() { return name; }
    string get_type() { return type; }
    string get_data_type() { return data_type; }
    int get_array_size() { return array_size; }
    vector<string> get_param_types() { return param_types; }
};