Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 152476717E3
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 10:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjARJhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 04:37:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbjARJfA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 04:35:00 -0500
Received: from mail-ua1-x930.google.com (mail-ua1-x930.google.com [IPv6:2607:f8b0:4864:20::930])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F34901E
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 00:54:42 -0800 (PST)
Received: by mail-ua1-x930.google.com with SMTP id b18so2093324uan.11
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 00:54:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=49hVYpdfpGudyxPMxCrvPN1QUwNU0gvklZbqsfCUCE0=;
        b=MZvIz4ucU3ckbBoYyb8BHSztHdYfF/T1xOUu1DUJwso2pkiuOZ9WKT3l57A3A+BLVS
         np+t3nXZ8jvTIt3eDrkpglsgxVgpdwfyIS4zTEMzpEytvCCVF8Wv5NYLIXaze6GMPCS9
         MYcDnL0ttRjUdcBD+Px/1KIY6a7pveaN5qeSKBGSUuZ5tViGxlsOzRANMMeXisd+Ch+U
         MdyGvlHGraIECEzxgcIHSrW9Evfq3lcTOxSn5kF33OLUweKXvjFbv2SSP3k3cHxg11rZ
         mbEt+edQSeZukvlMHL77SnJBtxEb3mjK4LyDJhiCqWWf72zEo4OsRKZPRF/56ZYYcLFh
         x1gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=49hVYpdfpGudyxPMxCrvPN1QUwNU0gvklZbqsfCUCE0=;
        b=JWv30S+XBkJhz+Ixs73fZJZCqArfMgRawfVyaBXW6M0yEBkwyR2iLpU6Wf4y1kRI6B
         qQvs3BTsA7TXK+l2VMgll4S4tjP9ga/fZuwXMrZ36DvBOR4FxC9zSmkdlvuyE6jZFrbc
         y7YNJdCer+MiZsztQrhL1HLYxVN6NMmPyDiOZVr2m1QDsKgd3GGVzBgiaqU2Kga48bzs
         jcD7PcRPme+U/5cL86iI7WA9OyOEjxiQ6/ZoTprGM4fGmLE167IVUb070wnZJ5kq6tx+
         W9p/3NRJDNdxP6t0DVlQ8kyZh3LbYeZrCNJp95BglZwsGMuXm4DRt/IWXJ7CP2omYqkk
         K1gQ==
X-Gm-Message-State: AFqh2ko3nm3uwoOQyyeqizooo7LH+UxYpkO/LvfrfzOPUs0KulKCYyWw
        9TgsKl+mA/rvkFMpNFqLrGi59fBe5HbrNndjpB/ppg==
X-Google-Smtp-Source: AMrXdXugKCqXvSeRnMwos6ZAe03rDqs6gyi4RAQrNJ/ogr4rbIIcW04mOaSGMLnhgth9bR1KUu84pU6rVNG0Hgd9XxY=
X-Received: by 2002:ab0:784f:0:b0:5a4:c264:fb05 with SMTP id
 y15-20020ab0784f000000b005a4c264fb05mr759518uaq.22.1674032081336; Wed, 18 Jan
 2023 00:54:41 -0800 (PST)
MIME-Version: 1.0
References: <20230117124546.116438951@linuxfoundation.org>
In-Reply-To: <20230117124546.116438951@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 18 Jan 2023 14:24:30 +0530
Message-ID: <CA+G9fYsbfzY1=5dZvdHfBqv5nX8wovpXVH2vb_Q1mo+jcTv0eA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/176] 6.1.7-rc2 review
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

On Tue, 17 Jan 2023 at 18:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.7 release.
> There are 176 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.7-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.7-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 507f83506c2bc81502508bb12fc4970dec7b1746
* git describe: v6.1.5-194-g507f83506c2b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.5=
-194-g507f83506c2b

## Test Regressions (compared to v6.1.5-11-g5eedeabf82ee)

## Metric Regressions (compared to v6.1.5-11-g5eedeabf82ee)

## Test Fixes (compared to v6.1.5-11-g5eedeabf82ee)

## Metric Fixes (compared to v6.1.5-11-g5eedeabf82ee)

## Test result summary
total: 177864, pass: 147712, fail: 4982, skip: 25143, xfail: 27

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 147 total, 144 passed, 3 failed
* arm64: 47 total, 47 passed, 0 failed
* i386: 35 total, 29 passed, 6 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 34 total, 30 passed, 4 failed
* riscv: 12 total, 12 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 40 total, 35 passed, 5 failed

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
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
