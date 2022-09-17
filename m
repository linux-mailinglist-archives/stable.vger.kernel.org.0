Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8FE5BB93C
	for <lists+stable@lfdr.de>; Sat, 17 Sep 2022 17:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiIQP6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Sep 2022 11:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiIQP6O (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Sep 2022 11:58:14 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D22E2F025
        for <stable@vger.kernel.org>; Sat, 17 Sep 2022 08:58:12 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id z21so35535489edi.1
        for <stable@vger.kernel.org>; Sat, 17 Sep 2022 08:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=8fPvIm0YNXtGcrlrCnYdi9c1mcqxw77pDzuWUIUBqxQ=;
        b=BepDLzIGApuUjMjlKfBC+GCZzEmW3NZN+mC75ZHl3imx6DavQD1UrDnSbiy6lQbaud
         B7OK7vTcfiDHujOGkzVmaJHeOALiWNVsLDs43o2f3ELZn88LRdcKTkp5Fds2RWSrLJPq
         O3s1rKj1Nij+HO1llTrj6y0y5D//eXzmLldNUSpt0qRYpd48a1uu7EZ6UwU/zq9d2SP5
         RbMp0ZEnrqLYH9tqaftwwRbzbVg/KnbRe1NZSEVL+/lQRvD0BhqdlSfbykzbkkfyf4Ri
         9eOe9qyeFozuLCq0s36bqGKSjHjjwW0BZWVMqfsF26sVKBJTNcX7xfkqU9aL++KXqpUu
         ChsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=8fPvIm0YNXtGcrlrCnYdi9c1mcqxw77pDzuWUIUBqxQ=;
        b=YlyZFSEiuLj+weNV/b4pVq/4uzVV9MwS857yBfXMgWY7ZTpP5QEJURbFtcCjeL8IbS
         2oRJwKL2ag5aezZQQMkz0u1DBsnje3bGelZJbgSWYAr7krBGM0MRVkOJm99ot2l4P6+4
         iKUY3TdxesbsLge4SMHQ1IQPAC590HxW3usyVhrDWSNNkCkBvCyiPj8O/h+DodVHLxQN
         7c9DxDrbPKfcHkFiKFFUC1Lu4pmo41zog06zc8dDoqnTi8G37DuSJfZ6ZYGzZnHk5YuD
         f3BKOJvteZnE7KCS7sOmjjAmsIkKJf/CGz9CgFawXwcx7EsT+1hrwu4BIB4VeLsXw3OE
         xI6g==
X-Gm-Message-State: ACrzQf234rvdXVnlTna7lzMIeapfOa2lPBnTI9MvgdUDY+BwFwzbz83J
        QLLUkyoppukzFpUmcvQcQLIbF2D/BPEaX/lxwgjMNg==
X-Google-Smtp-Source: AMsMyM7olCPBYW2bSlZdrMZLuIEyHD1NC+6PSY649fMJ+JKh1c1K0QbJWx0C/50sxdmVdejH4I0r+px+uaCDTrzknAM=
X-Received: by 2002:a05:6402:2989:b0:44e:90d0:b9ff with SMTP id
 eq9-20020a056402298900b0044e90d0b9ffmr8320290edb.110.1663430290773; Sat, 17
 Sep 2022 08:58:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220916100446.916515275@linuxfoundation.org>
In-Reply-To: <20220916100446.916515275@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 17 Sep 2022 21:27:59 +0530
Message-ID: <CA+G9fYtbiOXm0mmHQ0B+wmNANZjMeEd2jOA+1KxjU3wO-1sQgA@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/35] 5.15.69-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 16 Sept 2022 at 15:42, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.69 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 18 Sep 2022 10:04:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.69-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
Regressions on x86_64 while running libgpiod tests.

Regressions on x86_64 while running libgpiod tests.
This reported regression also noticed on mainline, stable-rc 5.19,
stable-rc 5.15 and stable-rc 5.10 branches

I have not bisected this reported crash yet.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

+ cd ./automated/linux/gpiod
+ ./gpiod.sh /opt/libgpiod/bin/
[INFO]  libgpiod test suite
[INFO]  117 tests registered
[INFO]  checking the linux kernel version
[INFO]  kernel release is v5.15.69 - ok to run tests
[INFO]  using gpio-tools from '/usr/bin'
[  109.045516] BUG: kernel NULL pointer dereference, address: 00000000000000a0
[  109.046035] #PF: supervisor write access in kernel mode
[  109.046035] #PF: error_code(0x0002) - not-present page
[  109.046035] PGD 1079dd067 P4D 1079dd067 PUD 101ff2067 PMD 0
[  109.046035] Oops: 0002 [#1] SMP NOPTI
[  109.046035] CPU: 3 PID: 459 Comm: gpiod-test Not tainted 5.15.69-rc1 #1
[  109.046035] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.12.0-1 04/01/2014
[  109.046035] RIP: 0010:down_write+0x1a/0x60
[  109.046035] Code: 01 f0 ff ff 19 c0 f7 d0 83 e0 fc e9 20 69 3e 00
0f 1f 44 00 00 55 48 89 e5 41 54 49 89 fc e8 1d d6 ff ff 31 c0 ba 01
00 00 00 <f0> 49 0f b1 14 24 75 18 65 48 8b 04 25 40 ad 01 00 49 89 44
24 08
[  109.046035] RSP: 0018:ffffa74e405abd18 EFLAGS: 00010246
[  109.046035] RAX: 0000000000000000 RBX: ffff9ffbc32b8c00 RCX: ffffff8100000000
[  109.046035] RDX: 0000000000000001 RSI: ffffff8100000000 RDI: 00000000000000a0
[  109.046035] RBP: ffffa74e405abd20 R08: ffffa74e405abdc8 R09: ffff9ffbc32b8c58
[  109.046035] R10: ffff9ffbc39276a8 R11: 000000000000000e R12: 00000000000000a0
[  109.046035] R13: ffff9ffbc4e83200 R14: 00000000000000a0 R15: 000000000000000e
[  109.046035] FS:  00007f3109509740(0000) GS:ffff9ffbfbd80000(0000)
knlGS:0000000000000000
[  109.046035] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  109.046035] CR2: 00000000000000a0 CR3: 0000000104d36000 CR4: 00000000003506e0
[  109.046035] Call Trace:
[  109.046035]  <TASK>
[  109.046035]  simple_recursive_removal+0x55/0x2c0
[  109.046035]  ? debugfs_remove+0x70/0x70
[  109.046035]  debugfs_remove+0x45/0x70
[  109.046035]  gpio_mockup_debugfs_cleanup+0x15/0x20 [gpio_mockup]
[  109.046035]  devm_action_release+0x15/0x20
[  109.046035]  devres_release_all+0xc1/0x110
[  109.046035]  __device_release_driver+0x195/0x270
[  109.046035]  driver_detach+0xce/0x110
[  109.046035]  bus_remove_driver+0x59/0xe0
[  109.046035]  driver_unregister+0x31/0x60
[  109.046035]  platform_driver_unregister+0x12/0x20
[  109.046035]  gpio_mockup_exit+0x1c/0x485 [gpio_mockup]
[  109.046035]  __do_sys_delete_module+0x1b2/0x290
[  109.046035]  ? syscall_trace_enter.constprop.0+0x151/0x1c0
[  109.046035]  __x64_sys_delete_module+0x18/0x20
[  109.046035]  do_syscall_64+0x3b/0x90
[  109.046035]  entry_SYSCALL_64_after_hwframe+0x61/0xcb
[  109.046035] RIP: 0033:0x7f31096ae95b
[  109.046035] Code: 73 01 c3 48 8b 0d c5 34 0e 00 f7 d8 64 89 01 48
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 95 34 0e 00 f7 d8 64 89
01 48
[  109.046035] RSP: 002b:00007ffe1319d968 EFLAGS: 00000202 ORIG_RAX:
00000000000000b0
[  109.046035] RAX: ffffffffffffffda RBX: 0000000001f89370 RCX: 00007f31096ae95b
[  109.046035] RDX: 0000000001f88591 RSI: 0000000000000800 RDI: 0000000001f89938
[  109.046035] RBP: 0000000001f89370 R08: 0000000000000007 R09: 0000000001f915c0
[  109.046035] R10: 00007f31095b8b88 R11: 0000000000000202 R12: 0000000001f89420
[  109.046035] R13: 00007f3109755b00 R14: 0000000000418df8 R15: 00007f31097ee000
[  109.046035]  </TASK>
[  109.046035] Modules linked in: gpio_mockup(-)
[  109.046035] CR2: 00000000000000a0
[  109.046035] ---[ end trace 0ecf9a9cb4176b72 ]---
[  109.046035] RIP: 0010:down_write+0x1a/0x60
[  109.046035] Code: 01 f0 ff ff 19 c0 f7 d0 83 e0 fc e9 20 69 3e 00
0f 1f 44 00 00 55 48 89 e5 41 54 49 89 fc e8 1d d6 ff ff 31 c0 ba 01
00 00 00 <f0> 49 0f b1 14 24 75 18 65 48 8b 04 25 40 ad 01 00 49 89 44
24 08
[  109.046035] RSP: 0018:ffffa74e405abd18 EFLAGS: 00010246
[  109.046035] RAX: 0000000000000000 RBX: ffff9ffbc32b8c00 RCX: ffffff8100000000
[  109.046035] RDX: 0000000000000001 RSI: ffffff8100000000 RDI: 00000000000000a0
[  109.046035] RBP: ffffa74e405abd20 R08: ffffa74e405abdc8 R09: ffff9ffbc32b8c58
[  109.046035] R10: ffff9ffbc39276a8 R11: 000000000000000e R12: 00000000000000a0
[  109.046035] R13: ffff9ffbc4e83200 R14: 00000000000000a0 R15: 000000000000000e
[  109.046035] FS:  00007f3109509740(0000) GS:ffff9ffbfbd80000(0000)
knlGS:0000000000000000
[  109.046035] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  109.046035] CR2: 00000000000000a0 CR3: 0000000104d36000 CR4: 00000000003506e0
+ ../../utils/send-to-lava.sh result.txt

https://lkft.validation.linaro.org/scheduler/job/5549097#L1040
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.68-36-gd766f744e482/testrun/11953397/suite/log-parser-test/tests/
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.68-36-gd766f744e482/testrun/11951679/suite/log-parser-test/tests/

## Build
* kernel: 5.15.69-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: d766f744e4827dc41ef6c01403a96b7bb3938132
* git describe: v5.15.68-36-gd766f744e482
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.68-36-gd766f744e482

## Test Regressions (compared to v5.15.68)
  - Kernel BUG while running libgpiod on x86_64.

## No metric Regressions (compared to v5.15.68)

## No test Fixes (compared to v5.15.68)

## No Metric Fixes (compared to v5.15.68)

## Test result summary
total: 105940, pass: 93319, fail: 676, skip: 11638, xfail: 307

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 339 total, 336 passed, 3 failed
* arm64: 72 total, 70 passed, 2 failed
* i386: 61 total, 55 passed, 6 failed
* mips: 62 total, 59 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 69 total, 66 passed, 3 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 30 total, 27 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 65 total, 63 passed, 2 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kunit
* kvm-unit-tests
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
