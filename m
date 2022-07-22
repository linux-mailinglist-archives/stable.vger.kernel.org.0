Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20AEC57E771
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 21:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236314AbiGVTds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 15:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235563AbiGVTdr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 15:33:47 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D53851A1F
        for <stable@vger.kernel.org>; Fri, 22 Jul 2022 12:33:46 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id bp15so10223038ejb.6
        for <stable@vger.kernel.org>; Fri, 22 Jul 2022 12:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5oxdEkaXhPUPJ0/wg8u+2Mtd7O2U9x1Gsa0zT2Q8HEI=;
        b=AlchECHHpMCmJUfcd9XT4anSGSwKj6kI8rL4ug7CUkzF0c+Zl7l3WdjAG1QTrrCb1E
         StFM3SktZ73zgPPJjWwM4c3sMwE33SabwU+emB+euYjp4ZavzFtevKyQ/KG7ukT+QXH+
         S03QYCh35HMcieKY5zm2HOgUzHVsGv8bR6lZ845gBP3e9gaB2/he6UeIKEZZe5e/hSVu
         YK7WEveP2VKqpIKx7PAVa0hA4ni2A40EFnt9lQKUvwpdyF2lImGa/PK2eZgXUL8c0opx
         lIeoqKqq6PfWhdIeUDZKia/QRekmb/H2PVw9YPbBkA4hpxKkLGAX9DbBTz+c8iBUeMKY
         /97Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5oxdEkaXhPUPJ0/wg8u+2Mtd7O2U9x1Gsa0zT2Q8HEI=;
        b=ZyFaXp7oafqlSphwCqM+vtw+DiCEH1k/dkvECeKrsR7fVYrLlCMXaYge0HkfJTojAL
         PR7F1Ps8UHIYrVBjZ2FSCFSTkHY9WflTRj8vjcr3e5URMPx7mw9ffPyA4QHfYhqpxET1
         m1a77FpviN4MRg7L4dJPtOWyn89g9zKNH045TP7N1Az+qbd5aelIa/cZozlZD2zAQjX+
         4x0dD2DLFeSoJb5AmYs3e4wxy8IpQ7CAdaH1ABcdQDxJhM7kpAMQNtK/49wKy6DvlVKX
         NctP1LPDeY5ba7U95cH6giZyuDMNzG++Nc20hDlruZjHVexAK9Hd1OAyOWgRyUqMLYFp
         oddw==
X-Gm-Message-State: AJIora+ikLBb8TwbPlI4TlUHPNxn1yMhwo72avHLXbygKGEZkG7HJtJk
        3+/ojOz/A4AgCYgwPlWuRIcP05C1QPl0W+ScKDJsWw==
X-Google-Smtp-Source: AGRyM1ueRgegb/NuFRFXw6Zcn8CLw5PNh/V2nLuAycY8OBnDhqkNTHiFuefKd1+oJEhTgof5l/I1Cut0a1iCGZleGeM=
X-Received: by 2002:a17:907:7294:b0:72b:1ae:9c47 with SMTP id
 dt20-20020a170907729400b0072b01ae9c47mr1066032ejc.253.1658518424523; Fri, 22
 Jul 2022 12:33:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220722090650.665513668@linuxfoundation.org>
In-Reply-To: <20220722090650.665513668@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 23 Jul 2022 01:03:33 +0530
Message-ID: <CA+G9fYuya-ovYrsVeb6hFMH9jPDkg59SBTVCJnsV+K=b5NXywA@mail.gmail.com>
Subject: Re: [PATCH 5.18 00/70] 5.18.14-rc1 review
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
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 22 Jul 2022 at 14:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.18.14 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 24 Jul 2022 09:06:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.18.14-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.18.14-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.18.y
* git commit: 4142b06492bc82bde362db55d6f29b0e2e509091
* git describe: v5.18.13-71-g4142b06492bc
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.18.y/build/v5.18=
.13-71-g4142b06492bc

## Test Regressions (compared to v5.18.12)
No test regressions found.

## Metric Regressions (compared to v5.18.12)
No metric regressions found.

## Test Fixes (compared to v5.18.12)
No test fixes found.

## Metric Fixes (compared to v5.18.12)
No metric fixes found.

## Test result summary
total: 131100, pass: 119324, fail: 970, skip: 10006, xfail: 800

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 308 total, 308 passed, 0 failed
* arm64: 62 total, 60 passed, 2 failed
* i386: 52 total, 50 passed, 2 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 54 passed, 6 failed
* riscv: 27 total, 22 passed, 5 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 56 total, 54 passed, 2 failed

## Test suites summary
* fwts
* kselftest-android
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
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-lib
* kselftest-membarrier
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
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
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
