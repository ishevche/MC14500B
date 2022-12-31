# Changed MC14599B circuit, here data pin is divided on input_data and output_data; write/read deleted therefore...
SIZE = 8

class MC14599B:
    def __init__(self, chip_enable=0, write_disable=0, reset=0, input_data=0, output_data=0):
        self.chip_enable = chip_enable
        self.write_disable = write_disable
        self.reset = reset
        self.input_data = input_data
        self.output_data = output_data
        self.latches = [0 for _ in range(0, SIZE)]

    def update(self, chip_enable, write_disable, reset, input_data, A0, A1, A2):
        self.chip_enable = chip_enable
        self.write_disable = write_disable
        self.reset = reset
        self.input_data = input_data

        address = int(str(A0) + str(A1) + str(A2), 2)

        if reset == 1:
            for latch in range(0, len(self.latches)):
                self.latches[latch] = 0
            # data ?
        elif (chip_enable == 0) and (reset == 0):
            self.data = "z"
        elif (chip_enable == 1) and (write_disable == 0) and (reset == 0):
            self.latches[address] = input_data
        elif (chip_enable == 1) and (write_disable == 1) and (reset == 0):
            self.data = "z"
        output_data = self.latches[address]
        return {"latches": self.latches.copy(), "output_data": output_data}


def generate_testcases(dut, testcases):
    def test_setup():
        chip_enable, write_disable, reset, input_data = 0, 0, 1, 0
        A0, A1, A2 = 0, 0, 0
        testcases.append(create_testcase(chip_enable, write_disable, reset, input_data, A0, A1, A2, dut))

    def test_write():
        test_setup()
        for address in range(0, 0b111+1):
            f_address = bin(address)[2:].zfill(3)
            A0 = f_address[0]
            A1 = f_address[1]
            A2 = f_address[2]
            chip_enable, write_disable, reset = 1, 0, 0
            for input_data in [0, 1, 0]:
                testcases.append(create_testcase(chip_enable, write_disable, reset, input_data, A0, A1, A2, dut))
        for address in range(0, 0b111+1):
            f_address = bin(address)[2:].zfill(3)
            A0 = f_address[0]
            A1 = f_address[1]
            A2 = f_address[2]
            chip_enable, write_disable, reset = 1, 0, 0
            for input_data in [0, 1, 0]:
                testcases.append(create_testcase(chip_enable, write_disable, reset, input_data, A0, A1, A2, dut))

    test_setup()
    test_write()
    return


def main():
    dut = MC14599B()
    testcases = []
    generate_testcases(dut, testcases)
    write_to_file(testcases)


def form_input(chip_enable, write_disable, reset, data, A0, A1, A2):
    return bin(chip_enable)[2:].zfill(1) + bin(write_disable)[2:].zfill(1)\
                        + bin(reset)[2:].zfill(1) + str(data).zfill(1) + str(A0) + str(A1) + str(A2)


def create_testcase(chip_enable, write_disable, reset, data, A0, A1, A2, dut):
    current_input = form_input(chip_enable, write_disable, reset, data, A0, A1, A2)
    raw_output = dut.update(chip_enable, write_disable, reset, data, A0, A1, A2)
    output = "".join([str(digit) for digit in raw_output["latches"]]).zfill(8) + str(raw_output["output_data"]).zfill(1)
    return current_input + output


def write_to_file(testcases):
    with open("tb_cases_MC14599B.txt", mode="w") as file:
        for testcase in testcases:
            file.write(testcase + "\n")


if __name__ == "__main__":
    main()
