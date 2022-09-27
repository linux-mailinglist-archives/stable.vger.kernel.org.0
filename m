Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED99F5EBC92
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 10:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbiI0IAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 04:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbiI0H7y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 03:59:54 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47DDEB0B17
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 00:56:47 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id hy2so18918226ejc.8
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 00:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=ipaWPMu8MrV9IYxOaGz/3RfGA0OEYukjBOQDMEv33Kg=;
        b=QSkoJB6u5aKIMamm1t3oC096eLYPUzBxxVKjrHPHoLa/8WCy+w0pAzJycNxLZFvaP5
         uufvgIlVIcPQl/zylG+HDnvuAELrV8VXmeCTPKWlwO2184h+M0wf5wxfrJUysA4dpUBP
         KotMWi3Oqf5rjz5Iqj10Il/+zwkpQjqeK3u9TTtawkeSA5muinGEa0keYYsddocdDt7Y
         czlRRiOR/hS4f0G+gxmeQOOlqhwc+4Zr1z92zE2AS0Y/S3ohprDhfpN10dfibHGfnR0H
         4UP/KAKWMjut0LBreRo+Pw29Y8hoKkSQeaS67EvVub/kasHLZ8m0pBPz3KDf5dhhzMJ9
         v+dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=ipaWPMu8MrV9IYxOaGz/3RfGA0OEYukjBOQDMEv33Kg=;
        b=BQuksq8bmwjPN74BumN/swdLs3itebOr2KPQkczPaaUkgJdotKgIv2DJ7U9qwTfB7n
         gZtLUDbupCU8rFmI+gLsJQCce+dq8NzAOBj4A2Rpa8/GU990vYIdL+fdCea1B46EYzFr
         OFUlT9E22XX1IidRcP2c2qytT9+qZvSifWSty2MAWlm4m/y8+rHHvtTBm5YSmW0R26Ib
         u7qGbnyo2NNi2srAoAbluzv5ObAI6oQT5YvlH1lZfft18hv4pebDB4QgfwG5ay0PKq8F
         nrB4+iDQKr67SVlfmN4ttolOImv4qukx8jIOqDheqoWaomhFZ8L2l+B6ORK9xn3J3C3f
         YOgA==
X-Gm-Message-State: ACrzQf3Q2cE+jV60tJhfcE2hSjWzQrQJmi0ItdzJ8QeqzSu0eWLK7x2K
        XJ6X8+xEzMkvJaFgzCb6vtzizaDtGHb5M3Yw28Ko8sNXLDWazw==
X-Google-Smtp-Source: AMsMyM74kmK3FajFfvRtn8uhxQhHSaHBuqlmxm5HyDuPYcbWWtyozCf4DnopQNFwWKuEpL9OUrlKG7g4x1Pq1Zihd/o=
X-Received: by 2002:a17:906:fd85:b0:77b:b538:6472 with SMTP id
 xa5-20020a170906fd8500b0077bb5386472mr21305559ejb.48.1664265363692; Tue, 27
 Sep 2022 00:56:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220926100806.522017616@linuxfoundation.org>
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 27 Sep 2022 13:25:52 +0530
Message-ID: <CA+G9fYtxogp--B0Em6VCL0C3wwVFXa6xW-Rq2kQk3br+FPGLgg@mail.gmail.com>
Subject: Re: [PATCH 5.19 000/207] 5.19.12-rc1 review
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

On Mon, 26 Sept 2022 at 16:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.19.12 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 28 Sep 2022 10:07:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.12-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm, x86_64, and i386.
Following deadlock warning noticed on arm64 with kselftests Kconfigs.


Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>


NOTE:
Following kernel boot warning noticed on arm64 bcm2711-rpi-4-b,
dragonboard-845c and devices with kselftest Kconfigs [1].

[   51.802754] ======================================================
[   51.809016] WARNING: possible circular locking dependency detected
[   51.815280] 5.19.12-rc1 #1 Not tainted
[   51.819078] ------------------------------------------------------
[   51.825340] kworker/u9:0/170 is trying to acquire lock:
[   51.830635] ffff000044f1b048 (&hdev->req_lock){+.+.}-{3:3}, at:
scan_update_work+0x2c/0x70 [bluetooth]
[   51.840186]
[   51.840186] but task is already holding lock:
[   51.846095] ffff80000c563dd0
((work_completion)(&hdev->scan_update)){+.+.}-{0:0}, at:
process_one_work+0x1e8/0x6d4
[   51.856610]
[   51.856610] which lock already depends on the new lock.
[   51.856610]
[   51.864898]
[   51.864898] the existing dependency chain (in reverse order) is:
[   51.872482]
[   51.872482] -> #1 ((work_completion)(&hdev->scan_update)){+.+.}-{0:0}:
[   51.880603]        lock_acquire+0x84/0xa0
[   51.884668]        __flush_work+0x88/0x510
[   51.888820]        __cancel_work_timer+0x150/0x1d0
[   51.893678]        cancel_work_sync+0x28/0x40
[   51.898094]        hci_request_cancel_all+0x38/0x110 [bluetooth]
[   51.904265]        hci_dev_close_sync+0x3c/0x620 [bluetooth]
[   51.910071]        hci_dev_do_close+0x38/0x80 [bluetooth]
[   51.915600]        hci_power_off+0x2c/0x70 [bluetooth]
[   51.920870]        process_one_work+0x280/0x6d4
[   51.925472]        worker_thread+0x7c/0x430
[   51.929711]        kthread+0x108/0x114
[   51.933509]        ret_from_fork+0x10/0x20
[   51.937660]
[   51.937660] -> #0 (&hdev->req_lock){+.+.}-{3:3}:
[   51.943843]        __lock_acquire+0x12d8/0x205c
[   51.948434]        lock_acquire.part.0+0xe4/0x22c
[   51.953201]        lock_acquire+0x84/0xa0
[   51.957261]        __mutex_lock+0x9c/0x410
[   51.961413]        mutex_lock_nested+0x64/0xa0
[   51.965914]        scan_update_work+0x2c/0x70 [bluetooth]
[   51.971477]        process_one_work+0x280/0x6d4
[   51.976074]        worker_thread+0x7c/0x430
[   51.980313]        kthread+0x108/0x114
[   51.984110]        ret_from_fork+0x10/0x20
[   51.988261]
[   51.988261] other info that might help us debug this:
[   51.988261]
[   51.996373]  Possible unsafe locking scenario:
[   51.996373]
[   52.002370]        CPU0                    CPU1
[   52.006956]        ----                    ----
[   52.011543]   lock((work_completion)(&hdev->scan_update));
[   52.017103]                                lock(&hdev->req_lock);
[   52.023280]
lock((work_completion)(&hdev->scan_update));
[   52.031395]   lock(&hdev->req_lock);
[   52.035015]
[   52.035015]  *** DEADLOCK ***
[   52.035015]
[   52.041013] 2 locks held by kworker/u9:0/170:
[   52.045425]  #0: ffff000048b8d938
((wq_completion)hci0){+.+.}-{0:0}, at: process_one_work+0x1e8/0x6d4
[   52.054788]  #1: ffff80000c563dd0
((work_completion)(&hdev->scan_update)){+.+.}-{0:0}, at:
process_one_work+0x1e8/0x6d4
[   52.065736]
[   52.065736] stack backtrace:
[   52.070149] CPU: 1 PID: 170 Comm: kworker/u9:0 Not tainted 5.19.12-rc1 #1
[   52.077031] Hardware name: Raspberry Pi 4 Model B (DT)
[   52.082237] Workqueue: hci0 scan_update_work [bluetooth]
[   52.087725] Call trace:
[   52.090197]  dump_backtrace+0xbc/0x130
[   52.093997]  show_stack+0x30/0x70
[   52.097352]  dump_stack_lvl+0x8c/0xb8
[   52.101062]  dump_stack+0x18/0x34
[   52.104416]  print_circular_bug+0x1f8/0x200
[   52.108655]  check_noncircular+0x12c/0x140
[   52.112804]  __lock_acquire+0x12d8/0x205c
[   52.116864]  lock_acquire.part.0+0xe4/0x22c
[   52.121101]  lock_acquire+0x84/0xa0
[   52.124633]  __mutex_lock+0x9c/0x410
[   52.128255]  mutex_lock_nested+0x64/0xa0
[   52.132228]  scan_update_work+0x2c/0x70 [bluetooth]
[   52.137265]  process_one_work+0x280/0x6d4
[   52.141330]  worker_thread+0x7c/0x430
[   52.145039]  kthread+0x108/0x114
[   52.148308]  ret_from_fork+0x10/0x20


[1] https://builds.tuxbuild.com/2FJZaTWmWVmCtAL2pw1Fvo1uWXw/config
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.19.y/build/v5.19.11-208-gddfc03723522/testrun/12111785/suite/log-parser-boot/tests/


## Build
* kernel: 5.19.12-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.19.y
* git commit: ddfc03723522344950fd8eddeec14bd1facf0ba5
* git describe: v5.19.11-208-gddfc03723522
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.19.y/build/v5.19.11-208-gddfc03723522

## No test Regressions (compared to v5.19.11)

## No metric Regressions (compared to v5.19.11)

## No test Fixes (compared to v5.19.11)

## No metric Fixes (compared to v5.19.11)

## Test result summary
total: 117926, pass: 103539, fail: 1113, skip: 13021, xfail: 253

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 333 total, 333 passed, 0 failed
* arm64: 65 total, 63 passed, 2 failed
* i386: 55 total, 53 passed, 2 failed
* mips: 56 total, 56 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 69 total, 63 passed, 6 failed
* riscv: 27 total, 22 passed, 5 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 58 total, 56 passed, 2 failed

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
* kselftest-net
* kselftest-net-forwarding
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
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* perf
* perf/Zstd-perf.data-compression
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
