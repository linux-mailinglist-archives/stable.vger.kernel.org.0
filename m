Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F277C14B396
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 12:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbgA1LkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 06:40:19 -0500
Received: from mail-lf1-f47.google.com ([209.85.167.47]:36090 "EHLO
        mail-lf1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgA1LkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 06:40:19 -0500
Received: by mail-lf1-f47.google.com with SMTP id f24so8843841lfh.3
        for <stable@vger.kernel.org>; Tue, 28 Jan 2020 03:40:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Lip5TnMQNksiPynN7VgKsJ7O3qbZtjuxsyhSyEIaWAs=;
        b=iODQ93nLscqQ2WHRSTInJlso1imEZYIDFzlUAikAUSzHdA+PEq8vG3RUMr+EUg/0e2
         wXFjNmEMercRcV7yxxK+RDvFIfvi/ednCcGASBxWYT7BxSTrpF6TsNulGJcP7EihsPSQ
         IqWH4yXjR0h84u/p/a2W8wkhiVBNfluZV9hcIcLPnaSZTXIkjUOWKDn1+kfElSKKw94H
         IE/Qj0Zn8hxfV5NOIx8ty/tX9iAL1NZ9sfUV6Nr4gA9WUGL4TblYJJBHiGJ2Etv6FW2+
         Km8E92rC0d+QhEgo8gdNULsDRmOYDv5k7wAiBuaT/77U973iXyViTIV+i806BcyifM7/
         bd8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Lip5TnMQNksiPynN7VgKsJ7O3qbZtjuxsyhSyEIaWAs=;
        b=Y6t6b/hBVnU/uK9dJ9jirsHFVpSeKTT+x0xN8QRtb7lKmwvoT5lP28+Fkp/8i2+Juy
         WaAh38nOhOLyQPdV5Th+0Mt9pHURakmNJII4VAB7ZnxIZLPw3AfLYFTrqQl5Fs3LRPTA
         KkgaVEEN22kqzQCtqmZvGVAqcx70RQxSeIqxfEsa5vZlYjFU1XLiUf4HoCGfYO/Pwxsm
         F1iqYGPBgmPg8Ruh+YY4jnIxfLhzU48iGrgg9dCPHX2lftC0SxoDLVnzLKePrkCI9Jgl
         x6DkhH7222gKJlLqVKKyhF3t5s5JcBcf3h2fLbcfJGuRFplVUt6aQdrmJUyCUcfe5DyQ
         HEJQ==
X-Gm-Message-State: APjAAAWtDddQowQyEaNOiQlEidHqZ/bqTIktQhLhechO8/gMLWJ34M7w
        iXvpndu9rKZPuUGk0CCRP4BjkL+v441onHqgYs1PNw==
X-Google-Smtp-Source: APXvYqz9ktuxl+v7iTupzTQ/sH89bmDNlL3mQm7uUpcC6Ugp7OZfQn2SXTFF//zY9Du4A1HTE6NirAQMhDE3K889XD4=
X-Received: by 2002:ac2:5b41:: with SMTP id i1mr2155221lfp.82.1580211617093;
 Tue, 28 Jan 2020 03:40:17 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 28 Jan 2020 17:10:05 +0530
Message-ID: <CA+G9fYtJxdSV7SKWU9SDkt9gjznkvPr-z84fe8Xe_YbBD2RRrw@mail.gmail.com>
Subject: stable-rc 4.14.169-rc1/c103be7db25e: regressions detected in project
 stable v.4.14.y on OE
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc 4.14 build failed due to these build error,

lib/bitmap.c: In function 'bitmap_from_u32array':
lib/bitmap.c:1133:1: warning: ISO C90 forbids mixed declarations and
code [-Wdeclaration-after-statement]
 unsigned long *bitmap_alloc(unsigned int nbits, gfp_t flags)
 ^~~~~~~~
In file included from
/srv/oe/build/tmp-lkft-glibc/work-shared/intel-corei7-64/kernel-source/lib/bitmap.c:8:0:
lib/bitmap.c:1138:15: error: non-static declaration of 'bitmap_alloc'
follows static declaration
 EXPORT_SYMBOL(bitmap_alloc);
               ^
include/linux/export.h:65:21: note: in definition of macro '___EXPORT_SYMBOL'
  extern typeof(sym) sym;      \
                     ^~~
lib/bitmap.c:1138:1: note: in expansion of macro 'EXPORT_SYMBOL'
 EXPORT_SYMBOL(bitmap_alloc);
 ^~~~~~~~~~~~~
lib/bitmap.c:1133:16: note: previous definition of 'bitmap_alloc' was here
 unsigned long *bitmap_alloc(unsigned int nbits, gfp_t flags)
                ^~~~~~~~~~~~
In file included from
/srv/oe/build/tmp-lkft-glibc/work-shared/intel-corei7-64/kernel-source/lib/bitmap.c:8:0:
lib/bitmap.c:1144:15: error: non-static declaration of 'bitmap_zalloc'
follows static declaration
 EXPORT_SYMBOL(bitmap_zalloc);
               ^
include/linux/export.h:65:21: note: in definition of macro '___EXPORT_SYMBOL'
  extern typeof(sym) sym;      \
                     ^~~
lib/bitmap.c:1144:1: note: in expansion of macro 'EXPORT_SYMBOL'
 EXPORT_SYMBOL(bitmap_zalloc);
 ^~~~~~~~~~~~~
lib/bitmap.c:1140:16: note: previous definition of 'bitmap_zalloc' was here
 unsigned long *bitmap_zalloc(unsigned int nbits, gfp_t flags)
                ^~~~~~~~~~~~~
In file included from
/srv/oe/build/tmp-lkft-glibc/work-shared/intel-corei7-64/kernel-source/lib/bitmap.c:8:0:
lib/bitmap.c:1150:15: error: non-static declaration of 'bitmap_free'
follows static declaration
 EXPORT_SYMBOL(bitmap_free);
               ^
include/linux/export.h:65:21: note: in definition of macro '___EXPORT_SYMBOL'
  extern typeof(sym) sym;      \
                     ^~~
lib/bitmap.c:1150:1: note: in expansion of macro 'EXPORT_SYMBOL'
 EXPORT_SYMBOL(bitmap_free);
 ^~~~~~~~~~~~~
lib/bitmap.c:1146:6: note: previous definition of 'bitmap_free' was here
 void bitmap_free(const unsigned long *bitmap)
      ^~~~~~~~~~~
  CC      drivers/char/random.o
scripts/Makefile.build:326: recipe for target 'lib/bitmap.o' failed
make[3]: *** [lib/bitmap.o] Error 1
Makefile:1052: recipe for target 'lib' failed
make[2]: *** [lib] Error 2

-- 
Linaro LKFT
https://lkft.linaro.org
