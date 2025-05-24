#pragma once
#include "scope_table.h"
#include <stack>
using namespace std;

class symbol_table {
private:
    stack<scope_table*> scopes;
    int current_id;
    int bucket_size;

public:
    symbol_table(int bucket_size);
    ~symbol_table();

    void enter_scope();
    void exit_scope();
    bool insert(const string &name, const string &type, 
                const string &data_type="", int array_size=-1);
    symbol_info* lookup(const string &name);
    void print_current(ofstream &out);
    void print_all(ofstream &out);
};