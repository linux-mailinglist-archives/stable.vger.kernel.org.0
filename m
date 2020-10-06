Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 062D728488F
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 10:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbgJFIZn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 04:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgJFIZn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Oct 2020 04:25:43 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465B9C061755
        for <stable@vger.kernel.org>; Tue,  6 Oct 2020 01:25:43 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id d20so7178369iop.10
        for <stable@vger.kernel.org>; Tue, 06 Oct 2020 01:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YRj9P/9Lvsmxkr1sJc/9VWaorXzUF7X2yNhikWl2Zyw=;
        b=KqRBxzTuIgJZ68p3ZslROEmoubYrk5WVvyHndOzgCgejx6vcpnodycSKPoyRUgPLpC
         DzvVVdNGcA+IsJiXbiSfwg125KxadQq+eFcurKPiKuRd1Px6ZA48FwXFW3bscJwmd3gy
         Mr+L/cchQ8lkrUa1Dvgvk+YsqaxyArjSWJtYy9Y6sBWTxNv/B8eBUOCg3ULC49F4+PsG
         oImyyLYLEfp91+QkTwf9QpsgwNh6ooDozyh2UZzhNO5xprsTq8iHPP4/tdMfhEBfc/35
         bwNlOacIIZV8PxT8K6cKGsMc/5wyHNPSO5DmPGjHLfHGsi17SJ6GZ+KxLWwFZ/yfrwba
         XCMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YRj9P/9Lvsmxkr1sJc/9VWaorXzUF7X2yNhikWl2Zyw=;
        b=iJxm8/o0lGOnqPfbsw7LHSawH6b/yGSDx5UVj4BHO9RCPWcNkprq5+LB+fQdfz+3mC
         6T4u1PHXoBhT8kq4bpwz0G3DZJS2Y4ZZhI7qixGTRt8z86IIbqzCfvgN426L6z8fVoG4
         LPiKhl9C9GkCp/lXrz7S8Toi2NMWWfVSt2kq9rJyai6ZStl0Ao+dEOt7urOTL1DcsZKK
         WY4m7dnNuWopGnr8D7Pph7hUgjYEJRLphAq8PIO7VFWqHEsviz4T24R+OYqMia6ZxeKk
         K7+/A0ViibYKVrbnS80g1nNhgp8arcdKE5XCWkzZtOa5ur1YPpQzwYhGkvlidkNjGG+U
         5K6g==
X-Gm-Message-State: AOAM5301qtKvpjA1XuSAhlkmfdDDO356yHoAfnyVXyAQBnYDxRESiWcj
        QbSZqKCZ3UOBaAr10KP8hGSQNW1hsnyBeMzST80jrw==
X-Google-Smtp-Source: ABdhPJwJCHEhkfRixrBxYgOGpD7RdsD3ZKvjUm5DFxPapq4Yvpmp/pbEgQOedan6gckCg3m09xuOjp3Q54/Pu62awLo=
X-Received: by 2002:a02:a0c2:: with SMTP id i2mr221750jah.92.1601972742395;
 Tue, 06 Oct 2020 01:25:42 -0700 (PDT)
MIME-Version: 1.0
References: <20201005142109.796046410@linuxfoundation.org> <CA+G9fYvHOu8kJhRKV5GPJmnaE_x2mrnN6myb4G4YHHW-oiKD7A@mail.gmail.com>
In-Reply-To: <CA+G9fYvHOu8kJhRKV5GPJmnaE_x2mrnN6myb4G4YHHW-oiKD7A@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 6 Oct 2020 13:55:30 +0530
Message-ID: <CA+G9fYu5zw8=Dbm79TW6qhbu-BPYbnxTh976Kv1riUQCkv7ZNg@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/57] 5.4.70-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 6 Oct 2020 at 11:24, Naresh Kamboju <naresh.kamboju@linaro.org> wro=
te:
>
> On Mon, 5 Oct 2020 at 20:59, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.70 release.
> > There are 57 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 07 Oct 2020 14:20:55 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patc=
h-5.4.70-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
>
> Results from Linaro=E2=80=99s test farm.
> No regressions on arm64, arm, x86_64, and i386.
>
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>


NOTE:
While running LTP containers test suite,
I noticed this kernel panic on arm64 Juno-r2 devices.
Not easily reproducible and not seen on any other arm64 devices.

steps to reproduce:
---------------------------
# boot stable rc 5.4.70 kernel on juno-r2 machine
# cd /opt/ltp
# ./runltp -f containers

Crash log,
---------------
pidns13     0  TINFO  :  cinit2: writing some data in pipe
pidns13     0  TINFO  :  cinit1: setup handler for async I/O on pipe
pidns13     1  TPASS  :  cinit1: si_fd is 6, si_code is 1
[  122.275627] Internal error: synchronous external abort: 96000210
[#1] PREEMPT SMP
[  122.283139] Modules linked in: tda998x drm_kms_helper drm crct10dif_ce f=
use
[  122.290130] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.4.70-rc1 #1
[  122.296406] Hardware name: ARM Juno development board (r2) (DT)
[  122.302337] pstate: 80000085 (Nzcv daIf -PAN -UAO)
[  122.307144] pc : sil24_interrupt+0x28/0x5f0
[  122.311337] lr : __handle_irq_event_percpu+0x78/0x2c0
[  122.316395] sp : ffff800010003db0
[  122.319712] x29: ffff800010003db0 x28: ffff800011f73d80
[  122.325034] x27: ffff800011962018 x26: ffff000954a82000
[  122.330357] x25: ffff800011962018 x24: ffff800011f6a158
[  122.335679] x23: ffff800010003ef4 x22: ffff000975740000
[  122.341001] x21: 0000000000000033 x20: ffff80001233d044
[  122.346324] x19: ffff000975742500 x18: 0000000000000000
[  122.351646] x17: 0000000000000000 x16: 0000000000000000
[  122.356967] x15: 0000000000000000 x14: 003d090000000000
[  122.362290] x13: 00003d0900000000 x12: 0000000000000000
[  122.367612] x11: 00003d0900000000 x10: 0000000000000040
[  122.372934] x9 : ffff800011f89b68 x8 : ffff800011f89b60
[  122.378256] x7 : ffff000975800408 x6 : 0000000000000000
[  122.383578] x5 : ffff000975800248 x4 : ffff80096d5ba000
[  122.388900] x3 : ffff800010003f30 x2 : ffff80001093a078
[  122.394222] x1 : ffff000975740000 x0 : ffff00097574df80
[  122.399545] Call trace:
[  122.401995]  sil24_interrupt+0x28/0x5f0
[  122.405838]  __handle_irq_event_percpu+0x78/0x2c0
[  122.410550]  handle_irq_event_percpu+0x3c/0x98
[  122.415002]  handle_irq_event+0x4c/0xe8
[  122.418844]  handle_fasteoi_irq+0xbc/0x168
[  122.422947]  generic_handle_irq+0x34/0x50
[  122.426963]  __handle_domain_irq+0x6c/0xc0
[  122.431066]  gic_handle_irq+0x58/0xb0
[  122.434733]  el1_irq+0xbc/0x180
[  122.437880]  cpuidle_enter_state+0xb8/0x528
[  122.442070]  cpuidle_enter+0x3c/0x50
[  122.445652]  call_cpuidle+0x40/0x78
[  122.449146]  do_idle+0x1f0/0x2a0
[  122.452379]  cpu_startup_entry+0x2c/0x88
[  122.456311]  rest_init+0xdc/0xe8
[  122.459545]  arch_call_rest_init+0x14/0x1c
[  122.463647]  start_kernel+0x484/0x4b8
[  122.467321] Code: d503201f f9400ac0 f9400014 91011294 (b9400294)
[  122.473437] ---[ end trace 68b3da9e48a77548 ]---
[  122.478062] Kernel panic - not syncing: Fatal exception in interrupt
[  122.484429] SMP: stopping secondary CPUs
[  122.488569] Kernel Offset: disabled
[  122.492062] CPU features: 0x0002,24006004
[  122.496074] Memory Limit: none
[  122.499141] ---[ end Kernel panic - not syncing: Fatal exception in
interrupt ]---

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>


Full test log,
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.6=
9-58-g7b199c4db17f/testrun/3273934/suite/linux-log-parser/test/check-kernel=
-panic-1818664/log

- Naresh
