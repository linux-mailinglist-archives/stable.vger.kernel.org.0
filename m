Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFDDEE17B
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 14:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbfKDNq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 08:46:26 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:36645 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727663AbfKDNqZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 08:46:25 -0500
Received: by mail-lf1-f66.google.com with SMTP id a6so8886817lfo.3
        for <stable@vger.kernel.org>; Mon, 04 Nov 2019 05:46:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=G/42w8BC1CKlTirE0iFyAOpHQU7VI05VqMsTRfAKs2I=;
        b=I+2ukIwN1cr77ud6MYgcwJTCx1tkbUNmIVXHOR35airm6e38dUWMNIrO1LdULsulrR
         4BlTvEfgjMlztqREGHM3U//g5Kkp9JwGl55sC92sFLvBGVLjcb7dwB5Ue6PMGts8xu+Z
         /OQ9xBs6PBxjBpoZVglO3PJgKVTmKDWPTCTVVtPTW/K/mVgB7MnAPOJAGms8WyE92lZt
         ahE9GUGlFcrPjoQ3JeMEdG7JIyPUM9tWzln9jTX3bR+zfjRniEG39lpd0uJ0/gku+VPK
         soywL+D7uWiHQy9wYho8/+NRNqaNRmcCxtwIoRASjkPTZimBYoG71fX0Tuyf2rjdnWX1
         FnCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=G/42w8BC1CKlTirE0iFyAOpHQU7VI05VqMsTRfAKs2I=;
        b=fVvRPMNmsOFJNyV6zzdF4JgXkf20+D5//Jy6K6y7dzGq49ATpYj/gRrivISuDRSax8
         eooL8LHNBLy/AAOI+Ke7F/oldOsBk39Y0ZlNzprT3Vvo+/rwiJ/+2hoXtyWAmXAlC8gI
         W3W1tNZzZ7Eh3hnEx1cSl8ySGwVIzRM9U1YL36tvKGfe/yPdm6p7OT67EtyKxATdy2sk
         URK31jPSsy68w9E37IgWC5EiaYCaoQHjODWFPIToe6N02C06CjQnd1I8TFFin9XBmYet
         tj07skB19x1YqA6TOhtxStU9NO50d68ldXIMh3IEmIh7cVRrNQO4slkh5zId3NLe8lqj
         RkNw==
X-Gm-Message-State: APjAAAWePrIZKqkoDdBYV8I8gfZ6BEWet20pQUE//xexyVVEtTEEwaay
        CZtLCjaUZpiUPL7OIl/Wou3BNPkQQlFAHqLAx4llrA==
X-Google-Smtp-Source: APXvYqxBkPjal82I4aAjinMPGSTsAa6bX63riJyDyu5WrMK/SseZHlnGaRP9iYvUEkLbXYHTRnsaGCk0kd3Wsg5mWmU=
X-Received: by 2002:ac2:48b5:: with SMTP id u21mr17158943lfg.75.1572875182511;
 Mon, 04 Nov 2019 05:46:22 -0800 (PST)
MIME-Version: 1.0
References: <cki.462EE8B116.HM2586PHBR@redhat.com>
In-Reply-To: <cki.462EE8B116.HM2586PHBR@redhat.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 4 Nov 2019 19:16:10 +0530
Message-ID: <CA+G9fYvJAcM1zWtR=3sb6KDf1x8Z5=SOdZqRYwWfNZ1d_Tr=_g@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=E2=9D=8C_FAIL=3A_Test_report_for_kernel_5=2E3=2E9=2Drc1=2Dff21a?=
        =?UTF-8?Q?f2=2Ecki_=28stable=29?=
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 4 Nov 2019 at 18:14, CKI Project <cki-project@redhat.com> wrote:
>
>
> Hello,
>
> We ran automated tests on a recent commit from this kernel tree:
>
>        Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/=
linux-stable-rc.git
>             Commit: ff21af282725 - Linux 5.3.9-rc1
>
> The results of these automated tests are provided below.
>
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: OK
>              Tests: FAILED

While going through the boot failure logs kernel warning and kernel
panics have been noticed.

   aarch64:
   ppc64le:
   x86_64:
     =E2=9D=8C Boot test


arm64 host 2 failure log,

Linux version 5.3.9-rc1-ff21af2.cki
....

[   48.230795] systemd-journald[1707]: Received SIGTERM from PID 1 (systemd=
).
[   48.277531] printk: systemd: 17 output lines suppressed due to ratelimit=
ing
[   48.956717] SELinux:  policy capability network_peer_controls=3D1
[   48.962639] SELinux:  policy capability open_perms=3D1
[   48.967590] SELinux:  policy capability extended_socket_class=3D1
[   48.973501] SELinux:  policy capability always_check_network=3D0
[   48.979319] SELinux:  policy capability cgroup_seclabel=3D1
[   48.984707] SELinux:  policy capability nnp_nosuid_transition=3D1
[   49.111194] Unable to handle kernel paging request at virtual
address fffe00002225e9f8
[   49.119099] Mem abort info:
[   49.121885]   ESR =3D 0x96000044
[   49.124926]   Exception class =3D DABT (current EL), IL =3D 32 bits
[   49.130832]   SET =3D 0, FnV =3D 0
[   49.133877]   EA =3D 0, S1PTW =3D 0
[   49.137004] Data abort info:
[   49.139871]   ISV =3D 0, ISS =3D 0x00000044
[   49.143696]   CM =3D 0, WnR =3D 1
[   49.146650] [fffe00002225e9f8] address between user and kernel address r=
anges
[   49.153779] Internal error: Oops: 96000044 [#1] SMP
[   49.158645] Modules linked in: xfs libcrc32c ast i2c_algo_bit
drm_vram_helper uas ttm drm_kms_helper syscopyarea sysfillrect
sysimgblt fb_sys_fops usb_storage drm gpio_xlp i2c_xlp9xx
[   49.174897] CPU: 27 PID: 1 Comm: systemd Tainted: G        W
 5.3.9-rc1-ff21af2.cki #1
[   49.183406] Hardware name: HPE Apollo 70             /C01_APACHE_MB
        , BIOS L50_5.13_1.11 06/18/2019
[   49.193132] pstate: 00400009 (nzcv daif +PAN -UAO)
[   49.197916] pc : queued_spin_lock_slowpath+0x240/0x2d8
[   49.203044] lr : __fib6_clean_all+0xc8/0x100
[   49.207300] sp : ffff0000120dbbe0
[   49.210601] x29: ffff0000120dbbe0 x28: ffff800f4e18801c
[   49.215900] x27: 0000000000000000 x26: 0000000000000000
[   49.221198] x25: 0000000000000000 x24: 0000000000000002
[   49.226495] x23: 0000000000000000 x22: ffff000010b20838
[   49.231793] x21: ffff0000118cb5c0 x20: 00000000ffff800f
[   49.237090] x19: ffff800f4e18801c x18: 0000000000000000
[   49.242388] x17: 000000000b8f1ad6 x16: 00000000e2893b39
[   49.247686] x15: ffffffffffffffff x14: ffffffffffffff00
[   49.252983] x13: ffffffffffffffff x12: 0000000000000001
[   49.258281] x11: ffff000010f3f670 x10: 00000000000019b0
[   49.263578] x9 : ffff0000120db9a0 x8 : ffff000010f4c988
[   49.268876] x7 : 0000000000000000 x6 : ffff800f5c21e040
[   49.274173] x5 : 0000000000700000 x4 : ffff800f5c21e040
[   49.279471] x3 : ffff000011312040 x2 : ffff000011312070
[   49.284768] x1 : ffff000011312070 x0 : ffff800f5c21e048
[   49.290066] Call trace:
[   49.292501]  queued_spin_lock_slowpath+0x240/0x2d8
[   49.297279]  __fib6_clean_all+0xc8/0x100
[   49.301188]  fib6_flush_trees+0x38/0x48
[   49.305013]  security_load_policy+0x29c/0x5e8
[   49.309358]  sel_write_load+0x10c/0x200
[   49.313183]  __vfs_write+0x48/0x90
[   49.316572]  vfs_write+0xac/0x1b8
[   49.319873]  ksys_write+0x64/0xe0
[   49.323175]  __arm64_sys_write+0x24/0x30
[   49.327088]  el0_svc_common.constprop.0+0x74/0x168
[   49.331865]  el0_svc_handler+0x34/0x90
[   49.335602]  el0_svc+0x8/0xc
[   49.338474] Code: 910020c0 8b020062 f861d908 aa0203e1 (f8286826)
[   49.344619] ---[ end trace 4f9e552a506205dd ]---
[   49.349223] Kernel panic - not syncing: Fatal exception in interrupt
[   49.355584] SMP: stopping secondary CPUs
[   49.359538] Kernel Offset: disabled
[   49.363014] CPU features: 0x6002,22000c38
[   49.367010] Memory Limit: none
[   49.370074] ---[ end Kernel panic - not syncing: Fatal exception in
interrupt ]---


arm64 host 1 failure log,
--------------------------------
[    8.825895] systemd-journald[306]: Received SIGTERM from PID 1 (systemd)=
.
[    8.965523] printk: systemd: 16 output lines suppressed due to ratelimit=
ing
[   10.472247] SELinux:  policy capability network_peer_controls=3D1
[   10.478149] SELinux:  policy capability open_perms=3D1
[   10.483106] SELinux:  policy capability extended_socket_class=3D1
[   10.488996] SELinux:  policy capability always_check_network=3D0
[   10.494813] SELinux:  policy capability cgroup_seclabel=3D1
[   10.500184] SELinux:  policy capability nnp_nosuid_transition=3D1
[   10.580715] WARNING: CPU: 5 PID: 1 at net/ipv6/ip6_fib.c:1957
fib6_walk_continue+0x1a4/0x1d8
[   10.589118] Modules linked in: xfs libcrc32c sdhci_of_arasan
i2c_xgene_slimpro sdhci_pltfm sdhci gpio_dwapb cqhci xhci_plat_hcd
gpio_xgene_sb gpio_keys
[   10.602625] CPU: 5 PID: 1 Comm: systemd Tainted: G        W
5.3.9-rc1-ff21af2.cki #1
[   10.611022] Hardware name: AppliedMicro X-Gene Mustang Board/X-Gene
Mustang Board, BIOS 3.06.25 Oct 17 2016
[   10.620715] pstate: 00400005 (nzcv daif +PAN -UAO)
[   10.625482] pc : fib6_walk_continue+0x1a4/0x1d8
[   10.629989] lr : fib6_walk+0x40/0x80
[   10.633544] sp : ffff00001006baf0
[   10.636841] x29: ffff00001006baf0 x28: ffff8001efe82814
[   10.642126] x27: 0000000000000000 x26: 0000000000000000
[   10.647411] x25: 0000000000000000 x24: 0000000000000000
[   10.652696] x23: ffff8001efe82818 x22: 0000000000000000
[   10.657981] x21: ffff0000118cb5c0 x20: 0000000000000000
[   10.663265] x19: ffff00001006bba0 x18: 0000000000000000
[   10.668550] x17: 0000000000000000 x16: 0000000000000000
[   10.673834] x15: ffffffffffffffff x14: ffffffffffffff00
[   10.679119] x13: ffffffffffffffff x12: 0000000000000001
[   10.684404] x11: ffff000010f3f670 x10: 00000000000019b0
[   10.689688] x9 : ffff00001006b9a0 x8 : ffff8001ee8c1814
[   10.694973] x7 : 0000000000000000 x6 : 0000000000000366
[   10.700258] x5 : 0000000000000000 x4 : ffff0000118cbd20
[   10.705542] x3 : ffff0000118cbe00 x2 : ffff8001fd9d5a00
[   10.710827] x1 : ffff8001fd9d5a00 x0 : 0000000000000000
[   10.716112] Call trace:
[   10.718546]  fib6_walk_continue+0x1a4/0x1d8
[   10.722708]  fib6_walk+0x40/0x80
[   10.725919]  fib6_clean_tree+0x64/0x78
[   10.729649]  __fib6_clean_all+0x78/0x100
[   10.733551]  fib6_flush_trees+0x38/0x48
[   10.737369]  security_load_policy+0x29c/0x5e8
[   10.741704]  sel_write_load+0x10c/0x200
[   10.745521]  __vfs_write+0x48/0x90
[   10.748905]  vfs_write+0xac/0x1b8
[   10.752202]  ksys_write+0x64/0xe0
[   10.755499]  __arm64_sys_write+0x24/0x30
[   10.759402]  el0_svc_common.constprop.0+0x74/0x168
[   10.764169]  el0_svc_handler+0x34/0x90
[   10.767899]  el0_svc+0x8/0xc
[   10.770764] ---[ end trace 908987db50058d8b ]---
[   36.370645] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [systemd:1=
]
[   36.377402] Modules linked in: xfs libcrc32c sdhci_of_arasan
i2c_xgene_slimpro sdhci_pltfm sdhci gpio_dwapb cqhci xhci_plat_hcd
gpio_xgene_sb gpio_keys
[   36.390904] CPU: 5 PID: 1 Comm: systemd Tainted: G        W
5.3.9-rc1-ff21af2.cki #1
[   36.399300] Hardware name: AppliedMicro X-Gene Mustang Board/X-Gene
Mustang Board, BIOS 3.06.25 Oct 17 2016
[   36.408992] pstate: 00400005 (nzcv daif +PAN -UAO)
[   36.413761] pc : fib6_walk_continue+0x1a8/0x1d8
[   36.418268] lr : fib6_walk+0x40/0x80
[   36.421823] sp : ffff00001006baf0
[   36.425119] x29: ffff00001006baf0 x28: ffff8001efe82814
[   36.430404] x27: 0000000000000000 x26: 0000000000000000
[   36.435689] x25: 0000000000000000 x24: 0000000000000000
[   36.440974] x23: ffff8001efe82818 x22: 0000000000000000
[   36.446258] x21: ffff0000118cb5c0 x20: 0000000000000000
[   36.451543] x19: ffff00001006bba0 x18: 0000000000000000
[   36.456828] x17: 0000000000000000 x16: 0000000000000000
[   36.462113] x15: ffffffffffffffff x14:
 ffffffffffffff00
[   36.467397] x13: ffffffffffffffff x12: 0000000000000001
[   36.472682] x11: ffff000010f3f670 x10: 0000000000000001
[   36.477966] x9 : 0000000000000000 x8 : ffff8001feef14a8
[   36.483251] x7 : 0000000000000000 x6 : 000000015e261b39
[   36.488536] x5 : 0000000000000000 x4 : ffff0000118cbd20
[   36.493820] x3 : ffff0000118cbe00 x2 : ffff8001fd9d5a00
[   36.499105] x1 : ffff8001fd9d5a00 x0 : 0000000000000000
[   36.504389] Call trace:
[   36.506823]  fib6_walk_continue+0x1a8/0x1d8
[   36.510984]  fib6_walk+0x40/0x80
[   36.514195]  fib6_clean_tree+0x64/0x78
[   36.517925]  __fib6_clean_all+0x78/0x100
[   36.521827]  fib6_flush_trees+0x38/0x48
[   36.525643]  security_load_policy+0x29c/0x5e8
[   36.529978]  sel_write_load+0x10c/0x200
[   36.533794]  __vfs_write+0x48/0x90
[   36.537178]  vfs_write+0xac/0x1b8
[   36.540475]  ksys_write+0x64/0xe0
[   36.543772]  __arm64_sys_write+0x24/0x30
[   36.547675]  el0_svc_common.constprop.0+0x74/0x168
[   36.552441]  el0_svc_handler+0x34/0x90
[   36.556171]  el0_svc+0x8/0xc
[   64.370649] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [systemd:1=
]
...
[ 1500.504373] Call trace:
[ 1500.506806]  fib6_walk_continue+0x1a8/0x1d8
[ 1500.510968]  fib6_walk+0x40/0x80
[ 1500.514180]  fib6_clean_tree+0x64/0x78
[ 1500.517909]  __fib6_clean_all+0x78/0x100
[ 1500.521812]  fib6_flush_trees+0x38/0x48
[ 1500.525628]  security_load_policy+0x29c/0x5e8
[ 1500.529962]  sel_write_load+0x10c/0x200
[ 1500.533778]  __vfs_write+0x48/0x90
[ 1500.537161]  vfs_write+0xac/0x1b8
[ 1500.540458]  ksys_write+0x64/0xe0
[ 1500.543756]  __arm64_sys_write+0x24/0x30
[ 1500.547658]  el0_svc_common.constprop.0+0x74/0x168
[ 1500.552425]  el0_svc_handler+0x34/0x90
[ 1500.556154]  el0_svc+0x8/0xc

Kernel config,
https://artifacts.cki-project.org/pipelines/263738/kernel-stable-aarch64-ff=
21af282725ae2ebc3ac4298513816f760c929e.config
