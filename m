Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4835B8553
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbiINJmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbiINJmW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:42:22 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7D861B00
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 02:41:44 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id u9so33426173ejy.5
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 02:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=2QTHjIJATAE4dtWLgNMw1b7pLdmY12OOr8muR2WBpL4=;
        b=qUSJ+kB7WeMughU7epaBGxTIAb+DOXq/S5E+tJzQ7wVUAy39LaFMWrefM2ApsJ8J/r
         t+Sk5sbcB6f8ZjHtmGdIJccHUS/tTnBcy7pNIcTD4RjhW0AjgmhlyrQSc2bwD14cTkpq
         KQdWFhpGCurDfmVOAFhCW8yDIMftIbDwWUSyiDrGcHeb8zMDj5FX7H7P326T+Visw6z9
         X/qzWvJB0tI8ZFKjzUDFGBggNrNFPgsMLj0aNhTe2eQWusCgCdV42P+sQcuey5I/yTGN
         HV6oM3pWbx082M0S3mWm6gGWXgJq1a9KyJAjhdFC5u3Z5uqRexPDpUtNl6YU0+6bBkAw
         zpOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=2QTHjIJATAE4dtWLgNMw1b7pLdmY12OOr8muR2WBpL4=;
        b=1j73L/cERYiKpLlF1+xE7ei1PxUgqOUhcJq9/I9VLmE/KqGGs4dRIiwK4uQdqZEcQW
         YYVc1I8Ev18Ilr32wAxr/wqP+C43G3y6Y0vzWFvhvXeTrGFAbKy+72SGSb/U8D1PaCgF
         VydS8Y3DWBBmexNJNsuhShL/PRfAqXAnpfeHVHsVnVG/ArFdYHc8AwagRXg14LS6Sxrt
         XZtTRCu1BREo3hPBChIRPUyzjiO9fZcWDCAWanlPjUxq/98Vaem/VWIV/izisZOuB32S
         QODUopKfJZu9948q8Wmc4ieO+cW17JFedEROupGqxuQ36MI59nDGZ/Iyp1sD7xCsHVuN
         lwHg==
X-Gm-Message-State: ACgBeo1sP0UVPp/CJDhCP7u2uEFAfPzoC5r6HZV80j9zOvGKZ1E5+Pj5
        9QdOyibyKAILe9saOr4LVfLWJQLkzA1o2CiYaQ1p6w==
X-Google-Smtp-Source: AA6agR5ZKDh1B1qLI4CnWaTmS7MdpjOYsuffoGM9VfXHG/QDiAdeyi8cHZ1dpFi1dxOzCOVsTncoUqTfgUXWTLuOMbU=
X-Received: by 2002:a17:906:cc0d:b0:77a:c170:3019 with SMTP id
 ml13-20020a170906cc0d00b0077ac1703019mr14706840ejb.253.1663148502775; Wed, 14
 Sep 2022 02:41:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220913140357.323297659@linuxfoundation.org>
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 14 Sep 2022 15:11:31 +0530
Message-ID: <CA+G9fYv5CJeEaxu6XoaJrpizk+z1uXZ0aaQm2DVTA_w79oa2SA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/121] 5.15.68-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>, linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 13 Sept 2022 at 19:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.68 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.68-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
While running LTP syscalls, hugetlb and ssuite tests on x86 and arm64
Raspberry Pi 4 Model B.

> Trond Myklebust <trond.myklebust@hammerspace.com>
>     NFS: Fix another fsync() issue after a server reboot
>
> Trond Myklebust <trond.myklebust@hammerspace.com>
>     NFS: Save some space in the inode
>
> Trond Myklebust <trond.myklebust@hammerspace.com>
>     NFS: Further optimisations for 'ls -l'

I have not bisected the reported problem.

hugemmap05.c:99: TINFO: check /proc/meminfo before allocation.
hugemmap05.c:278: TINFO: HugePages_Total is 3.
hugemmap05.c:278: TINFO: HugePages_Free is 3.
hugemmap05.c:278: TINFO: HugePages_Surp is 1.
hugemmap05.c:27[   51.077819] ------------[ cut here ]------------
[   51.082692] WARNING: CPU: 0 PID: 590 at fs/nfs/inode.c:123
nfs_evict_inode+0x58/0x70
[   51.090451] Modules linked in: x86_pkg_temp_thermal
[   51.095329] CPU: 0 PID: 590 Comm: hugemmap05 Not tainted 5.15.68-rc1 #1
[   51.101948] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.5 11/26/2020
[   51.109340] RIP: 0010:nfs_evict_inode+0x58/0x70
[   51.113872] Code: 29 49 8b 54 24 90 49 8d 44 24 90 48 39 c2 75 2b
4c 89 e7 e8 7a d8 ff ff 4c 89 e7 e8 82 74 ff ff 4c 8b 65 f8 c9 c3 cc
cc cc cc <0f> 0b 49 8b 54 24 90 49 8d 44 24 90 48 39 c2 74 d5 0f 0b eb
d1 0f
[   51.132626] RSP: 0018:ffffb6b140a8fb90 EFLAGS: 00010286
[   51.137861] RAX: adacafaea9a8abaa RBX: ffff937fa606a2c0 RCX: ffffb6b140a8fbd0
[   51.144986] RDX: ffff937fa606a2d0 RSI: ffffffffbc720682 RDI: ffffffffbc5ec05f
[   51.152120] RBP: ffffb6b140a8fb98 R08: 0000000000000000 R09: ffffb6b140a8fcf0
[   51.159253] R10: 0000000000000000 R11: 0000000000000002 R12: ffff937fa606a1a8
[   51.166395] R13: ffffffffbd851b40 R14: ffff937c40803870 R15: 0000000000000003
[   51.173525] FS:  00007f5afcdf4740(0000) GS:ffff937fa7a00000(0000)
knlGS:0000000000000000
[   51.181602] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   51.187359] CR2: 00007f5afcf10680 CR3: 000000010360a006 CR4: 00000000003706f0
8: TINFO: HugePa[   51.194499] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
[   51.203009] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   51.210135] Call Trace:
[   51.212585]  <TASK>
[   51.214684]  evict+0xc8/0x180
[   51.217682]  prune_icache_sb+0x81/0xc0
[   51.221435]  super_cache_scan+0x169/0x200
[   51.225447]  do_shrink_slab+0x13f/0x2b0
[   51.229288]  shrink_slab+0x186/0x2a0
[   51.232868]  drop_slab_node+0x4a/0xa0
[   51.236533]  drop_slab+0x41/0x90
[   51.239765]  drop_caches_sysctl_handler+0x79/0x90
[   51.244471]  proc_sys_call_handler+0x159/0x290
[   51.248918]  proc_sys_write+0x13/0x20
[   51.252582]  new_sync_write+0x111/0x1a0
[   51.256423]  vfs_write+0x1d5/0x270
[   51.259828]  ksys_write+0x67/0xf0
[   51.263150]  __x64_sys_write+0x19/0x20
[   51.266901]  do_syscall_64+0x38/0x90
[   51.270479]  entry_SYSCALL_64_after_hwframe+0x61/0xcb
[   51.275534] RIP: 0033:0x7f5afcef31d7
[   51.279112] Code: 0f 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7
0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00
00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89
74 24
[   51.297859] RSP: 002b:00007ffd40638738 EFLAGS: 00000246 ORIG_RAX:
0000000000000001
[   51.305425] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f5afcef31d7
[   51.312557] RDX: 0000000000000001 RSI: 00000000016f1480 RDI: 0000000000000003
[   51.319689] RBP: 00000000016f1480 R08: 0000000000000001 R09: 0000000000000001
[   51.326812] R10: 0000000000001000 R11: 0000000000000246 R12: 0000000000000001
[   51.333938] R13: 00000000016f12a0 R14: 0000000000000001 R15: 00007f5afcfe87a0
[   51.341073]  </TASK>
[   51.343264] ---[ end trace 3420625c1fbde9e9 ]---
ges_Rsvd is 3.
[   51.348004] hugemmap05 (590): drop_caches: 3
hugemmap05.c:253: TINFO: First hex is 7070707

Full test log link on x86_64
https://lkft.validation.linaro.org/scheduler/job/5522436#L1711


Crash log on arm64  Raspberry Pi 4 Model B.

linktest 1 TPASS: errors: 0
linktest 1 TINFO: test hard link, limit: 1000
linktest 1 TPASS: errors: 0
[ 1172.344209] ------------[ cut here ]------------
[ 1172.348913] WARNING: CPU: 3 PID: 4759 at fs/nfs/inode.c:123
nfs_clear_inode+0x54/0x90
[ 1172.356884] Modules linked in: algif_hash aes_neon_bs aes_neon_blk
xhci_pci xhci_pci_renesas snd_soc_hdmi_codec raspberrypi_cpufreq
hci_uart btqca brcmfmac btbcm brcmutil bluetooth cfg80211
raspberrypi_hwmon rfkill clk_raspberrypi reset_raspberrypi vc4
pwm_bcm2835 cec bcm2711_thermal pcie_brcmstb drm_kms_helper
i2c_bcm2835 iproc_rng200 rng_core crct10dif_ce fuse drm
[ 1172.389906] CPU: 3 PID: 4759 Comm: rm Not tainted 5.15.68-rc1 #1
[ 1172.396005] Hardware name: Raspberry Pi 4 Model B (DT)
[ 1172.401217] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[ 1172.408284] pc : nfs_clear_inode+0x54/0x90
[ 1172.412444] lr : nfs_evict_inode+0x34/0x44
[ 1172.416604] sp : ffff800012babca0
[ 1172.419963] x29: ffff800012babca0 x28: ffff000040b40000 x27: 0000000000000000
[ 1172.427217] x26: ffff000049a61e88 x25: 0000000000000002 x24: 00000000ffffffec
[ 1172.434468] x23: ffff80000a62ea28 x22: ffff8000092bf7b0 x21: ffff000049a61fa0
[ 1172.441718] x20: ffff000049a62088 x19: ffff000049a61e88 x18: 0000000000000000
[ 1172.448966] x17: 0000000000000000 x16: 0000000000000000 x15: 8107000128000000
[ 1172.456215] x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000088
[ 1172.463464] x11: 0000015a6a1d5174 x10: ffff8000ed98a000 x9 : ffff800008486634
[ 1172.470714] x8 : fffffc0001160848 x7 : fffffffffffffffe x6 : 0000000000000001
[ 1172.477962] x5 : ffff80000a62f000 x4 : ffff80000a62f260 x3 : 0000000000000000
[ 1172.485211] x2 : ffff000049a620a8 x1 : ffff000049a61fb0 x0 : ffff000049a61dc0
[ 1172.492460] Call trace:
[ 1172.494938]  nfs_clear_inode+0x54/0x90
[ 1172.498745]  nfs_evict_inode+0x34/0x44
[ 1172.502551]  evict+0xac/0x190
[ 1172.505564]  iput+0x174/0x22c
[ 1172.508572]  do_unlinkat+0x1c0/0x26c
[ 1172.512201]  __arm64_sys_unlinkat+0x48/0x90
[ 1172.516446]  invoke_syscall+0x50/0x120
[ 1172.520254]  el0_svc_common.constprop.0+0x104/0x124
[ 1172.525207]  do_el0_svc+0x30/0x9c
[ 1172.528572]  el0_svc+0x2c/0x90
[ 1172.531676]  el0t_64_sync_handler+0xa4/0x130
[ 1172.536012]  el0t_64_sync+0x1a0/0x1a4
[ 1172.539728] ---[ end trace 6eb5987f00ab00b7 ]---

Full test log log link on arm64
https://lkft.validation.linaro.org/scheduler/job/5524239#L1447


## Build
* kernel: 5.15.68-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 292041e8d6044e6398e95c0bffa9484edd678478
* git describe: v5.15.67-122-g292041e8d604
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.67-122-g292041e8d604

## No test Regressions (compared to v5.15.67)

## No metric Regressions (compared to v5.15.67)

## No test Fixes (compared to v5.15.67)

## No metric Fixes (compared to v5.15.67)

## Test result summary
total: 106655, pass: 93993, fail: 696, skip: 11659, xfail: 307

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 333 total, 333 passed, 0 failed
* arm64: 65 total, 63 passed, 2 failed
* i386: 55 total, 53 passed, 2 failed
* mips: 56 total, 56 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 63 total, 63 passed, 0 failed
* riscv: 22 total, 22 passed, 0 failed
* s390: 24 total, 24 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 58 total, 56 passed, 2 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-filecaps
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-fsx
* ltp-hugetlb
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-open-posix-tests
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
