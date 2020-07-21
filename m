Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE12227AB5
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 10:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgGUIcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 04:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbgGUIcf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 04:32:35 -0400
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A54C0619D9
        for <stable@vger.kernel.org>; Tue, 21 Jul 2020 01:32:35 -0700 (PDT)
Received: by mail-vk1-xa29.google.com with SMTP id q85so4339628vke.4
        for <stable@vger.kernel.org>; Tue, 21 Jul 2020 01:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=PoeTzQAbfq8diFTwwkNIgvAU88Rk11ryiy5bkw2TiLE=;
        b=qkm0DThRajhvOArCsxPVp1WLsRduMWxTjOVSRdgSHGFQtywjmua1Zl9383pSh24DNb
         v0XyxiAVaFN2kT0lLlfTZxPoDCc49BlaWLllFJu333dYWH0XizRN0yZWSClvUoe5d6gX
         5sPeNxdD+omjnrlErPeHqeUtaI4YymmCxSP2Any4uMGd2Vtc6B+yXnsrudl4a+QS6I5t
         c3h6RTazDPN8jUdsGPBOoWcIzUERpPhQ7NJ6MXoscqG3OHeeveIZgFeFBRolVcqYRIPp
         hDZkPeoG5EFi2oluChUeG6rVI385un+IOgpRNfE2rp+hWQ6dGV/zma8+Tqot6ol7oInA
         Mk2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=PoeTzQAbfq8diFTwwkNIgvAU88Rk11ryiy5bkw2TiLE=;
        b=DAzrjZh9stZponVhUuCdz4AUHt+ZMJBXhv6Dp1JS2sKb52+JTSGxytLzJ6feBWNxfc
         aKxPJCkEGujUPw8AhFrIgJSb2tushLCW/YR+prCtJuIPz2MocSz6WKaOfLu1UIjT+tb1
         lDneg3y8tuYvNaO6V++wPdT8OkgMWaW+z1vwAnrpGj7/zB6dKYbV0qzHIEOzjqEGijLl
         c3DzLRWKXMIcOhj8CSj9LJoGRpM3Wyk7lDmMbDP6uIjblmU9fkBAQT/6WHheYDZBkJeE
         aPzvdJAPykQ7nSXczMOzjL5Sa21U+UP1XDvH/uWyENBh2jgPtdGugjK5oeMc/FBYiTle
         CbJg==
X-Gm-Message-State: AOAM530fhNRA0Vr5VrZAV4+KW6dMN2oWRfxx7viOenPPBNAejdogq332
        YKFcTg6Is+zgzvoO2C9T+8tG70kEshtU7r0c6O32StQchkpdPLBL
X-Google-Smtp-Source: ABdhPJwbf5Rm4LJQfuNeEBXEFYSArJpqfyxXBcSf96bg1G+qIb4bGdA0GfWckqnuMBu8NcbcIyGsk60Fg5COAjcw1MY=
X-Received: by 2002:a1f:a14f:: with SMTP id k76mr19527994vke.0.1595320353996;
 Tue, 21 Jul 2020 01:32:33 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Jul 2020 14:02:22 +0530
Message-ID: <CA+G9fYvGXOcsF=70FVwOxqVYOeGTUuzhUzh5od1cKV1hshsW_g@mail.gmail.com>
Subject: stable-rc 4.14: arm64: Internal error: Oops: clk_reparent
 __clk_set_parent_before on db410c
To:     linux- stable <stable@vger.kernel.org>, linux-clk@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        freedreno <freedreno@lists.freedesktop.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Rob Clark <robdclark@chromium.org>,
        Robin Murphy <robin.murphy@arm.com>, jcrouse@codeaurora.org,
        Eric Anholt <eric@anholt.net>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        samuel@sholland.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Kernel Internal oops while booting stable-rc 4.14 kernel on qcom db410c device
this problem happened only once on this specific platform.
and  rcu_preempt detected stalls on CPUs/tasks detected after this and
board hung.

metadata:
  git branch: linux-4.14.y
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git commit: 5b1e982af0f810358664827a6333affb4f5d8eb5
  git describe: v4.14.188-126-g5b1e982af0f8
  make_kernelversion: 4.14.189-rc1
  kernel-config:
https://builds.tuxbuild.com/12PM71zBW-5EAp5ztC_yxg/kernel.config

Crash dump:

[    5.424958] Unable to handle kernel paging request at virtual
address 00001008
[    5.435485] Mem abort info:
[    5.442509]   Exception class = DABT (current EL), IL = 32 bits
[    5.445203]   SET = 0, FnV = 0
[[    5.451101]   EA = 0, S1PTW =[    5.454226] Data abort info:
[    5.457264]   ISV = 0, ISS = 0x00000044
[    5.460390]   CM = 0, WnR = 1
[    5.463951] user pgtable: 4k pages, 48-bit VAs, pgd = ffff80003d66d000
[    5.467078] [0000000000001008] *pgd=0000000000000000
[    5.473503] Internal error: Oops: 96000044 [#1] PREEMPT SMP
[    5.479838] Modules linked in: adv7511 msm mdt_loader msm_rng
drm_kms_helper rng_core drm fuse
[    5.485405] Process kworker/2:0 (pid: 21, stack limit = 0xffff000009450000)
[    5.494090] CPU: 2 PID: 21 Comm: kworker/2:0 Not tainted 4.14.189-rc1 #1
[    5.501036] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
[    5.507996] Workqueue: events deferred_probe_work_func
[    5.514935] task: ffff80003d454380 task.stack: ffff000009450000
[    5.520155] pc : clk_reparent+0x60/0xe8
[    5.526058] lr : __clk_set_parent_before+0x40/0x88
[    5.529882] sp : ffff000009453640 pstate : 800001c5
[    5.534748] x29: ffff000009453640 x28: ffff0000090b7000
[    5.539615] x27: ffff80003fe7c478 x26: ffff0000094537a8
[    5.545175] x25: 0000000000000001 x24: ffff000009239038
[    5.550736] x23: ffff80003b6be688 x22: 0000000000000000
[    5.556297] x21: 0000000000000000 x20: ffff80003c9d8c00
[    5.561858] x19: ffff80003d798900 x18: 00000000fffffffe
[    5.567419] x17: 0000ffff7fdbb6a0 x16: ffff00000821ad98
[    5.572980] x15: 0000000000000001 x14: ffffffffffffffff
[    5.578540] x13: ffff0000094537c8 x12: 0000000000000010
[    5.584102] x11: 0000000000000010 x10: 0101010101010101
[    5.589663] x9 : 0000000000000000 x8 : 7f7f7f7f7f7f7f7f
[    5.595223] x7 : fefefefefeff6e77 x6 : 0000000000000140
[    5.600784] x5 : 0000000000000001 x4 : ffff80003c9d8c00
[    5.606344] x3 : ffff80003d798900 x2 : 0000000000000004
[    5.611905] x1 : ffff80003d7989a8 x0 : 0000000000001000
[    5.617467] Call trace:
[    5.623030]  clk_reparent+0x60/0xe8
[    5.625465]  __clk_set_parent_before+0x40/0x88
[    5.628943]  clk_register+0x330/0x618
[    5.633668]  pll_28nm_register+0xa4/0x340 [msm]
[    5.637492]  msm_dsi_pll_28nm_init+0xc8/0x1d8 [msm]
[    5.642007]  msm_dsi_pll_init+0x34/0xe0 [msm]
[    5.646870]  dsi_phy_driver_probe+0x1cc/0x310 [msm]
[    5.651196]  platform_drv_probe+0x58/0xb8
[    5.656060]  driver_probe_device+0x228/0x2d0
[    5.660231]  __device_attach_driver+0xb8/0xe8
[    5.664750]  bus_for_each_drv+0x64/0xa0
[    5.669269]  __device_attach+0xcc/0x138
[    5.673093]  device_initial_probe+0x10/0x18
[    5.676918]  bus_probe_device+0x90/0x98
[    5.681088]  device_add+0x3c4/0x5a8
[    5.684915]  of_device_add+0x40/0x58
[    5.688392]  of_platform_device_create_pdata+0x80/0xe8
[    5.692219]  of_platform_bus_create+0xd4/0x308
[    5.697432]  of_platform_populate+0x48/0xb8
[    5.702143]  msm_pdev_probe+0x3c/0x328 [msm]
[    5.706125]  platform_drv_probe+0x58/0xb8
[    5.710642]  driver_probe_device+0x228/0x2d0
[    5.714814]  __device_attach_driver+0xb8/0xe8
[    5.719334]  bus_for_each_drv+0x64/0xa0
[    5.723852]  __device_attach+0xcc/0x138
[    5.727677]  device_initial_probe+0x10/0x18
[    5.731502]  bus_probe_device+0x90/0x98
[    5.735675]  deferred_probe_work_func+0xa4/0x140
[    5.739502]  process_one_work+0x19c/0x300
[    5.744366]  worker_thread+0x4c/0x420
[    5.748539]  kthread+0x100/0x130
[    5.752362]  ret_from_fork+0x10/0x1c
[    5.755842] Code: 54000260 f9405080 f9005460 b4000040 (f9000401)
[    5.759669] ---[ end trace 6d70d7dd8a236384 ]---
[    5.765922] note: kworker/2:0[21] exited with preempt_count 1
[   26.777168] INFO: rcu_preempt detected stalls on CPUs/tasks:
[   26.777204] 0-...: (1 GPs behind) idle=2fa/140000000000001/0
softirq=1679/1723 fqs=2625
[   26.783112] 1-...: (1 GPs behind) idle=53a/140000000000000/0
softirq=1946/1958 fqs=2625
[   26.791444] (detected by 3, t=5252 jiffies, g=58, c=57, q=2362)
[   26.799781] Task dump for CPU 0:
[   26.806033] systemd-udevd   R  running task        0  2533      1 0x00000202
[   26.809515] Call trace:
[   26.816814]  __switch_to+0xe8/0x148
[   26.819248]  __wake_up_common+0x80/0x170
[   26.822724]  __wake_up_common_lock+0x7c/0xa8
[   26.826897]  __wake_up_sync_key+0x1c/0x28
[   26.831416]  sock_def_readable+0x40/0x88
[   26.835584] Task dump for CPU 1:
[   26.839755] systemd         R  running task        0     1      0 0x0000000a
[   26.843237] Call trace:
[   26.850531]  __switch_to+0xe8/0x148
[   26.852968]  0xffff800009fc8000
[   26.856467] INFO: rcu_sched detected stalls on CPUs/tasks:
[   26.859584] 0-...: (1 GPs behind) idle=2fa/140000000000001/0
softirq=1722/1723 fqs=2625
[   26.865145] 1-...: (1 GPs behind) idle=53a/140000000000000/0
softirq=1957/1958 fqs=2625
[   26.873477] (detected by 3, t=5270 jiffies, g=-150, c=-151, q=3)
[   26.881815] Task dump for CPU 0:
[   26.888067] systemd-udevd   R  running task        0  2533      1 0x00000202
[   26.891549] Call trace:
[   26.898845]  __switch_to+0xe8/0x148
[   26.901281]  __wake_up_common+0x80/0x170
[   26.904758]  __wake_up_common_lock+0x7c/0xa8
[   26.908931]  __wake_up_sync_key+0x1c/0x28
[   26.913449]  sock_def_readable+0x40/0x88
[   26.917618] Task dump for CPU 1:
[   26.921790] systemd         R  running task        0     1      0 0x0000000a
[   26.925271] Call trace:
[   26.932565]  __switch_to+0xe8/0x148
[   26.935002]  0xffff800009fc8000
[   41.449201] random: crng init done
[   41.449221] random: 7 urandom warning(s) missed due to ratelimiting
[   89.797164] INFO: rcu_preempt detected stalls on CPUs/tasks:
[   89.797195] 0-...: (1 GPs behind) idle=2fa/140000000000001/0
softirq=1679/1723 fqs=10482
[   89.803103] 1-...: (1 GPs behind) idle=53a/140000000000000/0
softirq=1946/1958 fqs=10482
[   89.811437] (detected by 3, t=21007 jiffies, g=58, c=57, q=2578)
[   89.819773] Task dump for CPU 0:
[   89.826027] systemd-udevd   R  running task        0  2533      1 0x00000202
[   89.829508] Call trace:
[   89.836807]  __switch_to+0xe8/0x148
[   89.839241]  __wake_up_common+0x80/0x170
[   89.842717]  __wake_up_common_lock+0x7c/0xa8
[   89.846891]  __wake_up_sync_key+0x1c/0x28
[   89.851410]  sock_def_readable+0x40/0x88
<System Hung>

Full test log,
https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/build/v4.14.188-126-g5b1e982af0f8/testrun/2969667/suite/linux-log-parser/test/check-kernel-oops-1592908/log


-- 
Linaro LKFT
https://lkft.linaro.org
