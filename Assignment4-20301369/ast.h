#ifndef AST_H
#define AST_H

#include <iostream>
#include <vector>
#include <string>
#include <fstream>
#include <map>

using namespace std;

class ASTNode {
    public:
        virtual ~ASTNode() {}
        virtual string generate_code(ofstream& outcode,
                                     map<string, string>& symbol_to_temp,
                                     int& temp_count,
                                     int& label_count) const = 0;
    };

class ExprNode : public ASTNode {
protected:
    string node_type;
public:
    ExprNode(string type) : node_type(type) {}
    virtual string get_type() const { return node_type; }
};

class VarNode : public ExprNode {
private:
    string name;
    ExprNode* index;

public:
    VarNode(string name, string type, ExprNode* idx = nullptr)
        : ExprNode(type), name(name), index(idx) {}
    ~VarNode() { if(index) delete index; }

    bool has_index() const { return index != nullptr; }

    string generate_index_code(ofstream& outcode, map<string, string>& symbol_to_temp,
                              int& temp_count, int& label_count) const {
        return index->generate_code(outcode, symbol_to_temp, temp_count, label_count);
    }

    string generate_code(ofstream& outcode, map<string, string>& symbol_to_temp,
                        int& temp_count, int& label_count) const override {
        if (has_index()) {
            string index_temp = generate_index_code(outcode, symbol_to_temp, temp_count, label_count);
            string result_temp = "t" + to_string(temp_count++);
            outcode << result_temp << " = " << name << "[" << index_temp << "]" << endl;
            return result_temp;
        } else {
            return name;
        }
    }

    string get_name() const { return name; }
};

class ConstNode : public ExprNode {
private:
    string value;

public:
    ConstNode(string val, string type) : ExprNode(type), value(val) {}

    string generate_code(ofstream& outcode, map<string, string>& symbol_to_temp,
                        int& temp_count, int& label_count) const override {
        string temp = "t" + to_string(temp_count++);
        outcode << temp << " = " << value << endl;
        return temp;
    }
};

class BinaryOpNode : public ExprNode {
private:
    string op;
    ExprNode* left;
    ExprNode* right;

public:
    BinaryOpNode(string op, ExprNode* left, ExprNode* right, string result_type)
        : ExprNode(result_type), op(op), left(left), right(right) {}
    ~BinaryOpNode() { delete left; delete right; }

    string generate_code(ofstream& outcode, map<string, string>& symbol_to_temp,
                        int& temp_count, int& label_count) const override {
        string left_temp = left->generate_code(outcode, symbol_to_temp, temp_count, label_count);
        string right_temp = right->generate_code(outcode, symbol_to_temp, temp_count, label_count);
        string result_temp = "t" + to_string(temp_count++);
        outcode << result_temp << " = " << left_temp << " " << op << " " << right_temp << endl;
        return result_temp;
    }
};

class UnaryOpNode : public ExprNode {
private:
    string op;
    ExprNode* expr;

public:
    UnaryOpNode(string op, ExprNode* expr, string result_type)
        : ExprNode(result_type), op(op), expr(expr) {}
    ~UnaryOpNode() { delete expr; }

    string generate_code(ofstream& outcode, map<string, string>& symbol_to_temp,
                        int& temp_count, int& label_count) const override {
        string expr_temp = expr->generate_code(outcode, symbol_to_temp, temp_count, label_count);
        string result_temp = "t" + to_string(temp_count++);
        outcode << result_temp << " = " << op << expr_temp << endl;
        return result_temp;
    }
};

class AssignNode : public ASTNode {
    private:
        VarNode* lhs;
        ExprNode* rhs;
        string type;
    
    public:
        AssignNode(VarNode* l, ExprNode* r, string t) : lhs(l), rhs(r), type(t) {}
    
        ~AssignNode() {
            delete lhs;
            delete rhs;
        }
    
        string generate_code(ofstream& outcode,
                             map<string, string>& symbol_to_temp,
                             int& temp_count,
                             int& label_count) const override {
            string lhs_code = lhs->generate_code(outcode, symbol_to_temp, temp_count, label_count);
            string rhs_code = rhs->generate_code(outcode, symbol_to_temp, temp_count, label_count);
            outcode << lhs_code << " = " << rhs_code << endl;
            return lhs_code;
        }
    };

class StmtNode : public ASTNode {
public:
    virtual string generate_code(ofstream& outcode, map<string, string>& symbol_to_temp,
                                int& temp_count, int& label_count) const = 0;
};

class ExprStmtNode : public StmtNode {
private:
    ExprNode* expr;

public:
    ExprStmtNode(ExprNode* e) : expr(e) {}
    ~ExprStmtNode() { if(expr) delete expr; }

    string generate_code(ofstream& outcode, map<string, string>& symbol_to_temp,
                        int& temp_count, int& label_count) const override {
        if (expr) expr->generate_code(outcode, symbol_to_temp, temp_count, label_count);
        return "";
    }
};

class BlockNode : public StmtNode {
private:
    vector<StmtNode*> statements;

public:
    ~BlockNode() {
        for (auto stmt : statements) {
            delete stmt;
        }
    }

    void add_statement(StmtNode* stmt) {
        if (stmt) statements.push_back(stmt);
    }

    string generate_code(ofstream& outcode, map<string, string>& symbol_to_temp,
                        int& temp_count, int& label_count) const override {
        for (auto stmt : statements) {
            stmt->generate_code(outcode, symbol_to_temp, temp_count, label_count);
        }
        return "";
    }
};

class IfNode : public StmtNode {
private:
    ExprNode* condition;
    StmtNode* then_block;
    StmtNode* else_block;

public:
    IfNode(ExprNode* cond, StmtNode* then_stmt, StmtNode* else_stmt = nullptr)
        : condition(cond), then_block(then_stmt), else_block(else_stmt) {}
    ~IfNode() {
        delete condition;
        delete then_block;
        if (else_block) delete else_block;
    }

    string generate_code(ofstream& outcode, map<string, string>& symbol_to_temp,
                        int& temp_count, int& label_count) const override {
        string cond_temp = condition->generate_code(outcode, symbol_to_temp, temp_count, label_count);
        string label_then = "L" + to_string(label_count++);
        string label_end = "L" + to_string(label_count++);

        if (else_block) {
            string label_else = "L" + to_string(label_count++);
            outcode << "if " << cond_temp << " goto " << label_then << endl;
            outcode << "goto " << label_else << endl;
            outcode << label_then << ":" << endl;
            then_block->generate_code(outcode, symbol_to_temp, temp_count, label_count);
            outcode << "goto " << label_end << endl;
            outcode << label_else << ":" << endl;
            else_block->generate_code(outcode, symbol_to_temp, temp_count, label_count);
        } else {
            outcode << "if " << cond_temp << " goto " << label_then << endl;
            outcode << "goto " << label_end << endl;
            outcode << label_then << ":" << endl;
            then_block->generate_code(outcode, symbol_to_temp, temp_count, label_count);
        }

        outcode << label_end << ":" << endl;
        return "";
    }
};

class WhileNode : public StmtNode {
private:
    ExprNode* condition;
    StmtNode* body;

public:
    WhileNode(ExprNode* cond, StmtNode* body_stmt)
        : condition(cond), body(body_stmt) {}
    ~WhileNode() { delete condition; delete body; }

    string generate_code(ofstream& outcode, map<string, string>& symbol_to_temp,
                        int& temp_count, int& label_count) const override {
        string label_start = "L" + to_string(label_count++);
        string label_body = "L" + to_string(label_count++);
        string label_end = "L" + to_string(label_count++);

        outcode << label_start << ":" << endl;
        string cond_temp = condition->generate_code(outcode, symbol_to_temp, temp_count, label_count);
        outcode << "if " << cond_temp << " goto " << label_body << endl;
        outcode << "goto " << label_end << endl;

        outcode << label_body << ":" << endl;
        body->generate_code(outcode, symbol_to_temp, temp_count, label_count);
        outcode << "goto " << label_start << endl;

        outcode << label_end << ":" << endl;
        return "";
    }
};

class ForNode : public StmtNode {
private:
    ExprNode* init;
    ExprNode* condition;
    ExprNode* update;
    StmtNode* body;

public:
    ForNode(ExprNode* init_expr, ExprNode* cond_expr, ExprNode* update_expr, StmtNode* body_stmt)
        : init(init_expr), condition(cond_expr), update(update_expr), body(body_stmt) {}
    ~ForNode() {
        if (init) delete init;
        if (condition) delete condition;
        if (update) delete update;
        delete body;
    }

    string generate_code(ofstream& outcode, map<string, string>& symbol_to_temp,
                        int& temp_count, int& label_count) const override {
        if (init) init->generate_code(outcode, symbol_to_temp, temp_count, label_count);
        string label_cond = "L" + to_string(label_count++);
        string label_body = "L" + to_string(label_count++);
        string label_end = "L" + to_string(label_count++);

        outcode << label_cond << ":" << endl;
        string cond_temp = condition->generate_code(outcode, symbol_to_temp, temp_count, label_count);
        outcode << "if " << cond_temp << " goto " << label_body << endl;
        outcode << "goto " << label_end << endl;

        outcode << label_body << ":" << endl;
        body->generate_code(outcode, symbol_to_temp, temp_count, label_count);
        if (update) update->generate_code(outcode, symbol_to_temp, temp_count, label_count);
        outcode << "goto " << label_cond << endl;

        outcode << label_end << ":" << endl;
        return "";
    }
};

class ReturnNode : public StmtNode {
private:
    ExprNode* expr;

public:
    ReturnNode(ExprNode* e) : expr(e) {}
    ~ReturnNode() { if (expr) delete expr; }

    string generate_code(ofstream& outcode, map<string, string>& symbol_to_temp,
                        int& temp_count, int& label_count) const override {
        if (expr) {
            string ret_temp = expr->generate_code(outcode, symbol_to_temp, temp_count, label_count);
            outcode << "return " << ret_temp << endl;
        } else {
            outcode << "return" << endl;
        }
        return "";
    }
};

class DeclNode : public StmtNode {
    private:
        string type;
        vector<pair<string, int>> vars;  // name, size (0 for scalar)
    
    public:
        DeclNode(string t) : type(t) {}
        void add_var(string name, int size) {
            vars.push_back({name, size});
        }
    
        string generate_code(ofstream& outcode, map<string, string>&, int&, int&) const override {
            for (auto& v : vars) {
                if (v.second == 0)
                    outcode << "// Declaration: " << type << " " << v.first << endl;
                else
                    outcode << "// Declaration: " << type << " " << v.first << "[" << v.second << "]" << endl;
            }
            return "";
        }
    };

class FuncDeclNode : public ASTNode {
    private:
        string return_type;
        string name;
        vector<pair<string, string>> params;
        BlockNode* body;
    
    public:
        FuncDeclNode(string ret_type, string n) : return_type(ret_type), name(n), body(nullptr) {}
        ~FuncDeclNode() { if (body) delete body; }
    
        void add_param(string type, string name) {
            params.push_back(make_pair(type, name));
        }
    
        void set_body(BlockNode* b) {
            body = b;
        }
    
        string generate_code(ofstream& outcode, map<string, string>& symbol_to_temp,
                            int& temp_count, int& label_count) const override {
    
            // Function signature
            outcode << "// Function: " << return_type << " " << name << "(";
            for (size_t i = 0; i < params.size(); ++i) {
                outcode << params[i].first << " " << params[i].second;
                if (i < params.size() - 1) outcode << ", ";
            }
            outcode << ")" << endl;
    
            // Assign temporaries to parameters (t0 = a, t1 = b, etc.)
            for (auto& param : params) {
                string temp = "t" + to_string(temp_count++);
                symbol_to_temp[param.second] = temp;
                outcode << temp << " = " << param.second << endl;
            }
    
            // Generate body code
            if (body) {
                body->generate_code(outcode, symbol_to_temp, temp_count, label_count);
            }
    
            outcode << endl;
            return "";
        }
    };

class FuncCallNode : public ExprNode {
    private:
        string name;
        vector<ExprNode*> arguments;
    
    public:
        FuncCallNode(string n, string type) : ExprNode(type), name(n) {}
        ~FuncCallNode() {
            for (auto arg : arguments) delete arg;
        }
    
        void add_argument(ExprNode* arg) {
            arguments.push_back(arg);
        }
    
        string generate_code(ofstream& outcode, map<string, string>& symbol_to_temp,
                                int& temp_count, int& label_count) const override {
            vector<string> arg_temps;
            for (auto arg : arguments) {
                string arg_temp = arg->generate_code(outcode, symbol_to_temp, temp_count, label_count);
                string param_temp = "t" + to_string(temp_count++);
                outcode << param_temp << " = " << arg_temp << endl;
                outcode << "param " << param_temp << endl;
                arg_temps.push_back(param_temp);
            }
    
            string ret_temp = "t" + to_string(temp_count++);
            outcode << ret_temp << " = call " << name << ", " << arguments.size() << endl;
            return ret_temp;
        }
    };

class ProgramNode : public ASTNode {
private:
    vector<ASTNode*> units;

public:
    ~ProgramNode() {
        for (auto unit : units) delete unit;
    }

    void add_unit(ASTNode* unit) {
        if (unit) units.push_back(unit);
    }

    string generate_code(ofstream& outcode, map<string, string>& symbol_to_temp,
                        int& temp_count, int& label_count) const override {
        for (ASTNode* unit : units) {
            unit->generate_code(outcode, symbol_to_temp, temp_count, label_count);
        }
        return "";
    }
};
class ArgumentsNode : public ASTNode {
    private:
        vector<ExprNode*> arguments;
    
    public:
        void add_argument(ExprNode* arg) {
            arguments.push_back(arg);
        }
    
        vector<ExprNode*> get_arguments() const {
            return arguments;
        }
    
        string generate_code(ofstream& outcode, map<string, string>& symbol_to_temp, int& temp_count, int& label_count) const override {
            // Just return comma-separated temporary names for each argument
            string arg_code;
            for (size_t i = 0; i < arguments.size(); ++i) {
                if (i > 0) arg_code += ", ";
                arg_code += arguments[i]->generate_code(outcode, symbol_to_temp, temp_count, label_count);
            }
            return arg_code;
        }
};
#endif // AST_H
