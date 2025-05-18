#ifndef SYMBOL_INFO_H
#define SYMBOL_INFO_H
#include<bits/stdc++.h>
using namespace std;

class symbol_info
{
private:
    string name;
    string type;

    // Write necessary attributes to store what type of symbol it is (variable/array/function)
    // Write necessary attributes to store the type/return type of the symbol (int/float/void/...)
    // Write necessary attributes to store the parameters of a function
    // Write necessary attributes to store the array size if the symbol is an array
    string symbol_type;
    string return_type;
    vector<string> params;
    int size;


public:
    symbol_info(string name, string type)
    {
        this->name = name;
        this->type = type;
    }
    string getname()
    {
        return name;
    }
    string get_type()
    {
        return type;
    }
    void set_name(string name)
    {
        this->name = name;
    }
    void set_type(string type)
    {
        this->type = type;
    }
    // Write necessary functions to set and get the attributes
    string get_symbol_type()
    {
        return symbol_type;
    }
    string get_return_type()
    {
        return return_type;
    }
    int get_size()
    {
        return size;
    }
    vector<string> get_params()
    {
        return params;
    }
    void set_symbol_type(string symbol_type)
    {
        this->symbol_type = symbol_type;
    }
    void set_return_type(string return_type)
    {
        this->return_type = return_type;
    }
    void set_size(int size)
    {
        this->size = size;
    }
    void add_param_type(string param)
    {
        params.push_back(param);
    }


    ~symbol_info()
    {
        // Write necessary code to deallocate memory, if necessary
    }
};

#endif