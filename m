Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3267C227C20
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 11:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728865AbgGUJvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 05:51:54 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:54705 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbgGUJvy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 05:51:54 -0400
Received: from mail-qk1-f172.google.com ([209.85.222.172]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MdNwm-1kWsdi2xhw-00ZNzD; Tue, 21 Jul 2020 11:51:50 +0200
Received: by mail-qk1-f172.google.com with SMTP id h7so2755635qkk.7;
        Tue, 21 Jul 2020 02:51:50 -0700 (PDT)
X-Gm-Message-State: AOAM531u4LEAZ7tWv36mPVhFzqj9YunaiOr2n9Li7Y+3kopphRqFyVPj
        H9mGhZRyJRJL+peDSppyV2hlukZUhfJ2gFyV9Qk=
X-Google-Smtp-Source: ABdhPJxBRQhClmaMU2BXn01fDryDefa+/WaccJEhBLk9naWWoRxYwq34Rla1CU2pBQCz7qWbqe7+Ktr/GOqZmqq4mng=
X-Received: by 2002:a05:620a:1654:: with SMTP id c20mr25728174qko.138.1595325109197;
 Tue, 21 Jul 2020 02:51:49 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYvGXOcsF=70FVwOxqVYOeGTUuzhUzh5od1cKV1hshsW_g@mail.gmail.com>
In-Reply-To: <CA+G9fYvGXOcsF=70FVwOxqVYOeGTUuzhUzh5od1cKV1hshsW_g@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 21 Jul 2020 11:51:32 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1ReCDR8REM7AWMisiEJ_D45pC8dXaoYFFVG3aZj91e7Q@mail.gmail.com>
Message-ID: <CAK8P3a1ReCDR8REM7AWMisiEJ_D45pC8dXaoYFFVG3aZj91e7Q@mail.gmail.com>
Subject: Re: stable-rc 4.14: arm64: Internal error: Oops: clk_reparent
 __clk_set_parent_before on db410c
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux- stable <stable@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        freedreno <freedreno@lists.freedesktop.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Rob Clark <robdclark@chromium.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Eric Anholt <eric@anholt.net>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        samuel@sholland.org
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:b+FzA2uS0VCKNX+eJ5gdPPEron+dk5fj0I7YFYqOkVKsCguGJ/W
 6xoD843AK1R1Myn36CM5PSnvdMrUcTDNWpY8Hds8JLeSaLTzZSHjUc8zAS7NpVlO6rYbIwf
 uGQs50kSP7r1I+O+7BFqHCqArihLbVTxgydU8bC8M0ZZwhuhIDJBMFNRbsOuquNKl+i6tSK
 nlKQbt84O3JX2foDd4Vpg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:7tFTUK+kodQ=:4LTiNoFIlEOTEkHnRT4J+x
 CsVdqf5jGW+acg5w/FtfxFw/JLgILIgkj51q04BaYnKJtwBW1Y5ex4nJZD1QdxmZJx7aX0HLK
 AIcLhrivDVXmrdhhMd6GXmcHE5IXTPHtEngtfxaKmBO19/KS5AOH2hlyeJN8R4utgc1Ru96nE
 YX5I4ENNPGNUbDfhVxF9bygNfPVl/q9w+3IhlO9kqMBlFn85gym+FEf0KxMBYmiUvSuWBU6re
 eEukp6Db/ENPReYen5vWwY3Ej/G4+e1GsULqEQ2mUTsnJZ2jRmEvYyBasnEbFZB6/vEaa7VO/
 HK7PtVXI+wksCJqWZb6+qZSa6rAmSc6O4xSv6TDWXA9fzx+hj50V/TfY5IumuP/sPX9Tg1iGn
 t8mgSA3otRebGNLeTYgTQex15FjIB9CPTC9TvvhwUdqbfiG0qWUOmCO21Rn5nzhG8hC6WVOGu
 pZUCSdPQrhca8ZXPCgCZ1k21EEc9KuvN4Y7/sB1z27mk5H0u+9XkhUu874QXRx8qrjtUtHBTg
 7mHtC/qAmAE1cgnq1vkc2cnLs/mwl/2PJ17VBNrJGikRkj1MiUp7k/pKczysTO0ude8qArq7S
 GW7gct5KQWWWpVVqzAIfOdYGapJjcmmqaSqSiYGSo8LpMNZ4uXunt/qfh2Vd2EZZCB5gv4jM4
 bfo7EKO27SUMkqe1mLRhlFAYePxBPwBlLiW6bwNuPEpdIzGnyKVlqNDVqEl5+wpZcX/jUMidg
 FFIQfrv/4+0AnIeXcFebaYUqOz+TMDV9sN/k/gMt3YiIdmYZfYeooS+bngpMpXDiXtmujq2E5
 no0a6ihNYml9tHb4b6kkyU0oGfYdzhXItTfVxOOAFmwi25IoqFyHOfHEo0tCLM8V6cUzjPppD
 fNUPH6g9UvAwFsg0k4CgH5Ji6YDNaAokIKLUWVIDnCEc9yH2sGOsNq849PkCNxVxsfmCPS+B0
 NTG5rYjXk0kyj8QCQIZWUWjpjLBZjbWT8ViSEDQR3R0QoU1jgAJAU
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 21, 2020 at 10:32 AM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> Kernel Internal oops while booting stable-rc 4.14 kernel on qcom db410c device
> this problem happened only once on this specific platform.
> and  rcu_preempt detected stalls on CPUs/tasks detected after this and
> board hung.
>
> metadata:
>   git branch: linux-4.14.y
>   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>   git commit: 5b1e982af0f810358664827a6333affb4f5d8eb5
>   git describe: v4.14.188-126-g5b1e982af0f8
>   make_kernelversion: 4.14.189-rc1
>   kernel-config:
> https://builds.tuxbuild.com/12PM71zBW-5EAp5ztC_yxg/kernel.config

I looked at the object file at
https://builds.tuxbuild.com/12PM71zBW-5EAp5ztC_yxg/vmlinux.xz

> Crash dump:
>
> [    5.424958] Unable to handle kernel paging request at virtual
> address 00001008
> [    5.435485] Mem abort info:
> [    5.442509]   Exception class = DABT (current EL), IL = 32 bits
> [    5.445203]   SET = 0, FnV = 0
> [[    5.451101]   EA = 0, S1PTW =[    5.454226] Data abort info:
> [    5.457264]   ISV = 0, ISS = 0x00000044
> [    5.460390]   CM = 0, WnR = 1
> [    5.463951] user pgtable: 4k pages, 48-bit VAs, pgd = ffff80003d66d000
> [    5.467078] [0000000000001008] *pgd=0000000000000000
> [    5.473503] Internal error: Oops: 96000044 [#1] PREEMPT SMP
> [    5.479838] Modules linked in: adv7511 msm mdt_loader msm_rng
> drm_kms_helper rng_core drm fuse
> [    5.485405] Process kworker/2:0 (pid: 21, stack limit = 0xffff000009450000)
> [    5.494090] CPU: 2 PID: 21 Comm: kworker/2:0 Not tainted 4.14.189-rc1 #1
> [    5.501036] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
> [    5.507996] Workqueue: events deferred_probe_work_func
> [    5.514935] task: ffff80003d454380 task.stack: ffff000009450000
> [    5.520155] pc : clk_reparent+0x60/0xe8
> [    5.526058] lr : __clk_set_parent_before+0x40/0x88
> [    5.529882] sp : ffff000009453640 pstate : 800001c5
> [    5.534748] x29: ffff000009453640 x28: ffff0000090b7000
> [    5.539615] x27: ffff80003fe7c478 x26: ffff0000094537a8
> [    5.545175] x25: 0000000000000001 x24: ffff000009239038
> [    5.550736] x23: ffff80003b6be688 x22: 0000000000000000
> [    5.556297] x21: 0000000000000000 x20: ffff80003c9d8c00
> [    5.561858] x19: ffff80003d798900 x18: 00000000fffffffe
> [    5.567419] x17: 0000ffff7fdbb6a0 x16: ffff00000821ad98
> [    5.572980] x15: 0000000000000001 x14: ffffffffffffffff
> [    5.578540] x13: ffff0000094537c8 x12: 0000000000000010
> [    5.584102] x11: 0000000000000010 x10: 0101010101010101
> [    5.589663] x9 : 0000000000000000 x8 : 7f7f7f7f7f7f7f7f
> [    5.595223] x7 : fefefefefeff6e77 x6 : 0000000000000140
> [    5.600784] x5 : 0000000000000001 x4 : ffff80003c9d8c00
> [    5.606344] x3 : ffff80003d798900 x2 : 0000000000000004
> [    5.611905] x1 : ffff80003d7989a8 x0 : 0000000000001000
> [    5.617467] Call trace:
> [    5.623030]  clk_reparent+0x60/0xe8

We are here:

static void clk_reparent(struct clk_core *core, struct clk_core *new_parent)
{
        bool was_orphan = core->orphan;

        hlist_del(&core->child_node);

        if (new_parent) {
                bool becomes_orphan = new_parent->orphan;

                /* avoid duplicate POST_RATE_CHANGE notifications */
                if (new_parent->new_child == core)
                        new_parent->new_child = NULL;

                hlist_add_head(&core->child_node, &new_parent->children);


and "new_parent->children.first" points to 0x1000, which is not
a valid pointer, so the "first->pprev = &n->next" in hlist_add_head()
causes a crash.

> [    5.625465]  __clk_set_parent_before+0x40/0x88
> [    5.628943]  clk_register+0x330/0x618

(speculation) the most likely call chain here would be __clk_core_init(),
implying that there is some random other orphan clock that has a
broken parent:

        /*
         * walk the list of orphan clocks and reparent any that newly finds a
         * parent.
         */
        hlist_for_each_entry_safe(orphan, tmp2, &clk_orphan_list, child_node) {
                struct clk_core *parent = __clk_init_parent(orphan);

                /*
                 * We need to use __clk_set_parent_before() and _after() to
                 * to properly migrate any prepare/enable count of the orphan
                 * clock. This is important for CLK_IS_CRITICAL clocks, which
                 * are enabled during init but might not have a parent yet.
                 */
                if (parent) {
                        /* update the clk tree topology */
                        __clk_set_parent_before(orphan, parent);

None of the above have changed in stable kernels.

> [    5.633668]  pll_28nm_register+0xa4/0x340 [msm]
> [    5.637492]  msm_dsi_pll_28nm_init+0xc8/0x1d8 [msm]
> [    5.642007]  msm_dsi_pll_init+0x34/0xe0 [msm]
> [    5.646870]  dsi_phy_driver_probe+0x1cc/0x310 [msm]

The only changes to the dsi driver in v4.14-stable were:

89e30bb46074 drm/msm/dsi: save pll state before dsi host is powered off
892afde0f4a1 drm: msm: Fix return type of dsi_mgr_connector_mode_valid for kCFI
35ff594b0da2 drm/msm/dsi: Implement reset correctly
5151a0c8d730 drm/msm/dsi: use correct enum in dsi_get_cmd_fmt
e6bc3a4b0c23 clk: divider: fix incorrect usage of container_of

None of these look suspicious to me.

      Arnd

> [    5.651196]  platform_drv_probe+0x58/0xb8
> [    5.656060]  driver_probe_device+0x228/0x2d0
> [    5.660231]  __device_attach_driver+0xb8/0xe8
> [    5.664750]  bus_for_each_drv+0x64/0xa0
> [    5.669269]  __device_attach+0xcc/0x138
> [    5.673093]  device_initial_probe+0x10/0x18
> [    5.676918]  bus_probe_device+0x90/0x98
> [    5.681088]  device_add+0x3c4/0x5a8
> [    5.684915]  of_device_add+0x40/0x58
> [    5.688392]  of_platform_device_create_pdata+0x80/0xe8
> [    5.692219]  of_platform_bus_create+0xd4/0x308
> [    5.697432]  of_platform_populate+0x48/0xb8
> [    5.702143]  msm_pdev_probe+0x3c/0x328 [msm]
> [    5.706125]  platform_drv_probe+0x58/0xb8
> [    5.710642]  driver_probe_device+0x228/0x2d0
> [    5.714814]  __device_attach_driver+0xb8/0xe8
> [    5.719334]  bus_for_each_drv+0x64/0xa0
> [    5.723852]  __device_attach+0xcc/0x138
> [    5.727677]  device_initial_probe+0x10/0x18
> [    5.731502]  bus_probe_device+0x90/0x98
> [    5.735675]  deferred_probe_work_func+0xa4/0x140

It's worth noting that this is a deferred probe, so maybe
there is a race in the clk registration that gets hit if two drivers
register a clock at the same time?

> [    5.739502]  process_one_work+0x19c/0x300
> [    5.744366]  worker_thread+0x4c/0x420
> [    5.748539]  kthread+0x100/0x130
> [    5.752362]  ret_from_fork+0x10/0x1c
> [    5.755842] Code: 54000260 f9405080 f9005460 b4000040 (f9000401)
> [    5.759669] ---[ end trace 6d70d7dd8a236384 ]---
> [    5.765922] note: kworker/2:0[21] exited with preempt_count 1
> [   26.777168] INFO: rcu_preempt detected stalls on CPUs/tasks:
> [   26.777204] 0-...: (1 GPs behind) idle=2fa/140000000000001/0
> softirq=1679/1723 fqs=2625
> [   26.783112] 1-...: (1 GPs behind) idle=53a/140000000000000/0
> softirq=1946/1958 fqs=2625
> [   26.791444] (detected by 3, t=5252 jiffies, g=58, c=57, q=2362)
> [   26.799781] Task dump for CPU 0:
> [   26.806033] systemd-udevd   R  running task        0  2533      1 0x00000202
> [   26.809515] Call trace:
> [   26.816814]  __switch_to+0xe8/0x148
> [   26.819248]  __wake_up_common+0x80/0x170
> [   26.822724]  __wake_up_common_lock+0x7c/0xa8
> [   26.826897]  __wake_up_sync_key+0x1c/0x28
> [   26.831416]  sock_def_readable+0x40/0x88
> [   26.835584] Task dump for CPU 1:
> [   26.839755] systemd         R  running task        0     1      0 0x0000000a
> [   26.843237] Call trace:
> [   26.850531]  __switch_to+0xe8/0x148
> [   26.852968]  0xffff800009fc8000
> [   26.856467] INFO: rcu_sched detected stalls on CPUs/tasks:
> [   26.859584] 0-...: (1 GPs behind) idle=2fa/140000000000001/0
> softirq=1722/1723 fqs=2625
> [   26.865145] 1-...: (1 GPs behind) idle=53a/140000000000000/0
> softirq=1957/1958 fqs=2625
> [   26.873477] (detected by 3, t=5270 jiffies, g=-150, c=-151, q=3)
> [   26.881815] Task dump for CPU 0:
> [   26.888067] systemd-udevd   R  running task        0  2533      1 0x00000202
> [   26.891549] Call trace:
> [   26.898845]  __switch_to+0xe8/0x148
> [   26.901281]  __wake_up_common+0x80/0x170
> [   26.904758]  __wake_up_common_lock+0x7c/0xa8
> [   26.908931]  __wake_up_sync_key+0x1c/0x28
> [   26.913449]  sock_def_readable+0x40/0x88
> [   26.917618] Task dump for CPU 1:
> [   26.921790] systemd         R  running task        0     1      0 0x0000000a
> [   26.925271] Call trace:
> [   26.932565]  __switch_to+0xe8/0x148
> [   26.935002]  0xffff800009fc8000
> [   41.449201] random: crng init done
> [   41.449221] random: 7 urandom warning(s) missed due to ratelimiting
> [   89.797164] INFO: rcu_preempt detected stalls on CPUs/tasks:
> [   89.797195] 0-...: (1 GPs behind) idle=2fa/140000000000001/0
> softirq=1679/1723 fqs=10482
> [   89.803103] 1-...: (1 GPs behind) idle=53a/140000000000000/0
> softirq=1946/1958 fqs=10482
> [   89.811437] (detected by 3, t=21007 jiffies, g=58, c=57, q=2578)
> [   89.819773] Task dump for CPU 0:
> [   89.826027] systemd-udevd   R  running task        0  2533      1 0x00000202
> [   89.829508] Call trace:
> [   89.836807]  __switch_to+0xe8/0x148
> [   89.839241]  __wake_up_common+0x80/0x170
> [   89.842717]  __wake_up_common_lock+0x7c/0xa8
> [   89.846891]  __wake_up_sync_key+0x1c/0x28
> [   89.851410]  sock_def_readable+0x40/0x88
> <System Hung>
>
> Full test log,
> https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/build/v4.14.188-126-g5b1e982af0f8/testrun/2969667/suite/linux-log-parser/test/check-kernel-oops-1592908/log
>
>
> --
> Linaro LKFT
> https://lkft.linaro.org
