#!/bin/bash

julia --project=$(pwd) --color=yes -e 'using Franklin; serve()'
