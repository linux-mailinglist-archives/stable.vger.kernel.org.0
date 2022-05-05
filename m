Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5549E51BF8F
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 14:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354664AbiEEMlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 08:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242786AbiEEMlC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 08:41:02 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80AF655379
        for <stable@vger.kernel.org>; Thu,  5 May 2022 05:37:23 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id y76so7398057ybe.1
        for <stable@vger.kernel.org>; Thu, 05 May 2022 05:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tEMd/zLrxbYdbg2uuhvlaGmu3rjwRRkiLQsaE+nT+sg=;
        b=rSUeAlDKusX2+al0u8A+A85/uZVhGP+J1QkMwzt2NnZ4d7ocNWq9b2IBTYhPp/4VKh
         87YvbbZp5gnhae6xPQcPTR54g+VN2t16uW+U9RZr5bnSGOWTA2IiKtZt2BbAwEMEXQ86
         gieOpgaZ2g1WYJribCRVSPATxLmApPf5ARgySCZjODJyMCGTzcs2NBM3bSHWwIMpesQB
         2BYMzygA03okqq5Km+3pwbTlPKV1dhxwHkUyakuFhQPER5sZs4VXxFgB6wLy7Xjfpwj7
         81naC6/CJCo/2wagHgnRucGMQTyt7oRB5MgMJWJTaAqooTVBYl8l1bZGLgM/nzuRRatn
         PTLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tEMd/zLrxbYdbg2uuhvlaGmu3rjwRRkiLQsaE+nT+sg=;
        b=6TVqcKFtS9Qh5qM0C8ixKw48y+8x/1e+G/S2oemaMJ8y8meVCCI8p4WbPukefyyy89
         0KuSJhdyfaFA6KJ2jdrQq9z6Ezx4eQt8Q2d9jOo/e7aUY+5Mrae4f4JAwn79vtayeais
         R9ZDYzzuaFptaf3adUdTQ1wqdrNT4+f8Y6jUDjyQLG3zTes7q35JpuErgLSM9Y01NXri
         vcoK8VXJzKmLJCRNTIZNn1TIOulGBlPDKTEvwTm7nqf6MFFJAkVx14ohfnOnF7liPBS6
         rc5WRIV7l7WoOp9TUjaYh8W+YFLR6JOPm+U5AtPhysh4eG3oC3RnMcFsGClaYMPkH+SZ
         Vhtg==
X-Gm-Message-State: AOAM532famv8WrhmsC7XeHK1VxbWsWWCh5cU+RmyEgDzRbRK4VO7DTsk
        H9NGmAuCN0kmNWX0gN2Ki2GaDfP6X2SauWu6tSuwDw==
X-Google-Smtp-Source: ABdhPJwMFIvRn4OMXBXw3D3Qu4dFidCuq9dp119PnmhLQ1I8MtR4sTkdLeM9mUvbtyd75IAGoxeEfuVvkkrWJTPtCkA=
X-Received: by 2002:a25:c012:0:b0:648:4912:7b9a with SMTP id
 c18-20020a25c012000000b0064849127b9amr22563848ybf.474.1651754242549; Thu, 05
 May 2022 05:37:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220504152927.744120418@linuxfoundation.org>
In-Reply-To: <20220504152927.744120418@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 5 May 2022 18:07:11 +0530
Message-ID: <CA+G9fYt2Mv1hMeRLg4fv7+yyi9XBidO9dH3bW=svZJcYbm6NSg@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/84] 5.4.192-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 4 May 2022 at 22:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.192 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 06 May 2022 15:25:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.192-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.192-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: a4a4cbb413802e07ea4b9e45236bd75e241dd4ca
* git describe: v5.4.191-85-ga4a4cbb41380
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
91-85-ga4a4cbb41380

## Test Regressions (compared to v5.4.191-74-g65a8a6ba51b6)
No test regressions found.

## Metric Regressions (compared to v5.4.191-74-g65a8a6ba51b6)
No metric regressions found.

## Test Fixes (compared to v5.4.191-74-g65a8a6ba51b6)
No test fixes found.

## Metric Fixes (compared to v5.4.191-74-g65a8a6ba51b6)
No metric fixes found.

## Test result summary
total: 89238, pass: 74202, fail: 874, skip: 12971, xfail: 1191

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 290 total, 290 passed, 0 failed
* arm64: 40 total, 34 passed, 6 failed
* i386: 19 total, 19 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 54 passed, 6 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 40 total, 40 passed, 0 failed

## Test suites summary
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
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
* kselftest-x86
* kselftest-zram
* kvm-unit-tests
* libgpiod
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
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
