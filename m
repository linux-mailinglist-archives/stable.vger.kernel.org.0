Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E69F69E092
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 13:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234714AbjBUMmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 07:42:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234701AbjBUMmA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 07:42:00 -0500
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E7029438
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 04:41:54 -0800 (PST)
Received: by mail-vs1-xe32.google.com with SMTP id y8so3505753vsn.2
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 04:41:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1676983314;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+pSg+Hzb7t5dfpW1K0cuXfE/ecGC3GyQvKNw8DxtAc0=;
        b=LPCQhSj4y91w98bW3FzXRlnAJehtmFOzLyD8zSPTuLSvCPLherrSl8rfnL0tEXZ/wU
         GpqJaLKjexKt4G+dD/gCQ0sFN1n7pd9bb7/gL9Pu8VKsJH7J/+SYbxv/i51mQ27aYgN3
         F3lyExPtlcdYMhg2vBrsI+wXwk+3SC18szDVHaZ0lgMKp6YYWAYXxvOYffRkdm9aXuL6
         Y87G5OD26PtqHASgqkHsKwqsI0L5lclTds6Ojld6UUFUGKQ9ltdL1UBpXoiG4zQObJbC
         XGbse2CJz22VYk736s/PARPa/xf9uGcRm9wroXYj1sAQn2l/JEW2i0GQyJ1nV1fC7upR
         LGBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676983314;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+pSg+Hzb7t5dfpW1K0cuXfE/ecGC3GyQvKNw8DxtAc0=;
        b=PUfbAY3mTZczZOhWW0A9SUWMBHwTe3Vs9gJakwSQRFb3RlpA/LXl/kc0va9ZWbURtQ
         zh1ppcJ38AHTskrbXv5xCJBT6qIZiCS4qQi1KYlb187St3PiTnN59Ioxwl4fmn+tMS1O
         /m9qBt2G+fKuggfrsUP/WO62xkeB4TXKMA+YKX47Mgb1OMYqHz4Sr7USrZXv37PprEGX
         K0R7tapRC+/qkTKzeadIo2VredF0+mvl2JMv6F+TTZKk4F2ndPd45RaHwr4mDmolv42g
         0VeHxpmTXYqS2lxJ4+fKFCb9EWdilprJtjJD2egKeiFneR7kBXygbjdcFSTvGQk7Ue9N
         d9mg==
X-Gm-Message-State: AO0yUKVaAHUA4IJASzS+oODy22ceo7/KhxR2r/adGn+6m0q6zSJPm9i2
        A+QsS1ZGJ24maR6PbtRxGTwcYoVm2pWRgOhNEpU/8g==
X-Google-Smtp-Source: AK7set+6S+M96c3GgrIEjh+AkXol3D62hQiJwDDVLEtX5+ypQvN+GhLJBK62qVPKJ+Pl91ZKgezK2UJErldDrk6xW1A=
X-Received: by 2002:a05:6102:a24:b0:41e:991d:8814 with SMTP id
 4-20020a0561020a2400b0041e991d8814mr228996vsb.71.1676983313635; Tue, 21 Feb
 2023 04:41:53 -0800 (PST)
MIME-Version: 1.0
References: <20230220133548.158615609@linuxfoundation.org>
In-Reply-To: <20230220133548.158615609@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Feb 2023 18:11:42 +0530
Message-ID: <CA+G9fYuuKMfmiso193a+WAKBbgS1vtP_r7hKQPgpwEwNdr7v7w@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/53] 4.14.306-rc1 review
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

On Mon, 20 Feb 2023 at 19:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.306 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.306-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.306-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 2fbaf74fe65717ef42f395575562c1f594810941
* git describe: v4.14.305-54-g2fbaf74fe657
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.305-54-g2fbaf74fe657

## Test Regressions (compared to v4.14.305)

## Metric Regressions (compared to v4.14.305)

## Test Fixes (compared to v4.14.305)

## Metric Fixes (compared to v4.14.305)

## Test result summary
total: 92817, pass: 79357, fail: 3404, skip: 9909, xfail: 147

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 228 total, 225 passed, 3 failed
* arm64: 42 total, 39 passed, 3 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 41 total, 41 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 20 total, 19 passed, 1 failed
* s390: 15 total, 11 passed, 4 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 38 total, 37 passed, 1 failed

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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
