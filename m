Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05F126A8392
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 14:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjCBNcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 08:32:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjCBNcq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 08:32:46 -0500
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F013E636
        for <stable@vger.kernel.org>; Thu,  2 Mar 2023 05:32:44 -0800 (PST)
Received: by mail-vs1-xe33.google.com with SMTP id by13so4887422vsb.3
        for <stable@vger.kernel.org>; Thu, 02 Mar 2023 05:32:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e+JOa9pZ7+ghAgpItfrprFVqlWXmHMHYenIGtlQBzKw=;
        b=F2k5RDZeoIE5VJbWxYIWjjFQMBpubb9nOElNeKL6kxhHkh+1ag7CjXfXi9IkwbNaWC
         7h4n5E9dSML3Oy9qh3EQhg/yzXRGsLMgc3U82wwuyvsyjhSDS51YM962HebyssumV59V
         KH6NnWO7EVVa/LoLb+vKEYM6427Vr2RLBGLyYJmdBTTSgAI7oNMmy/2jDjX6/uy6nxSi
         0xMphofecLvx3/bJAKv4G7viTet8/aUB0+eXZadXdimALk3R+ifpT8Y3bZkea5yKFtqa
         Mkob0wLPQWTUEcE4UUvj+pcRwl7i2vW2Vu7Nq/qfGPztYMXTBZweVckdx7bFb/kRZQ1R
         h1Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e+JOa9pZ7+ghAgpItfrprFVqlWXmHMHYenIGtlQBzKw=;
        b=u9hp+5mU6F9CGldwNetQvQY08/jAB1PzCUUEkPywYMIP7KYVO4dMoj8w294n/ul5RX
         Pcta6ag3DGJScnLPEZZDkdGa99oNV6k61ZuZzRo/OvypGR9tswwkRCDLgk/Gn+IO3i6h
         LVxBBZy3mVGKptQQz0F1Tm2KPK+Km6AgAoJlDxlaGbK6zM4AEB1RYJTHpnkG94FmHbke
         WLVmqNZIVDyLVci7+jy/O3K7Gu+RmUQmzVrMUrv3yb2C7TOhFLUqnh6gXYdSDuYek7Cw
         a8JgmjNoFpRMC3fIwmLeez6Co3DbTAnmGZzsLR4WucE4JM93kF2y1xFVkzR3RsJXp7Ti
         CsMw==
X-Gm-Message-State: AO0yUKVzkycPL/+Z9hd0C9K4QJ4IC1S/rmA6snprs6zB511h4NDLnwVF
        yGuzugQCPuCsTXhCqXkEofolR0OdI+RhJe3nYME5fw==
X-Google-Smtp-Source: AK7set8PXR+poX2YcXj7iCgYydTF+Ao1o9SGyiLg8mU8hDre6+aCk1K8aMCxotCIKFtKAoNrlqhM17w7h8cWXXNfNOc=
X-Received: by 2002:a67:f6d5:0:b0:41f:641c:f775 with SMTP id
 v21-20020a67f6d5000000b0041f641cf775mr6258638vso.3.1677763963739; Thu, 02 Mar
 2023 05:32:43 -0800 (PST)
MIME-Version: 1.0
References: <20230301180652.658125575@linuxfoundation.org>
In-Reply-To: <20230301180652.658125575@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 2 Mar 2023 19:02:31 +0530
Message-ID: <CA+G9fYt_2bZ3AXe49PkGF3s-WLY4=+oDa20dYR5YHZr+tV1haQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/22] 5.15.97-rc1 review
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

On Wed, 1 Mar 2023 at 23:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.97 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.97-rc1.gz
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
* kernel: 5.15.97-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 6e657625508dd663e1229f6f6677c578cf36755c
* git describe: v5.15.96-23-g6e657625508d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.96-23-g6e657625508d

## Test Regressions (compared to v5.15.96)

## Metric Regressions (compared to v5.15.96)

## Test Fixes (compared to v5.15.96)

## Metric Fixes (compared to v5.15.96)

## Test result summary
total: 139666, pass: 116363, fail: 4228, skip: 18769, xfail: 306

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 115 total, 114 passed, 1 failed
* arm64: 42 total, 40 passed, 2 failed
* i386: 33 total, 30 passed, 3 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 27 total, 26 passed, 1 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 12 total, 11 passed, 1 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 36 total, 34 passed, 2 failed

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
