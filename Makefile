# 编辑该文件请用sublime等带有makefile 语法高亮的编辑器 否则容易掉坑
.PHONY : all output clean help

all : output

.DEFAULT_GOAL := development

output :
	# 默认编译开发环境的配置
	mkdir -p output

clean :
	rm -rf output

testing : output


help :
	@echo 'Usage: make [TARGET]'
	@echo 'TARGETS:'
	@echo '  all       (=make) compile and link.'
	@echo '  clean     clean objects and the executable file.'
	@echo '  help      print this info.'
	@echo


