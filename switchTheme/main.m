//
//  main.m
//  switchTheme
//
//  Created by Kelian on 03/05/2020.
//  Copyright © 2020 MLforAll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../libmactheme/libmactheme/libmactheme.h"

static inline int
arc_main(int ac, const char **av)
{
    if (ac < 2)
    {
        (void) fprintf(stderr, "%s: needs light, dark or auto\n", *av);
        return EXIT_FAILURE;
    }

    const char *st[] = {"light", "dark", "auto"};
    os_theme_t t = kThemeUnknown;

    for (uint8_t i = 0; i < sizeof(st) / sizeof(char *); i++)
    {
        if (strcmp(av[1], st[i]) == 0)
        {
            t = (os_theme_t)i;
            break ;
        }
    }

    if (t == kThemeUnknown)
    {
        (void) fprintf(stderr, "%s: Couldn't get os_theme_t value\n", *av);
        return EXIT_FAILURE;
    }
    if (NSProcessInfo.processInfo.operatingSystemVersion.minorVersion < 15 && t == kThemeAuto)
    {
        (void) fprintf(stderr, "%s: macOS Mojave and earlier do not support automatic theme\n", *av);
        return EXIT_FAILURE;
    }

    NSString *errMsg;
    if (![MacTheme setTheme:t error:&errMsg])
    {
        (void) fprintf(stderr, "%s: Couldn't change theme: %s\n", *av, errMsg.UTF8String);
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}

int
main(int ac, const char **av)
{
    int exv;
    @autoreleasepool {
        exv = arc_main(ac, av);
    }
    return exv;
}
