Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8853779BD
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 03:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhEJBXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 21:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhEJBXU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 21:23:20 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50878C061573;
        Sun,  9 May 2021 18:22:15 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id i13so12611902pfu.2;
        Sun, 09 May 2021 18:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SoLhD7ineASZqqR0oXIoyOceHC0bJ5NdY1er3QmkfNA=;
        b=rz33cacOclNxw4snydhYgWUUlwjzMxoZs+nduRbwaxpaPmO7EfhoTwvEL7uskl5m1Z
         fRdwt8dihpJeUAC4xPl/kE1jA4Y5h4iCkls+eVq2hwmniE+a3RFgDIoMuH7oRzHwmxYa
         wh8P56+ywJwEaibZeXDzd+co0HuEr0PBf6PUX4/uvfcmY/X/BbxSeYRTFFWGPDD/xwcp
         rYtx3dkfFTbxrI2BGDIOqYYZOHh214R7hjlKZJeckwf9XUzAZY3vT6oxKSxPenda1Rs9
         Q3hq7Qu+p6FpvYmb3pOpzizv678DGx6U2FsaHZqA9tOZIZ+J59UY58fmK4tn+vpOMM6+
         GiQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SoLhD7ineASZqqR0oXIoyOceHC0bJ5NdY1er3QmkfNA=;
        b=r6sHSyS+hod9bA/jtQnbvbMYBicXvgVKpLSfi+1EBzBNq43rzqlSUT2LMbX+uXov54
         //E+dqxyvF9UVZ2nTGtnAacVxDLy/Yo0IMgAzX50mgZAlMgVdcXwqX3KaYVeVOAHyzUm
         dJ4Lh6HDHkMbejKU8CplbhB5ydDUFCYed+paOD1/VdQc87NKBX1C//M8G/FimhDnt+aV
         OMhXg6il+vfd1dJanZAVNkMiRVR6ecBfmiWaxZyuVMwlyFPYAcJnO2Y/1K7JttP6zkei
         CUaiuHG64I6VHXAEEDWo2caHp2MX0m4dWfYzXQ76se1CwFSjOjjLVaWE9NQQ+ZBJrB11
         VI0A==
X-Gm-Message-State: AOAM530ZTP57SZIPYCyHfNBoGPmnX6xciKILH5uYJcHAGGZrPzXudodF
        EUiXHIlyT7AuV55x69jkQwo=
X-Google-Smtp-Source: ABdhPJwFsmcGs6qhm+6/8JK2XGHvs9gGuw87SLsCybvhOc7ng7bPYADNFK7w7egNsfQCx3x/whfqww==
X-Received: by 2002:a65:4887:: with SMTP id n7mr682536pgs.284.1620609734780;
        Sun, 09 May 2021 18:22:14 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c13sm17527088pjv.21.2021.05.09.18.22.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 May 2021 18:22:14 -0700 (PDT)
Subject: Re: [PATCH stable 5.10 0/3] ARM FDT relocation backports
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@armlinux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Desaulniers <ndesaulniers@gooogle.com>,
        Joe Perches <joe@perches.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Tian Tao <tiantao6@hisilicon.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
References: <20210509173029.1653182-1-f.fainelli@gmail.com>
 <CAMj1kXGt1zrRQused3xgXzhQYfDchgH325iRDCZrx+7o1+bUnA@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5f8fed97-8c73-73b0-6576-bf3fbcdb1440@gmail.com>
Date:   Sun, 9 May 2021 18:22:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAMj1kXGt1zrRQused3xgXzhQYfDchgH325iRDCZrx+7o1+bUnA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/9/2021 12:17 PM, Ard Biesheuvel wrote:
> On Sun, 9 May 2021 at 19:30, Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>> Hi Greg, Sasha,
>>
>> These patches were not marked with a Fixes: tag but they do fix booting
>> ARM 32-bit platforms that have specific FDT placement and would cause
>> boot failures like these:
>>
> 
> I don't have any objections to backporting these changes, but it would
> be helpful if you could explain why this is a regression. Also, you'll
> need to pull in the following patch as well

This does not qualify as a regression in that it has never worked for
the specific platform that I have shown above until your 3 commits came
in and fixed that particular FDT placement. To me this qualifies as a
bug fix, and given that the 3 (now 4) commits applied without hunks, it
seems reasonable to me to back port those to stable.

> 
> 10fce53c0ef8 ARM: 9027/1: head.S: explicitly map DT even if it lives
> in the first physical section

Thanks, I will add this and resubmit.

> 
> 
>> [    0.000000] 8<--- cut here ---
>> [    0.000000] Unable to handle kernel paging request at virtual address
>> ffa14000
>> [    0.000000] pgd = (ptrval)
>> [    0.000000] [ffa14000] *pgd=80000040007003, *pmd=00000000
>> [    0.000000] Internal error: Oops: 206 [#1] SMP ARM
>> [    0.000000] Modules linked in:
>> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 5.4.85-1.0 #1
>> [    0.000000] Hardware name: Broadcom STB (Flattened Device Tree)
>> [    0.000000] PC is at fdt_check_header+0xc/0x21c
>> [    0.000000] LR is at __unflatten_device_tree+0x7c/0x2f8
>> [    0.000000] pc : [<c0d30e44>]    lr : [<c0a6c0fc>]    psr: 600000d3
>> [    0.000000] sp : c1401eac  ip : c1401ec8  fp : c1401ec4
>> [    0.000000] r10: 00000000  r9 : c150523c  r8 : 00000000
>> [    0.000000] r7 : c124eab4  r6 : ffa14000  r5 : 00000000  r4 :
>> c14ba920
>> [    0.000000] r3 : 00000000  r2 : c150523c  r1 : 00000000  r0 :
>> ffa14000
>> [    0.000000] Flags: nZCv  IRQs off  FIQs off  Mode SVC_32  ISA ARM
>> Segment user
>> [    0.000000] Control: 30c5383d  Table: 40003000  DAC: fffffffd
>> [    0.000000] Process swapper (pid: 0, stack limit = 0x(ptrval))
>> [    0.000000] Stack: (0xc1401eac to 0xc1402000)
>> [    0.000000] 1ea0:                            c14ba920 00000000
>> ffa14000 c1401ef4 c1401ec8
>> [    0.000000] 1ec0: c0a6c0fc c0d30e44 c124eab4 c124eab4 00000000
>> c14ebfc0 c140e5b8 00000000
>> [    0.000000] 1ee0: 00000001 c126f5a0 c1401f14 c1401ef8 c1250064
>> c0a6c08c 00000000 c1401f08
>> [    0.000000] 1f00: c022ddac c140ce80 c1401f9c c1401f18 c120506c
>> c125002c 00000000 00000000
>> [    0.000000] 1f20: 00000000 00000000 ffffffff c1401f94 c1401f6c
>> c1406308 3fffffff 00000001
>> [    0.000000] 1f40: 00000000 00000001 c1432b58 c14ca180 c1213ca4
>> c1406308 c1406300 30c0387d
>> [    0.000000] 1f60: c1401f8c c1401f70 c028e0ec 00000000 c1401f94
>> c1406308 c1406300 30c0387d
>> [    0.000000] 1f80: 00000000 7fa14000 420f1000 30c5387d c1401ff4
>> c1401fa0 c1200c98 c120467c
>> [    0.000000] 1fa0: 00000000 00000000 00000000 00000000 00000000
>> 00000000 00000000 c127fa44
>> [    0.000000] 1fc0: 00000000 00000000 00000000 c1200330 00000000
>> 30c0387d ffffffff 7fa14000
>> [    0.000000] 1fe0: 420f1000 30c5387d 00000000 c1401ff8 00000000
>> c1200c28 00000000 00000000
>> [    0.000000] Backtrace:
>> [    0.000000] [<c0d30e38>] (fdt_check_header) from [<c0a6c0fc>]
>> (__unflatten_device_tree+0x7c/0x2f8)
>> [    0.000000]  r6:ffa14000 r5:00000000 r4:c14ba920
>> [    0.000000] [<c0a6c080>] (__unflatten_device_tree) from [<c1250064>]
>> (unflatten_device_tree+0x44/0x54)
>> [    0.000000]  r10:c126f5a0 r9:00000001 r8:00000000 r7:c140e5b8
>> r6:c14ebfc0 r5:00000000
>> [    0.000000]  r4:c124eab4 r3:c124eab4
>> [    0.000000] [<c1250020>] (unflatten_device_tree) from [<c120506c>]
>> (setup_arch+0x9fc/0xc84)
>> [    0.000000]  r4:c140ce80
>> [    0.000000] [<c1204670>] (setup_arch) from [<c1200c98>]
>> (start_kernel+0x7c/0x540)
>> [    0.000000]  r10:30c5387d r9:420f1000 r8:7fa14000 r7:00000000
>> r6:30c0387d r5:c1406300
>> [    0.000000]  r4:c1406308
>> [    0.000000] [<c1200c1c>] (start_kernel) from [<00000000>] (0x0)
>> [    0.000000]  r10:30c5387d r9:420f1000 r8:7fa14000 r7:ffffffff
>> r6:30c0387d r5:00000000
>> [    0.000000]  r4:c1200330
>> [    0.000000] Code: e89da800 e1a0c00d e92dd870 e24cb004 (e5d03000)
>> [    0.000000] random: get_random_bytes called from
>> print_oops_end_marker+0x50/0x58 with crng_init=0
>> [    0.000000] ---[ end trace f34b4929828506c1 ]---
>> [    0.000000] Kernel panic - not syncing: Attempted to kill the idle
>> task!
>> [    0.000000] ---[ end Kernel panic - not syncing: Attempted to kill
>> the idle task! ]---
>>
>>
>> Ard Biesheuvel (3):
>>   ARM: 9011/1: centralize phys-to-virt conversion of DT/ATAGS address
>>   ARM: 9012/1: move device tree mapping out of linear region
>>   ARM: 9020/1: mm: use correct section size macro to describe the FDT
>>     virtual address
>>
>>  Documentation/arm/memory.rst  |  7 ++++++-
>>  arch/arm/include/asm/fixmap.h |  2 +-
>>  arch/arm/include/asm/memory.h |  5 +++++
>>  arch/arm/include/asm/prom.h   |  4 ++--
>>  arch/arm/kernel/atags.h       |  4 ++--
>>  arch/arm/kernel/atags_parse.c |  6 +++---
>>  arch/arm/kernel/devtree.c     |  6 +++---
>>  arch/arm/kernel/head.S        |  5 ++---
>>  arch/arm/kernel/setup.c       | 19 ++++++++++++++-----
>>  arch/arm/mm/init.c            |  1 -
>>  arch/arm/mm/mmu.c             | 20 ++++++++++++++------
>>  arch/arm/mm/pv-fixup-asm.S    |  4 ++--
>>  12 files changed, 54 insertions(+), 29 deletions(-)
>>
>> --
>> 2.25.1
>>

-- 
Florian
