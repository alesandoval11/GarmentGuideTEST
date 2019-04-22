//
//  wrapper.cpp
//  test_cpp_bridge
//
//  Created by Brian Munoz on 4/8/19.
//  Copyright © 2019 Brian Munoz. All rights reserved.
//

//#include <stdio.h>
#include "server.h"
// extern "C" will cause the C++ compiler
// (remember, this is still C++ code!) to
// compile the function in such a way that
// it can be called from C
// (and Swift).
extern "C" int runServer()
{
    // Create an instance of A, defined in
    // the library, and call getInt() on it:
    return server().runServer();
}
