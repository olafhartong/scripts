#!/usr/bin/env python

# pip install beautifulsoup4
# pip install lxml
from sys import stderr, argv, exit
from bs4 import BeautifulSoup
from re import compile
from json import dumps

input_file = 'input.xml'

class OlafTest:
    def __init__(self, input_file):
        self._input_file = input_file
        self._debug_on = True

    def _debug(self, msg):
        if self._debug_on:
            stderr.write('%s\n' % msg)

    def set_debug(self, debug_on):
        self._debug_on = debug_on

    def read_input_file(self):
        self._debug('Reading file: %s' % self._input_file)

        with open(self._input_file) as f:
            self._input_content = f.read()

    def parse_xml(self):
        self._xmlobj = BeautifulSoup(self._input_content, features='xml')
        return True

    def read(self):
        result_list = list()
        s = 'string'
        i = 'int'

	fields = { 'category':s, 'name':s, 'severity':s, 'value':i, 'aspect':s, 'desc':s }

        for f in self._xmlobj.find_all('entry'):
            result = dict()

            field_prefix = f.find('name').string
            for field, field_type in fields.iteritems():
              field_prefixed = '%s.%s' % (field_prefix, field)
              if field_type == 'string':
                result[field_prefixed] = f.find(field).string
              elif field_type == 'int':
                result[field_prefixed] = int(f.find(field).string)
            result_list.append(result)
        return result_list

    def to_json(self, input_string, pretty=False):
        if pretty:
            json_str = dumps(input_string, sort_keys=True, indent=4, separators=(',', ': '))
        else:
            json_str = dumps(input_string)
        return json_str


if __name__ == '__main__':
    bro = OlafTest(input_file)
    bro.set_debug(False)
    bro.read_input_file()
    bro.parse_xml()

    for obj in bro.read():
        print bro.to_json(obj, pretty=True)
