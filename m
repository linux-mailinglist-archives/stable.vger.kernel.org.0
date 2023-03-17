Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C036BDE82
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 03:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjCQCQ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 22:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCQCQ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 22:16:57 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D493CB1A71
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 19:16:55 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id a3so3328831vsi.0
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 19:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679019415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cU/rQjq3RhEca9wlD/dJREI/qWqiUYpv57PoCQmL1G0=;
        b=wjhLBIKuDNMOWNWP+xQqgvu39nIkqExv5G+5T5KkNSnJWmALIB7+IP/c1fyVxvZfgr
         lBp3lKi+5JNXiBtQT6TdonaiNZcVdN7UPzcENkxLuYj+bPm5hnXbedtqcFTHvEJDz11K
         e6zLaLQ8rod7OeDXkz3CphDbrCQLVauoHzipXwV0AD70TgizHgRE692sxYM+uOPnpCNr
         SIeJoknQjjkewL6ePCoBVreUXHz596YHm9VOA6YtVIpxeglTX7HDnuWkpJnJkM6prTRv
         cz25gaL7LUssybP5YWw7QdqOOvtRgIo4KH58p/06GxivD9MOySIleuLkyLbfJnrbKxQS
         4x6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679019415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cU/rQjq3RhEca9wlD/dJREI/qWqiUYpv57PoCQmL1G0=;
        b=Pmulp1pP3FkCYFFjhECvzLfjHIvirZYJtGjhy7XsITOjC58E9IJGUWy+6/LKuzea50
         krN5oR5tco9HWrR6s25IZ5PxvS35lG6BpHQXak86Y09kRefceUb65DTVXfMyb0MuktDL
         oZjqWH1A5itXHBr+C7gkGzGYMuS5W/Lm5CdRTuL4Ad8wPdwZZDm2e3+XcyU9axfFoEvh
         0CJOWnOBJdv07lvlmS+WDm9bDQh/qdMZWsUd49hZCO+8T0lDdPpGi43ixKHkxNKnL8El
         F4meRMQtfsXbKMd2dayFikFG7LVx7mgzBKicJyaw9olr3tUj+Rq7/L3+XWehClgTo+IU
         GB3g==
X-Gm-Message-State: AO0yUKVlfB5zoJkCR+x7u5lvCDYdLJK5Nz0QcGaQjSZ/2eJ+i8mHYQe3
        4KUZ0hy+q70791oIQNqfPyMjog6eaQrisoQl4CWZzg==
X-Google-Smtp-Source: AK7set9cWglT+HwPgC0CXoFDIkOfAK7xE3L2Mr0Y7sFI0j9xTIgK2ePduWEiEoF3TK+U2MOFSFvhGQ+EJUYwsJEMMqU=
X-Received: by 2002:a05:6102:15a:b0:425:b211:3671 with SMTP id
 a26-20020a056102015a00b00425b2113671mr6164901vsr.1.1679019414772; Thu, 16 Mar
 2023 19:16:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230316083443.411936182@linuxfoundation.org>
In-Reply-To: <20230316083443.411936182@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 17 Mar 2023 07:46:43 +0530
Message-ID: <CA+G9fYsejevnZZ_N9Kejtj6Cxk+Z3MNb5cma=vfD3iwPdTn-jw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/137] 5.15.103-rc2 review
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
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 16 Mar 2023 at 14:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.103 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.103-rc2.gz
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

## Build
* kernel: 5.15.103-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: bc64d631a29ef83d6cdf41d6285f01e3ac03feb9
* git describe: v5.15.101-142-gbc64d631a29e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.101-142-gbc64d631a29e

## Test Regressions (compared to v5.15.100)

## Metric Regressions (compared to v5.15.100)

## Test Fixes (compared to v5.15.100)

## Metric Fixes (compared to v5.15.100)

## Test result summary
total: 141652, pass: 117485, fail: 4068, skip: 19788, xfail: 311

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 115 total, 114 passed, 1 failed
* arm64: 42 total, 42 passed, 0 failed
* i386: 33 total, 31 passed, 2 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 27 total, 26 passed, 1 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 12 total, 11 passed, 1 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 36 total, 36 passed, 0 failed

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
* packetdrill
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
