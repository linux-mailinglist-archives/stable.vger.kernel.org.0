Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A398B2BC172
	for <lists+stable@lfdr.de>; Sat, 21 Nov 2020 19:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbgKUSev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Nov 2020 13:34:51 -0500
Received: from gproxy6-pub.mail.unifiedlayer.com ([67.222.39.168]:39239 "EHLO
        gproxy6-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727228AbgKUSev (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Nov 2020 13:34:51 -0500
Received: from cmgw14.unifiedlayer.com (unknown [10.9.0.14])
        by gproxy6.mail.unifiedlayer.com (Postfix) with ESMTP id A15E11E0668
        for <stable@vger.kernel.org>; Sat, 21 Nov 2020 11:34:48 -0700 (MST)
Received: from bh-25.webhostbox.net ([208.91.199.152])
        by cmsmtp with ESMTP
        id gXiikR5gYwNNlgXiikedPj; Sat, 21 Nov 2020 11:34:48 -0700
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.3 cv=BoezP7f5 c=1 sm=1 tr=0
 a=QNED+QcLUkoL9qulTODnwA==:117 a=2cfIYNtKkjgZNaOwnGXpGw==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=nNwsprhYR40A:10:nop_rcvd_month_year
 a=evQFzbml-YQA:10:endurance_base64_authed_username_1 a=_jlGtV7tAAAA:8
 a=nrmGvONqP5d-hfDFzWAA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=nlm17XC03S6CtCLSeiRr:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=TuRJ41wRl+SBapa6arR1JGk5kFAOutf8UU9gl4I774E=; b=I/49lGzYh5BDMv/sbOIqFUsWPC
        ilWJGHb1eMZ4/TocIR4b53GkTR5vNR3Qq9pWSWbAr12lRhIKames4TpHa11UJxWBeqs/JLF3UwrF8
        izRcFlSbAxnJyAeE6MoGhwviWoIdTnGXwFZHh4s0qO73I5dVqNRMk+5tQgcsji6/Hy6tegrFzUyYd
        9w4OUAHJmHRJGW4jePgircEevumZM9Rcr/Jt3kMaeLxWtU35OQt+jNsg0oD0moiQZGGVI12HIKIZC
        f3AoMF+WuTXl+h5gw0jemceNpEs3i5x7JFg+5qQ2j3gGAB1o1M0brs0jS0LBw+CrN80inQV4gnVk3
        Ldo+xHoQ==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:40920 helo=localhost)
        by bh-25.webhostbox.net with esmtpa (Exim 4.93)
        (envelope-from <linux@roeck-us.net>)
        id 1kgXih-0037YB-G0; Sat, 21 Nov 2020 18:34:47 +0000
Date:   Sat, 21 Nov 2020 10:34:46 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/16] 4.9.245-rc1 review
Message-ID: <20201121183446.GC111877@roeck-us.net>
References: <20201120104539.706905067@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201120104539.706905067@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1kgXih-0037YB-G0
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:40920
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 10
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 20, 2020 at 12:03:05PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.245 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 22 Nov 2020 10:45:32 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 166 fail: 2
Failed builds:
	powerpc:cell_defconfig
	powerpc:maple_defconfig
Qemu test results:
	total: 382 pass: 377 fail: 5
Failed tests:
	ppc64:mac99:ppc64_book3s_defconfig:smp:initrd
	ppc64:mac99:ppc64_book3s_defconfig:smp:ide:rootfs
	ppc64:mac99:ppc64_book3s_defconfig:smp:sdhci:mmc:rootfs
	ppc64:mac99:ppc64_book3s_defconfig:smp:nvme:rootfs
	ppc64:mac99:ppc64_book3s_defconfig:smp:scsi[DC395]:rootfs

Build failures see below. Note that the failures are different than the
failures observed in the v4.4.y release candidate, meaning that some
additional errors may not be reported.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter

---
Building powerpc:cell_defconfig ... failed
--------------
Error log:
In file included from arch/powerpc/include/asm/kup.h:10:0,
                 from arch/powerpc/include/asm/uaccess.h:12,
                 from arch/powerpc/lib/checksum_wrappers.c:24:
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: data definition has no type or storage class [-Werror]
 DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
 ^~~~~~~~~~~~~~~~~~~~~~~~
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’ [-Werror=implicit-int]
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: parameter names (without types) in function declaration [-Werror]
arch/powerpc/include/asm/book3s/64/kup-radix.h: In function ‘prevent_user_access’:
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:6: error: implicit declaration of function ‘static_branch_unlikely’ [-Werror=implicit-function-declaration]
  if (static_branch_unlikely(&uaccess_flush_key))
      ^~~~~~~~~~~~~~~~~~~~~~
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: error: ‘uaccess_flush_key’ undeclared (first use in this function); did you mean ‘do_uaccess_flush’?
  if (static_branch_unlikely(&uaccess_flush_key))
                              ^~~~~~~~~~~~~~~~~
                              do_uaccess_flush
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: note: each undeclared identifier is reported only once for each function it appears in
cc1: all warnings being treated as errors
make[2]: *** [arch/powerpc/lib/checksum_wrappers.o] Error 1
make[2]: *** Waiting for unfinished jobs....
make[2]: *** wait: No child processes.  Stop.
make[1]: *** [arch/powerpc/lib] Error 2
make[1]: *** Waiting for unfinished jobs....
In file included from arch/powerpc/include/asm/kup.h:10:0,
                 from arch/powerpc/include/asm/uaccess.h:12,
                 from arch/powerpc/platforms/cell/spufs/syscalls.c:8:
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: data definition has no type or storage class [-Werror]
 DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
 ^~~~~~~~~~~~~~~~~~~~~~~~
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’ [-Werror=implicit-int]
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: parameter names (without types) in function declaration [-Werror]
arch/powerpc/include/asm/book3s/64/kup-radix.h: In function ‘prevent_user_access’:
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:6: error: implicit declaration of function ‘static_branch_unlikely’ [-Werror=implicit-function-declaration]
  if (static_branch_unlikely(&uaccess_flush_key))
      ^~~~~~~~~~~~~~~~~~~~~~
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: error: ‘uaccess_flush_key’ undeclared (first use in this function); did you mean ‘do_uaccess_flush’?
  if (static_branch_unlikely(&uaccess_flush_key))
                              ^~~~~~~~~~~~~~~~~
                              do_uaccess_flush
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: note: each undeclared identifier is reported only once for each function it appears in
cc1: all warnings being treated as errors
make[4]: *** [arch/powerpc/platforms/cell/spufs/syscalls.o] Error 1
make[4]: *** Waiting for unfinished jobs....
In file included from arch/powerpc/include/asm/kup.h:10:0,
                 from arch/powerpc/include/asm/uaccess.h:12,
                 from include/linux/uaccess.h:8,
                 from include/linux/crypto.h:26,
                 from crypto/cipher.c:17:
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: data definition has no type or storage class
 DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
 ^~~~~~~~~~~~~~~~~~~~~~~~
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’ [-Werror=implicit-int]
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: parameter names (without types) in function declaration
arch/powerpc/include/asm/book3s/64/kup-radix.h: In function ‘prevent_user_access’:
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:6: error: implicit declaration of function ‘static_branch_unlikely’ [-Werror=implicit-function-declaration]
  if (static_branch_unlikely(&uaccess_flush_key))
      ^~~~~~~~~~~~~~~~~~~~~~
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: error: ‘uaccess_flush_key’ undeclared (first use in this function); did you mean ‘do_uaccess_flush’?
  if (static_branch_unlikely(&uaccess_flush_key))
                              ^~~~~~~~~~~~~~~~~
                              do_uaccess_flush
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: note: each undeclared identifier is reported only once for each function it appears in
In file included from arch/powerpc/include/asm/kup.h:10:0,
                 from arch/powerpc/include/asm/uaccess.h:12,
                 from include/linux/uaccess.h:8,
                 from include/linux/crypto.h:26,
                 from crypto/compress.c:15:
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: data definition has no type or storage class
 DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
 ^~~~~~~~~~~~~~~~~~~~~~~~
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’ [-Werror=implicit-int]
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: parameter names (without types) in function declaration
cc1: some warnings being treated as errors
make[2]: *** [crypto/cipher.o] Error 1
make[2]: *** Waiting for unfinished jobs....
arch/powerpc/include/asm/book3s/64/kup-radix.h: In function ‘prevent_user_access’:
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:6: error: implicit declaration of function ‘static_branch_unlikely’ [-Werror=implicit-function-declaration]
  if (static_branch_unlikely(&uaccess_flush_key))
      ^~~~~~~~~~~~~~~~~~~~~~
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: error: ‘uaccess_flush_key’ undeclared (first use in this function); did you mean ‘do_uaccess_flush’?
  if (static_branch_unlikely(&uaccess_flush_key))
                              ^~~~~~~~~~~~~~~~~
                              do_uaccess_flush
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: note: each undeclared identifier is reported only once for each function it appears in
In file included from arch/powerpc/include/asm/kup.h:10:0,
                 from arch/powerpc/include/asm/uaccess.h:12,
                 from include/asm-generic/termios-base.h:7,
                 from arch/powerpc/include/asm/termios.h:20,
                 from include/uapi/linux/termios.h:5,
                 from include/linux/tty.h:6,
                 from kernel/signal.c:18:
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: data definition has no type or storage class
 DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
 ^~~~~~~~~~~~~~~~~~~~~~~~
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’ [-Werror=implicit-int]
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: parameter names (without types) in function declaration
arch/powerpc/include/asm/book3s/64/kup-radix.h: In function ‘prevent_user_access’:
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:6: error: implicit declaration of function ‘static_branch_unlikely’ [-Werror=implicit-function-declaration]
  if (static_branch_unlikely(&uaccess_flush_key))
      ^~~~~~~~~~~~~~~~~~~~~~
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: error: ‘uaccess_flush_key’ undeclared (first use in this function); did you mean ‘do_uaccess_flush’?
  if (static_branch_unlikely(&uaccess_flush_key))
                              ^~~~~~~~~~~~~~~~~
                              do_uaccess_flush
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: note: each undeclared identifier is reported only once for each function it appears in
In file included from arch/powerpc/include/asm/kup.h:10:0,
                 from arch/powerpc/include/asm/uaccess.h:12,
                 from include/linux/uaccess.h:8,
                 from include/linux/crypto.h:26,
                 from include/crypto/algapi.h:15,
                 from crypto/memneq.c:62:
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: data definition has no type or storage class
 DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
 ^~~~~~~~~~~~~~~~~~~~~~~~
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’ [-Werror=implicit-int]
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: parameter names (without types) in function declaration
arch/powerpc/include/asm/book3s/64/kup-radix.h: In function ‘prevent_user_access’:
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:6: error: implicit declaration of function ‘static_branch_unlikely’ [-Werror=implicit-function-declaration]
  if (static_branch_unlikely(&uaccess_flush_key))
      ^~~~~~~~~~~~~~~~~~~~~~
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: error: ‘uaccess_flush_key’ undeclared (first use in this function); did you mean ‘do_uaccess_flush’?
  if (static_branch_unlikely(&uaccess_flush_key))
                              ^~~~~~~~~~~~~~~~~
                              do_uaccess_flush
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: note: each undeclared identifier is reported only once for each function it appears in
cc1: some warnings being treated as errors

Building powerpc:maple_defconfig ... failed
--------------
Error log:
In file included from arch/powerpc/include/asm/kup.h:10:0,
                 from arch/powerpc/include/asm/uaccess.h:12,
                 from arch/powerpc/lib/checksum_wrappers.c:24:
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: data definition has no type or storage class [-Werror]
 DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
 ^~~~~~~~~~~~~~~~~~~~~~~~
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’ [-Werror=implicit-int]
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: parameter names (without types) in function declaration [-Werror]
arch/powerpc/include/asm/book3s/64/kup-radix.h: In function ‘prevent_user_access’:
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:6: error: implicit declaration of function ‘static_branch_unlikely’ [-Werror=implicit-function-declaration]
  if (static_branch_unlikely(&uaccess_flush_key))
      ^~~~~~~~~~~~~~~~~~~~~~
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: error: ‘uaccess_flush_key’ undeclared (first use in this function); did you mean ‘do_uaccess_flush’?
  if (static_branch_unlikely(&uaccess_flush_key))
                              ^~~~~~~~~~~~~~~~~
                              do_uaccess_flush
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: note: each undeclared identifier is reported only once for each function it appears in
cc1: all warnings being treated as errors
make[2]: *** [arch/powerpc/lib/checksum_wrappers.o] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [arch/powerpc/lib] Error 2
make[1]: *** Waiting for unfinished jobs....
In file included from arch/powerpc/include/asm/kup.h:10:0,
                 from arch/powerpc/include/asm/uaccess.h:12,
                 from include/linux/uaccess.h:8,
                 from include/linux/crypto.h:26,
                 from crypto/cipher.c:17:
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: data definition has no type or storage class
 DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
 ^~~~~~~~~~~~~~~~~~~~~~~~
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’ [-Werror=implicit-int]
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: parameter names (without types) in function declaration
arch/powerpc/include/asm/book3s/64/kup-radix.h: In function ‘prevent_user_access’:
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:6: error: implicit declaration of function ‘static_branch_unlikely’ [-Werror=implicit-function-declaration]
  if (static_branch_unlikely(&uaccess_flush_key))
      ^~~~~~~~~~~~~~~~~~~~~~
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: error: ‘uaccess_flush_key’ undeclared (first use in this function); did you mean ‘do_uaccess_flush’?
  if (static_branch_unlikely(&uaccess_flush_key))
                              ^~~~~~~~~~~~~~~~~
                              do_uaccess_flush
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: note: each undeclared identifier is reported only once for each function it appears in
cc1: some warnings being treated as errors
make[2]: *** [crypto/cipher.o] Error 1
make[2]: *** Waiting for unfinished jobs....
In file included from arch/powerpc/include/asm/kup.h:10:0,
                 from arch/powerpc/include/asm/uaccess.h:12,
                 from include/linux/uaccess.h:8,
                 from include/linux/crypto.h:26,
                 from crypto/compress.c:15:
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: data definition has no type or storage class
 DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
 ^~~~~~~~~~~~~~~~~~~~~~~~
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’ [-Werror=implicit-int]
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: parameter names (without types) in function declaration
arch/powerpc/include/asm/book3s/64/kup-radix.h: In function ‘prevent_user_access’:
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:6: error: implicit declaration of function ‘static_branch_unlikely’ [-Werror=implicit-function-declaration]
  if (static_branch_unlikely(&uaccess_flush_key))
      ^~~~~~~~~~~~~~~~~~~~~~
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: error: ‘uaccess_flush_key’ undeclared (first use in this function); did you mean ‘do_uaccess_flush’?
  if (static_branch_unlikely(&uaccess_flush_key))
                              ^~~~~~~~~~~~~~~~~
                              do_uaccess_flush
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: note: each undeclared identifier is reported only once for each function it appears in
cc1: some warnings being treated as errors
make[2]: *** [crypto/compress.o] Error 1
In file included from arch/powerpc/include/asm/kup.h:10:0,
                 from arch/powerpc/include/asm/uaccess.h:12,
                 from include/linux/uaccess.h:8,
                 from include/linux/crypto.h:26,
                 from include/crypto/algapi.h:15,
                 from crypto/memneq.c:62:
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: data definition has no type or storage class
 DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
 ^~~~~~~~~~~~~~~~~~~~~~~~
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’ [-Werror=implicit-int]
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: parameter names (without types) in function declaration
arch/powerpc/include/asm/book3s/64/kup-radix.h: In function ‘prevent_user_access’:
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:6: error: implicit declaration of function ‘static_branch_unlikely’ [-Werror=implicit-function-declaration]
  if (static_branch_unlikely(&uaccess_flush_key))
      ^~~~~~~~~~~~~~~~~~~~~~
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: error: ‘uaccess_flush_key’ undeclared (first use in this function); did you mean ‘do_uaccess_flush’?
  if (static_branch_unlikely(&uaccess_flush_key))
                              ^~~~~~~~~~~~~~~~~
                              do_uaccess_flush
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: note: each undeclared identifier is reported only once for each function it appears in
cc1: some warnings being treated as errors
make[2]: *** [crypto/memneq.o] Error 1
make[1]: *** [crypto] Error 2
In file included from arch/powerpc/include/asm/kup.h:10:0,
                 from arch/powerpc/include/asm/uaccess.h:12,
                 from include/asm-generic/termios-base.h:7,
                 from arch/powerpc/include/asm/termios.h:20,
                 from include/uapi/linux/termios.h:5,
                 from include/linux/tty.h:6,
                 from kernel/signal.c:18:
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: data definition has no type or storage class
 DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
 ^~~~~~~~~~~~~~~~~~~~~~~~
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’ [-Werror=implicit-int]
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: parameter names (without types) in function declaration
arch/powerpc/include/asm/book3s/64/kup-radix.h: In function ‘prevent_user_access’:
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:6: error: implicit declaration of function ‘static_branch_unlikely’ [-Werror=implicit-function-declaration]
  if (static_branch_unlikely(&uaccess_flush_key))
      ^~~~~~~~~~~~~~~~~~~~~~
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: error: ‘uaccess_flush_key’ undeclared (first use in this function); did you mean ‘do_uaccess_flush’?
  if (static_branch_unlikely(&uaccess_flush_key))
                              ^~~~~~~~~~~~~~~~~
                              do_uaccess_flush
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: note: each undeclared identifier is reported only once for each function it appears in
In file included from arch/powerpc/include/asm/kup.h:10:0,
                 from arch/powerpc/include/asm/uaccess.h:12,
                 from include/asm-generic/termios-base.h:7,
                 from arch/powerpc/include/asm/termios.h:20,
                 from include/uapi/linux/termios.h:5,
                 from include/linux/tty.h:6,
                 from arch/powerpc/kernel/setup_64.c:27:
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: data definition has no type or storage class [-Werror]
 DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
 ^~~~~~~~~~~~~~~~~~~~~~~~
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’ [-Werror=implicit-int]
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: parameter names (without types) in function declaration [-Werror]
arch/powerpc/include/asm/book3s/64/kup-radix.h: In function ‘prevent_user_access’:
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:6: error: implicit declaration of function ‘static_branch_unlikely’ [-Werror=implicit-function-declaration]
  if (static_branch_unlikely(&uaccess_flush_key))
      ^~~~~~~~~~~~~~~~~~~~~~
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: error: ‘uaccess_flush_key’ undeclared (first use in this function); did you mean ‘do_uaccess_flush’?
  if (static_branch_unlikely(&uaccess_flush_key))
                              ^~~~~~~~~~~~~~~~~
                              do_uaccess_flush
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: note: each undeclared identifier is reported only once for each function it appears in
cc1: some warnings being treated as errors
make[2]: *** [kernel/signal.o] Error 1
make[2]: *** Waiting for unfinished jobs....
cc1: all warnings being treated as errors
make[2]: *** [arch/powerpc/kernel/setup_64.o] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [arch/powerpc/kernel] Error 2
In file included from arch/powerpc/include/asm/kup.h:10:0,
                 from arch/powerpc/include/asm/uaccess.h:12,
                 from include/linux/poll.h:11,
                 from fs/bad_inode.c:16:
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: data definition has no type or storage class
 DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
 ^~~~~~~~~~~~~~~~~~~~~~~~
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’ [-Werror=implicit-int]
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: parameter names (without types) in function declaration
arch/powerpc/include/asm/book3s/64/kup-radix.h: In function ‘prevent_user_access’:
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:6: error: implicit declaration of function ‘static_branch_unlikely’ [-Werror=implicit-function-declaration]
  if (static_branch_unlikely(&uaccess_flush_key))
      ^~~~~~~~~~~~~~~~~~~~~~
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: error: ‘uaccess_flush_key’ undeclared (first use in this function); did you mean ‘do_uaccess_flush’?
  if (static_branch_unlikely(&uaccess_flush_key))
                              ^~~~~~~~~~~~~~~~~
                              do_uaccess_flush
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: note: each undeclared identifier is reported only once for each function it appears in
cc1: some warnings being treated as errors
