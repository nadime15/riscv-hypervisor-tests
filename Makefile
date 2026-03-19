export PATH := $(RISCV)/bin:$(PATH)
CROSS_COMPILE=riscv64-unknown-elf-
SAIL?=./build/c_emulator/sail_riscv_sim
MARCH=rv64imafdch_zicntr_zihpm_sscofpmf

.PHONY: riscv-hs-tests riscv-hyp-tests riscv-hext-asm-tests

build-riscv-hs-tests:
	cd riscv-hs-tests \
	&& make all CROSS_COMPILE=$(CROSS_COMPILE) PATH=$(RISCV)/bin:$(PATH)
run-riscv-hs-tests:
	cd riscv-hs-tests \
	&& $(SAIL) ./build/riscv-hs-tests.elf
##	&& spike --isa=$(MARCH) ./build/riscv-hs-tests.elf
clean-riscv-hs-tests:
	cd riscv-hs-tests \
	&& make clean

build-riscv-hyp-tests:
	cd riscv-hyp-tests \
	&& PLAT=sail LOG_LEVEL=LOG_INFO make
run-riscv-hyp-tests:
	cd riscv-hyp-tests \
	&& $(SAIL) ./build/sail/rvh_test.elf
#	&& spike --isa=rv64imafdch_zicntr_zihpm_sscofpmf ./build/sail/rvh_test.elf
clean-riscv-hyp-tests:
	cd riscv-hyp-tests \
	&& PLAT=sail make clean

build-riscv-hext-asm-tests:
	cd riscv-hext-asm-tests \
	&& ./run_tests.py --build
run-riscv-hext-asm-tests:
	cd riscv-hext-asm-tests \
	&& ./run_tests.py --run
clean-riscv-hext-asm-tests:
	cd riscv-hext-asm-tests \
	&& ./run_tests.py --clean

build: build-riscv-hs-tests build-riscv-hyp-tests build-riscv-hext-asm-tests
run: run-riscv-hs-tests run-riscv-hyp-tests run-riscv-hext-asm-tests
clean: clean-riscv-hs-tests clean-riscv-hyp-tests clean-riscv-hext-asm-tests
