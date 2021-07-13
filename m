Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2DF3C748B
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 18:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhGMQfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 12:35:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30659 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229437AbhGMQfB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 12:35:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626193925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ynyw9tbWu8YeO7wEnHiaM9wG+awjKNn1e8S8PlFi8N4=;
        b=BP4QWeWs31UTXhHwlPUZhm5TDn62XyV7jVKQ2dDn0Qg9NfyF7lNbOPhk6tyK5FMjgCXVlA
        2h5vrsfbdgGLlLOWHud6+e3o+43M68BIzXY4awnf+SqJWNH+NeK4Ddw7kCpGjbepKaZhs3
        ZcGt+AjEXzOOFX6eFJhXDwZWSbnB/iw=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-awa5UDBBMiyo5XqTUZ60mw-1; Tue, 13 Jul 2021 12:32:02 -0400
X-MC-Unique: awa5UDBBMiyo5XqTUZ60mw-1
Received: by mail-lj1-f197.google.com with SMTP id z18-20020a2e96520000b0290178006de192so9232699ljh.3
        for <stable@vger.kernel.org>; Tue, 13 Jul 2021 09:32:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ynyw9tbWu8YeO7wEnHiaM9wG+awjKNn1e8S8PlFi8N4=;
        b=h+JfvDato1X4pATJyHbRL4+QfXh99B9AkHewiBCvStL9q/86sTXOMLv1v/eS9Xzqxr
         jwIRrg7XMNlwFsZSvpvUen+ED+EU5to+Y9uVjeFeJ269mzLeLIOYo6aUMmObgoz5hZhe
         zhlRoW2vY6lMe8Lpm6G2sREnmD6O9i3LHUQUbghzIAM1lExnb3LMfkUSVLOFeNyxJSE/
         7l+2h+CTJD3hQNc7qHF3v1z63NL4V76uY06ycEQfHrXJ3LZvXP1ilv6ZyG/CxhhFv9wJ
         CMUjqjiHqxabIKn8uE5UVsR/+QamXYG8FKxU9QXtMYTeMrR4cbjxvbShiwlblPPNLQmj
         KXIg==
X-Gm-Message-State: AOAM5311k/0h+S5Y2ClpMbymyyLs3X0zXrpS5FOz5dzzLinj0Zb+JD1b
        +U5f6veqqNshE/MyPTafRr/JzQ8NN+lEmfTAIJQgwjYViI80YP5tBf7o2dXtrWgvx9ZhlL0bwCJ
        cMogeUditjKon/VFvGJ75argQ5LnCLk+4
X-Received: by 2002:a05:6512:3b21:: with SMTP id f33mr4188272lfv.185.1626193920002;
        Tue, 13 Jul 2021 09:32:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwzthxLBHkTN5IKaxRD1d3ZSlpLUm/j7FNLxM70f0KTeWjQLpELyDkRszld+7vosKTIJtMXucqNCqB2bHovg/Q=
X-Received: by 2002:a05:6512:3b21:: with SMTP id f33mr4188241lfv.185.1626193919674;
 Tue, 13 Jul 2021 09:31:59 -0700 (PDT)
MIME-Version: 1.0
References: <cki.AEAEEEA6D2.TXY6U4DQIG@redhat.com>
In-Reply-To: <cki.AEAEEEA6D2.TXY6U4DQIG@redhat.com>
From:   Veronika Kabatova <vkabatov@redhat.com>
Date:   Tue, 13 Jul 2021 18:31:23 +0200
Message-ID: <CA+tGwnnq848NswpBS1Es0oobf+Wgqn7sfbsj-=+zV0QFnkazBg@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IOKdjCBGQUlMOiBUZXN0IHJlcG9ydCBmb3Iga2VybmVsIDUuMTMuMi1yYzEgKHN0YQ==?=
        =?UTF-8?B?YmxlLCA5NDkyNDFhZCk=?=
To:     CKI Project <cki-project@redhat.com>
Cc:     skt-results-master@redhat.com,
        Linux Stable maillist <stable@vger.kernel.org>,
        Li Wang <liwang@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 13, 2021 at 6:16 PM CKI Project <cki-project@redhat.com> wrote:
>
>
> Hello,
>
> We ran automated tests on a recent commit from this kernel tree:
>
>        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stabl=
e/linux-stable-rc.git
>             Commit: 949241ad55a9 - Linux 5.13.2-rc1
>
> The results of these automated tests are provided below.
>
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: OK
>              Tests: FAILED
>
> All kernel binaries, config files, and logs are available for download he=
re:
>
>   https://arr-cki-prod-datawarehouse-public.s3.amazonaws.com/index.html?p=
refix=3Ddatawarehouse-public/2021/07/12/335680374
>
> One or more kernel tests failed:
>
>     ppc64le:
>      =E2=9D=8C LTP
>
>     aarch64:
>      =E2=9D=8C Boot test
>

Hi,

I'm not sure why the reporter is ignoring a panic on ppc64le, but it is vis=
ible
in the console log. Direct link:

https://arr-cki-prod-datawarehouse-public.s3.amazonaws.com/datawarehouse-pu=
blic/2021/07/12/335680374/build_ppc64le_redhat%3A1418169689/tests/10288413_=
ppc64le_1_console.log

Look for "call trace" or "bfq_finish_requeue_request". The panic is
reproducible 100% on POWER8. The panic goes away if the following
patch is reverted:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/=
commit/?h=3Dlinux-5.13.y&id=3Da483f513670541227e6a31ac7141826b8c785842

For the aarch64 boot failure, we cannot reproduce it reliably. The console
log is available in the artifacts link, direct:

https://s3.us-east-1.amazonaws.com/arr-cki-prod-datawarehouse-public/datawa=
rehouse-public/2021/07/12/335680374/build_aarch64_redhat:1418169681/tests/1=
0288401_aarch64_1_console.log

We couldn't reproduce the lockup trace, but while trying to do it we
instead saw some rcu stalls, the trace was same on two different runs.
Not sure if they are related to the original boot lockup or not:

INFO: rcu_sched detec ted stalls on C..0: (0 ticks this GP)
idle=3Db9e/1/0x4000000000000000 softirq=3D421/421 fqs=3D1706
[  178.152710] (detected by 60, t=3D6003 jiffies, g=3D4649, q=3D3457)
[  178.158450] Task dump for CPU 85:
[  178.161756] task:kworker/u513:2  state:R  running task     stack:
 0 pid: 1650 ppid:     2 flags:0x0000000a
[  178.171670] Workqueue: writeback wb_workfn (flush-8:0)
[  178.176813] Call trace:
[  178.179248]  __switch_to+0x108/0x134
[  178. 182822]  0xffff[-- MARK -- Tue Jul 13 15:35:00 2021]
[  183.157641] rcu: INFO: rcu_sched detected expedited stalls on
CPUs/tasks: { 85-... } 6485 jiffies s: 833 root: 0x20/.
[  183.168282] rcu: blocking rcu_node structures (internal RCU debug):
l=3D1:80-95:0x20/.
[  183.176025] Task dump for CPU 85:
[  183.179345] task:kworker/u513:2  stat e:R  running ta  2 flags:0x0000000=
a
[  183.189271] Workqueue: writeback wb_workfn (flush-8:0)
[  183.194409] Call trace:
[  183.196844]  __switch_to+0x108/0x134
[  183.200428]  0xffff000807de4180
[  358.186779] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[  358.192699] rcu: 85-...0: (0 ticks this GP)
idle=3Db9e/1/0x4000000000000000 softirq=3D421/421  fqs=3D6863
[  jiffies, g=3D4649, q=3D12800)
[  358.207852] Task dump for CPU 85:
[  358.211157] task:kworker/u513:2  state:R  running task     stack:
 0 pid: 1650 ppid:     2 flags:0x0000000a
[  358.221068] Workqueue: writeback wb_workfn (flush-8:0)
[  358.226206] Call trace:
[  358.228641]  __switch_to+0x108/0x134
[  358.232212]  0xffff000807de4180
[  367.476761] rcu: INFO:  rcu_sched dete-... } 24917 jiffies s: 833
root: 0x20/.
[  367.487481] rcu: blocking rcu_node structures (internal RCU debug):
l=3D1:80-95:0x20/.
[  367.495224] Task dump for CPU 85:
[  367.498538] task:kworker/u513:2  state:R  running task     stack:
 0 pid: 1650 ppid:     2 flags:0x0000000a
[  367.508456] Workqueue: writeback wb_workfn (flush-8:0)
[  367.513594] Call trace:
[  367.516029]  __switch_to+0x108/0x134
[  367.519607]  0xffff000807de4180
[-- MARK -- Tue Jul 13 15:40:00 2021]
[  538.235960] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[  538.241879] rcu: 85-...0: (0 ticks this GP)
idle=3Db9e/1/0x4000000000000000 softirq=3D421/421 fqs=3D12725
[  538.251112] (detected by 16, t=3D42013 jiffies, g=3D4649, q=3D22145)
[  538.257026] Task dump for CPU 85:
[   538.260331] t     stack:    0 pid: 1650 ppid:     2 flags:0x0000000a
[  538.270241] Workqueue: writeback wb_workfn (flush-8:0)
[  538.275379] Call trace:
[  538.277814]  __switch_to+0x108/0x134
[  538.281385]  0xffff000807de4180
[  551.795927] rcu: INFO: rcu_sched detected expedited stalls on
CPUs/tasks: { 85-... } 43349 jiffies s: 833 root: 0x20/.
[  551.806641] rcu: blocking rcu_node structures (internal RCU debug):
l=3D1:80-95:0x20/.
[  551.814384] Task dump for CPU 85:
[  551. 817697] task:kw    stack:    0 pid: 1650 ppid:     2 flags:0x000000=
0a
[  551.827614] Workqueue: writeback wb_workfn (flush-8:0)
[  551.832751] Call trace:
[  551.835186]  __switch_to+0x108/0x134
[  551.838763]  0xffff000807de4180
[  718.285222] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[  718.291140] rcu: 85-...0: (0 ticks this GP)
idle=3Db9e/1/0x4000000000000000 softirq=3D421/421 fqs=3D18713
[  718.300377] (detected by 48, t=3D60018 jiffies, g=3D4649, q=3D30763)
[  718.306291] Task dump for CPU 85:
[  718.309595] task:kworker/u513:2  state:R  running task     stack:
 0 pid: 1650 ppid:     2 flags:0x0000000a
[  718.319505]  Workqueue: writ.324642] Call trace:
[  718.327077]  __switch_to+0x108/0x134
[  718.330647]  0xffff000807de4180
[   736.115176] rdited stalls on CPUs/tasks: { 85-... } 61781 jiffies
s: 833 root: 0x20/.
[  736.125890] rcu: blocking rcu_node structures (internal RCU debug):
l=3D1:80-95:0x20/.
[  736.133632] Task dump for CPU 85:
[  736.136943] task:kworker/u513:2  state:R  running task     stack:
 0 pid: 1650 ppid:     2 flags:0x0000000a
[  736.146861] Workqueue: writeback wb_workfn (flush-8:0)
[  736.151998] Call trace:
[  736.154432]  __switch_to+0x1 08/0x134
[  73[-- MARK -- Tue Jul 13 15:45:00 2021]
[  891.634611] ------------[ cut here ]------------
[  891.639223] NETDEV WATCHDOG: enp11s0f0np0 (mlx5_c ore): transmit G:
CPU: 63 PID: 0 at net/sched/sch_generic.c:467 dev_watchdog+0x374/0x37c
[  891.655173] Modules linked in: rfkill vfat fat rpcrdma sunrpc
rdma_ucm ib_srpt ib_isert iscsi_target_mod target_core_mod ib_iser
libiscsi scsi_transport_iscsi ib_umad rdma_cm ib_ipoib iw_cm ib_cm
mlx5_ib ib_uverbs ib_core acpi_ipmi joydev ipmi_ssif i2c_smbus
mlx5_core psample mlxfw ipmi_devintf ipmi_msghandler thunderx2_pmu
cppc_cpufreq fuse zram ip_tab les xfs ast crcm_helper drm_kms_helper
syscopyarea sysfillrect sysimgblt fb_sys_fops cec drm_ttm_helper ttm
drm gpio_xlp i2c_xlp9xx uas usb_storage aes_neon_bs
[  891.703738] CPU: 63 PID: 0 Comm: swapper/63 Not tainted 5.13.2-rc1 #1
[  891.710171] Hardware name: HPE ASSY,ARx4z
SystemBoard/Comanche_2S_CN99X_ARM , BIOS L50_5.13_1.11 06/18/2019
[  891.719901] pstate: 40400009 (nZcv daif +PAN -UAO -TCO BTYPE=3D--)
[  891.725900] pc : dev_watchdog+ 0x374/0x37c
[ x37c
[  891.733904] sp : ffff800012b83d60
[  891.737207] x29: ffff800012b83d60 x28: 0000000000000000 x27: ffff8000118=
13000
[  891.744340] x26: 0000000000000001 x25: 0000000000000140 x24: 00000000fff=
fffff
[  891.751470] x23: 000000000000003f x22: ffff000854f00480 x21: ffff800011d=
37000
[  891.758600] x20: ffff000854f00000 x19: 0000000000000017 x18: 00000000000=
00000
[  891.765731] x17: 0000000000000001 x16: 0000000000000019 x1 5:
000000000000fff x13: ffff800092b83a8f x12: ffff800012b83a97
[  891.779989] x11: ffff008f53a80000 x10: 00000000ffff0000 x9 : ffff8000102=
32988
[  891.787119] x8 : 0000000000000000 x7 : ffff008f53500000 x6 : 00000000000=
2fffd
[  891.794249] x5 : 0000000000000000 x4 : ffff000f5c5e3148 x3 : ffff000f5c5=
f0ef0
[  891.801377] x2 : ffff000f5c5e3148 x1 : ffff800f4adcd000 x0 : 00000000000=
00046
[  891.808507] Call trace:
[  891.810944]  dev_watchdog +0x374/0x37c
[
[  891.818256]  __run_timers.part.0+0x290/0x330
[  891.822517]  run_timer_softirq+0x48/0x80
[  891.826430]  __do_softirq+0x128/0x388
[  891.830084]  __irq_exit_rcu+0x168/0x170
[  891.833915]  irq_exit+0x1c/0x30
[  891.837048]  __handle_domain_irq+0x8c/0xec
[  891.841139]  gic_handle_irq+0x5c/0xdc
[  891.844791]  el1_irq+0xc0/0x148
[  891.847923]  arch_cpu_idle+0x18/0x30
[  891.851490]  default_idle_call+0x4c/0x160
[  89 1.855494]  cpui585]  do_idle+0xbc/0x110
[  891.862718]  cpu_startup_entry+0x34/0x9c
[  891.866633]  secondary_start_kernel+0xf4/0x120
[  891.871072] ---[ end trace 4867eab29f724990 ]---
[  891.875689] mlx5_core 0000:0b:00.0 enp11s0f0np0: TX timeout detected
[  891.882060] mlx5_core 0000:0b:00.0 enp11s0f0np0: TX timeout on
queue: 23, SQ: 0x195, CQ: 0x9a, SQ Cons: 0x1 SQ Prod: 0x2, usecs since
last trans: 29710000
[  891.895925] mlx5_core 0 000:0b:00.0 enp 0xa2
[  891.903522] mlx5_core 0000:0b:00.0 enp11s0f0np0: Recovered 2 eqes on EQ =
0x2a
[  898.334537] rcu: INFO: rcu_sched detec ted stalls on C..0: (0 ticks
this GP) idle=3Db9e/1/0x4000000000000000 softirq=3D421/421 fqs=3D24701
[  898.349691] (detected by 54, t=3D78023 jiffies, g=3D4649, q=3D39150)
[  898.355606] Task dump for CPU 85:
[  898.358910] task:kworker/u513:2  state:R  running task     stack:
 0 pid: 1650 ppid:     2 flags:0x0000000a
[  898.368821] Workqueue: writeback wb_workfn (flush-8:0)
[  898.373959] Call trace:
[  898.376395]  __switch_to+0x108/0x134
[  8 98.379965]  0xf[  920.434478] rcu: INFO: rcu_sched detected
expedited stalls on CPUs/tasks: { 85-... } 80213 jiffies s: 833 root:
0x20/.
[  920.445191] rcu: blocking rcu_node structures (internal RCU debug):
l=3D1:80-95:0x20/.
[  92 0.452933] Task rker/u513:2  state:R  running task     stack:
0 pid: 1650 ppid:     2 flags:0x0000000a
[  920.466163] Workqueue: writeback wb_workfn (flush-8:0)
[  920.471299] Call trace:
[  920.473734]  __switch_to+0x108/0x134
[  920.477312]  0xffff000807de4180
[ 1078.383857] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:



Veronika

> We hope that these logs can help you find the problem quickly. For the fu=
ll
> detail on our testing procedures, please scroll to the bottom of this mes=
sage.
>
> Please reply to this email if you have any questions about the tests that=
 we
> ran or if you have any suggestions on how to make future tests more effec=
tive.
>
>         ,-.   ,-.
>        ( C ) ( K )  Continuous
>         `-',-.`-'   Kernel
>           ( I )     Integration
>            `-'
> _________________________________________________________________________=
_____
>
> Compile testing
> ---------------
>
> We compiled the kernel for 4 architectures:
>

<snip>

