#ifndef SWITCH_RULES_H
#define SWITCH_RULES_H

#ifdef __cplusplus
extern "C"{
#endif
int switch_rule_init(void *ptr); 
int push_switch_rule(char *mac_addr, int output_port); 

#ifdef __cplusplus
}
#endif
#endif
