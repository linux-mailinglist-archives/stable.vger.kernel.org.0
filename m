Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 854631FA8B0
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 08:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgFPGPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 02:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbgFPGPb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 02:15:31 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BAC2C05BD43
        for <stable@vger.kernel.org>; Mon, 15 Jun 2020 23:15:31 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id y13so191848lfe.9
        for <stable@vger.kernel.org>; Mon, 15 Jun 2020 23:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FulxESwzgytmO4+1WzTW2Qkldo1w2AaQNhNmTLqMC7A=;
        b=V/CPm089ah4owxKe+jQ8SuVcSaSwkjvtPBSx/q7zb3feo0/0EMHD08/13yolhfRE6h
         AoWGZI1s/84uYJcKjo5POwubyLylA0k9F4RfJc3MEJbVeW8gD4SCbvwrK6mr169UqXf9
         1uWPJCy/LN8Jm8yuiIu+lgcSkQl5rQvvgPuTgiTwjDQfK3bRgDBMSBGHUmZQTufVyvct
         iJGhv4wv3i8Iu9o9+rfvELkVsz2Vel8JZq2Sh9fiNjoDbKhmf5gm1V42o50/yGM2EQg7
         MhCOZ9HYI9vtZsdRnrQHmSTpSAblKBHb2dbGJFt+b1rRbJGdD18eeSBFxCGnUxEpOdQG
         iGdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FulxESwzgytmO4+1WzTW2Qkldo1w2AaQNhNmTLqMC7A=;
        b=dy9whiaJC/g3iMNhVARpvwYSO8pXS4GFKVGlzKlGCbYZInfDqyYMk4wV3EdliQrtfF
         AEnbcIsv+drAdh319fzHFLZA/Aia3nrgRQmG8RERtAaKvrARZOJbE5gqDPerEwkicACZ
         xjDl2fjugDe1/tL9rKD5MNw9toa8a1NXSBCdl+cIhNzCQRMXGQfARLAmj78P5XaYSptn
         obfIvelcVBEYrY3eNDNkRmOQlDS9QzGkNShriBIMRV9lA1zdVKriZyzGclOfl+EA0VTG
         vqOqrPeONd10Npor1JVTkC2BJszoNJ55uf8eBitXNs072paLT9QDqBM93LjEjleU/zDU
         YahA==
X-Gm-Message-State: AOAM532EgL7lz24hRCq8arsEt+rkGBPLSNDOOeIHgngJFbUx569BPr0Y
        XFrKeCumq4xFn3r9FtL2TRimXA/k2NLZw2UHHnmJs8AuhpnkjA==
X-Google-Smtp-Source: ABdhPJzzAXNtLx3L3RSUJs7+Tb5ebKM3+kioaY/6DBWV52vmql4FgLIKt18tlyYWFa33I7uHYlEbRJ6+66JCN2ttTwc=
X-Received: by 2002:a19:8453:: with SMTP id g80mr839444lfd.167.1592288129551;
 Mon, 15 Jun 2020 23:15:29 -0700 (PDT)
MIME-Version: 1.0
References: <159065034721114@kroah.com>
In-Reply-To: <159065034721114@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 16 Jun 2020 11:45:18 +0530
Message-ID: <CA+G9fYtSmkcCAeKVzUj3B5Yj3ZZw-wiMyQAMwqUOSyiPRB2Byg@mail.gmail.com>
Subject: Re: patch "serial: imx: Initialize lock for non-registered console"
 added to tty-next
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 28 May 2020 at 12:49, <gregkh@linuxfoundation.org> wrote:
>
>
> This is a note to let you know that I've just added the patch titled
>
>     serial: imx: Initialize lock for non-registered console
>
> to my tty git tree which can be found at
>     git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
> in the tty-next branch.
>
> The patch will show up in the next release of the linux-next tree
> (usually sometime within the next 24 hours during the week.)
>
> The patch will also be merged in the next major kernel release
> during the merge window.
>
> If you have any questions about this process, please let me know.
>
>
> From 8f065acec7573672dd15916e31d1e9b2e785566c Mon Sep 17 00:00:00 2001
> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Date: Mon, 25 May 2020 13:59:52 +0300
> Subject: serial: imx: Initialize lock for non-registered console
>
> The commit a3cb39d258ef
> ("serial: core: Allow detach and attach serial device for console")
> changed a bit logic behind lock initialization since for most of the console
> driver it's supposed to have lock already initialized even if console is not
> enabled. However, it's not the case for Freescale IMX console.
>
> Initialize lock explicitly in the ->probe().
>
> Note, there is still an open question should or shouldn't not this driver
> register console properly.
>
> Fixes: a3cb39d258ef ("serial: core: Allow detach and attach serial device for console")
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Link: https://lore.kernel.org/r/20200525105952.13744-1-andriy.shevchenko@linux.intel.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/tty/serial/imx.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
> index 986d902fb7fe..6b078e395931 100644
> --- a/drivers/tty/serial/imx.c
> +++ b/drivers/tty/serial/imx.c
> @@ -2404,6 +2404,9 @@ static int imx_uart_probe(struct platform_device *pdev)
>                 }
>         }
>
> +       /* We need to initialize lock even for non-registered console */
> +       spin_lock_init(&sport->port.lock);

On arm64 Hikey devices running stable-rc 5.7 branch kernel reported following
kernel INFO while booting.

[    2.059344] mmc2: new SDIO card at address 0001
[    2.105114] f7111000.uart: ttyAMA1 at MMIO 0xf7111000 (irq = 8,
base_baud = 0) is a PL011 rev2
[    2.105886] serial serial0: tty port ttyAMA1 registered
[    2.106843] f7112000.uart: ttyAMA2 at MMIO 0xf7112000 (irq = 9,
base_baud = 0) is a PL011 rev2
[    2.109759] f7113000.uart: ttyAMA3 at MMIO 0xf7113000 (irq = 10,
base_baud = 0) is a PL011 rev2
[    2.109916] INFO: trying to register non-static key.
[    2.109936] the code is fine but needs lockdep annotation.
[    2.109956] turning off the locking correctness validator.
[    2.109982] CPU: 2 PID: 57 Comm: kworker/2:1 Not tainted 5.7.3-rc1 #1
[    2.110004] Hardware name: HiKey Development Board (DT)
[    2.110040] Workqueue: events deferred_probe_work_func
[    2.110063] Call trace:
[    2.110082]  dump_backtrace+0x0/0x1e0
[    2.110100]  show_stack+0x24/0x30
[    2.110120]  dump_stack+0xe8/0x150
[    2.110140]  register_lock_class+0x640/0x680
[    2.110159]  __lock_acquire+0x7c/0x1728
[    2.110178]  lock_acquire+0xf8/0x458
[    2.110200]  _raw_spin_lock_irqsave+0x60/0x80
[    2.110221]  uart_add_one_port+0x3ac/0x4e8
[    2.110242]  pl011_register_port+0x70/0xd8
[    2.110262]  pl011_probe+0x154/0x1a0
[    2.110283]  amba_probe+0xcc/0x170
[    2.110301]  really_probe+0x290/0x498
[    2.110319]  driver_probe_device+0x12c/0x148
[    2.110339]  __device_attach_driver+0xa4/0x120
[    2.110359]  bus_for_each_drv+0x78/0xd8
[    2.110378]  __device_attach+0xe8/0x170
[    2.110397]  device_initial_probe+0x24/0x30
[    2.110416]  bus_probe_device+0xa0/0xa8
[    2.110435]  deferred_probe_work_func+0x94/0xf0
[    2.110458]  process_one_work+0x2b0/0x770
[    2.110477]  worker_thread+0x48/0x4a0
[    2.110496]  kthread+0x158/0x168
[    2.110515]  ret_from_fork+0x10/0x18
[    4.158216] printk: console [ttyAMA3] enabled
[    4.165009] 5V_HUB: supplied by SYS_5V

Please refer full test log,
https://lkft.validation.linaro.org/scheduler/job/1496830#L3764


metadata:
  git branch: linux-5.7.y
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git commit: f2c964aa9a1ce76f00767fd3fdcebf8e0db2b99e
  kernel-config:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/hikey/lkft/linux-stable-rc-5.7/6/config

--
Linaro LKFT
https://lkft.linaro.org
