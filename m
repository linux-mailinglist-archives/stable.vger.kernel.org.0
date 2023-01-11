Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 386FE665D1B
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 14:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjAKNyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 08:54:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238967AbjAKNxV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 08:53:21 -0500
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D6012A80
        for <stable@vger.kernel.org>; Wed, 11 Jan 2023 05:53:07 -0800 (PST)
Received: by mail-ua1-x929.google.com with SMTP id l13so3692437uai.8
        for <stable@vger.kernel.org>; Wed, 11 Jan 2023 05:53:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hs8zNDDs0guRBNHJ+MuE4jpZoikoTxsHLHrp29d2KYE=;
        b=VSqZBh8nG8YKorjtR6me1swYJUH5mQpYp0P9RxKY5fV1Ni6HR//9epzpnGwN6Mrf8z
         F5juGLQxg1Z041QTfRuOgGyHWgqmOvMrqzR5POFfCRKOfzobH/w2jGR+7aOu1z0J8AoW
         Yn3PsJsFn7qdkvBV3+je3msp8jQy1x1S3cwiI7+SSyQ6i/7tF7fFE+R7/K6FKf9sOUvx
         RPpdfWC2De9RSV27gtIVJS/kdYq5HzDkd35A8zT042fGbV78agXpmdaNCwv3mEPM9vjZ
         lEP1dzhNlQKjLjtH5k9rpc6DL78TG2zH8kYpRt963JlnexC8LvKzXRhP/Ey9cPdd2HG/
         Ty/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hs8zNDDs0guRBNHJ+MuE4jpZoikoTxsHLHrp29d2KYE=;
        b=uCO/NG65mVxem4MJzs6/HVgoiow9M/IT+iXB28SWYwFHqiM4yK48dIrxc7NTQSbKuv
         jo88RnrSx2+mqnfgQTvj4hc+tpUf2rTeSnzuytg6PmCMymaptKLRkpKEX+evhflXvWGS
         pmudC55uzT3kkRKl8T1lf+iUwv94ckIg69baEGA9yw3LvIj8I7aEyVMwODPP7OhAeNjj
         CJTHxloOHUkO1FutiNxzrIRRngymrc6Sz104TDLLXEBWqM6iLU3ttSooEAakHIxfdXxi
         lWj6t1TkguastY7Pa06Z4YG3+Bw2psNkjkLMRypTMew1YnyIozvarkId6aV35ctpQG2P
         pLmA==
X-Gm-Message-State: AFqh2krZhLXo2gPVQIpD9X0D2FcPFZl3IjLF9aUE/yyH4llANburq4Ft
        98kxeNFiIE7orc1Xcy5Q9SgoFthxrqZZs8nKsNvhPw==
X-Google-Smtp-Source: AMrXdXszpcVXeyvXDiC3YTLc+H/R45k8PlHBCpTF08kbAkvIrxuiMiEAXeDO1gGNZboW8F3gQwuLGGvWyEYBvXvZRMk=
X-Received: by 2002:ab0:251a:0:b0:5d5:d02:8626 with SMTP id
 j26-20020ab0251a000000b005d50d028626mr2219346uan.115.1673445186568; Wed, 11
 Jan 2023 05:53:06 -0800 (PST)
MIME-Version: 1.0
References: <20230110180017.145591678@linuxfoundation.org>
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 11 Jan 2023 19:22:55 +0530
Message-ID: <CA+G9fYvfhDRhOs2ahCVS5L2QRSVeO6m5AOY3K6o751U0rxgmvA@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/148] 6.0.19-rc1 review
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
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 Jan 2023 at 23:36, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.0.19 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> NOTE, this will probably be the LAST 6.0.y release.  If there is
> anything preventing you from moving to 6.1.y right now, please let me
> know.
>
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.0.19-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:

Regression reported on arm64 Raspberry Pi 4 Model B with clang-15
built kernel Image.

Insufficient stack space to handle exception!
end Kernel panic - not syncing: kernel stack overflow
https://lore.kernel.org/stable/CA+G9fYt42ntYZhhzqAYKf8J3TdNZ+fRYwNgQP=3DTgC=
LODcpNrfg@mail.gmail.com/

## Build
* kernel: 6.0.19-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.0.y
* git commit: a7ffaeeaf9bb7ab13e00a589d0910efb9119479c
* git describe: v6.0.18-149-ga7ffaeeaf9bb
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0.1=
8-149-ga7ffaeeaf9bb

## Test Regressions (compared to v6.0.18)

## Metric Regressions (compared to v6.0.18)

## Test Fixes (compared to v6.0.18)

## Metric Fixes (compared to v6.0.18)

## Test result summary
total: 167741, pass: 139653, fail: 4441, skip: 23296, xfail: 351

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 148 passed, 3 failed
* arm64: 49 total, 49 passed, 0 failed
* i386: 39 total, 36 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 32 passed, 6 failed
* riscv: 16 total, 16 passed, 0 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 42 total, 41 passed, 1 failed

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
* ltp-math++
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
