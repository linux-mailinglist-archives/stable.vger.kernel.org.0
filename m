Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC166B58FB
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 07:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbjCKGep (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 01:34:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjCKGem (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 01:34:42 -0500
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B98AC10B1E1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 22:34:40 -0800 (PST)
Received: by mail-ua1-x931.google.com with SMTP id i22so554211uat.8
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 22:34:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678516480;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JPakH+auDoUb1ydDIhbuBIDdqYVJ4FXLw0TE82j034Y=;
        b=jzUTGflnxhBqTkcA1oMQtsPjAYgnh+6hak7cJTnAVGOjEMpf74K5vtONO9PG52uPOk
         Kr3z4vlG4UAfuhkvvaGuYpSQiax8xh4h+MZFxbaiJJ7MZsWXwQ8NCtniMljB2NebCWFo
         WfK+oTP8npSwssnEQas2UE3d+FtJIxh1NPZQ8kBGv00G0Uh2vrIVHaVOqv9eoN4ZREcy
         TjOgO+dt8UCpK0SZ0Q+xmBjGOb4/Qiv/ruZn6jJBum1/VG9oGR9mvhl8YIFQD5JTsts9
         zjy3MbguxH8U2WURwhns3hZXcbUy1Vd/IqcQ5ZOYe4bRfo2ANTxpr5UecvyVJW69zTyA
         ECOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678516480;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JPakH+auDoUb1ydDIhbuBIDdqYVJ4FXLw0TE82j034Y=;
        b=PoToeGsgswrMaLvNkpJnsnwOkUTAgBgggRwRD/JC0Au+h4OMUbfYmxiQoLWZAhJ5dv
         jsRoO+Ofy8BOgwtTZXNZhzyvejd7nS5eNSpDhgDDM0ZB+B8gV6SyvQ+bINJ0BdVfI0TK
         nDXXwd/AUcvbBL+PDcg7/tQ4DelbRlQUtFa8l1+6diMXED4jsYsPWHEcoR9avmaW4cTj
         qh8KJawRaEouWTMhw+0uduEP/cjmFhlQxfgbk23C7loqcG2FKmN0m7Y1o6mmsBOYxtiK
         06oBN/aDG9CidzupDKZ5KKsOHoe0v9RLVXAP1jU8mnaX45zcazDE0thMofd0+VykTjEw
         SiWw==
X-Gm-Message-State: AO0yUKV2vpVetJiJpt4U33EyDnRyquNggXlvu8OQqYPVSHjHI41x56KQ
        h3kbKhXXbB9DBTe4v37rijJuN4wHDC+kM0bUDbPJpQ==
X-Google-Smtp-Source: AK7set/ZzGTn4GCGKrunnuoJ/kWGsgB4lln5SyuX3wiHAk3A/ZTPGTv4R7DooDRrTw+h6X7KqNhFgRaKLhbeIBLuDFU=
X-Received: by 2002:a1f:4b01:0:b0:401:8898:ea44 with SMTP id
 y1-20020a1f4b01000000b004018898ea44mr16171806vka.3.1678516479571; Fri, 10 Mar
 2023 22:34:39 -0800 (PST)
MIME-Version: 1.0
References: <20230310133804.978589368@linuxfoundation.org>
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 11 Mar 2023 12:04:28 +0530
Message-ID: <CA+G9fYuemYyXoZ3--tDqiZmR1f10DNRf-eSDje1dvkJQpeXsGg@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/529] 5.10.173-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 10 Mar 2023 at 20:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.173 release.
> There are 529 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.173-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.

As others reported, s390 build regressions are noticed.

* s390, build failures
  - clang-16-defconfig
  - gcc-12-defconfig
  - gcc-8-defconfig-fe40093d

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.173-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 420427e5b0dd499d0e1ba2ccbd30717bb5b36335
* git describe: v5.10.172-530-g420427e5b0dd
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.172-530-g420427e5b0dd

## Test Regressions (compared to v5.10.172)

* s390, build
  - clang-16-defconfig
  - gcc-12-defconfig
  - gcc-8-defconfig-fe40093d

## Metric Regressions (compared to v5.10.172)

## Test Fixes (compared to v5.10.172)

## Metric Fixes (compared to v5.10.172)

## Test result summary
total: 114034, pass: 92733, fail: 3011, skip: 18038, xfail: 252

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 112 total, 111 passed, 1 failed
* arm64: 39 total, 37 passed, 2 failed
* i386: 30 total, 28 passed, 2 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 23 total, 18 passed, 5 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 9 total, 6 passed, 3 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 33 total, 31 passed, 2 failed

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
* packetdrill
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
