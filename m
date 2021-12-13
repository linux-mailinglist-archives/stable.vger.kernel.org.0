Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECA84731C4
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 17:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236217AbhLMQ14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 11:27:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234495AbhLMQ1z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 11:27:55 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611DFC061574;
        Mon, 13 Dec 2021 08:27:55 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id v64so39610039ybi.5;
        Mon, 13 Dec 2021 08:27:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hwHeOyBhVF+xpEC9/lpWfLu35Pjic1p8DmLhAMTSq18=;
        b=Y4yVhJxegWDcu4mQDrq6g5r6zxmLqqoynynNHa1o1ZGJndGbBcdBh+EzF+76J8pqqh
         A8AhE64hb2g3Y0A8cMtB52Swp/tfDZYcsc3sWCYgT/G9zzrE1mvw2CDwqEQkZpnM/hiq
         UeN2dAtKQE0KYmSFC6RMijXmtO9y+9+pJcERFaulvFd/vCp+wxbCRf3GaTbk2nwlWg2x
         CG6w1iSwz5oOh9tT9R6TApr02MNiurL1DEt7fxWps5R2ZvFwLD3/O22C7WW/Z40GUjLR
         Jzgo06TzyZ9GWExCoswEOcOD8pQir6vD9+Admzhk/qNwpJIhDutbC+sldvLiAm814j3U
         X0lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hwHeOyBhVF+xpEC9/lpWfLu35Pjic1p8DmLhAMTSq18=;
        b=m68yIBokk/CStjvw2re5bIYqalfMLSsdQLnqLSyHJE6tdMCbJANoue7WKgJgdyQVR6
         WBh8D509j8bAi76Gz9IMxHw6SUI6dDxDmAzDovheEj9wLEa0Cb6xEjdpMXQuEWWUg6Ar
         M5bNOUsiJNBlvHXCBPoWdNj+GAnJOd9GrIuDnkY7LFXM29P6wDyxVwg5e8oAWkEXadbJ
         GFFa/tMgQshSDxALyivYMT+jlPQOCdR4R4pMHi5Eu3EDGCH7jZslW7XsIQ45nfHMc7P9
         7lhX7xXFhaSwvYoD/+BMgviUzx7yxUZ7vXgyaDbn5UsDj8FDEkai0Y6r/zlv1ec8CfZz
         8GrA==
X-Gm-Message-State: AOAM533Y7Rr7J7P4A/U9DTVLY9HTkj5Bf02btKxCNiYrsktTL8d28KwI
        n8Ps2qVvXN8234d/F4gDty4dCVT+OO8jSCumCABWuflkhm0=
X-Google-Smtp-Source: ABdhPJyyXLQj/hPoLkLLRloyy4F+FZbBM6jX1lp6NcEq0V+gpsOFNGIjSTH8jIhDk5iMz1Kigo9cYgplud4KIyKqlfc=
X-Received: by 2002:a25:d4c:: with SMTP id 73mr32740326ybn.74.1639412874604;
 Mon, 13 Dec 2021 08:27:54 -0800 (PST)
MIME-Version: 1.0
References: <20211213092930.763200615@linuxfoundation.org>
In-Reply-To: <20211213092930.763200615@linuxfoundation.org>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Mon, 13 Dec 2021 16:27:18 +0000
Message-ID: <CADVatmPsqW050=k07RDChjnf_F+MJfkLzHiRcdeoWQ7Mws_qMw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/74] 4.19.221-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

HI Greg,

On Mon, Dec 13, 2021 at 9:51 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.221 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.

Just an initial report. mips allmodconfig is failing with the following error.

drivers/spi/spi-sh-msiof.c:78: warning: "STR" redefined
   78 | #define STR     0x40    /* Status Register */
      |
In file included from ./arch/mips/include/asm/mach-generic/spaces.h:15,
                 from ./arch/mips/include/asm/addrspace.h:13,
                 from ./arch/mips/include/asm/barrier.h:11,
                 from ./include/linux/compiler.h:320,
                 from ./arch/mips/include/asm/bitops.h:16,
                 from ./include/linux/bitops.h:19,
                 from ./include/linux/bitmap.h:8,
                 from drivers/spi/spi-sh-msiof.c:14:
./arch/mips/include/asm/mipsregs.h:30: note: this is the location of
the previous definition
   30 | #define STR(x) __STR(x)
      |
In file included from ./arch/mips/include/asm/sibyte/sb1250.h:41,
                 from drivers/watchdog/sb_wdog.c:58:
./arch/mips/include/asm/sibyte/bcm1480_scd.h:274: warning:
"M_SPC_CFG_CLEAR" redefined
  274 | #define M_SPC_CFG_CLEAR                 M_BCM1480_SPC_CFG_CLEAR
      |
In file included from ./arch/mips/include/asm/sibyte/sb1250.h:40,
                 from drivers/watchdog/sb_wdog.c:58:
./arch/mips/include/asm/sibyte/sb1250_scd.h:405: note: this is the
location of the previous definition
  405 | #define M_SPC_CFG_CLEAR         _SB_MAKEMASK1(32)
      |
In file included from ./arch/mips/include/asm/sibyte/sb1250.h:41,
                 from drivers/watchdog/sb_wdog.c:58:
./arch/mips/include/asm/sibyte/bcm1480_scd.h:275: warning:
"M_SPC_CFG_ENABLE" redefined
  275 | #define M_SPC_CFG_ENABLE                M_BCM1480_SPC_CFG_ENABLE
      |
In file included from ./arch/mips/include/asm/sibyte/sb1250.h:40,
                 from drivers/watchdog/sb_wdog.c:58:
./arch/mips/include/asm/sibyte/sb1250_scd.h:406: note: this is the
location of the previous definition
  406 | #define M_SPC_CFG_ENABLE        _SB_MAKEMASK1(33)
      |
/src/gcc-10/bin/mips-linux-ld:
arch/mips/boot/dts/mscc/ocelot_pcb123.dtb.o: in function
`__dtb_ocelot_pcb123_begin':
(.dtb.init.rodata+0x0): multiple definition of
`__dtb_ocelot_pcb123_begin';
arch/mips/boot/dts/mscc/ocelot_pcb123.dtb.o:(.dtb.init.rodata+0x0):
first defined here
/src/gcc-10/bin/mips-linux-ld:
arch/mips/boot/dts/mscc/ocelot_pcb123.dtb.o: in function
`__dtb_ocelot_pcb123_end':
(.dtb.init.rodata+0x1003): multiple definition of
`__dtb_ocelot_pcb123_end';
arch/mips/boot/dts/mscc/ocelot_pcb123.dtb.o:(.dtb.init.rodata+0x1003):
first defined here
/src/gcc-10/bin/mips-linux-ld: arch/mips/boot/dts/mti/sead3.dtb.o: in
function `__dtb_sead3_begin':
(.dtb.init.rodata+0x0): multiple definition of `__dtb_sead3_begin';
arch/mips/boot/dts/mti/sead3.dtb.o:(.dtb.init.rodata+0x0): first
defined here
/src/gcc-10/bin/mips-linux-ld: arch/mips/boot/dts/mti/sead3.dtb.o: in
function `__dtb_sead3_end':
(.dtb.init.rodata+0x100b): multiple definition of `__dtb_sead3_end';
arch/mips/boot/dts/mti/sead3.dtb.o:(.dtb.init.rodata+0x100b): first
defined here
make: *** [Makefile:1046: vmlinux] Error 1


-- 
Regards
Sudip
