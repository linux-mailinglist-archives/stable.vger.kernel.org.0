Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1ACB43AD04
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 09:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232976AbhJZHUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 03:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbhJZHUX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 03:20:23 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C605C061767
        for <stable@vger.kernel.org>; Tue, 26 Oct 2021 00:18:00 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id r12so10142986edt.6
        for <stable@vger.kernel.org>; Tue, 26 Oct 2021 00:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nPXOg67+1qkEmMEuDjAeRK21qCbtEpnDes6fvwObkJ8=;
        b=PQ1hvyltDPUqtB3D9Y1UJLdF2Gxgw3j58Ghl71H3nnGJYKPJq6iYC2dPMNmLwM7hgG
         3dSG6u8bATQffQgI6AZr1p7RVRjbSzIgTtntLHIVcMUSAJiSxEp1vcUWV1dLT0bNdDw/
         RfV60lrhnHb93NCqPQ8r3dwztC9/jsSiTAI1qTa9JwCuWQGwL5vgR8x+oayfhFOttZnR
         FtjvURlyV0AgWdpx5tn/fQyCqtCmv4M4Pjvtj6g7mSlSxScVLUKWRxEHPtA8rFinJmCx
         MD9/jBkVVUwjXO68k163ZOQid9BxZd8cxMNenBzrjxPCi/vxhyiVu96mdjM+0wJz/ihh
         KaFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nPXOg67+1qkEmMEuDjAeRK21qCbtEpnDes6fvwObkJ8=;
        b=nCm8gs9V/iHiujXhYHbZD8s/MGzMkKUrqbmXJFzJP6H01B8o9aCDKqW/JUJWTLCmpP
         WCsHMsW477ZTZHUCJOKeFhqapZaIg7Iwin0wcr6mRlWM++9AwVpUiMo9WRBrrOB6sQH4
         mFaU3MIi/x8QBT8L+3+CeDLdpFcK8ESh34jtl5zR6IHmvCApZeO300+rIc1xivM0wLnS
         I95fyUK+QHngSvi3Lf+LZoGCBkIwaOYKw7EM73FkC2Jkmzk+iCAcQgCk21T386okhJ/P
         9u8DoyH7y8J1AkR6GUbYZ+Gh2qu/zUeW6KVvDiz7fS0VC1ef4b/KLTmu043xTiO4rro2
         nepw==
X-Gm-Message-State: AOAM533DFjvCRPU0WtylkjmMmYRaG3hvwz+U9aZE7naP1Cu5/PjCV57q
        FTzY22lSn6lAK0JJ71dS1rV7VVveFUlqa+ANnSFR+A==
X-Google-Smtp-Source: ABdhPJwHEV5vn6V+f9cA2qrhEKGqnDJGuAaesAhHrnMe0zKzVKgMMZOikd90Gu74qsfhBAKti2AdUreEX1aG67EKeKo=
X-Received: by 2002:a17:907:206f:: with SMTP id qp15mr16739093ejb.493.1635232678687;
 Tue, 26 Oct 2021 00:17:58 -0700 (PDT)
MIME-Version: 1.0
References: <20211025190956.374447057@linuxfoundation.org>
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 26 Oct 2021 12:47:32 +0530
Message-ID: <CA+G9fYvoub6khvCVNObitqz11Z=7ig1y5AXztmvVnDSw0CAHEA@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/95] 5.10.76-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 26 Oct 2021 at 01:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.76 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 27 Oct 2021 19:07:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.76-rc1.gz
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
* kernel: 5.10.76-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: e2430f94799e6bf1f96aeaca998817fed82e9afe
* git describe: v5.10.75-96-ge2430f94799e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.75-96-ge2430f94799e

## No regressions (compared to v5.10.75-88-g629133650a80)

## No fixes (compared to v5.10.75-88-g629133650a80)

## Test result summary
total: 88300, pass: 74672, fail: 525, skip: 12272, xfail: 831

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 289 total, 289 passed, 0 failed
* arm64: 39 total, 39 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 38 total, 38 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 36 total, 36 passed, 0 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 39 total, 39 passed, 0 failed

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
* kselftest-bpf
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers
* kselftest-efivarfs
* kselftest-filesystems
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
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* packetdrill
* perf
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
