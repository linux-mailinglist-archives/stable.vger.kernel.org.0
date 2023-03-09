Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80CCA6B236A
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 12:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbjCILud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 06:50:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjCILu3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 06:50:29 -0500
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF58A1FD7
        for <stable@vger.kernel.org>; Thu,  9 Mar 2023 03:50:27 -0800 (PST)
Received: by mail-vs1-xe31.google.com with SMTP id o6so1322295vsq.10
        for <stable@vger.kernel.org>; Thu, 09 Mar 2023 03:50:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678362626;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HiYZzwXd4jtoSzThZQPKSQxGIapRPCL9zH5yq/Shf0M=;
        b=YiRM8YJH6aJ2n64d4YL25ODZVcXkN1HF02cA2PipZrqEnc+F/wAh82TRVzHRVU4zoY
         qsIsVorBFCAXJHDHZaBc+geUe1sgynoGRy1HCdyerXZwNALeSxOz50A1N6/UpmuyR65i
         96NdseMM7UYh0QIe10D3Ko18A97ZNce/YBpVEBtNcKQSUmBZiXaiuwSNjyCDq4o2uyPW
         Dd1o4PADjmdjtwI123PlGVsnWvGCTIJS9g9w5obggWc9CGwHvp3xwZk/HRmcC6o7Z1aL
         99tFx0gXUHuUYw9WerA/cRHFxchKd7rcN+vB0OdJS9fqLO8UhhhvBcmSASL93EGPeVOx
         MLQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678362626;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HiYZzwXd4jtoSzThZQPKSQxGIapRPCL9zH5yq/Shf0M=;
        b=Y0JMe03/i3b+mGMj1TeLNNhtap60R380jK9T3sVGWfoW9jaj+/X1SCWK3nBvFBK5NX
         SYkmifmabme+YyEkuPW6WvSKRQt11bF36bQKVLU+0Hfwn/100IsLdTzzSinUoD8D7/xA
         GYT+aTeXdTfMfz8eLE1Cec/uf72rSZ1DObCMk7eU5Hzx7/ht6Ju+K0VZIMm/iSYTOGvn
         SNnp+oPu7kKNrVsQcTF7aRmkVPkB50iNwa46f40qZcviMgUkvbWNKxCV45pDpRVtgWw2
         QaH84gh3ggbK33zS0GvJq446D6q2sx7Zs9hfmzWGfqeM8nqZEzaeN8jKURdHUAQp5VPA
         A51A==
X-Gm-Message-State: AO0yUKUkmVPRLkEokfvlHq8J5ZHaKzKjQI8wxOhEWQ9Ix4kYe2VDopho
        WFQu8L5Npf53l892lUYntG6xkXFNlYJhXD1gC+dUTA==
X-Google-Smtp-Source: AK7set+ckfVi4sH4kFYU88j8MVo7KGl04SpGQdxUqBTSjr0HT2/3p81USQ4erk/mbUXzgEg5nUJTBteC6Ve1oJa3TCE=
X-Received: by 2002:a05:6102:3e10:b0:421:c926:4b6d with SMTP id
 j16-20020a0561023e1000b00421c9264b6dmr14291413vsv.0.1678362626175; Thu, 09
 Mar 2023 03:50:26 -0800 (PST)
MIME-Version: 1.0
References: <20230308091759.112425121@linuxfoundation.org>
In-Reply-To: <20230308091759.112425121@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 9 Mar 2023 17:20:14 +0530
Message-ID: <CA+G9fYv=uYWAX=fCGZ7ENwAshgFUhVZi6YMJiHsqoTKJMCrLiA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/570] 5.15.99-rc2 review
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

On Wed, 8 Mar 2023 at 14:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.99 release.
> There are 570 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 10 Mar 2023 09:16:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.99-rc2.gz
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
* kernel: 5.15.99-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 95417703d86d2be28dc9d740163b8f48b7869ca1
* git describe: v5.15.98-572-g95417703d86d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.98-572-g95417703d86d

## Test Regressions (compared to v5.15.98)

## Metric Regressions (compared to v5.15.98)

## Test Fixes (compared to v5.15.98)

## Metric Fixes (compared to v5.15.98)

## Test result summary
total: 138674, pass: 115790, fail: 4504, skip: 18075, xfail: 305

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
