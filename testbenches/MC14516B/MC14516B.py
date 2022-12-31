class MC14516B:
    def __init__(self, reset=0, preset_enable=0, up_down=0, carry_in=0, preset=0):
        self.reset = reset
        self.preset_enable = preset_enable
        self.up_down = up_down
        self.carry_in = carry_in
        self.preset = preset
        self.carry_out = 0
        self.result = 0b0000

    def update(self, reset, preset_enable, preset, up_down, carry_in):
        self.reset = reset
        self.preset_enable = preset_enable

        self.up_down = up_down
        self.carry_in = carry_in
        self.preset = preset

        if self.reset:
            self.result = 0b0000
        elif self.preset_enable:
            self.result = preset

        if (not self.reset == 1) and (not carry_in == 1) and (not preset_enable == 1):
            if up_down == 1:
                self.result = self.result + 1 if (self.result < 0b1111) else 0
            else:
                self.result = self.result - 1 if (self.result > 0b0000) else 0b1111

        additive_carry = (self.result == 0b1111 and self.up_down == 1)
        difference_carry = (self.result == 0b0000 and self.up_down == 0)

        if carry_in:
            self.carry_out = 1
        elif additive_carry or difference_carry:
            self.carry_out = 0
        else:
            self.carry_out = 1

        return {"result": self.result, "carry_out": self.carry_out}


def generate_testcases(dut, testcases):
    current_input = "10000010"
    output = "00011"
    processed_input = [1, 0, 0b0000, 1, 0]
    dut.update(*processed_input)
    reset = 0
    preset_enable = 0
    preset = 0
    up_down = 1
    carry_in = 0
    testcases.append(current_input+output)
    for i in range(0, 0b1111+2):
        testcases.append(create_testcase(reset, preset_enable, preset, up_down, carry_in, dut))
    reset = 1
    testcases.append(create_testcase(reset, preset_enable, preset, up_down, carry_in, dut))
    up_down = 0
    for i in range(0, 0b1111+2):
        testcases.append(create_testcase(reset, preset_enable, preset, up_down, carry_in, dut))
    for i in range(0, 0b1111+1):
        preset = i
        testcases.append(create_testcase(reset, preset_enable, preset, up_down, carry_in, dut))
    for i in range(0, 0b1111+1):
        preset = i
        preset_enable = 1
        testcases.append(create_testcase(reset, preset_enable, preset, up_down, carry_in, dut))
    preset_enable = 0
    testcases.append(create_testcase(reset, preset_enable, preset, up_down, carry_in, dut))

    reset = 0
    testcases.append(create_testcase(reset, preset_enable, preset, up_down, carry_in, dut))
    up_down = 0
    for i in range(0, 0b1111 + 2):
        testcases.append(create_testcase(reset, preset_enable, preset, up_down, carry_in, dut))
    for i in range(0, 0b1111 + 1):
        preset = i
        testcases.append(create_testcase(reset, preset_enable, preset, up_down, carry_in, dut))
    for i in range(0, 0b1111 + 1):
        preset = i
        preset_enable = 1
        testcases.append(create_testcase(reset, preset_enable, preset, up_down, carry_in, dut))
    preset_enable = 0
    testcases.append(create_testcase(reset, preset_enable, preset, up_down, carry_in, dut))
    reset = 0
    preset_enable = 0
    preset = 0
    testcases.append(create_testcase(reset, preset_enable, preset, up_down, carry_in, dut))
    carry_in = 1
    for i in range(0, 0b1111+2):
        testcases.append(create_testcase(reset, preset_enable, preset, up_down, carry_in, dut))


def main():
    dut = MC14516B()
    testcases = []
    generate_testcases(dut, testcases)
    write_to_file(testcases)


def form_input(reset, preset_enable, preset, up_down, carry_in):
    return bin(reset)[2:].zfill(1) + bin(preset_enable)[2:].zfill(1) + bin(preset)[2:].zfill(4)\
                        + bin(up_down)[2:].zfill(1) + bin(carry_in)[2:].zfill(1)


def create_testcase(reset, preset_enable, preset, up_down, carry_in, dut):
    current_input = form_input(reset, preset_enable, preset, up_down, carry_in)
    raw_output = dut.update(reset, preset_enable, preset, up_down, carry_in)
    output = bin(raw_output["result"])[2:].zfill(4) + bin(raw_output["carry_out"])[2:].zfill(1)
    return current_input + output


def write_to_file(testcases):
    with open("tb_cases_MC14516B.txt", mode="w") as file:
        for testcase in testcases:
            file.write(testcase + "\n")


if __name__ == "__main__":
    main()
