#!/bin/bash

aws lambda invoke --function-name test_lambda --payload file://event.json out.json && cat out.json
