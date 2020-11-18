Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0B22B826F
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 17:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgKRQ52 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 11:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbgKRQ51 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 11:57:27 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D2BC0613D6
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 08:57:27 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id w13so3702958eju.13
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 08:57:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q+vAmgbhUhID2bejoiR+0/7u4a1jtXsFIW6HxVMmr8A=;
        b=iZaUW8MT5xQy74L6uUoR2FwpX8lXivPOd6a9rdVhPjJHOyo93uLRsbar6dxive1ugX
         +eLsJLqtuIDKabE8vYQFTpVeVXRLvmmZRFvw2kGF2NGp+2CIS1pOKiLTN6EWHPZ1Mjmb
         UDP1E1FnMe3JzNIV3Bv9dr8PTu+RsXQ87sAQcztN7BinBRERrhz4IV5YuZtGES9E0b0o
         321eejdpTiBRvHG+QBaT1FNTXBID/QMJ4lSqCF5wjI+1n1Um/L12ixk/4v34kpofRpGK
         Cf6SKc9z9QllPicy2QtIpDBEFgt/rV0r01sWqNR8XLSpRb86szqVr8zcQXAcWwZ+uvOf
         B1TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q+vAmgbhUhID2bejoiR+0/7u4a1jtXsFIW6HxVMmr8A=;
        b=ib7vFa7Xx3eiZD6vz1MEk6nrojPSud5L/9xiJUjJb+v+XHWThDQ8G6kzhs5itEsXtE
         pINfTsW0dfYjMcQQz1RCjyFQ9aACkyneeS14lImei9Xhh/labfzVHUR6RekXZeNm3qwG
         QqxE8wV+DCwaV+qZYq1YL+9pnSX4G1cdftRMGVjSrjkdKzqly9+bdG44oayIL8RctMia
         hknn1wBe1yZZGgFBXoQpRqqEIc7wmE46S/crh3xAb0HLXSKbm9aLwMK+OMm4lxo3Imza
         kTQy8tLHI1ENOb7TGR9XKX8enlcpQGgFufsWCCVdTbvE8h0gI3cUWZyVPt7IIfmxHavZ
         ozvw==
X-Gm-Message-State: AOAM531eazw2AZi2LZBWBtdQEbx/Dps0d6giKc1PyH/svkLtDhLFtb+w
        QSZHJsE/hPDmTY5C1l9NfX1DIdlkLTs/hraZU6BLNQ==
X-Google-Smtp-Source: ABdhPJxJoP3L5WNu3Z7jlfY3e3j46TddEIxW9w2f2ym2HmJuwWmtEmvsNOXCCl52DhbMKKaexvDcOPLp2IyiMadNmlM=
X-Received: by 2002:a17:906:5fd0:: with SMTP id k16mr25467183ejv.133.1605718645682;
 Wed, 18 Nov 2020 08:57:25 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYtwycbC+Hf9aP5Br8wq7cKWVqjhcGusn2DbJaNauGC3Og@mail.gmail.com>
 <CA+G9fYsfEVK86ask=fL=M5juerbz+BwbFGcAZ_UxWrPHXYpA1Q@mail.gmail.com> <0256a0a0139c56db75cffa4fe14079ad@kernel.org>
In-Reply-To: <0256a0a0139c56db75cffa4fe14079ad@kernel.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 18 Nov 2020 22:27:13 +0530
Message-ID: <CA+G9fYvBtp-qh07yBMxEyPY4DXfp_vSC8ox0gkcEeFjsmOWSKg@mail.gmail.com>
Subject: Re: WARNING: kernel/irq/chip.c:242 __irq_startup+0xa8/0xb0
To:     Marc Zyngier <maz@kernel.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 18 Nov 2020 at 14:38, Marc Zyngier <maz@kernel.org> wrote:
>
> Naresh,
>
> On 2020-11-18 06:11, Naresh Kamboju wrote:
> > On Tue, 13 Oct 2020 at 11:09, Naresh Kamboju
> > <naresh.kamboju@linaro.org> wrote:
> >>
> >> On stable rc  5.8.15 the following kernel warning was noticed once
> >> while boot and this is hard to reproduce.
> >
> > This is now reproduciable on arm64 NXP ls2088 device
>
> How reproducible? On demand? Once in a while?

Once in a while.

>
> >
> > [   19.980839] ------------[ cut here ]------------
> > [   19.985468] WARNING: CPU: 1 PID: 441 at kernel/irq/chip.c:242
> > __irq_startup+0x9c/0xa8
> > [   19.985472] Modules linked in: rfkill lm90 ina2xx crct10dif_ce
> > qoriq_thermal fuse
> > [   20.000773] CPU: 1 PID: 441 Comm: (agetty) Not tainted 5.4.78-rc1 #2
>
> Can you please try and reproduce this on mainline?

yes on mainline kernel.

[   18.284440] ------------[ cut here ]------------
[   18.289063] WARNING: CPU: 3 PID: 441 at kernel/irq/chip.c:242
__irq_startup+0xa8/0xb0
[   18.296891] Modules linked in: rfkill caam crct10dif_ce error lm90
ina2xx qoriq_thermal fuse
[   18.296914] CPU: 3 PID: 441 Comm: (agetty) Not tainted 5.10.0-rc3 #2
[   18.311693] Hardware name: Freescale Layerscape 2088A RDB Board (DT)
[   18.311697] pstate: 60000085 (nZCv daIf -PAN -UAO -TCO BTYPE=--)
[   18.311700] pc : __irq_startup+0xa8/0xb0
[   18.311702] lr : irq_startup+0x64/0x140
[   18.311708] sp : ffff800011b2f8f0
[   18.335095] x29: ffff800011b2f8f0 x28: ffff724881a03800
[   18.335100] x27: ffffa9adf65ff200 x26: 0000000000020902
[   18.335104] x25: ffffa9adf522bb40 x24: ffffa9adf522b7f8
[   18.351023] x23: 0000000000000000 x22: 0000000000000001
[   18.351027] x21: 0000000000000001 x20: ffff724883dbc940
[   18.351030] x19: ffff7248812a0800 x18: 0000000000000010
[   18.351035] x17: 0000000000000000 x16: 0000000000000000
[   18.366952] x15: ffff724883dbcdc0 x14: ffffffffffffffff
[   18.366956] x13: ffff800011de0000 x12: ffff800011de0000
[   18.366959] x11: 0000000000000040 x10: ffffa9adf63c64e0
[   18.388178] x9 : ffffa9adf3f90c3c x8 : ffff7248a0000270
[   18.388181] x7 : 0000000000000000 x6 : ffffa9adf6334aa8
[   18.388185] x5 : ffffa9adf6334000 x4 : 0000000000000504
[   18.388189] x3 : ffff7248812a0800 x2 : 0000000013032004
[   18.404106] x1 : 0000000013032004 x0 : ffff7248812a0860
[   18.404111] Call trace:
[   18.404114]  __irq_startup+0xa8/0xb0
[   18.404116]  irq_startup+0x64/0x140
[   18.404123]  __enable_irq+0x78/0x88
[   18.427685]  enable_irq+0x54/0xa8
[   18.427689]  serial8250_do_startup+0x670/0x718
[   18.427692]  serial8250_startup+0x30/0x40
[   18.427696]  uart_startup.part.0+0x12c/0x2e0
[   18.427701]  uart_port_activate+0x68/0xa0
[   18.447701]  tty_port_open+0x98/0x250
[   18.447704]  uart_open+0x24/0x38
[   18.447707]  tty_open+0x120/0x518
[   18.447712]  chrdev_open+0xac/0x1a8
[   18.447718]  do_dentry_open+0x134/0x3a0
[   18.465200]  vfs_open+0x34/0x40
[   18.465203]  path_openat+0x85c/0xde0
[   18.465207]  do_filp_open+0x80/0x108
[   18.465209]  do_sys_openat2+0x1ec/0x2a0
[   18.465215]  do_sys_open+0x60/0xa8
[   18.482695]  __arm64_sys_openat+0x2c/0x38
[   18.482699]  do_el0_svc+0xe0/0x210
[   18.482702]  el0_sync_handler+0x180/0x18c
[   18.482705]  el0_sync+0x174/0x180
[   18.482710] ---[ end trace 12c4809389e4277f ]---

>
> Looking at the DT:
>
>                  serial0: serial@21c0500 {
>                          interrupts = <0 32 0x4>; /* Level high type */
>
>                  serial1: serial@21c0600 {
>                          interrupts = <0 32 0x4>; /* Level high type */
>
>                  serial2: serial@21d0500 {
>                          interrupts = <0 33 0x4>; /* Level high type */
>
>                  serial3: serial@21d0600 {
>                          interrupts = <0 33 0x4>; /* Level high type */
>
>
> The UART interrupt lines are shared. Braindead, 1980 style.
>
> Which UART is agetty trying to use? Is there any other process using
> another UART concurrently? We could have a race between the line being
> shut down on one device, and activated from the other, but I can't
> spot it right away.

From the boot log,

  Created slice system-getty.slice.
  Created slice system-serial\x2dgetty.slice.
<>
  Found device /dev/ttyS0.
  Found device /dev/ttyS1.
<>
  Started Getty on tty1.
  Started Serial Getty on ttyS1.
  Started Serial Getty on ttyS0.
  Started Authorization Manager.

And the warning triggered.

>
> If you can reproduce it easily enough, it shouldn't be too hard to trace
> what happens around the activation of the shared interrupt (assuming
> that
> this is where the problem is).

We do not find easy steps to reproduce it.
This warning was noticed while booting once in 20 runs.

ref:
https://qa-reports.linaro.org/lkft/linux-mainline-master/build/v5.10-rc3-391-g9cfd9c45994b/testrun/3443291/suite/linux-log-parser/test/check-kernel-warning-138789/log

- Naresh
