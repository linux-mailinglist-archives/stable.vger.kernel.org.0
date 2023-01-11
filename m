Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93BC9665787
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 10:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233903AbjAKJeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 04:34:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238633AbjAKJdl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 04:33:41 -0500
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0457B202D
        for <stable@vger.kernel.org>; Wed, 11 Jan 2023 01:31:52 -0800 (PST)
Received: by mail-ua1-x932.google.com with SMTP id t8so3525427uaj.5
        for <stable@vger.kernel.org>; Wed, 11 Jan 2023 01:31:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XTP2rUiYwe1rmS+ZXiHAVTpmRxymjf33zMdbnWtxm3c=;
        b=fOHPgZdqla9+x7CVSnI7vnlUCToKGmBGmds6ENRwAm2xT2AHTvoMP1OUt5Xn/eJhF5
         Ydy/xVJHajj13gEgWSzKJIQxaFmC9OlM9FFdPleXSvBz5hSnDjk4iMhGg6jZZotnkQzY
         SH8IAQML+rLYNh54U/lwDcN38VRsleFZbEgy6m0U0g1yCOpVTH+CzPD8Q8PLP6GeKInL
         Q/SiLU6QhLNX0lZegJAi9TdUNRqF+QHmyEPapLnI9pmFq2DnFmtLi+ILd/LrFgBK3c+E
         JupzXC8bpbMPm48CJuF2FD2+HvYu6tu38r4lGitG8EKfz+75NMYU9Q3C0O5YRVkzNNCZ
         uiBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XTP2rUiYwe1rmS+ZXiHAVTpmRxymjf33zMdbnWtxm3c=;
        b=QUaAegsiKtU5hbBTWZZNd14OEO9AzSb+UIKUiTKT8Z5mjWNT8Wa1uUogRW3Rny1dwY
         fua5iY7v0F6w4fcN/3kDwdAoGscPfHn/jx+MMp9lQog22IZGYphqWXBotqU/uHZxIk3Z
         9R0ONA2MPgbfYvZhIQIYYEQqx+CCSabs9Nwla3k03n7Pdxcc0mYJNpTd909EuIu7/XNt
         QALmx1MhyDvzMaKyL0DNbX0Wt+AN5yhGyfLNNorPfICFT8Tt7FxdThvQFNPiRXB0hXD5
         IeYue3Bc9poqWH4HOmico1BfSPmnm7EI+GCZ5IpWn8tfuysnACTxsHMFWxZuGZQ+lldv
         zkvQ==
X-Gm-Message-State: AFqh2koQP2SwvgLe+PNFzESCHte3iW6oO7DKWtBOns8WCq3x7GopfXB/
        EeYyvMhXw2+g4A8vvGc7UvWeIYWZgfc9hMH3MkDwlA==
X-Google-Smtp-Source: AMrXdXvZXdBKR84rzG5TSzValtRxUvWzUkSKmNsG1h7eUfcQ6Yudzd07vISazX9RrBM//6p78kRPsu14axTlQvJZkeY=
X-Received: by 2002:ab0:3102:0:b0:5a4:c264:fb05 with SMTP id
 e2-20020ab03102000000b005a4c264fb05mr4306720ual.22.1673429510872; Wed, 11 Jan
 2023 01:31:50 -0800 (PST)
MIME-Version: 1.0
References: <20230110180017.145591678@linuxfoundation.org> <CA+G9fYtpM7X15rY6g6asDxrjxDSfj5sDiP8P5Yb1TS3VVmjGNw@mail.gmail.com>
 <bd62bccb-6970-4cdb-ae23-792b5867705d@app.fastmail.com>
In-Reply-To: <bd62bccb-6970-4cdb-ae23-792b5867705d@app.fastmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 11 Jan 2023 15:01:39 +0530
Message-ID: <CA+G9fYsChy=HzEwkBVydPW4gJhDjkB87dY9FA833H2tZLfSh-w@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/148] 6.0.19-rc1 review
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 11 Jan 2023 at 13:48, Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Wed, Jan 11, 2023, at 07:16, Naresh Kamboju wrote:
> > On Tue, 10 Jan 2023 at 23:36, Greg Kroah-Hartman <gregkh@linuxfoundatio=
n.org> wrote:
> >>
> >
> > Results from Linaro=E2=80=99s test farm.
> > Regressions on arm64 Raspberry Pi 4 Model B.
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > While running LTP controllers cgroup_fj_stress_blkio test cases
> > the Insufficient stack space to handle exception! occurred and
> > followed by kernel panic on arm64 Raspberry Pi 4 Model B with
> > clang-15 built kernel Image.
> >
> > The full boot and test log attached to this email and build and
> > Kconfig links provided in the bottom of this email.
> >
> > I will try to reproduce this reported issue and get back to you.
>
> I looked at the log between 6.0.18 and 6.0.19-rc1, but don't see
> any arm64 or memory management patches that could result in this.
> Do you know if 6.0.18 ran successful

Yes, it ran successfully on 6.0.18.

On the same kernel 6.0.19-rc1 built with gcc-12 did not find this panic.
The reported issue is specific to clang-15 build.

> > [ 2893.044339] Insufficient stack space to handle exception!
> > [ 2893.044351] ESR: 0x0000000096000047 -- DABT (current EL)
> > [ 2893.044360] FAR: 0xffff8000128180d0
> > [ 2893.044364] Task stack:     [0xffff800012a18000..0xffff800012a1c000]
> > [ 2893.044370] IRQ stack:      [0xffff80000a798000..0xffff80000a79c000]
> > [ 2893.044375] Overflow stack: [0xffff0000f77c4310..0xffff0000f77c5310]
> ...
> > [ 2893.044413] pc : el1h_64_sync+0x0/0x68
> > [ 2893.044430] lr : wp_page_copy+0xf8/0x90c
> > [ 2893.044445] sp : ffff8000128180d0
> ...
> > [ 2893.044692]  el1h_64_sync+0x0/0x68
> > [ 2893.044700]  do_wp_page+0x4a0/0x5c8
> > [ 2893.044708]  handle_mm_fault+0x7fc/0x14dc
> > [ 2893.044718]  do_page_fault+0x29c/0x450
> > [ 2893.044727]  do_mem_abort+0x4c/0xf8
> > [ 2893.044741]  el0_da+0x48/0xa8
> > [ 2893.044750]  el0t_64_sync_handler+0xcc/0xf0
> > [ 2893.044759]  el0t_64_sync+0x18c/0x190
>
> It claims that the stack overflow happened in do_wp_page(),
> but that has a really short call chain. It would be good
> to have the source line for do_wp_page+0x4a0/0x5c8 and
> wp_page_copy+0xf8/0x90c to see where exactly it was.
>
>
> > [ 2893.285975] WARNING: CPU: 2 PID: 315758 at kernel/sched/core.c:3119
> > set_task_cpu+0x14c/0x208
> ....
> > [ 2893.286117] CPU: 2 PID: 315758 Comm: cgroup_fj_stres Not tainted
> > [ 2893.286416]  arch_timer_handler_phys+0x44/0x54
> > [ 2893.286427]  handle_percpu_devid_irq+0x90/0x220
> > [ 2893.286439]  generic_handle_domain_irq+0x38/0x50
> > [ 2893.286447]  gic_handle_irq+0x68/0xe8
> > [ 2893.286455]  el1_interrupt+0x88/0xc8
> > [ 2893.286464]  el1h_64_irq_handler+0x18/0x24
> > [ 2893.286474]  el1h_64_irq+0x64/0x68
> > [ 2893.286482]  panic+0x2d8/0x374
>
> This is apparently a second unrelated bug -- it still processes timer
> interrupts after calling panic() and this apparently fails because
> the system is already unusable.
>
> >   artifact-location:
> > https://storage.tuxsuite.com/public/linaro/lkft/builds/2K9JDtix2mHMoYRj=
NkBef3oR5JT
>

Adding " / " at end works.
https://storage.tuxsuite.com/public/linaro/lkft/builds/2K9JDtix2mHMoYRjNkBe=
f3oR5JT/

> file not found. I tried to get the vmlinux file to look at the disassembl=
y
> but the artifacts appear to be gone already.

System.map:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2K9JDtix2mHMoYRjNkBe=
f3oR5JT/System.map

vmlinux:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2K9JDtix2mHMoYRjNkBe=
f3oR5JT/vmlinux.xz

Sorry for the trouble.

- Naresh

>
>      Arnd
