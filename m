Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0D205BB8F0
	for <lists+stable@lfdr.de>; Sat, 17 Sep 2022 17:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiIQPDx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Sep 2022 11:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiIQPDw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Sep 2022 11:03:52 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D9F2F671
        for <stable@vger.kernel.org>; Sat, 17 Sep 2022 08:03:51 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id e18so35434605edj.3
        for <stable@vger.kernel.org>; Sat, 17 Sep 2022 08:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=IxLK6CN6EHyYmQE/kIBZxAWrdGfcW9YoUPVa03PK2n4=;
        b=QaQ3o//7l/VvsLuPGtRdsWlVcpR7DMr0jT2NBPTuGWynwXCV3Pxp99FO8qGxO9qY42
         iQEFItLU5rnUw0ECaDZsUSGkUe6hZP5QORs5Ztkk7lobBAUWAi7tNvLalwK+WefUZ9dQ
         oUuWEPrZRe3RjICfRLook4SIfQTe4ePQcjqUJpFIzwlyGkjMKMs5Ubrmo7XKFRIE4iLE
         vBg2IkL5hKi7u2auKwfHKTCs21mp52MNa0D7e4C11awaFtZabAYpC9b0y203rNAa0O+C
         0abogncaIwzPjb7dFqYtLEK/Je8oBYMRg+U2h8VKSUbROngdNvy/Zk5WpbGVuRSP8jag
         Jmbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=IxLK6CN6EHyYmQE/kIBZxAWrdGfcW9YoUPVa03PK2n4=;
        b=q1t0j/BniLLukDYpLHQuz5a81VEAEdrxjqdhHA+D9aUMb4f5nLM39qY3mIMMzp9Z15
         Xc1ankmOirOKGKyAsKxaQzM24m4uNfWA0T0tS8p1SnsUxK80FxaXdbch9j1TxTzDu9Kc
         7RGPyFmYzrqCl6n9dAeiIsbIYSnvulxtlF7fqwI5S+FygQY2fMv5p4h2X8pNnoMfTv4C
         9+Pf8ndAakExf4aC+sCzq2ZiUWZnrxcCKiJGS+WRmFWUkRzDo8onfIcelQbSVl57ukbk
         84zW1EpZ10WtZ0DdfT+YTi513ZJTY3G/uCm7+rHKbF5yFyl0tmZ0t9lxyjWUHkTCVUGm
         LHtw==
X-Gm-Message-State: ACrzQf3kM1pkClABPrIUdgX2Vz62FUtpIvdYcD5k2McvFNcSgK9ccFmd
        HQjgTXweQgnrwEiK7HKF51m9RXd3YUu5kjARgyIQ1A==
X-Google-Smtp-Source: AMsMyM5xJbggyIxuCntTBuJXwsJDRNChZ1d7/TtYOkgDUuupH8eg9qbw26XHkpLzumCy4K5ivYWf5Q9ZtbVYUmETsE8=
X-Received: by 2002:a05:6402:400e:b0:44f:1b9d:9556 with SMTP id
 d14-20020a056402400e00b0044f1b9d9556mr8291130eda.208.1663427029355; Sat, 17
 Sep 2022 08:03:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220916100448.431016349@linuxfoundation.org>
In-Reply-To: <20220916100448.431016349@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 17 Sep 2022 20:33:37 +0530
Message-ID: <CA+G9fYtxYKgqia+Crjok5yLshm3TpFwMyD8V5_-OkayA8UnDww@mail.gmail.com>
Subject: Re: [PATCH 5.19 00/38] 5.19.10-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        William Breathitt Gray <william.gray@linaro.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 16 Sept 2022 at 15:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.19.10 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 18 Sep 2022 10:04:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
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
[INFO]  kernel release is v5.19.10 - ok to run tests
[INFO]  using gpio-tools from '/usr/bin'
[   62.469728] BUG: kernel NULL pointer dereference, address: 00000000000000a0
[   62.471040] #PF: supervisor write access in kernel mode
[   62.472169] #PF: error_code(0x0002) - not-present page
[   62.473058] PGD 10799b067 P4D 10799b067 PUD 1079cc067 PMD 0
[   62.474012] Oops: 0002 [#1] PREEMPT SMP NOPTI
[   62.474777] CPU: 2 PID: 461 Comm: gpiod-test Not tainted 5.19.10-rc1 #1
[   62.475933] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.12.0-1 04/01/2014
[   62.477347] RIP: 0010:down_write+0x1a/0x60
[   62.478080] Code: 01 f0 ff ff 19 c0 f7 d0 83 e0 fc e9 e0 17 31 00
0f 1f 44 00 00 55 48 89 e5 41 54 49 89 fc e8 8d ca ff ff 31 c0 ba 01
00 00 00 <f0> 49 0f b1 14 24 75 18 65 48 8b 04 25 40 ad 01 00 49 89 44
24 08
[   62.481306] RSP: 0018:ffffacbdc06dfcf8 EFLAGS: 00010246
[   62.482215] RAX: 0000000000000000 RBX: ffffa320c4244810 RCX: ffffff8100000000
[   62.483433] RDX: 0000000000000001 RSI: 0000000000000064 RDI: 00000000000000a0
[   62.484649] RBP: ffffacbdc06dfd00 R08: ffffa320c13cae98 R09: ffffa320c4244aa0
[   62.485883] R10: ffffa320c4244aa0 R11: 000000000000000e R12: 00000000000000a0
[   62.486869] R13: ffffa320c0ae0100 R14: 00000000000000a0 R15: 000000000000000e
[   62.487804] FS:  00007f8ef9e8a740(0000) GS:ffffa320fbd00000(0000)
knlGS:0000000000000000
[   62.488832] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   62.489605] CR2: 00000000000000a0 CR3: 0000000101900000 CR4: 00000000003506e0
[   62.490565] Call Trace:
[   62.490918]  <TASK>
[   62.491250]  simple_recursive_removal+0xaa/0x2d0
[   62.491876]  ? debugfs_remove+0x70/0x70
[   62.492392]  debugfs_remove+0x45/0x70
[   62.492895]  gpio_mockup_debugfs_cleanup+0x15/0x20 [gpio_mockup]
[   62.493693]  devm_action_release+0x15/0x20
[   62.494246]  devres_release_all+0xc1/0x110
[   62.494801]  device_unbind_cleanup+0x12/0x80
[   62.495402]  device_release_driver_internal+0x1e5/0x230
[   62.496100]  driver_detach+0x4a/0x90
[   62.496578]  bus_remove_driver+0x59/0xe0
[   62.497103]  driver_unregister+0x31/0x60
[   62.497621]  platform_driver_unregister+0x12/0x20
[   62.498249]  gpio_mockup_exit+0x1c/0x465 [gpio_mockup]
[   62.498933]  __do_sys_delete_module+0x1b2/0x290
[   62.499592]  ? syscall_trace_enter.constprop.0+0x133/0x1b0
[   62.500245]  __x64_sys_delete_module+0x18/0x20
[   62.500740]  do_syscall_64+0x3b/0x90
[   62.501137]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   62.501679] RIP: 0033:0x7f8ef9d0c95b
[   62.502075] Code: 73 01 c3 48 8b 0d c5 34 0e 00 f7 d8 64 89 01 48
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 95 34 0e 00 f7 d8 64 89
01 48
[   62.504070] RSP: 002b:00007ffe85d75898 EFLAGS: 00000202 ORIG_RAX:
00000000000000b0
[   62.504878] RAX: ffffffffffffffda RBX: 0000000000f1f370 RCX: 00007f8ef9d0c95b
[   62.505634] RDX: 0000000000f1f527 RSI: 0000000000000800 RDI: 0000000000f1f938
[   62.506393] RBP: 0000000000f1f370 R08: 0000000000000007 R09: 0000000000f275c0
[   62.507154] R10: 00007f8ef9c16b88 R11: 0000000000000202 R12: 0000000000f1f420
[   62.507928] R13: 00007f8ef9db3b00 R14: 0000000000418df8 R15: 00007f8ef9f6f000
[   62.508704]  </TASK>
[   62.508959] Modules linked in: gpio_mockup(-)
[   62.509439] CR2: 00000000000000a0
[   62.509806] ---[ end trace 0000000000000000 ]---
[   62.510305] RIP: 0010:down_write+0x1a/0x60
[   62.510760] Code: 01 f0 ff ff 19 c0 f7 d0 83 e0 fc e9 e0 17 31 00
0f 1f 44 00 00 55 48 89 e5 41 54 49 89 fc e8 8d ca ff ff 31 c0 ba 01
00 00 00 <f0> 49 0f b1 14 24 75 18 65 48 8b 04 25 40 ad 01 00 49 89 44
24 08
[   62.512764] RSP: 0018:ffffacbdc06dfcf8 EFLAGS: 00010246
[   62.513329] RAX: 0000000000000000 RBX: ffffa320c4244810 RCX: ffffff8100000000
[   62.514090] RDX: 0000000000000001 RSI: 0000000000000064 RDI: 00000000000000a0
[   62.514844] RBP: ffffacbdc06dfd00 R08: ffffa320c13cae98 R09: ffffa320c4244aa0
[   62.515615] R10: ffffa320c4244aa0 R11: 000000000000000e R12: 00000000000000a0
[   62.516366] R13: ffffa320c0ae0100 R14: 00000000000000a0 R15: 000000000000000e
[   62.517164] FS:  00007f8ef9e8a740(0000) GS:ffffa320fbd00000(0000)
knlGS:0000000000000000
[   62.518028] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   62.518650] CR2: 00000000000000a0 CR3: 0000000101900000 CR4: 00000000003506e0


https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.19.y/build/v5.19.9-39-gf5066a94bca4/testrun/11946630/suite/log-parser-test/tests/
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.19.y/build/v5.19.9-39-gf5066a94bca4/testrun/11946106/suite/log-parser-test/tests/
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.19.y/build/v5.19.9-39-gf5066a94bca4/testrun/11952896/suite/log-parser-test/tests/

## Build
* kernel: 5.19.10-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.19.y
* git commit: f5066a94bca42cc8cc64e9999063584bff59f8d6
* git describe: v5.19.9-39-gf5066a94bca4
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.19.y/build/v5.19.9-39-gf5066a94bca4

## test Regressions (compared to v5.19.9)
  - Kernel BUG while running libgpiod on x86_64.

## No metric Regressions (compared to v5.19.9)

## No test Fixes (compared to v5.19.9)

## No metric Fixes (compared to v5.19.9)

## Test result summary
total: 115298, pass: 102277, fail: 950, skip: 11751, xfail: 320

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 339 total, 336 passed, 3 failed
* arm64: 72 total, 70 passed, 2 failed
* i386: 61 total, 55 passed, 6 failed
* mips: 62 total, 59 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 75 total, 66 passed, 9 failed
* riscv: 32 total, 27 passed, 5 failed
* s390: 26 total, 24 passed, 2 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 65 total, 63 passed, 2 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-arm64
* kselftest-arm64/arm64.btitest.bti_c_func
* kselftest-arm64/arm64.btitest.bti_j_func
* kselftest-arm64/arm64.btitest.bti_jc_func
* kselftest-arm64/arm64.btitest.bti_none_func
* kselftest-arm64/arm64.btitest.nohint_func
* kselftest-arm64/arm64.btitest.paciasp_func
* kselftest-arm64/arm64.nobtitest.bti_c_func
* kselftest-arm64/arm64.nobtitest.bti_j_func
* kselftest-arm64/arm64.nobtitest.bti_jc_func
* kselftest-arm64/arm64.nobtitest.bti_none_func
* kselftest-arm64/arm64.nobtitest.nohint_func
* kselftest-arm64/arm64.nobtitest.paciasp_func
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-firmware
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-kvm
* kselftest-lib
* kselftest-livepatch
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
* kselftest-x86
* kselftest-zram
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
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* perf
* perf/Zstd-perf.data-compression
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
