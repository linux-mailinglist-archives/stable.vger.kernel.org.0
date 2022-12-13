Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A405D64B4C5
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 13:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235367AbiLMMGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 07:06:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235555AbiLMMGC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 07:06:02 -0500
Received: from mail-vk1-xa2d.google.com (mail-vk1-xa2d.google.com [IPv6:2607:f8b0:4864:20::a2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D9C3891
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 04:05:53 -0800 (PST)
Received: by mail-vk1-xa2d.google.com with SMTP id v81so1425921vkv.5
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 04:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=atw8GONqw/Dh7pq6QHVWIz9UCL87+NRHru4MFr8q3M0=;
        b=WFt1B+cWMhNV3g3tNeb9DZBCPWih6xNa/J52tJN63PmLonaLlv1MBCSPBY8s0r8JNM
         YwR8QE/k0AKCoiFJKaJt9brz3BSIsYH39rNEEURZstZ3GXk1NWb/6IcPM/rrpJ+jC6D3
         shiB/TOhAYfeirGXDPi2TIpR+qd+Ici8rAXefBxOovcoje9+1u/pusfliJI0CH9UceEo
         xfby/0x77Al1dGitrnP4nXTEEz5U459djCVjg3R2CJ0GoOtda3S4NxFLfk8hAV5NT/kk
         xMK33ksZGewtgNNCsUd4OxFz9YxY8Oqy2cDia0n9+O16lkdhisXGMbMbisjAmBI2hy9x
         BeSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=atw8GONqw/Dh7pq6QHVWIz9UCL87+NRHru4MFr8q3M0=;
        b=Lbcr0TI8v2kVEw0jCmtJT5OEL8NQUvD/jkVW7W9yi9Xf51W0us59LoHMao6wWr7KJO
         s0iqCCoeKPJILtTBi0y8zB/5/Hm1vhHfqSY74wk6MXr3RotdT9IcgkUo2Awbn0vZp+u9
         qyJuCkGaxaHHS7/PLVSg8qGGuRgLjkZF7IfAOqonivczAgU9vmGrIf6ufJQrEaXTFgTe
         va+OD9SfZHV7IPUIot0U6AXNRtA9ymtqru+MN0G35y/G0D2lxU/+YfRnIyEPLVzVhjMt
         4+WPhpUmH6by0/+TjHAaLrM80KHNU/GTIRKfSH4WnrT8BKYq0IgLkxZJe2AVgYen/wSJ
         q3DQ==
X-Gm-Message-State: ANoB5pl6X6/Ky+zhG/Lq9l/TxmEjgmTb33BNwfC2BIp2dpqxFs+2efqI
        4VQh5XWHKcL0fp1qxs7H9NXJ0n2VN2uYV2JRqvkiwQ==
X-Google-Smtp-Source: AA0mqf5a1GFQo2eP5jLkOjw6izO0mJUysgNLBd4enZUUtJ7H0Xb/tIZVo0F7k32YOP9NQVmd9MHHeZTMwi2Qf+M/4ZM=
X-Received: by 2002:a1f:edc6:0:b0:3bc:b66b:fe7 with SMTP id
 l189-20020a1fedc6000000b003bcb66b0fe7mr36936238vkh.20.1670933151953; Tue, 13
 Dec 2022 04:05:51 -0800 (PST)
MIME-Version: 1.0
References: <20221212130912.069170932@linuxfoundation.org>
In-Reply-To: <20221212130912.069170932@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 13 Dec 2022 17:35:40 +0530
Message-ID: <CA+G9fYujR8JmdS7sJzSOpD-SoJU+FnM_uHp1uKLE6GVT_3k6dw@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/38] 4.14.302-rc1 review
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

On Mon, 12 Dec 2022 at 19:23, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.302 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.302-rc1.gz
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

NOTE:
same arm tinyconfig build warnings / errors as on the linux-4.19.y kernel.

## Build
* kernel: 4.14.302-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 30e132795eb838b35e2ecd48395d47a0a4a6de7c
* git describe: v4.14.301-39-g30e132795eb8
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.301-39-g30e132795eb8

## Test Regressions (compared to v4.14.301)

## Metric Regressions (compared to v4.14.301)

## Test Fixes (compared to v4.14.301)

## Metric Fixes (compared to v4.14.301)

## Test result summary
total: 89742, pass: 77542, fail: 1617, skip: 9655, xfail: 928

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 313 total, 306 passed, 7 failed
* arm64: 53 total, 50 passed, 3 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 41 total, 41 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 20 total, 19 passed, 1 failed
* s390: 15 total, 11 passed, 4 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 51 total, 50 passed, 1 failed

## Test suites summary
* boot
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
* packetdrill
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
