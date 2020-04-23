Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A72BD1B58D9
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 12:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbgDWKM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 06:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726849AbgDWKM4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 06:12:56 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EDF8C08C5F2
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 03:12:56 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id x23so4311736lfq.1
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 03:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pVDXXWmx8zoDTwONAL0VPHZtQyCmFIdPhRDUY0F9Gyg=;
        b=ZY0efxC9V8M/2fHXWdwD4/Z5x1SZ/n7fdXBhVi/IKva/htWXwzp/3zqvV5mId5wH3T
         Qm1loU/HrQmlv8CUNdXrXOggV5MLs0p81toVLkvsPILigCtMDqMqEFK8ubjVs4wOPEDq
         P5FPZTs/Jq9P1qmASq8Za/NP+soUnkWDQP7P0YOVhBwRoKzm1ioieIqP1bU5lqE68N4Z
         uFdlpH0T/0PZwBTpEhOzfuERKrL0IeV27o3tdnsKLBsc4TJUsryvAilqtfGF+ZWcsM9d
         P0E+PWSmkWySSL0Suq4INyaTf3LkaaUZZCeAexSEzb3kRnREVPu3CfQFNmjYrGpuRLuC
         TwhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pVDXXWmx8zoDTwONAL0VPHZtQyCmFIdPhRDUY0F9Gyg=;
        b=LAusoABYHvWYNNev6wcRr1Oy1675drqOXEOiBYgdElMLjr1QOtji2B9UNz1N8w9PTt
         2bGiepbEVEpRUfBenJMPG8MkXuaqY0LldqU4akZ9e5tfcmLtYUVkWhnUwTAo433E7Kiy
         +NbsXpEkJWqIAlnZjza8p3zDWohTEKTaXq1I7xiQ0Xy3aQGRVBBUe/bJU2bntQWwrvr9
         8kCDqsasGWmcU8lkMIJ3VMOi2+xykkMeMRyN7jSpkZGHL9+Mfhhjokjbmu/SIGOsuHFv
         asLtButyh+fwK/HxPvHMdic0l1WT50poJdcHr8ABP892KG2GTOn99uRHgVBnGMtdwJ6F
         uA+w==
X-Gm-Message-State: AGi0Pubst5aLkAoVlKmQdBbNLq+oCR2wqHSw/M/egWD9TEtcrOXhbgRh
        Wm9W6B7METXQXSTU17UO6BWTCFSKpgxDIHA5zVh7TBJluViHww==
X-Google-Smtp-Source: APiQypJuOVtAqtticAKgxt4i3cO67LNiB8zoZFm0uobKnAlWQ2y5mYgYQ5FHdZkOIyfU3ngxBKGUITskt8URHAHCoBI=
X-Received: by 2002:a19:c602:: with SMTP id w2mr1818162lff.74.1587636773101;
 Thu, 23 Apr 2020 03:12:53 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYuT016d2YjSFrUO3fnumUg7csginnEZRs1Ws-ZOn4+-tg@mail.gmail.com>
In-Reply-To: <CA+G9fYuT016d2YjSFrUO3fnumUg7csginnEZRs1Ws-ZOn4+-tg@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 23 Apr 2020 15:42:41 +0530
Message-ID: <CA+G9fYtcjK8MrygHu686rV4i+bYO2CR==OFNrXNSM_HzWEhNFA@mail.gmail.com>
Subject: Re: WARNING: drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h:178 mdp5_bind
To:     linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        freedreno@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        lkft-triage@lists.linaro.org
Cc:     Rob Clark <robdclark@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>,
        David Airlie <airlied@linux.ie>,
        Brian Masney <masneyb@onstation.org>,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Amit Pundir <amit.pundir@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 12 Apr 2020 at 15:08, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> While booting stable-rc 4.14 branch kernel this warning was noticed on
> Qualcomm  APQ 8016 SBC (DT) Dragonboard 410c device.
>
> [    8.459580] clk: failed to reparent byte0_clk_src to dsi0pllbyte: -22
> [    8.459724] clk: failed to reparent pclk0_clk_src to dsi0pll: -22
> [    8.466474] msm 1a00000.mdss: Using legacy clk name binding.  Use
> \"iface\" instead of \"iface_clk\"
> [    8.476753] msm 1a00000.mdss: Using legacy clk name binding.  Use
> \"bus\" instead of \"bus_clk\"
> [    8.480055] msm 1a00000.mdss: Using legacy clk name binding.  Use
> \"vsync\" instead of \"vsync_clk\"
> [    8.489023] msm 1a00000.mdss: 1a00000.mdss supply vdd not found,
> using dummy regulator
> [    8.498450] msm_mdp 1a01000.mdp: Using legacy clk name binding.
> Use \"bus\" instead of \"bus_clk\"
> [    8.505394] msm_mdp 1a01000.mdp: Using legacy clk name binding.
> Use \"iface\" instead of \"iface_clk\"
> [    8.524724] msm_mdp 1a01000.mdp: Using legacy clk name binding.
> Use \"core\" instead of \"core_clk\"
> [    8.524877] msm_mdp 1a01000.mdp: Using legacy clk name binding.
> Use \"vsync\" instead of \"vsync_clk\"[    8.532846] ------------[ cut
> here ]------------
> [    8.541651] WARNING: CPU: 1 PID: 32 at
> /usr/src/kernel/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h:178
> mdp5_bind+0x418/0x4e0 [msm]
> [    8.546303] Modules linked in: crc32_ce adv7511 rfkill msm
> mdt_loader drm_kms_helper drm msm_rng rng_core fuse
> [    8.557504] CPU: 1 PID: 32 Comm: kworker/1:1 Not tainted 4.14.176-rc1 #1
> [    8.567478] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
> [    8.574344] Workqueue: events deferred_probe_work_func
> [    8.581018] task: ffff80003d764680 task.stack: ffff00000a4c0000
> [    8.586178] PC is at mdp5_bind+0x418/0x4e0 [msm]
> [    8.591989] LR is at mdp5_bind+0x1b4/0x4e0 [msm]
> [    8.596644] pc : [<ffff000000ebd6f8>] lr : [<ffff000000ebd494>]
> pstate: 60000145
> [    8.601246] sp : ffff00000a4c39d0
> [    8.608617] x29: ffff00000a4c39d0 x28: 0000000000000000
> [    8.611832] x27: ffff800037db4a00 x26: ffff000000eec9e8
> [    8.617214] x25: ffff800037e28000 x24: ffff800037dc3810
> [    8.622509] x23: ffff800037ca7000 x22: ffff00000a22e4b0
> [    8.627805] x21: ffff800037dc3800 x20: 0000000000000000
> [    8.633100] x19: ffff80003a8c2880 x18: 0000000000000010
> [    8.638395] x17: 0000ffffb6f9ba28 x16: ffff0000082fd6e0
> [    8.643691] x15: ffffffffffffffff x14: ffffffffffffffff
> [    8.648986] x13: 0000000000000000 x12: 00000000e3d3f2dc
> [    8.654280] x11: ffff80003d764eb0 x10: ffff00000a200000
> [    8.659576] x9 : fffffffffffffffe x8 : 0000000000000000
> [    8.664871] x7 : ffff0000087c908c x6 : 0000000000000000
> [    8.670167] x5 : 0000000000000040 x4 : 0000000000000004
> [    8.675461] x3 : fffffffffffffeb0 x2 : ffff000009d5f1a0
> [    8.680755] x1 : ffff80003d764680 x0 : 0000000000000000
> [    8.686052] Call trace:
> [    8.691346] Exception stack(0xffff00000a4c3890 to 0xffff00000a4c39d0)
> [    8.693521] 3880:
> 0000000000000000 ffff80003d764680
> [    8.700120] 38a0: ffff000009d5f1a0 fffffffffffffeb0
> 0000000000000004 0000000000000040
> [    8.707934] 38c0: 0000000000000000 ffff0000087c908c
> 0000000000000000 fffffffffffffffe
> [    8.715746] 38e0: ffff00000a200000 ffff80003d764eb0
> 00000000e3d3f2dc 0000000000000000
> [    8.723558] 3900: ffffffffffffffff ffffffffffffffff
> ffff0000082fd6e0 0000ffffb6f9ba28
> [    8.731372] 3920: 0000000000000010 ffff80003a8c2880
> 0000000000000000 ffff800037dc3800
> [    8.739183] 3940: ffff00000a22e4b0 ffff800037ca7000
> ffff800037dc3810 ffff800037e28000
> [    8.746997] 3960: ffff000000eec9e8 ffff800037db4a00
> 0000000000000000 ffff00000a4c39d0
> [    8.754809] 3980: ffff000000ebd494 ffff00000a4c39d0
> ffff000000ebd6f8 0000000060000145
> [    8.762622] 39a0: ffff00000a4c39d0 ffff000000ebd494
> ffffffffffffffff 0000000000000000
> [    8.770431] 39c0: ffff00000a4c39d0 ffff000000ebd6f8
> [    8.778452] [<ffff000000ebd6f8>] mdp5_bind+0x418/0x4e0 [msm]
> [    8.782937] [<ffff0000087b304c>] component_bind_all+0x104/0x298
> [    8.789040] [<ffff000000ec8348>] msm_drm_bind+0x140/0x5f0 [msm]
> [    8.794481] [<ffff0000087b2c70>] try_to_bring_up_master+0x180/0x1e0
> [    8.800380] [<ffff0000087b2d78>] component_add+0xa8/0x170
> [    8.806845] [<ffff000000ed3c54>] dsi_dev_probe+0x24/0x38 [msm]
> [    8.812199] [<ffff0000087bc798>] platform_drv_probe+0x60/0xc0
> [    8.817913] [<ffff0000087b9e70>] driver_probe_device+0x218/0x2e0
> [    8.823730] [<ffff0000087ba0b4>] __device_attach_driver+0xa4/0xf0
> [    8.829810] [<ffff0000087b7cfc>] bus_for_each_drv+0x5c/0xa8
> [    8.835797] [<ffff0000087b9ad8>] __device_attach+0xd0/0x148
> [    8.841177] [<ffff0000087ba17c>] device_initial_probe+0x24/0x30
> [    8.846734] [<ffff0000087b8e80>] bus_probe_device+0xa0/0xa8
> [    8.852638] [<ffff0000087b937c>] deferred_probe_work_func+0xac/0x158
> [    8.858195] [<ffff00000810a558>] process_one_work+0x278/0x790
> [    8.864800] [<ffff00000810aac0>] worker_thread+0x50/0x480
> [    8.870441] [<ffff000008112570>] kthread+0x138/0x140
> [    8.875823] [<ffff000008085be4>] ret_from_fork+0x10/0x1c
> [    8.880846] ---[ end trace 73f4fbf7f1caf3f2 ]---
> [    8.886661] msm 1a00000.mdss: bound 1a01000.mdp (ops mdp5_ops [msm])
> [    8.891128] msm_dsi 1a98000.dsi: 1a98000.dsi supply gdsc not found,
> using dummy regulator
> [    8.897939] ------------[ cut here ]------------
> [    8.905384] WARNING: CPU: 1 PID: 2210 at
> /usr/src/kernel/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c:253
> mdp5_disable+0xa0/0xb8 [msm]
> [    8.909846] Modules linked in: crc32_ce adv7511 rfkill msm
> mdt_loader drm_kms_helper drm msm_rng rng_core fuse
> [    8.921401] CPU: 1 PID: 2210 Comm: kworker/1:2 Tainted: G        W
>      4.14.176-rc1 #1
> [    8.931289] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
> [    8.939543] Workqueue: pm pm_runtime_work
> [    8.946206] task: ffff80003a9c4680 task.stack: ffff00000e750000
> [    8.950335] PC is at mdp5_disable+0xa0/0xb8 [msm]
> [    8.956054] LR is at mdp5_disable+0x28/0xb8 [msm]
> [    8.960705] pc : [<ffff000000ebd960>] lr : [<ffff000000ebd8e8>]
> pstate: 40000145
> [    8.965394] sp : ffff00000e753c10
> [    8.972863] x29: ffff00000e753c10 x28: 0000000000000000
> [    8.976068] x27: ffff00000948a000 x26: ffff00000813eba8
> [    8.981451] x25: ffff00000e753d70 x24: 0000000000000000
> [    8.986744] x23: ffff0000087c5138 x22: 0000000000000000
> [    8.992049] x21: 000000000000000a x20: ffff800037dc3940
> [    8.997344] x19: ffff80003a8c2880 x18: 0000000000000010
> [    9.002640] x17: 0000ffffb6f9ba28 x16: ffff0000082fd6e0
> [    9.007926] x15: ffffffffffffffff x14: 0000000000000001
> [    9.013222] x13: 0000000000000010 x12: 000000002cdf788f
> [    9.018516] x11: ffff80003a9c4eb0 x10: ffff00000a200000
> [    9.023820] x9 : ffff00000e753d60 x8 : 0000000000000000
> [    9.029114] x7 : ffff0000087c9d6c x6 : 0000000000000000
> [    9.034416] x5 : 0000000000000040 x4 : 0000000000000002
> [    9.039704] x3 : fffffffffffffeb0 x2 : ffff000000eec9e0
> [    9.045000] x1 : 0000000000000002 x0 : 00000000ffffffff
> [    9.050294] Call trace:
> [    9.055582] Exception stack(0xffff00000e753ad0 to 0xffff00000e753c10)
> [    9.057764] 3ac0:
> 00000000ffffffff 0000000000000002
> [    9.064357] 3ae0: ffff000000eec9e0 fffffffffffffeb0
> 0000000000000002 0000000000000040
> [    9.072171] 3b00: 0000000000000000 ffff0000087c9d6c
> 0000000000000000 ffff00000e753d60
> [    9.079981] 3b20: ffff00000a200000 ffff80003a9c4eb0
> 000000002cdf788f 0000000000000010
> [    9.087795] 3b40: 0000000000000001 ffffffffffffffff
> ffff0000082fd6e0 0000ffffb6f9ba28
> [    9.095607] 3b60: 0000000000000010 ffff80003a8c2880
> ffff800037dc3940 000000000000000a
> [    9.103419] 3b80: 0000000000000000 ffff0000087c5138
> 0000000000000000 ffff00000e753d70
> [    9.111231] 3ba0: ffff00000813eba8 ffff00000948a000
> 0000000000000000 ffff00000e753c10
> [    9.119045] 3bc0: ffff000000ebd8e8 ffff00000e753c10
> ffff000000ebd960 0000000040000145
> [    9.126856] 3be0: ffff80003a9c4680 fffffffffffffeb0
> ffffffffffffffff 0000000000000040
> [    9.134668] 3c00: ffff00000e753c10 ffff000000ebd960
> [    9.142691] [<ffff000000ebd960>] mdp5_disable+0xa0/0xb8 [msm]
> [    9.147383] [<ffff000000ebd9ac>] mdp5_runtime_suspend+0x34/0x50 [msm]
> [    9.153076] [<ffff0000087c5174>] pm_generic_runtime_suspend+0x3c/0x58
> [    9.159496] [<ffff0000087c9220>] __rpm_callback+0xe8/0x270
> [    9.165919] [<ffff0000087c93dc>] rpm_callback+0x34/0xa0
> [    9.171968] [<ffff0000087c7c18>] rpm_suspend+0x100/0x6e8
> [    9.171988] [<ffff0000087c9dc8>] pm_runtime_work+0x80/0xc0
> [    9.181980] [<ffff00000810a558>] process_one_work+0x278/0x790
> [    9.187271] [<ffff00000810aac0>] worker_thread+0x50/0x480
> [    9.193091] [<ffff000008112570>] kthread+0x138/0x140
> [    9.198470] [<ffff000008085be4>] ret_from_fork+0x10/0x1c
> [    9.203502] ---[ end trace 73f4fbf7f1caf3f3 ]---
> [    9.209101] msm_dsi 1a98000.dsi: 1a98000.dsi supply gdsc not found,
> using dummy regulator
> [    9.215441] msm_dsi_host_set_src_pll: can't set parent to
> byte_clk_src. ret=-22
> [    9.221596] msm_dsi_manager_register: failed to register mipi dsi host#
> [    9.230109] msm 1a00000.mdss: failed to bind 1a98000.dsi (ops
> dsi_ops [msm]): -22
> [    9.237107] msm 1a00000.mdss: master bind failed: -22
> [    9.243823] msm_dsi: probe of 1a98000.dsi failed with error -22
>
>
> metadata:
>   git branch: linux-4.14.y
>   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>   kernel-config:
> http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/dragonboard-410c/lkft/linux-stable-rc-4.14/803/config
>
> full test log,
> https://lkft.validation.linaro.org/scheduler/job/1360268#L3514
>
> git log --oneline  drivers/gpu/drm | head
> 89e30bb46074 drm/msm/dsi: save pll state before dsi host is powered off
> 892afde0f4a1 drm: msm: Fix return type of dsi_mgr_connector_mode_valid for kCFI
> 3824b96e06cc drm/msm/mdp5: rate limit pp done timeout warnings
> b67d1c342e13 drm/i915/gvt: Separate display reset from ALL_ENGINES reset
> 313810964cac drm/msm: Set dma maximum segment size for mdss
> edae04b8f463 drm/amdgpu/soc15: fix xclk for raven
> 3e85259525a1 radeon: insert 10ms sleep in dce5_crtc_load_lut
> b06d001e8831 drm/nouveau/disp/nv50-: prevent oops when no channel
> method map provided
> e7f9d07dcc42 drm/vmwgfx: prevent memory leak in vmw_cmdbuf_res_add
> bf24b7d69aea drm/nouveau: Fix copy-paste error in
> nouveau_fence_wait_uevent_handler

We still notice kernel warnings while booting stable rc 4.14 branch
on dragonboard 410c board.


[    5.511973] clk: failed to reparent byte0_clk_src to dsi0pllbyte: -22
[    5.538839] clk: failed to reparent pclk0_clk_src to dsi0pll: -22
[    5.539495] msm 1a00000.mdss: Using legacy clk name binding.  Use
\"iface\" instead of \"iface_clk\"
[    5.550982] msm 1a00000.mdss: Using legacy clk name binding.  Use
\"bus\" instead of \"bus_clk\"
[    5.559901] msm 1a00000.mdss: Using legacy clk name binding.  Use
\"vsync\" instead of \"vsync_clk\"
[    5.559942] msm 1a00000.mdss: 1a00000.mdss supply vdd not found,
using dummy regulator
[    5.560349] msm_mdp 1a01000.mdp: Using legacy clk name binding.
Use \"bus\" instead of \"bus_clk\"
[    5.584744] msm_mdp 1a01000.mdp: Using legacy clk name binding.
Use \"iface\" instead of \"iface_clk\"
[    5.593420] msm_mdp 1a01000.mdp: Using legacy clk name binding.
Use \"core\" instead of \"core_clk\"
[    5.593489] msm_mdp 1a01000.mdp: Using legacy clk name binding.
Use \"vsync\" instead of \"vsync_clk\"
[    5.593573] ------------[ cut here ]------------
[    5.593795] WARNING: CPU: 3 PID: 26 at
drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h:178 mdp5_bind+0x3cc/0x488
[msm]
[    5.593801] Modules linked in: crc32_ce adv7511 msm mdt_loader
drm_kms_helper msm_rng drm rng_core fuse
[    5.625058] CPU: 3 PID: 26 Comm: kworker/3:0 Not tainted
4.14.177-rc1-00200-gcebd79de8787 #1
[    5.625062] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
[    5.625078] Workqueue: events deferred_probe_work_func
[    5.625093] task: ffff80003d478d80 task.stack: ffff0000093f8000
[    5.625323] pc : mdp5_bind+0x3cc/0x488 [msm]
[    5.670455] lr : mdp5_bind+0x184/0x488 [msm]
[    5.674749] sp : ffff0000093fba20 pstate : 60000145
[    5.679008] x29: ffff0000093fba20 x28: ffff000009047000
[    5.683607] x27: ffff80003fe93478 x26: ffff80003c0e1800
[    5.689164] x25: ffff0000091abb90 x24: ffff000000bee758
[    5.694457] x23: ffff80003c2e0000 x22: ffff80003c0e1400
[    5.699753] x21: ffff80003c0e1410 x20: 0000000000000000
[    5.705046] x19: ffff80003c0e2080 x18: 0000000000000000
[    5.710341] x17: 0000aaaabb5d3808 x16: 0000000000000007
[    5.715637] x15: ffff000009063000 x14: ffffffffffffffff
[    5.720929] x13: 0000000000000000 x12: 0101010101010101
[    5.726231] x11: 0000000000000004 x10: 0101010101010101
[    5.731523] x9 : fffffffffffffffe x8 : 7f7f7f7f7f7f7f7f
[    5.736819] x7 : 0000000000000005 x6 : 0000000000000000
[    5.742113] x5 : 0000000000000000 x4 : 0000000000000000
[    5.747411] x3 : 0000000000000000 x2 : 000000000000000f
[    5.752706] x1 : ffff80003d478d80 x0 : 0000000000000000
[    5.758001] Call trace:
         Starting Network Manager...[    5.763500]  mdp5_bind+0x3cc/0x488 [msm]

[    5.774184]  msm_drm_bind+0x110/0x530 [msm]
[    5.774208]  try_to_bring_up_master+0x14c/0x1a8
[    5.777170]  component_add+0x94/0x158
[    5.781896]  dsi_dev_probe+0x14/0x28 [msm]
[    5.785498]  platform_drv_probe+0x58/0xb8
[    5.789487]  driver_probe_device+0x228/0x2d0
[    5.793567]  __device_attach_driver+0xb8/0xe8
[    5.797907]  bus_for_each_drv+0x64/0xa0
[    5.802159]  __device_attach+0xcc/0x138
[    5.805805]  device_initial_probe+0x10/0x18
[    5.809625]  bus_probe_device+0x90/0x98
[    5.813791]  deferred_probe_work_func+0xa4/0x140
[    5.817613]  process_one_work+0x19c/0x300
[    5.822472]  worker_thread+0x4c/0x420
[    5.826379]  kthread+0x100/0x130
[    5.830026]  ret_from_fork+0x10/0x18
[    5.833322] ---[ end trace 57904f967cff9b90 ]---
[    5.837244] msm 1a00000.mdss: bound 1#
a01000.mdp (ops mdp5_ops [msm])
[    5.837369] msm_dsi 1a98000.dsi: 1a98000.dsi supply gdsc not found,
using dummy regulator
[    5.848108] msm_dsi 1a98000.dsi: 1a98000.dsi supply gdsc not found,
using dummy regulator
[    5.856546] msm_dsi_host_set_src_pll: can't set parent to
byte_clk_src. ret=-22
[    5.864103] msm_dsi_manager_register: failed to register mipi dsi
host for DSI 0
[    5.871385] ------------[ cut here ]------------
[    5.879021] WARNING: CPU: 3 PID: 42 at
drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c:253 mdp5_disable+0x94/0xb0
[msm]
[    5.883415] Modules linked in: crc32_ce adv7511 msm mdt_loader
drm_kms_helper msm_rng drm rng_core fuse
[    5.893227] CPU: 3 PID: 42 Comm: kworker/3:1 Tainted: G        W
   4.14.177-rc1-00200-gcebd79de8787 #1
[    5.902599] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
[    5.912326] Workqueue: pm pm_runtime_work
[    5.919172] task: ffff80003d631b00 task.stack: ffff000009450000
[    5.923282] pc : mdp5_disable+0x94/0xb0 [msm]
[    5.929001] lr : mdp5_disable+0x20/0xb0 [msm]
[    5.933321] sp : ffff000009453c40 pstate : 40000145
[    5.937662] x29: ffff000009453c40 x28: ffff000009047000
[    5.942350] x27: ffff000009047a80 x26: ffff000009453d90
[    5.947905] x25: 0000000000000000 x24: ffff80003c0e14e0
[    5.953201] x23: ffff0000085e9088 x22: 000000000000000a
[    5.958495] x21: ffff0000085e9088 x20: 0000000000000000
[    5.963791] x19: ffff80003c0e2080 x18: 0000000000000000
[    5.969086] x17: 0000aaaabb5d3808 x16: 0000000000000007
[    5.974380] x15: 0000000000000010 x14: 4420726f66207473
[    5.979676] x13: 000000015c0d6911 x12: 0000000000000000
[    5.984970] x11: 0000000000000016 x10: ffff80003fe98400
[    5.990266] x9 : 0000000000000000 x8 : 0000000000000000
[    5.995561] x7 : 00000000fffee0c3 x6 : ffff80003fe8fa18
[    6.000857] x5 : 0020000000000000 x4 : 0000000000000000
[    6.006152] x3 : ffff80003c0e1410 x2 : ffff000000bee750
[    6.011446] x1 : 0000000000000002 x0 : 00000000ffffffff
[    6.016742] Call trace:
[[0;32m  OK  [0m] Started Kernel Logging Service.[    6.022229]
mdp5_disable+0x94/0xb0 [msm]

[    6.034233]  worker_thread+0x4c/0x420
[    6.034268]  kthread+0x100/0x130
[    6.036959]  ret_from_fork+0x10/0x18
[    6.040256] ---[ end trace 57904f967cff9b91 ]---
[    6.044379] msm 1a00000.mdss: failed to bind 1a98000.dsi (ops dsi_ops [m#
sm]): -22
[    6.048771] msm 1a00000.mdss: master bind failed: -22
[    6.055868] msm_dsi: probe of 1a98000.dsi failed with error -22


ref:
https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/build/v4.14.176-200-gcebd79de8787/testrun/1387839/log
https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/build/v4.14.176-200-gcebd79de8787/testrun/1387839/

>
> --
> Linaro LKFT
> https://lkft.linaro.org
