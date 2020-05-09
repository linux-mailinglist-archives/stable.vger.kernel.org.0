Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63BD81CC0E7
	for <lists+stable@lfdr.de>; Sat,  9 May 2020 13:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgEILYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 May 2020 07:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727980AbgEILYp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 May 2020 07:24:45 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CEEC05BD09
        for <stable@vger.kernel.org>; Sat,  9 May 2020 04:24:44 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id o14so3340097ljp.4
        for <stable@vger.kernel.org>; Sat, 09 May 2020 04:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XrZ6yzJzFrQAo3XwetTdvxry4kQheIkMQpc43qZ5l9E=;
        b=KGJH8eX9FLDmEULeDenPcadJBFUf8wA0SROxLLl4LUFdm+rLIC3MTYVlELf2PE+AYX
         KRlcjh7+4ey+B4PzZckiZ9rUm/1Gf4IBSdLFOcVgzxuQau0CLMPX63X5tQmfBIogr8WK
         KVDXhFxqW5mG0EaWkIHaSbpiyN3b6dwbJ1vitz7wEDLKUkcUB//A2o8gJ2nNBarTh1ez
         r1kBkAo8U+TQtnBMn8/gfGC8eLYgP9DY/pPdKv7nHgSsolcAhgsfKzhIqaGTxKsRAWlb
         cdSuQs1QidTOC/xJ6FXw+XGSj/NF2dtp0clE0jrVkBERFoQaC+cD8XcSt+q/V+TF3T3s
         NvbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XrZ6yzJzFrQAo3XwetTdvxry4kQheIkMQpc43qZ5l9E=;
        b=OphUoo6rpVnqtNGuQ83dP3Jq4P6I3z/vH72s/YJKDTX1CSkdfiEeJca46JXF+cCAsx
         XcavFLSGJxUV2p7CtfPZf7fh6yJ3HHvqxVHUJu5aoKLbLL8dU1g3cHVRmPbR0j1DKa8y
         8kSNyJT1SA8tAgmtV4GNVlFUaShE5tKvSBThalWr20qJUwqvU8ok6j/Hy5DMzZz+d82O
         ivzVqAMVD5oBt5ohGNyCSgkYGNe2vTdYhKqg32F1U5TIGBMUYYNzfMkj2d62cFgLqTvo
         WSBq6VCkqNNXTeu1NHcUZUps3A2NFx8MZntdWsiY/XcvFZmMwqZcES5A7opjk1HJPiNt
         8Wlg==
X-Gm-Message-State: AOAM530vWzhgkUn0V58Pe7PaAI9s/cDWIGcvzO6dgMXBoUN6k5DNnBOy
        JGAD6u5UcprEtBOQkGvRhU4cbzsd1mXTWgWb3id3Gg==
X-Google-Smtp-Source: ABdhPJwjyUsmh9PSyKEcdeNU2xxttnfR+/XMyh1Dw0JYaat74zrf7oHzel1x85hsq0ED9aqevF4vySEay0kZcLKo4/k=
X-Received: by 2002:a2e:80da:: with SMTP id r26mr4434397ljg.38.1589023482886;
 Sat, 09 May 2020 04:24:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200508142854.087405740@linuxfoundation.org> <ada628d9-fd10-acd4-94fe-cdcf1caf43fc@roeck-us.net>
 <20200509065226.GA1765287@kroah.com>
In-Reply-To: <20200509065226.GA1765287@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 9 May 2020 16:54:30 +0530
Message-ID: <CA+G9fYt7JXrXiTyt+DkvM6boVyRQSCPp_90n5JkUNgaXJiBcZw@mail.gmail.com>
Subject: Re: [PATCH 4.4 000/308] 4.4.223-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 9 May 2020 at 12:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Fri, May 08, 2020 at 02:10:40PM -0700, Guenter Roeck wrote:
> > On 5/8/20 7:32 AM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 4.4.223 release.
> > > There are 308 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sun, 10 May 2020 14:26:28 +0000.
> > > Anything received after that time might be too late.
> > >
> >
> > Build results:
> >       total: 169 pass: 156 fail: 13
> > Failed builds:
> >       <all mips>
> > Qemu test results:
> >       total: 332 pass: 272 fail: 60
> > Failed tests:
> >       arm:mcimx6ul-evk:imx_v6_v7_defconfig:nodrm:mem256:imx6ul-14x14-evk:initrd
> >       arm:mcimx6ul-evk:imx_v6_v7_defconfig:nodrm:sd:mem256:imx6ul-14x14-evk:rootfs
> >       arm:mcimx6ul-evk:imx_v6_v7_defconfig:nodrm:usb1:mem256:imx6ul-14x14-evk:rootfs
> >       <all mips>
> >
> > Bisecting the arm boot failure points to commit 9b86858f37d682 ("regulator:
> > Try to resolve regulators supplies on registration"). Reverting this commit fixes
> > the problem.
>
> Thank you for saving me having to do the bisection.
>
> I've dropped both of these and now pushed out a -rc3.

rc3 looks good on arm architecture.

FYI,
On the rc2 the boot failure was noticed as below crash dump on arm
---

[  240.261355] INFO: task swapper/0:1 blocked for more than 120 seconds.
[  240.267836]       Not tainted 4.4.223-rc2-00309-g1a571d63aabc #1
[  240.273876] \"echo 0 > /proc/sys/kernel/hung_task_timeout_secs\"
disables this message.
[  240.281749] swapper/0       D c0a9cf00     0     1      0 0x00000000
[  240.288175] [<c0a9cf00>] (__schedule) from [<c0a9d2e0>] (schedule+0x44/0x9c)
[  240.295272] [<c0a9d2e0>] (schedule) from [<c0a9fc60>]
(schedule_timeout+0x164/0x1ac)
[  240.303066] [<c0a9fc60>] (schedule_timeout) from [<c0a9ddb0>]
(wait_for_common+0xa8/0x158)
[  240.311383] [<c0a9ddb0>] (wait_for_common) from [<c025f074>]
(flush_workqueue+0xf0/0x58c)
[  240.319613] [<c025f074>] (flush_workqueue) from [<c06cfe80>]
(deferred_probe_initcall+0x60/0x88)
[  240.328454] [<c06cfe80>] (deferred_probe_initcall) from
[<c020ac8c>] (do_one_initcall+0x90/0x1dc)
[  240.337383] [<c020ac8c>] (do_one_initcall) from [<c0edfdf0>]
(kernel_init_freeable+0x150/0x1e0)
[  240.346135] [<c0edfdf0>] (kernel_init_freeable) from [<c0a9c4a4>]
(kernel_init+0x8/0xe4)
[  240.354275] [<c0a9c4a4>] (kernel_init) from [<c0210a40>]
(ret_from_fork+0x14/0x34)
[  240.361891] INFO: task kworker/u4:1:126 blocked for more than 120 seconds.
[  240.368803]       Not tainted 4.4.223-rc2-00309-g1a571d63aabc #1
[  240.374842] \"echo 0 > /proc/sys/kernel/hung_task_timeout_secs\"
disables this message.
[  240.382711] kworker/u4:1    D c0a9cf00     0   126      2 0x00000000
[  240.389122] Workqueue: deferwq deferred_probe_work_func
[  240.394394] [<c0a9cf00>] (__schedule) from [<c0a9d2e0>] (schedule+0x44/0x9c)
[  240.401489] [<c0a9d2e0>] (schedule) from [<c0a9d640>]
(schedule_preempt_disabled+0xc/0x10)
[  240.409803] [<c0a9d640>] (schedule_preempt_disabled) from
[<c0a9e9f4>] (__mutex_lock_slowpath+0x9c/0x150)
[  240.419426] [<c0a9e9f4>] (__mutex_lock_slowpath) from [<c0a9eaf0>]
(mutex_lock+0x48/0x4c)
[  240.427654] [<c0a9eaf0>] (mutex_lock) from [<c05f11a4>]
(regulator_dev_lookup+0xe0/0x194)
[  240.435884] [<c05f11a4>] (regulator_dev_lookup) from [<c05f519c>]
(regulator_resolve_supply+0x40/0x218)
[  240.445332] [<c05f519c>] (regulator_resolve_supply) from
[<c05f5200>] (regulator_resolve_supply+0xa4/0x218)
[  240.455130] [<c05f5200>] (regulator_resolve_supply) from
[<c06d1454>] (class_for_each_device+0x4c/0xb4)
[  240.464577] [<c06d1454>] (class_for_each_device) from [<c05f4468>]
(regulator_register+0x7fc/0xea8)
[  240.473676] [<c05f4468>] (regulator_register) from [<c05f64b8>]
(devm_regulator_register+0x44/0x74)
[  240.482775] [<c05f64b8>] (devm_regulator_register) from
[<c05fdd90>] (palmas_ldo_registration+0x130/0x3fc)
[  240.492485] [<c05fdd90>] (palmas_ldo_registration) from
[<c05febf0>] (palmas_regulators_probe+0x398/0x438)
[  240.502195] [<c05febf0>] (palmas_regulators_probe) from
[<c06d1b8c>] (platform_drv_probe+0x50/0xac)
[  240.511295] [<c06d1b8c>] (platform_drv_probe) from [<c06d03dc>]
(driver_probe_device+0x1a4/0x2dc)
[  240.520227] [<c06d03dc>] (driver_probe_device) from [<c06ce994>]
(bus_for_each_drv+0x70/0x94)
[  240.528808] [<c06ce994>] (bus_for_each_drv) from [<c06d01ac>]
(__device_attach+0xb4/0x118)
[  240.537126] [<c06d01ac>] (__device_attach) from [<c06cf768>]
(bus_probe_device+0x84/0x8c)
[  240.545351] [<c06cf768>] (bus_probe_device) from [<c06cda7c>]
(device_add+0x3c0/0x5ac)
[  240.553322] [<c06cda7c>] (device_add) from [<c0936048>]
(of_platform_device_create_pdata+0x84/0xb4)
[  240.562426] [<c0936048>] (of_platform_device_create_pdata) from
[<c0936154>] (of_platform_bus_create+0xd0/0x2f0)
[  240.572661] [<c0936154>] (of_platform_bus_create) from [<c09364a8>]
(of_platform_populate+0x5c/0xb0)
[  240.581851] [<c09364a8>] (of_platform_populate) from [<c0706d8c>]
(palmas_i2c_probe+0x2d8/0x574)
[  240.590691] [<c0706d8c>] (palmas_i2c_probe) from [<c0898a1c>]
(i2c_device_probe+0x16c/0x204)
[  240.599184] [<c0898a1c>] (i2c_device_probe) from [<c06d03dc>]
(driver_probe_device+0x1a4/0x2dc)
[  240.607932] [<c06d03dc>] (driver_probe_device) from [<c06ce994>]
(bus_for_each_drv+0x70/0x94)
[  240.616510] [<c06ce994>] (bus_for_each_drv) from [<c06d01ac>]
(__device_attach+0xb4/0x118)
[  240.624825] [<c06d01ac>] (__device_attach) from [<c06cf768>]
(bus_probe_device+0x84/0x8c)
[  240.633050] [<c06cf768>] (bus_probe_device) from [<c06cda7c>]
(device_add+0x3c0/0x5ac)
[  240.641017] [<c06cda7c>] (device_add) from [<c089a864>]
(i2c_new_device+0x118/0x194)
[  240.648812] [<c089a864>] (i2c_new_device) from [<c089addc>]
(i2c_register_adapter+0x214/0x4a8)
[  240.657481] [<c089addc>] (i2c_register_adapter) from [<c08a3ac4>]
(omap_i2c_probe+0x43c/0x684)
[  240.666148] [<c08a3ac4>] (omap_i2c_probe) from [<c06d1b8c>]
(platform_drv_probe+0x50/0xac)
[  240.674462] [<c06d1b8c>] (platform_drv_probe) from [<c06d03dc>]
(driver_probe_device+0x1a4/0x2dc)
[  240.683387] [<c06d03dc>] (driver_probe_device) from [<c06ce994>]
(bus_for_each_drv+0x70/0x94)
[  240.691964] [<c06ce994>] (bus_for_each_drv) from [<c06d01ac>]
(__device_attach+0xb4/0x118)
[  240.700276] [<c06d01ac>] (__device_attach) from [<c06cf768>]
(bus_probe_device+0x84/0x8c)
[  240.708505] [<c06cf768>] (bus_probe_device) from [<c06cfb8c>]
(deferred_probe_work_func+0x64/0x90)
[  240.717518] [<c06cfb8c>] (deferred_probe_work_func) from
[<c02605b8>] (process_one_work+0x1b0/0x3c8)
[  240.726705] [<c02605b8>] (process_one_work) from [<c0261470>]
(worker_thread+0x50/0x548)
[  240.734848] [<c0261470>] (worker_thread) from [<c026620c>]
(kthread+0x108/0x110)
[  240.742293] [<c026620c>] (kthread) from [<c0210a40>]
(ret_from_fork+0x14/0x34)

test full log link,
https://lkft.validation.linaro.org/scheduler/job/1422610#L3316

- Naresh
