Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43530319917
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 05:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbhBLEZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 23:25:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhBLEZh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 23:25:37 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E12EC061756
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 20:24:57 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id z19so273158eju.9
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 20:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7RQasrQJgCHriEeRCu3UiqlCy0kfi/TYstfXH+im0Pk=;
        b=tF6ZNO1c1ryTrxV6++XNn01OuOsaFIn9GfGwx83quXMMrXtPdIy8EwXPfnAXRxqmA4
         PBQc1cUoyKeN6bvcoSfmC8dj1aQQMHaCv42dZiy7x8kBYkCfkYthqJ/98mmbYuT8wM1l
         hFEHsMyXiX4ZfekL3q9myLaXEXLM/a18vLhH7feNZYW8yvzrHN8X7j6Xs1L4AkviCfrS
         wFC+7Wgf71coGlcS//58BeWl2F/TNVtW9709KUoNKckkXD7HefM7eQ+sK4sVVIjjGMwh
         goPK5d5oCMv0JV33jZuxDmSAGn3LhCVQTCzDbTy8dyEw7bXAZUPWqOEQIWwX4S0Rk+Ar
         SmOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7RQasrQJgCHriEeRCu3UiqlCy0kfi/TYstfXH+im0Pk=;
        b=qmpkwYI2zVVXpW31wCVARqUFPmgct7YjsEKW1kizvPzMwnZWPjQv1lh1AO9y/pcRUz
         luKEFXglOG+pR3T090ULCFn+sSCA7uED4ZW4TwmSWW85kUidBZHVXxELzEcx87Va2Ue4
         uTLmW9LvkAPpf/kvhHiPcjcDGe6o/STAMUMceUzbBzpzwqcXGPpWZ+CvqGNbSh7WojKn
         /v6Xf2qWhVUZOU2DbFzx7AXK1o5/z+sbE5EjnPpoYR0B3ILtpYCgtiiIBMyLe4eXsaKR
         FL2ISDnxFyBJLGGXc6eSpVPW/rmj3fie5XPplIF5utYXPOec0JwyjLuK/mh+i/0QQzCs
         ffyg==
X-Gm-Message-State: AOAM531zluZ82DlIpzRQOWiRJfnVyKBMifraJn0Pe19woZ00vt6n6AeV
        AnOLyDw06KuPzThAdHOWsc8iXHtbRK8kR/q/u6I1iA==
X-Google-Smtp-Source: ABdhPJwz82g630BXYXVbsJ4SwjyjQHfqv8a/FftHdz6UGkL8G+PGw9v4FBJdafHttITTTwpuROBap+yEirDcuAoeMTo=
X-Received: by 2002:a17:906:a153:: with SMTP id bu19mr1149675ejb.287.1613103895829;
 Thu, 11 Feb 2021 20:24:55 -0800 (PST)
MIME-Version: 1.0
References: <20210211150148.516371325@linuxfoundation.org>
In-Reply-To: <20210211150148.516371325@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 12 Feb 2021 09:54:44 +0530
Message-ID: <CA+G9fYtqmv+NoWpKmwVrLqaWefFRB3WN5s_3qJL1hgZP8RBqDg@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/24] 5.4.98-rc1 review
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
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 11 Feb 2021 at 20:36, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.98 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 13 Feb 2021 15:01:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.98-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The following lockdep warning was found during the arm64 db410c boot.
And this is easily reproducible.

This was noticed on Linux next and reported on linux arm msm mailing list.
https://lore.kernel.org/linux-arm-msm/CA+G9fYunK_2h3-pHtZT_+56Xf8b=M-8Q9GnTsCJ3KxVaJULorA@mail.gmail.com/

> David Collins <collinsd@codeaurora.org>
>     regulator: core: avoid regulator_resolve_supply() race condition

[    3.982889] WARNING: possible recursive locking detected
[    3.988186] 5.4.98-rc1 #1 Not tainted
[    3.993477] --------------------------------------------
[    3.997041] kworker/1:1/31 is trying to acquire lock:
[    4.002421] ffff00000eb36940 (regulator_ww_class_mutex){+.+.}, at:
create_regulator+0x23c/0x360
[    4.007372]
[    4.007372] but task is already holding lock:
[    4.011044] mmc1: SDHCI controller on 7864900.sdhci [7864900.sdhci]
using ADMA 64-bit
[    4.015874] ffff00003a9d8940 (regulator_ww_class_mutex){+.+.}, at:
regulator_resolve_supply+0xbc/0x330
[    4.015887]
[    4.015887] other info that might help us debug this:
[    4.015890]  Possible unsafe locking scenario:
[    4.015890]
[    4.015893]        CPU0
[    4.015895]        ----
[    4.015897]   lock(regulator_ww_class_mutex);
[    4.015903]   lock(regulator_ww_class_mutex);
[    4.026541] ci_hdrc ci_hdrc.0: EHCI Host Controller
[    4.029681]
[    4.029681]  *** DEADLOCK ***
[    4.029681]
[    4.029684]  May be due to missing lock nesting notation
[    4.029684]
[    4.029688] 5 locks held by kworker/1:1/31:
[    4.029691]  #0: ffff00000eb24928 ((wq_completion)events){+.+.},
at: process_one_work+0x1fc/0x758
[    4.029709]  #1: ffff800013203de8
((work_completion)(&edge->state_work)){+.+.}, at:
process_one_work+0x1fc/0x758
[    4.039092] ci_hdrc ci_hdrc.0: new USB bus registered, assigned bus number 1
[    4.045388]  #2: ffff00003a91c160 (&dev->mutex){....}, at:
__device_attach+0x4c/0x178
[    4.045402]  #3: ffff00003a91d170 (&dev->mutex){....}, at:
__device_attach+0x4c/0x178
[    4.045416]  #4: ffff00003a9d8940 (regulator_ww_class_mutex){+.+.},
at: regulator_resolve_supply+0xbc/0x330
[    4.066243] ci_hdrc ci_hdrc.0: USB 2.0 started, EHCI 1.00
[    4.069606]
[    4.069606] stack backtrace:
[    4.069614] CPU: 1 PID: 31 Comm: kworker/1:1 Not tainted 5.4.98-rc1 #1
[    4.077634] hub 1-0:1.0: USB hub found
[    4.082453] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
[    4.082464] Workqueue: events qcom_channel_state_worker
[    4.082469] Call trace:
[    4.082476]  dump_backtrace+0x0/0x188
[    4.082481]  show_stack+0x24/0x30
[    4.082488]  dump_stack+0xe8/0x168
[    4.082494]  __lock_acquire+0xd80/0x1458
[    4.082501]  lock_acquire+0xe8/0x270
[    4.086663] hub 1-0:1.0: 1 port detected
[    4.095487]  __ww_mutex_lock.constprop.15+0xbc/0xf60
[    4.095494]  ww_mutex_lock+0x98/0x3a0
[    4.095500]  create_regulator+0x23c/0x360
[    4.095505]  regulator_resolve_supply+0x1ac/0x330
[    4.095512]  regulator_register_resolve_supply+0x24/0x80
[    4.123419] mmc0: new HS200 MMC card at address 0001
[    4.128297]  class_for_each_device+0x78/0xf8
[    4.128303]  regulator_register+0x8c4/0xb40
[    4.128310]  devm_regulator_register+0x50/0xa8
[    4.128317]  rpm_reg_probe+0x108/0x1c0
[    4.128325]  platform_drv_probe+0x58/0xa8
[    4.139377] mmcblk0: mmc0:0001 DS1008 7.28 GiB
[    4.143393]  really_probe+0x290/0x498
[    4.143398]  driver_probe_device+0x12c/0x148
[    4.143404]  __device_attach_driver+0xa4/0x120
[    4.143411]  bus_for_each_drv+0x78/0xd8
[    4.143416]  __device_attach+0xf0/0x178
[    4.143421]  device_initial_probe+0x24/0x30
[    4.143429]  bus_probe_device+0xa0/0xa8
[    4.148410] mmcblk0boot0: mmc0:0001 DS1008 partition 1 4.00 MiB
[    4.154157]  device_add+0x3fc/0x660
[    4.154163]  of_device_add+0x50/0x68
[    4.154170]  of_platform_device_create_pdata+0xf0/0x170
[    4.154175]  of_platform_bus_create+0x174/0x550
[    4.154181]  of_platform_populate+0x8c/0x148
[    4.154189]  qcom_smd_rpm_probe+0x88/0xa0
[    4.158693] mmcblk0boot1: mmc0:0001 DS1008 partition 2 4.00 MiB
[    4.164749]  rpmsg_dev_probe+0x124/0x1b0
[    4.164755]  really_probe+0x290/0x498
[    4.164760]  driver_probe_device+0x12c/0x148
[    4.164766]  __device_attach_driver+0xa4/0x120
[    4.164772]  bus_for_each_drv+0x78/0xd8
[    4.164779]  __device_attach+0xf0/0x178
[    4.170244] mmcblk0rpmb: mmc0:0001 DS1008 partition 3 4.00 MiB,
chardev (236:0)
[    4.172124]  device_initial_probe+0x24/0x30
[    4.172130]  bus_probe_device+0xa0/0xa8
[    4.175514] random: fast init done
[    4.180696] mmc1: new ultra high speed SDR104 SDHC card at address aaaa
[    4.182542]  device_add+0x3fc/0x660
[    4.182549]  device_register+0x28/0x38
[    4.182556]  rpmsg_register_device+0x54/0x98
[    4.182563]  qcom_channel_state_worker+0x188/0x2d0
[    4.182570]  process_one_work+0x2a4/0x758
[    4.182576]  worker_thread+0x48/0x4a0
[    4.182583]  kthread+0x158/0x168
[    4.187938] mmcblk1: mmc1:aaaa SL16G 14.8 GiB
[    4.190182]  ret_from_fork+0x10/0x18


test log link,
https://lkft.validation.linaro.org/scheduler/job/2263114#L4151

meta data:
kernel: 5.4.98-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-5.4.y
git commit: 539f3bba2f5bb16b852f7d0cf50f8d39d0c4c4e3
git describe: v5.4.97-25-g539f3bba2f5b
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.97-25-g539f3bba2f5b



-- 
Linaro LKFT
https://lkft.linaro.org
