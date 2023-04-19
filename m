Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77546E7545
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 10:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbjDSId3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 04:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbjDSId2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 04:33:28 -0400
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD647113
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 01:33:26 -0700 (PDT)
Received: by mail-ua1-x92c.google.com with SMTP id q10so7879928uas.2
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 01:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681893205; x=1684485205;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TFh8cKtmQeLzdNqi85aci1KA8iIgD65gwTL6N4mvUb4=;
        b=bQfRm00TH335URMWMoIjUAnRVREHVpYBP5fzrRr2WpfOwN1TgW1GKkHzAMlacfepea
         SCBUZRbUt587K6Vtuz5woZ6IKg0vEyy0mT7SmCTjNkdwKQb33cE5FQsv4hQv8WO7M65s
         XOtV8Lj0kFMVi3yNlEhGHuzXrwgYuHQmWhyud8dckS+lNdzpTe5aAAp94YcJzA6LCoeA
         oXFA56Qwo+PmpNv2trpwRsM/1wEISKkFIvkofQL/QkLGU6uUpgge9Uajz7kbsBg6Kc+/
         VgqlAQHRU9B/5J7t7C0haLx8PXj6qmh0EBW/0UKPiodL5A+k1FrySaqprMviSljrLQ3O
         q2Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681893205; x=1684485205;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TFh8cKtmQeLzdNqi85aci1KA8iIgD65gwTL6N4mvUb4=;
        b=iAcbVIznD/H/2ACM/uBQsOm/xpGUPTrCmdDZTJcNwbMje7lBBLeTNqdTfh3zK7cIPw
         9NzcA8WH6dUEmsr2sp70W4QZ1moghia7LW+7bfGRgdNgq02f64U0yZfRm2NBRa6C6KVf
         uU1fn61Eu8qMS1viSf6CMuGf5rik3bOJYCLuc7Lj8d/wpynkjNRPOe3GpVJcR0d0fWEa
         IshK8dDozWARXdzkrBHQn5iA5CqqUss6fk+s0JOHDgx3rrCUPNtu3Zwglc03ph+fdrSt
         F291qoPZHdQUxJCa6wTgfdycN39KEBYjjTmKpxE4LzX8Q9t9J1beQrxUX5uBYSi51g4y
         Akow==
X-Gm-Message-State: AAQBX9eCPfYDIEw4TDRBa58wC8GlDixloDPMEVick99MwcarzJcIu0Cp
        5NxaVQTELkIFZWuF3IG8C+xAAIWMRtYLRAewAe/pHA==
X-Google-Smtp-Source: AKy350aCAj0CmufVadvfZKn2S5DZRP2Jm81ER6UwRvOh7xB9fgGw8ImZRwGXf0ybp4mARVbrEA1jcZXOXojFkttjavs=
X-Received: by 2002:a1f:5c43:0:b0:440:3629:846 with SMTP id
 q64-20020a1f5c43000000b0044036290846mr7225925vkb.2.1681893205569; Wed, 19 Apr
 2023 01:33:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230418120258.713853188@linuxfoundation.org>
In-Reply-To: <20230418120258.713853188@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 19 Apr 2023 14:03:14 +0530
Message-ID: <CA+G9fYtQZpMB=uuEj9QFVXRp-JteNLd2N7ezpbfOP_ee080DaQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/57] 4.19.281-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        LTP List <ltp@lists.linux.it>, chrubis <chrubis@suse.cz>,
        Petr Vorel <pvorel@suse.cz>,
        Anders Roxell <anders.roxell@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 18 Apr 2023 at 17:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.281 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.281-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Recently we have upgraded the LTP test suite version and started noticing
these test failures on 4.19 and 4.14 only on arm64.

Need to investigate test case issues or kernel issues.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
creat09.c:73: TINFO: User nobody: uid = 65534, gid = 65534
creat09.c:75: TINFO: Found unused GID 11: SUCCESS (0)
creat09.c:120: TINFO: File created with umask(0)
creat09.c:106: TPASS: mntpoint/testdir/creat.tmp: Owned by correct group
creat09.c:112: TPASS: mntpoint/testdir/creat.tmp: Setgid bit not set
creat09.c:106: TPASS: mntpoint/testdir/open.tmp: Owned by correct group
creat09.c:112: TPASS: mntpoint/testdir/open.tmp: Setgid bit not set
creat09.c:120: TINFO: File created with umask(S_IXGRP)
creat09.c:106: TPASS: mntpoint/testdir/creat.tmp: Owned by correct group
creat09.c:110: TFAIL: mntpoint/testdir/creat.tmp: Setgid bit is set
creat09.c:106: TPASS: mntpoint/testdir/open.tmp: Owned by correct group
creat09.c:110: TFAIL: mntpoint/testdir/open.tmp: Setgid bit is set

 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19.279-143-gcc0a9b81697f/testrun/16319970/suite/ltp-syscalls/test/creat09/log
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19.279-143-gcc0a9b81697f/testrun/16319970/suite/ltp-syscalls/test/creat09/history/


## Build
* kernel: 4.19.281-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: cc0a9b81697f7222c51d17365c5960680ba00260
* git describe: v4.19.279-143-gcc0a9b81697f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19.279-143-gcc0a9b81697f

## Test Regressions (compared to v4.19.279-85-ge4a87ad39c98)

* qemu-arm64, ltp-cve
  - cve-2018-13405 ( creat09 )

* qemu-arm64, ltp-syscalls
  - creat09

## Metric Regressions (compared to v4.19.279-85-ge4a87ad39c98)

## Test Fixes (compared to v4.19.279-85-ge4a87ad39c98)

## Metric Fixes (compared to v4.19.279-85-ge4a87ad39c98)

## Test result summary
total: 96758, pass: 71960, fail: 3568, skip: 21047, xfail: 183

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 108 total, 107 passed, 1 failed
* arm64: 34 total, 33 passed, 1 failed
* i386: 20 total, 19 passed, 1 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 24 total, 24 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 28 total, 27 passed, 1 failed

## Test suites summary
* boot
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-arm64
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
* kselftest-ftrace
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
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
