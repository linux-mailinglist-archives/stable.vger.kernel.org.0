Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F5F31994E
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 05:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhBLErR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 23:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbhBLErE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 23:47:04 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB2FC061574
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 20:46:23 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id c6so9364584ede.0
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 20:46:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9+2yrPqX2PuOtJQUEK4jTbIiRslC1Fg3ZyV+1OHc848=;
        b=RKyIKnbvKOs02wQagQDLcw7ZyPj/rRl1baNQmo2q3O7ofpvR5z/20KgSJjIXuH09iZ
         5QYL0YL2PZFQ71p1YAR0tsJnuSnYqt9OgACRg7g7EK+HXwA1vschMMJCvq1P2pZI+GaY
         zV2XFRSNH+/OyEuOUb4hCCIDeKOsP8PBs/XS67mT4/01ckV9zzpEsmAEX/nbk55xuv5Y
         i9jMGuP6aPmTKilWKCFuulkwPmb+F01x+GntLPDkviI4PyYI8n7N9DzzoRG0xVMDhSEx
         RyO22bnInB8Hxw34sFVS7DJ/K69LrDXYAV9Ti96id7n6mHAVDkVpW7/cj3SG4vIj9ZbM
         zakg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9+2yrPqX2PuOtJQUEK4jTbIiRslC1Fg3ZyV+1OHc848=;
        b=jjIXsNh+uggdyheomnYmEdpUZjeBk6ZVXOWazIOjcQRJ21kMZGrZLP0I/QyE5uDJDe
         3K+6HS4yoTS2WVBehW+YEpZa+n3uWrdRihiHlAtcKb5HherIMJ2uO+kqVMAuk5tBRluX
         dbcFkQvcBJeXRdXHM9aPX1rl1RVz0eJkwiF5LlURbDddSRbalUlI5paox3LSBzF8Zzi5
         mhmaT1KpnPdZihVmhGBONd/zWycYzzLkJE00nkqwooWW0z05miQzHQr/m4GXgfW2MTDo
         qbxnef+XMbPoQye121dzd4gvmpL8eOdM11iEJMHYAK7spYgqFLuzScg0tWXtokz0Bxp3
         Jq4A==
X-Gm-Message-State: AOAM530eEbMN+cp85ut7j7FywxVyPoYqY5ajF0UUjKu5lhVmtl4991ph
        Vr2Fyi+oAOPuJFfasdRHzTb8mzj9maZcBn55HeUNmA==
X-Google-Smtp-Source: ABdhPJy0lJyBPB/Ayi6OC6JWEL6RjKMWAjdxD1+csMzTd3UjkDnZX4sKKlB9/3I3OBcy+ZpxS3tLUaPUGoAH3tBG9nU=
X-Received: by 2002:a05:6402:2053:: with SMTP id bc19mr1453492edb.230.1613105182209;
 Thu, 11 Feb 2021 20:46:22 -0800 (PST)
MIME-Version: 1.0
References: <20210211150147.743660073@linuxfoundation.org>
In-Reply-To: <20210211150147.743660073@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 12 Feb 2021 10:16:11 +0530
Message-ID: <CA+G9fYugE5n1qsudwP7XntBvvNcEquxQkMEskWvxJAZdZX5Fng@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/24] 4.19.176-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        David Collins <collinsd@codeaurora.org>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 11 Feb 2021 at 20:36, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.176 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 13 Feb 2021 15:01:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.176-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The following lockdep noticed on the arm beaglebone x15 device.
I have not bisected this problem yet.
Suspecting this patch,

> David Collins <collinsd@codeaurora.org>
>     regulator: core: avoid regulator_resolve_supply() race condition


[    2.470568] WARNING: possible recursive locking detected
[    2.470580] 4.19.176-rc1 #1 Not tainted
[    2.470590] --------------------------------------------
[    2.470600] swapper/0/1 is trying to acquire lock:
[    2.470611] (ptrval) (&rdev->mutex){+.+.}, at: regulator_enable+0x44/0x20c
[    2.470639]
[    2.470639] but task is already holding lock:
[    2.470650] (ptrval) (&rdev->mutex){+.+.}, at:
regulator_lock_nested+0x28/0x88
[    2.470676]
[    2.470676] other info that might help us debug this:
[    2.470687]  Possible unsafe locking scenario:
[    2.470687]
[    2.470698]        CPU0
[    2.470707]        ----
[    2.470716]   lock(&rdev->mutex);
[    2.470728]   lock(&rdev->mutex);
[    2.470740]
[    2.470740]  *** DEADLOCK ***
[    2.470740]
[    2.470752]  May be due to missing lock nesting notation
[    2.470752]
[    2.470765] 2 locks held by swapper/0/1:
[    2.470774]  #0: (ptrval) (&dev->mutex){....}, at: __driver_attach+0x78/0x168
[    2.470797]  #1: (ptrval) (&rdev->mutex){+.+.}, at:
regulator_lock_nested+0x28/0x88
[    2.470820]
[    2.470820] stack backtrace:
[    2.470836] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 4.19.176-rc1 #1
[    2.470846] Hardware name: Generic DRA74X (Flattened Device Tree)
[    2.470871] [<c0416430>] (unwind_backtrace) from [<c040f920>]
(show_stack+0x20/0x24)
[    2.470891] [<c040f920>] (show_stack) from [<c1306bec>]
(dump_stack+0xe8/0x114)
[    2.470910] [<c1306bec>] (dump_stack) from [<c04c2a04>]
(__lock_acquire+0x7cc/0x1acc)
[    2.470925] [<c04c2a04>] (__lock_acquire) from [<c04c46ec>]
(lock_acquire+0xdc/0x238)
[    2.470941] [<c04c46ec>] (lock_acquire) from [<c130a008>]
(__mutex_lock+0xa0/0xaf4)
[    2.470958] [<c130a008>] (__mutex_lock) from [<c130aa88>]
(mutex_lock_nested+0x2c/0x34)
[    2.470974] [<c130aa88>] (mutex_lock_nested) from [<c0ae9434>]
(regulator_enable+0x44/0x20c)
[    2.470990] [<c0ae9434>] (regulator_enable) from [<c0ae9780>]
(regulator_resolve_supply+0x184/0x2c8)
[    2.471006] [<c0ae9780>] (regulator_resolve_supply) from
[<c0ae98e8>] (regulator_register_resolve_supply+0x24/0x8c)
[    2.471022] [<c0ae98e8>] (regulator_register_resolve_supply) from
[<c0c294f0>] (class_for_each_device+0x70/0xe8)
[    2.471037] [<c0c294f0>] (class_for_each_device) from [<c0aea368>]
(regulator_register+0xa18/0xc58)
[    2.471053] [<c0aea368>] (regulator_register) from [<c0aebd64>]
(devm_regulator_register+0x54/0x84)
[    2.471069] [<c0aebd64>] (devm_regulator_register) from
[<c0af8c28>] (pbias_regulator_probe+0x1f4/0x2d0)
[    2.471084] [<c0af8c28>] (pbias_regulator_probe) from [<c0c29da0>]
(platform_drv_probe+0x58/0xa8)
[    2.471101] [<c0c29da0>] (platform_drv_probe) from [<c0c273b8>]
(really_probe+0x310/0x418)
[    2.471119] [<c0c273b8>] (really_probe) from [<c0c276e4>]
(driver_probe_device+0x88/0x1dc)
[    2.471135] [<c0c276e4>] (driver_probe_device) from [<c0c27984>]
(__driver_attach+0x14c/0x168)
[    2.471150] [<c0c27984>] (__driver_attach) from [<c0c24e08>]
(bus_for_each_dev+0x84/0xc4)
[    2.471167] [<c0c24e08>] (bus_for_each_dev) from [<c0c26a18>]
(driver_attach+0x2c/0x30)
[    2.471184] [<c0c26a18>] (driver_attach) from [<c0c26380>]
(bus_add_driver+0x1d0/0x274)
[    2.471199] [<c0c26380>] (bus_add_driver) from [<c0c28a4c>]
(driver_register+0x84/0x118)
[    2.471213] [<c0c28a4c>] (driver_register) from [<c0c29cf0>]
(__platform_driver_register+0x50/0x58)
[    2.471231] [<c0c29cf0>] (__platform_driver_register) from
[<c1ca3174>] (pbias_regulator_driver_init+0x24/0x28)
[    2.471249] [<c1ca3174>] (pbias_regulator_driver_init) from
[<c0403a68>] (do_one_initcall+0xa0/0x394)
[    2.471268] [<c0403a68>] (do_one_initcall) from [<c1c01454>]
(kernel_init_freeable+0x3ec/0x484)
[    2.471283] [<c1c01454>] (kernel_init_freeable) from [<c1306ff4>]
(kernel_init+0x18/0x128)
[    2.471299] [<c1306ff4>] (kernel_init) from [<c04010ac>]
(ret_from_fork+0x14/0x28)
[    2.471310] Exception stack(0xee19bfb0 to 0xee19bff8)
[    2.471323] bfa0:                                     00000000
00000000 00000000 00000000
[    2.471336] bfc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[    2.471348] bfe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    2.471385] vtt_fixed: supplied by smps3

test log link,
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19.175-25-g30e16c3fd5ac/testrun/3938030/suite/linux-log-parser/test/check-kernel-warning-2263196/log

metadata:
  git branch: linux-4.19.y
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git commit: 30e16c3fd5acd42264d873aacb75891f3cd202c4
  git describe: v4.19.175-25-g30e16c3fd5ac
  make_kernelversion: 4.19.176-rc1
  kernel-config:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/am57xx-evm/lkft/linux-stable-rc-4.19/747/config

-- 
Linaro LKFT
https://lkft.linaro.org
