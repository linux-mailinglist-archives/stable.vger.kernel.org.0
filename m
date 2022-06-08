Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37CAD542F5C
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 13:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238387AbiFHLjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 07:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238398AbiFHLjV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 07:39:21 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BEB1E0C3C
        for <stable@vger.kernel.org>; Wed,  8 Jun 2022 04:39:16 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id a30so17297703ybj.3
        for <stable@vger.kernel.org>; Wed, 08 Jun 2022 04:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=URahp1i/xdhO0qEtsUrc5LYw6DVXl05KdvtBCJZgyMU=;
        b=NRVzR7fYPN6ZmdXq1ws2IEmw0f5TTX8u0rTv1ETMx6Ijw0N0bsk2v0l/q7U/w68qwr
         DIjuWqgFNqVDM8yGbS3hb/c9vCSe7sbiZ0A7oWL1z8cMXzIOcoUDnB/jZRuRv86O6s2m
         V76qTiROj8owjD5axxq5eWwvqYIdkX2tUn6p6dHe/jhE87LdXkzwWu20/UQdRoYjjkhh
         kMixl8QXQLLy1+2aD044ff4/zd2y2xJWoFDslMetkHM/AQbEYF5WPcx//ZlFbwD4fQbZ
         KTPZq9UTr2OVQI/IYKDBCbn8CaV++T1iNMMhtxVSDRdLyOu981FJx57Auy0E04zcKoPs
         YyTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=URahp1i/xdhO0qEtsUrc5LYw6DVXl05KdvtBCJZgyMU=;
        b=in33LLcxIx925eVlZ3fHPxW0jThK7Z765LAkzWdJcaxvk6ZQUtkdTyN88zyKQZ0Rke
         +7hvptN/+jH04z50+g5AN/OP3Qf0JPW0Ltfs6MnnjQ+8QVG9gmKE6YO5M2BdD9Uy5dAu
         F8vpwpQ+3scKGPuqJsWbGR/N/KFZ6Lxqm9GIzoemLrxjTDToXJaoSO5MqFXmsBxRoJ8E
         Zv1O7Se0g1IBZqZvAh370ksbMtdP+xj0sMmm3+DMFyHDS7QcFBXRpSN4mEFqM+895HPh
         jUuAJ6DnsJgquls1nkkoaet444l76RHTiJpl5/hjJA2fzHgf6w/cmFZJ+p9eghNIsUb4
         bRyg==
X-Gm-Message-State: AOAM531CUVGEvXu2DoMaCx4uBfgVc8P9sPPpIRshi/qEsl9iOJQ8GhmO
        UIWW8Opjqm/qY18YVLTeWQB5Zul2iJbsSMiwp2NGsQ==
X-Google-Smtp-Source: ABdhPJyxzNjPyliKmbwzBYSdNaOShihgm0albFfiLg+OD33XB3DIHs9eJuyVDBE7rl6NoEvc8Y1fgmB/0+35EhJiD0Q=
X-Received: by 2002:a25:4f03:0:b0:663:dd99:b7d2 with SMTP id
 d3-20020a254f03000000b00663dd99b7d2mr7829897ybb.490.1654688355262; Wed, 08
 Jun 2022 04:39:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220607165002.659942637@linuxfoundation.org>
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 8 Jun 2022 17:09:03 +0530
Message-ID: <CA+G9fYuEOmX+Jq75AtaAgUHCzOgPCiOgGTGqeANAk72eUqRRTA@mail.gmail.com>
Subject: Re: [PATCH 5.18 000/879] 5.18.3-rc1 review
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

On Wed, 8 Jun 2022 at 00:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.18.3 release.
> There are 879 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 09 Jun 2022 16:48:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.18.3-rc1.gz
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
* kernel: 5.18.3-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.18.y
* git commit: 09bf95a7c28a7069eb8bb958d434a575a0c63454
* git describe: v5.18.2-880-g09bf95a7c28a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.18.y/build/v5.18=
.2-880-g09bf95a7c28a

## Test Regressions (compared to v5.18.2)
No test regressions found.

## Metric Regressions (compared to v5.18.2)
No metric regressions found.

## Test Fixes (compared to v5.18.2)
No test fixes found.

## Metric Fixes (compared to v5.18.2)
No metric fixes found.

## Test result summary
total: 136450, pass: 124786, fail: 519, skip: 10295, xfail: 850

## Build Summary
* arm: 17 total, 14 passed, 3 failed
* arm64: 20 total, 18 passed, 2 failed
* i386: 17 total, 12 passed, 5 failed
* mips: 4 total, 1 passed, 3 failed
* parisc: 2 total, 2 passed, 0 failed
* powerpc: 5 total, 2 passed, 3 failed
* riscv: 5 total, 5 passed, 0 failed
* s390: 5 total, 2 passed, 3 failed
* sh: 2 total, 0 passed, 2 failed
* sparc: 2 total, 2 passed, 0 failed
* x86_64: 20 total, 17 passed, 3 failed

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
* kunit/15
* kunit/261
* kunit/3
* kunit/427
* kunit/90
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-cap_bounds-tests
* ltp-commands
* ltp-commands-tests
* ltp-containers
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests
* ltp-fcntl-locktests-tests
* ltp-filecaps
* ltp-filecaps-tests
* ltp-fs
* ltp-fs-tests
* ltp-fs_bind
* ltp-fs_bind-tests
* ltp-fs_perms_simple
* ltp-fs_perms_simple-tests
* ltp-fsx
* ltp-fsx-tests
* ltp-hugetlb
* ltp-hugetlb-tests
* ltp-io
* ltp-io-tests
* ltp-ipc
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* packetdrill
* perf
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
