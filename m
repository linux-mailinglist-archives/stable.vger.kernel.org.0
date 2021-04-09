Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8606135A7AD
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 22:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbhDIUNZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 16:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233674AbhDIUNY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Apr 2021 16:13:24 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3937CC061762;
        Fri,  9 Apr 2021 13:13:11 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id 101-20020a9d0d6e0000b02902816815ff62so994316oti.9;
        Fri, 09 Apr 2021 13:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JJhTiblm/7fuqEyVHB/RWALrGNlHkLX9Ano4nIMMo2Y=;
        b=CHNdZNjL/v+35lYebTFZGe9tayf7bt+c/4xROsOX3r+QOOsaqXT+//6aH7gocDgJh3
         aSPyH926T2Adl9KH+IBZqKP+7ZG6EilnCITJPg5RFisZLnSNLvXHGlC/axujIVsus7aW
         ZJiRjQdVLi9L2etnK86neK9PonpQ1iUEfckz29MbwjaWO23084VYko0B+owpfaVvxU4k
         rr9ailL/6aTff4PbnEX+uxx9Ge+7FL1qomZGy2z1XWBfizsZqQdC2Dp/o9xDL+D7kH/j
         EQgDHPk1hEhFpOq+dfVYv+UrEVNqG3kZ2ctZiEKMxx9NOSHbHzQDPZnc0WmPlo3QvaJC
         wtXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=JJhTiblm/7fuqEyVHB/RWALrGNlHkLX9Ano4nIMMo2Y=;
        b=WN5GAVG/sp2MJxqbIrzZHW9HO2y2TjmedH4tXd6rrzhC3Lxz5rcq+Rab1dIdYURxL7
         Za3yE4lNVA/ti/n4LdzkZLurPl1nC2HHlWLSaUScIfoUWd8KbPy76BK8XepGqdcQBiGO
         t1pLTvGBy8GTCdvEwm1iGur6fohWa0iHOK5WsNhl6udD9L4beAhDg6+qh9Alve1ypfxR
         5efOskfhhDfE4GfTLtlGBWfyw1RGX77aeLa47mmKvBxj7yEgcFd4127tnTshJaLFW03O
         yX27KFAdiLlQaJknFz6OguCsNn7JFF1t12DhHa8FpknysqaCXUuEtswUDU21QAu6mYpv
         leQA==
X-Gm-Message-State: AOAM530WN/q182hoDX7yVZ21EhGhreNbCqgP3FOMJmeiFgI8LxQF7NSA
        VPLnXRyR0diyxuO2ltcJrP4=
X-Google-Smtp-Source: ABdhPJx35oBgutL12NM5qbpfbqRhfKE/wrj0+i+GwOa52Yof50+NMkBzAOnVHpO5PRbjIJh9HCngYg==
X-Received: by 2002:a05:6830:1684:: with SMTP id k4mr13841489otr.83.1617999188270;
        Fri, 09 Apr 2021 13:13:08 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 88sm803970ota.11.2021.04.09.13.13.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 09 Apr 2021 13:13:07 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 9 Apr 2021 13:13:06 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/14] 4.14.230-rc1 review
Message-ID: <20210409201306.GC227412@roeck-us.net>
References: <20210409095300.391558233@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409095300.391558233@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 09, 2021 at 11:53:25AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.230 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Apr 2021 09:52:52 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 408 pass: 408 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Having said this, I did see a spurious crash, and I see an unusual warning.
I have seen the crash only once, but the warning happens with every boot.
These are likely not new but exposed because I added network interface
tests. This is all v4.14.y specific; I did not see it in other branches.
See below for the tracebacks. Maybe someone has seen it before.

Thanks,
Guenter

---
ftgmac100 1e660000.ethernet eth0: NCSI interface down
------------[ cut here ]------------
WARNING: CPU: 0 PID: 477 at drivers/base/dma-mapping.c:325 remap_allocator_free+0x54/0x5c
trying to free invalid coherent area: 909a1000
Modules linked in:
CPU: 0 PID: 477 Comm: ip Not tainted 4.14.230-rc1-00015-gbbc0ac1df344 #1
Hardware name: Generic DT based system
[<8000f8dc>] (unwind_backtrace) from [<8000d194>] (show_stack+0x10/0x14)
[<8000d194>] (show_stack) from [<805a5a80>] (__warn+0xc0/0xf4)
[<805a5a80>] (__warn) from [<800177b4>] (warn_slowpath_fmt+0x38/0x48)
[<800177b4>] (warn_slowpath_fmt) from [<80010554>] (remap_allocator_free+0x54/0x5c)
[<80010554>] (remap_allocator_free) from [<80010e4c>] (__arm_dma_free.constprop.0+0xec/0x13c)
[<80010e4c>] (__arm_dma_free.constprop.0) from [<80429924>] (ftgmac100_free_rings+0x17c/0x1f8)
[<80429924>] (ftgmac100_free_rings) from [<80429a24>] (ftgmac100_stop+0x84/0xa4)
[<80429a24>] (ftgmac100_stop) from [<804e8a70>] (__dev_close_many+0xac/0x100)
[<804e8a70>] (__dev_close_many) from [<804f0dc0>] (__dev_change_flags+0xb4/0x1a0)
[<804f0dc0>] (__dev_change_flags) from [<804f0ec4>] (dev_change_flags+0x18/0x48)
[<804f0ec4>] (dev_change_flags) from [<80561644>] (devinet_ioctl+0x6cc/0x808)
[<80561644>] (devinet_ioctl) from [<804d1548>] (sock_ioctl+0x188/0x2e4)
[<804d1548>] (sock_ioctl) from [<800eac80>] (do_vfs_ioctl+0x3a0/0x82c)
[<800eac80>] (do_vfs_ioctl) from [<800eb140>] (SyS_ioctl+0x34/0x60)
[<800eb140>] (SyS_ioctl) from [<8000a600>] (ret_fast_syscall+0x0/0x28)
---[ end trace c13f2f82f69274ad ]---

=====

ftgmac100 1e660000.ethernet eth0: NCSI interface up
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = 9ec84000
[00000000] *pgd=9f7f6831, *pte=00000000, *ppte=00000000
Internal error: Oops: 17 [#1] ARM
Modules linked in:
CPU: 0 PID: 397 Comm: default.script Not tainted 4.14.230-rc1-00015-gbbc0ac1df344 #1
Hardware name: Generic DT based system
task: 9f5cc260 task.stack: 9ecee000
PC is at anon_vma_clone+0x64/0x19c
LR is at fs_reclaim_release+0x8/0x18
pc : [<800c1ccc>]    lr : [<80098b5c>]    psr: a0000153
sp : 9ecefe78  ip : 00000000  fp : ffffffff
r10: 01000200  r9 : 9f7e6d10  r8 : 80cb9a44
r7 : 9f7e0da0  r6 : 9f7e6d10  r5 : 9ed0f600  r4 : 9f5a562c
r3 : 00000030  r2 : 9fbdf618  r1 : 00000034  r0 : 9ed0f600
Flags: NzCv  IRQs on  FIQs off  Mode SVC_32  ISA ARM  Segment user
Control: 00c5387d  Table: 9ec84008  DAC: 00000055
Process default.script (pid: 397, stack limit = 0x9ecee188)
Stack: (0x9ecefe78 to 0x9ecf0000)
fe60:                                                       9f5a303c 9f5a3000
fe80: 00000002 9f7e0da0 9f7e0ab4 9f5a3000 9f77e600 9f7e0da0 9f5a3000 9f77e400
fea0: 9f72dc64 800c1e28 9f7e0ab0 9f7e0ab4 00000002 9f77e600 9f7e0da0 800161f8
fec0: 9f5cc640 cacd966c 9f5cc260 cd397f94 80cb0afc 00000000 80016870 00000000
fee0: 00000000 9f69f2f8 9f7e0aa8 807ca224 9f7e0aa0 9f72dc70 9f69f100 00000011
ff00: 9f77e658 9f77e458 9eceff08 9eceff08 9f5cc650 00000011 7eb26888 00000000
ff20: 00000000 00000000 9ecee000 00000000 76eff3a0 80016870 00000000 00000000
ff40: ffffffff 7eb26888 9eceff78 00000000 9ecee000 76ec4a28 7eb26888 9eceff78
ff60: 00000000 7eb26888 00000008 00000000 00000008 800245e4 76efdcd0 7eb26888
ff80: 00000000 00000002 8000a704 9ecee000 00000000 80016cd4 00000000 00000000
ffa0: 9ecee000 8000a520 76efdcd0 7eb26888 76efffcc 00000001 76efe7ac 00000000
ffc0: 76efdcd0 7eb26888 00000000 00000002 7eb26918 76efe000 76f00c60 76eff3a0
ffe0: 000e0350 7eb26888 76e96b94 76e96b98 60000150 76efffcc 00000000 00000000
[<800c1ccc>] (anon_vma_clone) from [<800c1e28>] (anon_vma_fork+0x24/0x138)
[<800c1e28>] (anon_vma_fork) from [<800161f8>] (copy_process.part.0+0x12a4/0x17dc)
[<800161f8>] (copy_process.part.0) from [<80016870>] (_do_fork+0xa0/0x488)
[<80016870>] (_do_fork) from [<80016cd4>] (sys_fork+0x24/0x2c)
[<80016cd4>] (sys_fork) from [<8000a520>] (ret_fast_syscall+0x0/0x4c)
Code: eb001f58 e2505000 0a000017 e594b004 (e59b9000)
---[ end trace 6680cdd56c4514b7 ]---

