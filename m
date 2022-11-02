Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7DE616C01
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 19:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiKBSW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 14:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbiKBSWG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 14:22:06 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961EC2FC04
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 11:21:54 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id r14so27784096edc.7
        for <stable@vger.kernel.org>; Wed, 02 Nov 2022 11:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V/eVIK6xT1kU1qH2Ln/as0vabBHHMy8hY2GK9xxcy4A=;
        b=lVXb7IYYx2Yynx8U+2eBHIzuT7chSNYuCXByEHORA/iDGRqhfXYZUxFjfoODvo3dX+
         gcidBkhaQHEC80eQ9RFmUP2+WhpsOlJZZCDvfMVTmseejDgjOgzCkNgTxMxfdx538a2p
         6woPoVE6eajCgR9rzhluIS/zs4QfPftC0E6GJ9Z+h7MR++y53WBOh8KBP+r3ACruurAA
         xdINfwkHxmxwIzkoJEf+x9U17g4RcDukNyKYmjWvXDvsc3FoSKzTS94OpoKWPQEmHiNK
         kBOFVBNKTRhSnuMkmqc+HXG5xtLW/ZgMvJKOuq3Plwaf1418qxJHiXpnltd4dXcZsX0D
         iFRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V/eVIK6xT1kU1qH2Ln/as0vabBHHMy8hY2GK9xxcy4A=;
        b=PG76mUYHfVBpCuD3jjBSIwg2zY+VZn7eQ6VF6S9zlTpCUpdn1cK6dPegzXArF+N5qt
         wXneR1hdofRqgysGhwh5PgdzPJF0VEmBzkexErBId1MOjrzQ66F4o8zPQKoqkq+qpilx
         27/QpE2iWwumQADQkmYS2kZommA24qINBBcc8bN1nW4uMmt29teNJQyFsLwssdmaujBR
         i3OLwQcOChuzb5CTl90ThYnMsCT7X6tivU6eBuD43+cEE8QMhZrHjewre5rct3LX+lip
         /nUDqweI8f5GV4hWhp0+H2DK4Ilm5e72D8hPKI/uz5O88Rbz0/WSTd4RWPwoO2ziC/pj
         A77w==
X-Gm-Message-State: ACrzQf02zulNQ/++SAwEQjJ/MaO0JvRJND1XyIqdCcymxc5Tl/8YkUFy
        4Awovvznhv1XOEirJuZTy1yG6CEW2GXDAMCco4+LcA==
X-Google-Smtp-Source: AMsMyM7ejRX94PIUh/QPg65ohG3YsVd/9yZRlTGI3s5XrgE5cdFJtDGtnLsQ9r6O4ZyagqnCt1NjrCVrCnqDtewPMxQ=
X-Received: by 2002:a05:6402:1c0a:b0:463:3cda:3750 with SMTP id
 ck10-20020a0564021c0a00b004633cda3750mr20390113edb.341.1667413312910; Wed, 02
 Nov 2022 11:21:52 -0700 (PDT)
MIME-Version: 1.0
References: <20221102022111.398283374@linuxfoundation.org>
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 2 Nov 2022 23:51:41 +0530
Message-ID: <CA+G9fYvcV7QSfN3GpjzxgLUD+TSJsFErCFeX-JvyCEN8yC8bcg@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/240] 6.0.7-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
We LKFT running same test suites on multiple configurations builds
on latest toolchains and on real hardware and qemu 's.

Because of the above reason we have been finding mixed results.
For example, Due to the slowness of the qemu few tests got timeout
but the same test passed on real hardware.

* qemu-arm64-gcc-12-lkftconfig-debug-kmemleak, ltp-cve
  - cve-2017-15299
  - cve-2017-15951
    tst_test.c:1524: TINFO: Timeout per run is 0h 02m 30s
    request_key03.c:59: TCONF: kernel doesn't support key type 'encrypted'
    request_key03.c:59: TCONF: kernel doesn't support key type 'trusted'
    <47>[  759.437664] systemd-journald[212]: Sent WATCHDOG=3D1 notificatio=
n.
    request_key03.c:135: TPASS: didn't crash while updating key of type 'us=
er'
    <47>[  869.408908] systemd-journald[212]: Sent WATCHDOG=3D1 notificatio=
n.
    Test timeouted, sending SIGKILL!
    tst_test.c:1569: TINFO: Killed the leftover descendant processes
    tst_test.c:1575: TINFO: If you are running on slow machine, try
exporting LTP_TIMEOUT_MUL > 1
    tst_test.c:1577: TBROK: Test killed! (timeout?)

  - cve-2020-25705
    tst_kconfig.c:82: TINFO: Parsing kernel config '/proc/config.gz'
    tst_test.c:1524: TINFO: Timeout per run is 0h 02m 30s
    <6>[ 1826.776891] IPv6: ADDRCONF(NETDEV_CHANGE): ltp_veth1: link
becomes ready
    <6>[ 1826.781937] IPv6: ADDRCONF(NETDEV_CHANGE): ltp_veth2: link
becomes ready
    icmp_rate_limit01.c:230: TINFO: Batch 0: Got 100 ICMP errors
    icmp_rate_limit01.c:234: TINFO: Batch 1: Got 100 ICMP errors
    icmp_rate_limit01.c:234: TINFO: Batch 2: Got 100 ICMP errors
    icmp_rate_limit01.c:234: TINFO: Batch 3: Got 100 ICMP errors
    icmp_rate_limit01.c:234: TINFO: Batch 4: Got 100 ICMP errors
    icmp_rate_limit01.c:234: TINFO: Batch 5: Got 100 ICMP errors
    icmp_rate_limit01.c:234: TINFO: Batch 6: Got 100 ICMP errors
    icmp_rate_limit01.c:234: TINFO: Batch 7: Got 100 ICMP errors
    icmp_rate_limit01.c:238: TFAIL: ICMP rate limit not randomized,
system is vulnerable

    HINT: You _MAY_ be missing kernel fixes:

    https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3Db38e7819cae9

    HINT: You _MAY_ be vulnerable to CVE(s):

    https://cve.mitre.org/cgi-bin/cvename.cgi?name=3DCVE-2020-25705

    Summary:
    passed   0
    failed   1
    [1] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/buil=
d/v6.0.6-241-g436175d0f780/testrun/12807800/suite/ltp-cve/test/cve-2017-152=
99/details/
    [2] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/buil=
d/v6.0.6-241-g436175d0f780/testrun/12807800/suite/ltp-cve/test/cve-2017-152=
99/log

* qemu-arm64-64k-page-size, ltp-hugetlb
  - hugemmap05
  - hugemmap05_1
  - hugemmap05_2
  - hugemmap05_3
    All these test failed due to ENOMEM.
        hugemmap05.c:83: TBROK: mmap((nil),1610612736,3,1,3,0) failed:
ENOMEM (12)
        hugemmap05.c:83: TBROK: mmap((nil),1610612736,3,1,3,0) failed:
ENOMEM (12)
    These failures only seen on qemu-arm64 but test passed on
    bcm2711-rpi-4-b-64k_page_size device with same config.
   [3] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build=
/v6.0.6-241-g436175d0f780/testrun/12807533/suite/ltp-hugetlb/test/hugemmap0=
5/log
   [4] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build=
/v6.0.6-241-g436175d0f780/testrun/12807533/suite/ltp-hugetlb/test/hugemmap0=
5/details/

* qemu-arm64-clang-15-lkftconfig, ltp-syscalls
  - add_key05
    add_key05.c:136: TFAIL: max used bytes 19991, key allow max bytes 20000

  - futex_cmp_requeue01
    futex_cmp_requeue01.c:68: TFAIL: process 89996 wasn't woken up:
ETIMEDOUT (110)
    [5] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/buil=
d/v6.0.6-241-g436175d0f780/testrun/12808167/suite/ltp-syscalls/test/add_key=
05/log

* qemu-arm64-gcc-12-lkftconfig-debug-kmemleak, ltp-syscalls
  - request_key03
    tst_test.c:1524: TINFO: Timeout per run is 0h 02m 30s
    request_key03.c:59: TCONF: kernel doesn't support key type 'encrypted'
    request_key03.c:59: TCONF: kernel doesn't support key type 'trusted'
    <47>[ 4891.998441] systemd-journald[211]: Sent WATCHDOG=3D1 notificatio=
n.
    request_key03.c:135: TPASS: didn't crash while updating key of type 'us=
er'
    Test timeouted, sending SIGKILL!
    tst_test.c:1569: TINFO: Killed the leftover descendant processes
    tst_test.c:1575: TINFO: If you are running on slow machine, try
exporting LTP_TIMEOUT_MUL > 1
    tst_test.c:1577: TBROK: Test killed! (timeout?)
        [6] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/=
build/v6.0.6-241-g436175d0f780/testrun/12810384/suite/ltp-syscalls/test/req=
uest_key03/log

* qemu-i386, ltp-fs_bind
  - fs_bind_rbind07_sh
    fs_bind_rbind07 1 TPASS: umount share2 passed as expected
    umount: /scratch/ltp-BdrYN1uDRZ/LTP_fs_bind_rbind07.R6J2DAH7FB/sandbox/=
parent2:
target is busy.
    fs_bind_rbind07 1 TFAIL: umount parent2 failed unexpectedly
    fs_bind_rbind07 1 TPASS: umount parent2 passed as expected
    fs_bind_rbind07 1 TPASS: umount parent1 passed as expected
    fs_bind_rbind07 1 TFAIL: There are still mounts in the sandbox:\nparent=
2
        [7] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/=
build/v6.0.6-241-g436175d0f780/testrun/12808354/suite/ltp-fs_bind/test/fs_b=
ind_rbind07_sh/log

## Build
* kernel: 6.0.7-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.0.y
* git commit: 436175d0f780af8302164b3102ecf0ff99f7a376
* git describe: v6.0.6-241-g436175d0f780
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0.6=
-241-g436175d0f780

## No Test Regressions (compared to v6.0.5-94-gd5a53a666fb9)

## No Metric Regressions (compared to v6.0.5-94-gd5a53a666fb9)

## No Test Fixes (compared to v6.0.5-94-gd5a53a666fb9)

## No Metric Fixes (compared to v6.0.5-94-gd5a53a666fb9)


## Test result summary
total: 160584, pass: 131298, fail: 11489, skip: 17432, xfail: 365

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 146 passed, 3 failed
* arm64: 47 total, 47 passed, 0 failed
* i386: 37 total, 36 passed, 1 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 34 total, 30 passed, 4 failed
* riscv: 12 total, 12 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 40 total, 40 passed, 0 failed

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
* kselftest-net-mptcp
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
