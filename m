Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 988876A1B89
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 12:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbjBXLnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 06:43:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBXLnp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 06:43:45 -0500
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7890D2D173
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 03:43:44 -0800 (PST)
Received: by mail-vs1-xe34.google.com with SMTP id o2so7683357vss.8
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 03:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wALh5tMBmtKVLsEj6gRhHumLh83at1y56LS2LBeylwc=;
        b=iHtL6/o0rPLEvl574pGx1vUzk87N7cP4bYzGQUYsPonSm1BOxsr2Yrs5g9hxAzpaNL
         ehrar68aQM4ZSSJ0+qyDJ7DJ4Lr71Cjsu0SA8JmeNHPGEWVm/0ZyspQPHkHCp+7K9tPT
         7Zvak6GN7ANOiSgOhyMdaXUbHOpxbs0VF527RqWscFK7+1pCt+SZEv4zbYXsnqBQlt0j
         3ZL+g2N+QwW6RmNNOUYwwTd5S/1QCyUdelAFhCAXpdcEhMNllP32GqXTcXO6ARakuWGB
         thFjbNgs99auWOGzQFsh1jJxmy3NxlSF45jXW3Iu6qyYrQ7wqZJykm000QphX6BDvU+L
         c6Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wALh5tMBmtKVLsEj6gRhHumLh83at1y56LS2LBeylwc=;
        b=JI3ov6WkqM4yzk3/+/NI1Qou1TFMsDdQC8+HYaBzMEODtJXdW0QyRImRDuqtpV0rTT
         Eg89DPtqiSh8mUx9lTwDA+b3LvNoXeC6ks9nBTwiloSiWV0btZ/12ofDZsFQFKdKx6N1
         B2U694XGvH5UwKb19iFptkA99yf3J/sZQidC3nAcJx9McG/QIJqrnMKAOJFaBZs3L3Rf
         Vyt/Kyy4kTzXb9D8/o24AYKJnO8bOZZu3OKpwh1MxdVEtOApY0CssfEwkGgbgJLLBGgq
         9EvEaS5JCA5KoT2P3ziUDXSzhZm5AWC8waogiNaibmYDhRZOGIHKg93A4s2aP9a2Qkvc
         2XdA==
X-Gm-Message-State: AO0yUKUwW9d5VBIGGH8OAQrbZGrXeT2xRw+QVE4N5Pv+bcOenVFi6Wue
        v8RMGZJGzZVq/O2kXz2hrNfmBKGj8hWpPmykzbbOpVYBcePdqXto
X-Google-Smtp-Source: AK7set+rQ2i5sbMZChzxneglD6+lyEQkRdFz96Sxp6hFV50Ed/X/XgQRXDz3bi/8yXpMwUuRjcAUpNrHXhkqCQkkcis=
X-Received: by 2002:ac5:c975:0:b0:401:73f4:dfe with SMTP id
 t21-20020ac5c975000000b0040173f40dfemr2402763vkm.3.1677239023364; Fri, 24 Feb
 2023 03:43:43 -0800 (PST)
MIME-Version: 1.0
References: <20230223141540.701637224@linuxfoundation.org>
In-Reply-To: <20230223141540.701637224@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 24 Feb 2023 17:13:32 +0530
Message-ID: <CA+G9fYupGOoRW=D_hg80N5CmxWxApHQhPVKZAFBBa0qbZTMMLg@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/26] 5.10.170-rc2 review
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 23 Feb 2023 at 19:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.170 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.170-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.170-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: d4288b01f4e882fd7ba86ad1a570b7e420167eb0
* git describe: v5.10.169-27-gd4288b01f4e8
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.169-27-gd4288b01f4e8

## Test Regressions (compared to v5.10.169)

## Metric Regressions (compared to v5.10.169)

## Test Fixes (compared to v5.10.169)

## Metric Fixes (compared to v5.10.169)

## Test result summary
total: 156882, pass: 130906, fail: 3641, skip: 22019, xfail: 316

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 148 passed, 1 failed
* arm64: 49 total, 46 passed, 3 failed
* i386: 39 total, 37 passed, 2 failed
* mips: 31 total, 29 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 32 total, 25 passed, 7 failed
* riscv: 16 total, 11 passed, 5 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 42 total, 40 passed, 2 failed

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
