Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F17449384E
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 11:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbiASKWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 05:22:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344075AbiASKWG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 05:22:06 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C3A6C06161C
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 02:22:05 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id h14so5838284ybe.12
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 02:22:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=M/1mppULbNCo+8UeKdQN4hW6p2XQiRr6LugmFGp2z0w=;
        b=oFQ5TBM8aTehXhCuqf48avpnS9pRh14/OfMz+uFxOrho9dnywsPKCOCj3yzVxgoL2W
         RJtbSFQ4fnaVKErLwHr7REXuY34jPgFqjH7xjniVr8mqTrGXH5cP4+t7FAxKJANvcWKc
         6eYVxLz0D/Fu/4aBB4rYy0JQqJlRRLIkKHy2gTohLRDSdClFyYPSxq8gjAvrJHBcsauX
         Ro35CETgiBAYQLg58QBfYJjWUTW75KKBEkTw95/7tYrxyayAYk2MqW+7x06D3qOn+eVH
         en201+WpLPJugCAw/pLOBQX/14IcdYSQ5leLP/H/DbjLLwJJinn+trp1j4Q3JY/dLeQD
         E2og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=M/1mppULbNCo+8UeKdQN4hW6p2XQiRr6LugmFGp2z0w=;
        b=ojHq9BgPnKLmXMFt55uB+bYp4XFZLV9KV8X49IeRBGXW5rLM2UzL5gcnnLy41PhFGj
         D0Qc4kdNgFAccccBM9Qhkjyv2+S0ikwJg+jy6s7asgo9Srg0fl6aWNu774uhZr3mXWaZ
         hrppGs6GVI4GmnjxqaofIMc4xckc2Coq6eYQNZTmuLMmyUI9e1jLBdB4Cm895jCQyLc8
         TBAmeBlwHHSA+hZM1EVX3rfXe7Gxbsmvx4nN9AFWQLskj/P/pTsiLc3k5U89PoyJ1VLJ
         YWZH0MPBD8wGHUe5lg0wl/N/NHjpfPnKdHz46ju1+Qu+wcqAT5ihqg9bWVhrjSub7+Ks
         7RFQ==
X-Gm-Message-State: AOAM531QeACCGb76O1WVYDHe94giRzkXUmsSFdtM1oTAsRP12zuZjydK
        sevrYuuUCa0LLj7iqrQzp6WrEQaFAOrQ2dtpW8bmvg==
X-Google-Smtp-Source: ABdhPJx2FCcnC+QrEQRAkQas3oqVospC5T0YeqFX9tPSNZgVOLpezStarOgPC0gEzIkk6JdS5f7tYv9jYuDGAlCA1Qk=
X-Received: by 2002:a25:9082:: with SMTP id t2mr16282877ybl.684.1642587724704;
 Wed, 19 Jan 2022 02:22:04 -0800 (PST)
MIME-Version: 1.0
References: <20220118160451.879092022@linuxfoundation.org>
In-Reply-To: <20220118160451.879092022@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 19 Jan 2022 15:51:53 +0530
Message-ID: <CA+G9fYv6n8LOwRQegLnj2KiTfE9SJ1kMorhejLCmd=TiAjHiAw@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/28] 5.15.16-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 18 Jan 2022 at 21:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.16 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 20 Jan 2022 16:04:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.16-rc1.gz
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
* kernel: 5.15.16-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 9cb47c4d3cbffab691a8fd73fa89f4965b423a82
* git describe: v5.15.14-70-g9cb47c4d3cbf
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.14-70-g9cb47c4d3cbf

## Test Regressions (compared to v5.15.15)
No test regressions found.

## Metric Regressions  (compared to v5.15.15)
No metric regressions found.

## Test Fixes (compared to v5.15.15)
No test fixes found.

## Metric Fixes (compared to v5.15.15)
No metric fixes found.

## Test result summary
total: 97762, pass: 83782, fail: 574, skip: 12431, xfail: 969

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 259 total, 259 passed, 0 failed
* arm64: 37 total, 37 passed, 0 failed
* i386: 35 total, 35 passed, 0 failed
* mips: 34 total, 30 passed, 4 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 52 total, 48 passed, 4 failed
* riscv: 24 total, 20 passed, 4 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 37 total, 37 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
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
* kselftest-kvm
* kselftest-lib
* kselftest-livepatch
* kselftest-membarrier
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
