Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E364F421D15
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 06:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbhJEECb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 00:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbhJEECa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 00:02:30 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46B8C061749
        for <stable@vger.kernel.org>; Mon,  4 Oct 2021 21:00:40 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id g10so13418870edj.1
        for <stable@vger.kernel.org>; Mon, 04 Oct 2021 21:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lnyQlBfDLvTeJ7czX2NVyPkC7cjq5N8egGvuyleFrlc=;
        b=wpZD9YsDBE33ER9dqAA1JFPbz6URlxU/76MMP11/5+aN4YEgIkMEixLombBLfM9jSq
         ynCVDG/Oo5tRV4nmiwJGpOo62LaPDUri5f4kZIswKM9llr/5gSLGU/vlrOQ266M0XpbY
         UOSHXovJUAPK98uFy2HOvo9wph0QooVZhxAbj5K0PSJstZsXpOza/sUbpUd1tAWXij1u
         QDTprZ5vNQD2T3I6zPdcAbiP4rufeZsYVnwlLZbkcXnvZ+L8BxpWOHUR15xnPjFB075B
         U6KAAO9ksx6kwa3JtKlACD6c6In5wPrO3mJNIVfEU4eCv60dJltjh7AGcq8P+bwz66Y5
         q6+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lnyQlBfDLvTeJ7czX2NVyPkC7cjq5N8egGvuyleFrlc=;
        b=yez00RSW1fCHHJjX+2gDc+ZKXTz8cK/bifMBFB5n1MioaEpcT0UtoeA5E0NUBm06IF
         oBTryljzqSdwfSpMstMuWFahyLFrUBVulcZOA9p/g7ZaI3aEG5dERqDmViWssmkjC16u
         2t9fi6NJJWn2W48fS2MOqP7MEW/83DbnoAaYPl2wAf+c9jMrZwIMz0Tj/uRK6LYvt9FO
         2lcSrKe9mzhpZBJ1jgFZJVQYZMR21gyyYXLT9NnW9ieZsnRxWpjNvoHi7cKBWAyGF0se
         dlIuEeJITYLSl+Myad6YtVsHfHNSfqDsFIukP8Oq0REhh88Hg+KyUJYH1JMAuAo6qp7v
         d8MA==
X-Gm-Message-State: AOAM531SHbCU+n5TYyy11DB1TkzaQCrcqxe3do7ZbQsGVZQP8O5rLeoE
        S/Hd20vHBjzTDLtrGsAuogPVrdZThD8qYOtXUDJ+0g==
X-Google-Smtp-Source: ABdhPJwucUTfG5YH1WnKdXOfOoVo9/HFC9Xg3vuteVxynCiRhKXT3wJG1zwdU8n9JpG/+0HllD9q462Ef7pvcy1umQA=
X-Received: by 2002:a17:906:7016:: with SMTP id n22mr9313284ejj.567.1633406439193;
 Mon, 04 Oct 2021 21:00:39 -0700 (PDT)
MIME-Version: 1.0
References: <20211004125044.945314266@linuxfoundation.org>
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 5 Oct 2021 09:30:27 +0530
Message-ID: <CA+G9fYs2WTaKa3jVfCBFTke8rFDupj=mNiaN=mWK-cYcvya8NA@mail.gmail.com>
Subject: Re: [PATCH 5.14 000/172] 5.14.10-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 4 Oct 2021 at 18:43, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.14.10 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 06 Oct 2021 12:50:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regression found on arm.
following kernel BUG reported on stable-rc linux-5.14.y while booting
BeagleBoard X15 device.

metadata:
  git branch: linux-5.14.y
  git repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
  git commit: cda15f9c69e08480d4308d0e5c62bd44324a9ff0
  git describe: v5.14.9-173-gcda15f9c69e0
  make_kernelversion: 5.14.10-rc1
  kernel-config: https://builds.tuxbuild.com/1z2ozt5ntwqausJUkOMJ8zBgRqi/config


Kernel crash:
--------------
[    6.457366] kernel BUG at kernel/cpu.c:1065!
[    6.461669] Internal error: Oops - BUG: 0 [#1] SMP ARM
[    6.466827] Modules linked in:
[    6.469909] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.14.10-rc1 #1
[    6.476318] Hardware name: Generic DRA74X (Flattened Device Tree)
[    6.482452] PC is at cpuhp_report_idle_dead+0x74/0x78
[    6.487518] LR is at do_idle+0x108/0x310
[    6.491485] pc : [<c035a700>]    lr : [<c03a3cc0>]    psr: 20000093
[    6.497772] sp : c2101ee0  ip : c2101f00  fp : c2101efc
[    6.503051] r10: 00000000  r9 : c2100000  r8 : 00000000
[    6.508300] r7 : c2108fe4  r6 : eeb04414  r5 : 2ca71000  r4 : c2093414
[    6.514862] r3 : c2101ee0  r2 : 00000000  r1 : 000000e0  r0 : 00000000
[    6.521423] Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM
Segment none
[    6.528686] Control: 10c5387d  Table: 8020406a  DAC: 00000051
[    6.534454] Register r0 information: NULL pointer
[    6.539215] Register r1 information: non-paged memory
[    6.544281] Register r2 information: NULL pointer
[    6.549011] Register r3 information: non-slab/vmalloc memory
[    6.554718] Register r4 information: non-slab/vmalloc memory
[    6.560424] Register r5 information: non-paged memory
[    6.565490] Register r6 information: non-slab/vmalloc memory
[    6.571197] Register r7 information: non-slab/vmalloc memory
[    6.576904] Register r8 information: NULL pointer
[    6.581634] Register r9 information: non-slab/vmalloc memory
[    6.587310] Register r10 information: NULL pointer
[    6.592132] Register r11 information: non-slab/vmalloc memory
[    6.597930] Register r12 information: non-slab/vmalloc memory
[    6.603698] Process swapper/0 (pid: 0, stack limit = 0x(ptrval))
[    6.609741] Stack: (0xc2101ee0 to 0xc2102000)
[    6.614135] 1ee0: 00000000 c2100000 c2108f90 c2108fe4 c2101f44
c2101f00 c03a3cc0 c035a698
[    6.622375] 1f00: c210e0c0 00000002 c2101f00 c209f0f0 c2100000
5a76ee47 c2101f3c 000000e0
[    6.630584] 1f20: c2101f58 00000002 c2108f40 00000000 c2100000
10c5387d c2101f54 c2101f48
[    6.638824] 1f40: c03a4334 c03a3bc4 c2101f84 c2101f58 c1556b84
c03a4318 00000000 00000000
[    6.647033] 1f60: c1556a88 c2101f70 c0322004 c239e068 c1fd7a80
ffffffff c2101f94 c2101f88
[    6.655273] 1f80: c1f00af0 c15569c0 c2101ff4 c2101f98 c1f012a0
c1f00ae4 ffffffff ffffffff
[    6.663482] 1fa0: 00000000 c1f00640 00000000 00000000 00000000
00000000 00000000 c1fd7a80
[    6.671722] 1fc0: 5a73e04d 00000000 00000000 c1f00330 00000051
10c0387d 00000000 8ffda000
[    6.679931] 1fe0: 412fc0f2 10c5387d 00000000 c2101ff8 00000000
c1f00b78 00000000 00000000
[    6.688140] Backtrace:
[    6.690612] [<c035a68c>] (cpuhp_report_idle_dead) from [<c03a3cc0>]
(do_idle+0x108/0x310)
[    6.698852]  r7:c2108fe4 r6:c2108f90 r5:c2100000 r4:00000000
[    6.704559] [<c03a3bb8>] (do_idle) from [<c03a4334>]
(cpu_startup_entry+0x28/0x2c)
[    6.712188]  r10:10c5387d r9:c2100000 r8:00000000 r7:c2108f40
r6:00000002 r5:c2101f58
[    6.720031]  r4:000000e0
[    6.722595] [<c03a430c>] (cpu_startup_entry) from [<c1556b84>]
(rest_init+0x1d0/0x2fc)
[    6.730560] [<c15569b4>] (rest_init) from [<c1f00af0>]
(arch_call_rest_init+0x18/0x1c)
[    6.738555]  r6:ffffffff r5:c1fd7a80 r4:c239e068
[    6.743194] [<c1f00ad8>] (arch_call_rest_init) from [<c1f012a0>]
(start_kernel+0x734/0x780)
[    6.751586] [<c1f00b6c>] (start_kernel) from [<00000000>] (0x0)
[    6.757568]  r10:10c5387d r9:412fc0f2 r8:8ffda000 r7:00000000
r6:10c0387d r5:00000051
[    6.765441]  r4:c1f00330
[    6.767974] Code: e34c1035 e3a03000 eb039b62 e89da8f0 (e7f001f2)
[    6.774108] ---[ end trace 8e1c46209559ca84 ]---

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

ref:
https://lkft.validation.linaro.org/scheduler/job/3659621#L2841

-- 
Linaro LKFT
https://lkft.linaro.org
