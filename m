Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0B1468A8FA
	for <lists+stable@lfdr.de>; Sat,  4 Feb 2023 09:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbjBDIby (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Feb 2023 03:31:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233073AbjBDIbw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Feb 2023 03:31:52 -0500
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB612B63C
        for <stable@vger.kernel.org>; Sat,  4 Feb 2023 00:31:50 -0800 (PST)
Received: by mail-vk1-xa29.google.com with SMTP id s76so3724506vkb.9
        for <stable@vger.kernel.org>; Sat, 04 Feb 2023 00:31:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DaVyYh/c2Uk1dR1FJCUBHRJioL1G3oEqQyGFL1fwAH0=;
        b=i0hpbL/CL19fMLx19G92LNWJYWoAbSEqhqJ/efjKlf5uJ2c3QQzCyOZM3Gf4svWW+1
         vh8aexWV3PplB0zmX7iiif9lrt9tmascDCay02oBgYgiGsihdhpZ4c/Gq1VQ1SC547D2
         2HdWsObgj2TP+Bv+ZV90k2DGRydX9M5AFe4xHanM88LVewb8CD3+pbp05PRqci8qhZYA
         9v5D6LE4nMASWo0VfvGj4BqXLvsZMj/Vh484P9VwmTEcCzfVAdRiYOWjvsekkmJjMjvL
         h/1yh2hjTFNiZOE5KQ/evJHFw6v+cffUFp3cePzR/Z/9/rRIbZUoxW8QH5LLVJJJ/0HN
         Gyaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DaVyYh/c2Uk1dR1FJCUBHRJioL1G3oEqQyGFL1fwAH0=;
        b=byAN6da9YK11n+n4+2zHqJVXGsS4wjKLuXw2LTaeROrzI4w2wNDVRqBADfsHQn4iIr
         dlA1YgynkBQd/PbvomrCX16x3mRow66dpZ+5U4HXQ6//aVarGwNIKDQ9BqRtWibSC7aM
         4ChLM0bgIwieGz94Rj067OyDPXQ9jKzOfY5GHswTiofzD5xlrde/w9bjQdJ9h0l/Ml4U
         28YUnddzfmluc+bCzRDXW87wGrp9u+Qt9xaA0bI//emm6u3OLz+D1IOYayprlT5ikSHK
         jAZsYCZ2l9vx3KIpNrHFmEqUj9T6nyRM3TnILalz3P+4gfGEe7/EnkA7y69Jfpoo17bj
         b0uw==
X-Gm-Message-State: AO0yUKUmBpbZitQCeJydCaN7DhvL2upC8Jkud5CBb1U1zt23+QMpRM2G
        IPvhgntzVEyWOl+7HuiWIqqEPqRbiv1Bp8/lmRFdGQ==
X-Google-Smtp-Source: AK7set+DLDpSKuybnOXMTABXcXt7goMwbT25dpFRLnPPP6EIOafvTK8SB0vDC/TSdvC11RQ43YlUIjHahmkPciNNDgw=
X-Received: by 2002:ac5:c1c1:0:b0:3e5:7064:1bf9 with SMTP id
 g1-20020ac5c1c1000000b003e570641bf9mr1939753vkk.30.1675499508949; Sat, 04 Feb
 2023 00:31:48 -0800 (PST)
MIME-Version: 1.0
References: <20230203101007.985835823@linuxfoundation.org>
In-Reply-To: <20230203101007.985835823@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 4 Feb 2023 14:01:37 +0530
Message-ID: <CA+G9fYsRZcCu986iGaqrRw7uDjdaX2NEbDs9P5QFr58ja5BnTA@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/20] 5.15.92-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Kyle Huey <me@kylehuey.com>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 3 Feb 2023 at 15:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.92 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.92-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
Following two commits causing build warnings with gcc-12 on arm64 and i386
while building tools/testing/selftests.

  selftests/vm: remove ARRAY_SIZE define from individual tests
    commit e89908201e2509354c40158b517945bf3d645812 upstream.

  tools: fix ARRAY_SIZE defines in tools and selftests hdrs
    commit 066b34aa5461f6072dbbecb690f4fe446b736ebf upstream.

## Build
* kernel: 5.15.92-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: c8466dc0f6290e0ea087f808e9b4a29da36e82ca
* git describe: v5.15.91-21-gc8466dc0f629
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.91-21-gc8466dc0f629

## Test Regressions (compared to v5.15.90-205-g5605d15db022)

## Metric Regressions (compared to v5.15.90-205-g5605d15db022)

* arm64, build
  - gcc-12-lkftconfig-kselftest-warnings

Build warnings:
    tools/testing/selftests/arm64/fp:
    vec-syscfg.c:24: warning: "ARRAY_SIZE" redefined
       24 | #define ARRAY_SIZE(a) (sizeof(a) / sizeof(a[0]))
          |
    In file included from vec-syscfg.c:21:
    ../../kselftest.h:52: note: this is the location of the previous defini=
tion
       52 | #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
          |
    vec-syscfg.c: In function 'get_child_rdvl':
    vec-syscfg.c:112:33: warning: too many arguments for format
[-Wformat-extra-args]
      112 |                 fprintf(stderr, "execl(%s) failed: %d\n",
          |                                 ^~~~~~~~~~~~~~~~~~~~~~~~
    vec-syscfg.c: At top level:
    vec-syscfg.c:326:13: warning: 'prctl_set_same' defined but not
used [-Wunused-function]
      326 | static void prctl_set_same(struct vec_data *data)
          |             ^~~~~~~~~~~~~~
    vec-syscfg.c: In function 'file_write_integer':
    vec-syscfg.c:195:12: warning: 'ret' may be used uninitialized
[-Wmaybe-uninitialized]
      195 |         if (ret < 0) {
          |            ^
    vec-syscfg.c:183:13: note: 'ret' was declared here
      183 |         int ret;
          |             ^~~


* i386, build
  - gcc-12-lkftconfig-kselftest-warnings

Build warnings:
    tools/testing/selftests/vm
    virtual_address_range.c:43:31: warning: left shift count >=3D width
of type [-Wshift-count-overflow]
    virtual_address_range.c:88:34: warning: left shift count >=3D width
of type [-Wshift-count-overflow]
    virtual_address_range.c:22:26: warning: conversion from 'long long
unsigned int' to 'size_t' {aka 'unsigned int'} changes value from
'17179869184' to '0' [-Woverflow]


## Test Fixes (compared to v5.15.90-205-g5605d15db022)

## Metric Fixes (compared to v5.15.90-205-g5605d15db022)

## Test result summary
total: 162736, pass: 133853, fail: 4290, skip: 24262, xfail: 331

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 148 passed, 1 failed
* arm64: 49 total, 47 passed, 2 failed
* i386: 39 total, 35 passed, 4 failed
* mips: 31 total, 29 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 34 total, 32 passed, 2 failed
* riscv: 14 total, 14 passed, 0 failed
* s390: 16 total, 14 passed, 2 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 42 total, 40 passed, 2 failed

## Test suites summary
* boot
* fwts
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
* ltp-comman[
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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
