Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 869361A5DD6
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 11:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgDLJjI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Apr 2020 05:39:08 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:41591 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbgDLJjH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Apr 2020 05:39:07 -0400
Received: by mail-lj1-f194.google.com with SMTP id n17so5975697lji.8
        for <stable@vger.kernel.org>; Sun, 12 Apr 2020 02:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=3mkSwu+udljtct+LWwDqVjqepbAVEgiBkFLEa2ojwk8=;
        b=mHaJCXE/E7rxoLDl6En/Hb/ugI7AIic4MYOIFEmyoDO1RtVhoVh7S5IdjkNis30XFx
         aFfJYnwbJaN7m8qkAnLJTNAen6KjVhjEQausplPbS6SwxrX4zv2Gg1MlRh4CMNurloC5
         NSmajY1NpUYtI5JTIIyUzskKFIEFgcfrOKCpuEGlQ0cqM9MLMNsJsMz5o6l1PB3ku3dp
         P2q4kM32bAsGQrrFWubH0mjl7fllADC2WI7ERegpbOsl+B306QbHu0ahTRjumKIgazBz
         hYAQcJ3TsgKwXi7zSI81CTUb/Z0Zvpd1lW81/6mu/0bsXtDcbfywnoS62f5ZB5fPnaYa
         MyEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=3mkSwu+udljtct+LWwDqVjqepbAVEgiBkFLEa2ojwk8=;
        b=bQtTeij/8n08VPLTNgPaM7mbVlC8LMstvkWvhPgAuPKWuTSwNffo3HgJPmrWsP3sP7
         tRAsZCThsQlxrY1qtI1ULX3tYadG9jUg1HB8TB7XYrfS7AQDfC+Gf42IXToPEcVpq4mI
         6PQdcyOjvITU8CCJo950agROwvvzS7BBNthWyaVY98qyPsxjdFGy2O8mirEbrcYtMheu
         nsozBQe2hhNhLuJ8toZUSb5tu/4PQ/bELxOxK2crKsWq8dXTCikniVGDK1f5iHZJUHEj
         RxHYe9EMr5U5p+gg7WUmtQJa+522sUNn6p9QKdtjqQADaXgcLDS1frVdVKhjVFaiILcm
         qU8Q==
X-Gm-Message-State: AGi0Pua6N1+S4Y8V2IU2cbN3FvAkNb/QgGXlq26kquu8J36CjCTrIrH2
        uucWcyI3D1VmiQL1GfSeLdNSu4sJN0Kk246FHLkqEKdX610=
X-Google-Smtp-Source: APiQypJyjW+slTN6/YSFAIhHOtIhIfdH88B1nMmWrFVLJ/AXKU90WCrZim04XUfs9jwMLtizhpjIJDGzmck9KhieHjY=
X-Received: by 2002:a2e:6c05:: with SMTP id h5mr7525958ljc.217.1586684342866;
 Sun, 12 Apr 2020 02:39:02 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 12 Apr 2020 15:08:51 +0530
Message-ID: <CA+G9fYuT016d2YjSFrUO3fnumUg7csginnEZRs1Ws-ZOn4+-tg@mail.gmail.com>
Subject: WARNING: drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h:178 mdp5_bind
To:     linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        freedreno@lists.freedesktop.org, dri-devel@lists.freedesktop.org
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

While booting stable-rc 4.14 branch kernel this warning was noticed on
Qualcomm  APQ 8016 SBC (DT) Dragonboard 410c device.

[    8.459580] clk: failed to reparent byte0_clk_src to dsi0pllbyte: -22
[    8.459724] clk: failed to reparent pclk0_clk_src to dsi0pll: -22
[    8.466474] msm 1a00000.mdss: Using legacy clk name binding.  Use
\"iface\" instead of \"iface_clk\"
[    8.476753] msm 1a00000.mdss: Using legacy clk name binding.  Use
\"bus\" instead of \"bus_clk\"
[    8.480055] msm 1a00000.mdss: Using legacy clk name binding.  Use
\"vsync\" instead of \"vsync_clk\"
[    8.489023] msm 1a00000.mdss: 1a00000.mdss supply vdd not found,
using dummy regulator
[    8.498450] msm_mdp 1a01000.mdp: Using legacy clk name binding.
Use \"bus\" instead of \"bus_clk\"
[    8.505394] msm_mdp 1a01000.mdp: Using legacy clk name binding.
Use \"iface\" instead of \"iface_clk\"
[    8.524724] msm_mdp 1a01000.mdp: Using legacy clk name binding.
Use \"core\" instead of \"core_clk\"
[    8.524877] msm_mdp 1a01000.mdp: Using legacy clk name binding.
Use \"vsync\" instead of \"vsync_clk\"[    8.532846] ------------[ cut
here ]------------
[    8.541651] WARNING: CPU: 1 PID: 32 at
/usr/src/kernel/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h:178
mdp5_bind+0x418/0x4e0 [msm]
[    8.546303] Modules linked in: crc32_ce adv7511 rfkill msm
mdt_loader drm_kms_helper drm msm_rng rng_core fuse
[    8.557504] CPU: 1 PID: 32 Comm: kworker/1:1 Not tainted 4.14.176-rc1 #1
[    8.567478] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
[    8.574344] Workqueue: events deferred_probe_work_func
[    8.581018] task: ffff80003d764680 task.stack: ffff00000a4c0000
[    8.586178] PC is at mdp5_bind+0x418/0x4e0 [msm]
[    8.591989] LR is at mdp5_bind+0x1b4/0x4e0 [msm]
[    8.596644] pc : [<ffff000000ebd6f8>] lr : [<ffff000000ebd494>]
pstate: 60000145
[    8.601246] sp : ffff00000a4c39d0
[    8.608617] x29: ffff00000a4c39d0 x28: 0000000000000000
[    8.611832] x27: ffff800037db4a00 x26: ffff000000eec9e8
[    8.617214] x25: ffff800037e28000 x24: ffff800037dc3810
[    8.622509] x23: ffff800037ca7000 x22: ffff00000a22e4b0
[    8.627805] x21: ffff800037dc3800 x20: 0000000000000000
[    8.633100] x19: ffff80003a8c2880 x18: 0000000000000010
[    8.638395] x17: 0000ffffb6f9ba28 x16: ffff0000082fd6e0
[    8.643691] x15: ffffffffffffffff x14: ffffffffffffffff
[    8.648986] x13: 0000000000000000 x12: 00000000e3d3f2dc
[    8.654280] x11: ffff80003d764eb0 x10: ffff00000a200000
[    8.659576] x9 : fffffffffffffffe x8 : 0000000000000000
[    8.664871] x7 : ffff0000087c908c x6 : 0000000000000000
[    8.670167] x5 : 0000000000000040 x4 : 0000000000000004
[    8.675461] x3 : fffffffffffffeb0 x2 : ffff000009d5f1a0
[    8.680755] x1 : ffff80003d764680 x0 : 0000000000000000
[    8.686052] Call trace:
[    8.691346] Exception stack(0xffff00000a4c3890 to 0xffff00000a4c39d0)
[    8.693521] 3880:
0000000000000000 ffff80003d764680
[    8.700120] 38a0: ffff000009d5f1a0 fffffffffffffeb0
0000000000000004 0000000000000040
[    8.707934] 38c0: 0000000000000000 ffff0000087c908c
0000000000000000 fffffffffffffffe
[    8.715746] 38e0: ffff00000a200000 ffff80003d764eb0
00000000e3d3f2dc 0000000000000000
[    8.723558] 3900: ffffffffffffffff ffffffffffffffff
ffff0000082fd6e0 0000ffffb6f9ba28
[    8.731372] 3920: 0000000000000010 ffff80003a8c2880
0000000000000000 ffff800037dc3800
[    8.739183] 3940: ffff00000a22e4b0 ffff800037ca7000
ffff800037dc3810 ffff800037e28000
[    8.746997] 3960: ffff000000eec9e8 ffff800037db4a00
0000000000000000 ffff00000a4c39d0
[    8.754809] 3980: ffff000000ebd494 ffff00000a4c39d0
ffff000000ebd6f8 0000000060000145
[    8.762622] 39a0: ffff00000a4c39d0 ffff000000ebd494
ffffffffffffffff 0000000000000000
[    8.770431] 39c0: ffff00000a4c39d0 ffff000000ebd6f8
[    8.778452] [<ffff000000ebd6f8>] mdp5_bind+0x418/0x4e0 [msm]
[    8.782937] [<ffff0000087b304c>] component_bind_all+0x104/0x298
[    8.789040] [<ffff000000ec8348>] msm_drm_bind+0x140/0x5f0 [msm]
[    8.794481] [<ffff0000087b2c70>] try_to_bring_up_master+0x180/0x1e0
[    8.800380] [<ffff0000087b2d78>] component_add+0xa8/0x170
[    8.806845] [<ffff000000ed3c54>] dsi_dev_probe+0x24/0x38 [msm]
[    8.812199] [<ffff0000087bc798>] platform_drv_probe+0x60/0xc0
[    8.817913] [<ffff0000087b9e70>] driver_probe_device+0x218/0x2e0
[    8.823730] [<ffff0000087ba0b4>] __device_attach_driver+0xa4/0xf0
[    8.829810] [<ffff0000087b7cfc>] bus_for_each_drv+0x5c/0xa8
[    8.835797] [<ffff0000087b9ad8>] __device_attach+0xd0/0x148
[    8.841177] [<ffff0000087ba17c>] device_initial_probe+0x24/0x30
[    8.846734] [<ffff0000087b8e80>] bus_probe_device+0xa0/0xa8
[    8.852638] [<ffff0000087b937c>] deferred_probe_work_func+0xac/0x158
[    8.858195] [<ffff00000810a558>] process_one_work+0x278/0x790
[    8.864800] [<ffff00000810aac0>] worker_thread+0x50/0x480
[    8.870441] [<ffff000008112570>] kthread+0x138/0x140
[    8.875823] [<ffff000008085be4>] ret_from_fork+0x10/0x1c
[    8.880846] ---[ end trace 73f4fbf7f1caf3f2 ]---
[    8.886661] msm 1a00000.mdss: bound 1a01000.mdp (ops mdp5_ops [msm])
[    8.891128] msm_dsi 1a98000.dsi: 1a98000.dsi supply gdsc not found,
using dummy regulator
[    8.897939] ------------[ cut here ]------------
[    8.905384] WARNING: CPU: 1 PID: 2210 at
/usr/src/kernel/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c:253
mdp5_disable+0xa0/0xb8 [msm]
[    8.909846] Modules linked in: crc32_ce adv7511 rfkill msm
mdt_loader drm_kms_helper drm msm_rng rng_core fuse
[    8.921401] CPU: 1 PID: 2210 Comm: kworker/1:2 Tainted: G        W
     4.14.176-rc1 #1
[    8.931289] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
[    8.939543] Workqueue: pm pm_runtime_work
[    8.946206] task: ffff80003a9c4680 task.stack: ffff00000e750000
[    8.950335] PC is at mdp5_disable+0xa0/0xb8 [msm]
[    8.956054] LR is at mdp5_disable+0x28/0xb8 [msm]
[    8.960705] pc : [<ffff000000ebd960>] lr : [<ffff000000ebd8e8>]
pstate: 40000145
[    8.965394] sp : ffff00000e753c10
[    8.972863] x29: ffff00000e753c10 x28: 0000000000000000
[    8.976068] x27: ffff00000948a000 x26: ffff00000813eba8
[    8.981451] x25: ffff00000e753d70 x24: 0000000000000000
[    8.986744] x23: ffff0000087c5138 x22: 0000000000000000
[    8.992049] x21: 000000000000000a x20: ffff800037dc3940
[    8.997344] x19: ffff80003a8c2880 x18: 0000000000000010
[    9.002640] x17: 0000ffffb6f9ba28 x16: ffff0000082fd6e0
[    9.007926] x15: ffffffffffffffff x14: 0000000000000001
[    9.013222] x13: 0000000000000010 x12: 000000002cdf788f
[    9.018516] x11: ffff80003a9c4eb0 x10: ffff00000a200000
[    9.023820] x9 : ffff00000e753d60 x8 : 0000000000000000
[    9.029114] x7 : ffff0000087c9d6c x6 : 0000000000000000
[    9.034416] x5 : 0000000000000040 x4 : 0000000000000002
[    9.039704] x3 : fffffffffffffeb0 x2 : ffff000000eec9e0
[    9.045000] x1 : 0000000000000002 x0 : 00000000ffffffff
[    9.050294] Call trace:
[    9.055582] Exception stack(0xffff00000e753ad0 to 0xffff00000e753c10)
[    9.057764] 3ac0:
00000000ffffffff 0000000000000002
[    9.064357] 3ae0: ffff000000eec9e0 fffffffffffffeb0
0000000000000002 0000000000000040
[    9.072171] 3b00: 0000000000000000 ffff0000087c9d6c
0000000000000000 ffff00000e753d60
[    9.079981] 3b20: ffff00000a200000 ffff80003a9c4eb0
000000002cdf788f 0000000000000010
[    9.087795] 3b40: 0000000000000001 ffffffffffffffff
ffff0000082fd6e0 0000ffffb6f9ba28
[    9.095607] 3b60: 0000000000000010 ffff80003a8c2880
ffff800037dc3940 000000000000000a
[    9.103419] 3b80: 0000000000000000 ffff0000087c5138
0000000000000000 ffff00000e753d70
[    9.111231] 3ba0: ffff00000813eba8 ffff00000948a000
0000000000000000 ffff00000e753c10
[    9.119045] 3bc0: ffff000000ebd8e8 ffff00000e753c10
ffff000000ebd960 0000000040000145
[    9.126856] 3be0: ffff80003a9c4680 fffffffffffffeb0
ffffffffffffffff 0000000000000040
[    9.134668] 3c00: ffff00000e753c10 ffff000000ebd960
[    9.142691] [<ffff000000ebd960>] mdp5_disable+0xa0/0xb8 [msm]
[    9.147383] [<ffff000000ebd9ac>] mdp5_runtime_suspend+0x34/0x50 [msm]
[    9.153076] [<ffff0000087c5174>] pm_generic_runtime_suspend+0x3c/0x58
[    9.159496] [<ffff0000087c9220>] __rpm_callback+0xe8/0x270
[    9.165919] [<ffff0000087c93dc>] rpm_callback+0x34/0xa0
[    9.171968] [<ffff0000087c7c18>] rpm_suspend+0x100/0x6e8
[    9.171988] [<ffff0000087c9dc8>] pm_runtime_work+0x80/0xc0
[    9.181980] [<ffff00000810a558>] process_one_work+0x278/0x790
[    9.187271] [<ffff00000810aac0>] worker_thread+0x50/0x480
[    9.193091] [<ffff000008112570>] kthread+0x138/0x140
[    9.198470] [<ffff000008085be4>] ret_from_fork+0x10/0x1c
[    9.203502] ---[ end trace 73f4fbf7f1caf3f3 ]---
[    9.209101] msm_dsi 1a98000.dsi: 1a98000.dsi supply gdsc not found,
using dummy regulator
[    9.215441] msm_dsi_host_set_src_pll: can't set parent to
byte_clk_src. ret=-22
[    9.221596] msm_dsi_manager_register: failed to register mipi dsi host#
[    9.230109] msm 1a00000.mdss: failed to bind 1a98000.dsi (ops
dsi_ops [msm]): -22
[    9.237107] msm 1a00000.mdss: master bind failed: -22
[    9.243823] msm_dsi: probe of 1a98000.dsi failed with error -22


metadata:
  git branch: linux-4.14.y
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  kernel-config:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/dragonboard-410c/lkft/linux-stable-rc-4.14/803/config

full test log,
https://lkft.validation.linaro.org/scheduler/job/1360268#L3514

git log --oneline  drivers/gpu/drm | head
89e30bb46074 drm/msm/dsi: save pll state before dsi host is powered off
892afde0f4a1 drm: msm: Fix return type of dsi_mgr_connector_mode_valid for kCFI
3824b96e06cc drm/msm/mdp5: rate limit pp done timeout warnings
b67d1c342e13 drm/i915/gvt: Separate display reset from ALL_ENGINES reset
313810964cac drm/msm: Set dma maximum segment size for mdss
edae04b8f463 drm/amdgpu/soc15: fix xclk for raven
3e85259525a1 radeon: insert 10ms sleep in dce5_crtc_load_lut
b06d001e8831 drm/nouveau/disp/nv50-: prevent oops when no channel
method map provided
e7f9d07dcc42 drm/vmwgfx: prevent memory leak in vmw_cmdbuf_res_add
bf24b7d69aea drm/nouveau: Fix copy-paste error in
nouveau_fence_wait_uevent_handler

-- 
Linaro LKFT
https://lkft.linaro.org
