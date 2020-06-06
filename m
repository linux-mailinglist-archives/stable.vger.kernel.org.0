Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27BC61F07B4
	for <lists+stable@lfdr.de>; Sat,  6 Jun 2020 17:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728785AbgFFPuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Jun 2020 11:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgFFPuI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Jun 2020 11:50:08 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC62C03E96A
        for <stable@vger.kernel.org>; Sat,  6 Jun 2020 08:50:06 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id i27so4434962ljb.12
        for <stable@vger.kernel.org>; Sat, 06 Jun 2020 08:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5A2hg09DmFmZvaAutmXPcUjOTTSqN9A2wl30Y78iCx8=;
        b=L5C0qRPW4cxxUqvz7uqn/nm5ZmewSBs/ZJubQr67yI3VRxjPpx/1aQDcGBIF3bDEbQ
         qwRtAyBop+rdHY6FL5WptQoIbDY3840mqOew5Qa5/K9j5qKRTyTMuVFFwciZv0DGpwyM
         ohZ9+E9fACHeJ/gKzxlnF6S8vi+bKqX6EOLPewxR/8cOpF26lh+GdnHq2EmUk8ai4hxt
         Ixt2Z1R0E+p7cvbj4uuDQteoey3ofFaruIfsHewC3Ypz/Uqm2CG/has+ke1Gz7mjaBRT
         QVdNgU2ZfaJMUQB4m0ZKwsqM1HgQxco7vKxqXzTtmI56TsduhldOmr/xF5mhEzFw8Yie
         qDRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5A2hg09DmFmZvaAutmXPcUjOTTSqN9A2wl30Y78iCx8=;
        b=fadpV/bLrolQgBR7pQAZQtP1hEzZG8qET7l91764kxD93AYko7/GcrcQw2joFZP1yT
         Vd483TeYcMki6H4OZEUGQvE+qts9N//neVx79ljbAUGpjKF0KYTrjkG4r3xxwzKwIvec
         YgYZsCBlYdvpTg3oDe3yl4UWE5AzxsOw7eatP39+gwpmhW8f5SWDNUnQJCDhr4NoLt6i
         16f/V/c7x6vmlUNsheNDO1UV/cuv1G2dc8aWaimr01PA6Ftn/8SHNS9eipL7z7M5ZK71
         xLDlgMKp7dgh54TG0ZAVAjj+oxke8m2g8KcQ4gr0tZjbaPacuF/9IPPFfML+Bdtx5uGd
         5yfQ==
X-Gm-Message-State: AOAM532+ZdFTgnQ1qmvEMKXO8wyynju0RXKUXmgcNhIPCpLdChdHHWUG
        4v28TADBr5OabMZxyXWicTdWzTp2CAOyHVjowDKH7A==
X-Google-Smtp-Source: ABdhPJym4tvsqXmIpO2EVJpiI9Hw6x9mro2aVOd15yiOOQgK7AHXfG7SLCrRs3yEqYQGBcV1gU5QNh0D06bkKFmUq64=
X-Received: by 2002:a05:651c:318:: with SMTP id a24mr5340332ljp.55.1591458605022;
 Sat, 06 Jun 2020 08:50:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200605135951.018731965@linuxfoundation.org>
In-Reply-To: <20200605135951.018731965@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 6 Jun 2020 21:19:53 +0530
Message-ID: <CA+G9fYsuzQ1BiAx74K2VGK4enUoNLe=jzpT-+AX2NB=wd4PHPw@mail.gmail.com>
Subject: Re: [PATCH 5.7 00/14] 5.7.1-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 5 Jun 2020 at 19:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.7.1 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 07 Jun 2020 13:54:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.7.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.7.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.

While running kselftest memfd_test case the kernel panic noticed on i386
which started with kernel BUG and followed by kernel panic.

steps to reproduce: (Not always reproducible)
          - cd /opt/kselftests/mainline/memfd/
          - ./run_fuse_test.sh || true
          - ./run_hugetlbfs_test.sh || true

[  417.473220] run_hugetlbfs_t (10826): drop_caches: 3
[  417.491120] audit: type=3D1701 audit(1591388532.357:87503):
auid=3D4294967295 uid=3D0 gid=3D0 ses=3D4294967295 subj=3Dkernel pid=3D1082=
9
comm=3D\"memfd_test\" exe=3D\"/opt/kselftests/mainline/memfd/memfd_test\"
sig=3D6 res=3D1
[  417.511294] BUG: kernel NULL pointer dereference, address: 00000043
[  417.517569] #PF: supervisor read access in kernel mode
[  417.522699] #PF: error_code(0x0000) - not-present page
[  417.527830] *pde =3D 00000000
[  417.530707] Oops: 0000 [#2] SMP
[  417.533846] CPU: 3 PID: 10829 Comm: memfd_test Tainted: G      D W
       5.7.1-rc1 #1
[  417.541845] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[  417.549327] EIP: kmem_cache_alloc_trace+0x81/0x2b0
<>
[  931.776242] Kernel panic - not syncing: Attempted to kill init!
exitcode=3D0x00000009
[  931.783933] Kernel Offset: 0x1ce00000 from 0xc1000000 (relocation
range: 0xc0000000-0xf77fdfff)
[  931.792627] ---[ end Kernel panic - not syncing: Attempted to kill
init! exitcode=3D0x00000009 ]---


software_node_release bug on stable-rc 5.7 noticed which is a known
issue on Linus's tree.
[  400.320910] BUG: kernel NULL pointer dereference, address: 0000000000000=
000
[  400.328959] #PF: supervisor read access in kernel mode
[  400.334097] #PF: error_code(0x0000) - not-present page
[  400.339226] PGD 800000022880d067 P4D 800000022880d067 PUD 21f410067 PMD =
0
[  400.346093] Oops: 0000 [#1] SMP PTI
[  400.349586] CPU: 2 PID: 8865 Comm: modprobe Tainted: G        W
    5.7.1-rc1 #1
[  400.357322] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.2 05/23/2018
[  400.364711] RIP: 0010:ida_free+0x76/0x140

Full test log link,
https://lkft.validation.linaro.org/scheduler/job/1477323#L11575


Kernel BUG on arm64 dragonboard 410c which is reported upstream but
did not get reply.
BUG: spinlock bad magic on CPU#1, swapper/0/1
lock: msm_uart_ports
Upstream issue reported link,
https://lore.kernel.org/lkml/CA+G9fYsDgghO+4zMY-AF2RgUmAfjZyA+tjeg5m5F1rEgE=
tw5fg@mail.gmail.com/

--=20
Linaro LKFT
https://lkft.linaro.org
