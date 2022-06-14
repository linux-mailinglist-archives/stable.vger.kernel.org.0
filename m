Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3E3854B86F
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 20:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344250AbiFNSSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 14:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238237AbiFNSSt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 14:18:49 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9418313DCC
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 11:18:48 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id t32so16475250ybt.12
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 11:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VTa+7HBzN4I1yS5HfDjgnfKrtisrri6WEDVPxDbVFxQ=;
        b=ZBVB0MZ5W3DJmT3meCnsFiVEZoQLJxwMreZ3ccSi1caXIOs3Km5DJ16BtqxzT7cDXS
         xq3nnPOfgxhFAaIV7Rr/U6jVy3ldOOjmdrF7mFRpuV6PNu6RMN1ZyOVT4RyGiZJDYDb2
         AvtqfTtfjQQE5EWZ2NGQ4nWz2vlgzkwHKX9YZk5RHAaDm8UC5kJJazUVnwiOhHvx1mFh
         y6PKj2j1CVwb6evRuKrlZx94AbvQduUkt4DwjdsxOJjAFXtjEBAD7bUrfJC4xqrLNtev
         AZe7my9mEJ7XsjViSiF8VvtC76QCLLp3rs4UOgPhKPprS/0zBbrJ9NnrwFRjTBbdA8nm
         XPSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VTa+7HBzN4I1yS5HfDjgnfKrtisrri6WEDVPxDbVFxQ=;
        b=ITe0evIcsym7dEvfSq7ivPZWqvYhtZNxTmiYGKy6J9bSoSIvXxy3GJbLY0It0ke/qi
         lykCptu67xXasbISOMxxlMgmYc/0HOzaPh+bd9TUJKFf17ZA7pTZpaZMjC/2zau7W0VR
         WBN2eUw4Y2ZKMAvl1au3KineM8tK7oC9u0avIa7NQUGnSDIoAwlc7ZOHkg+cqznxJs0C
         qAySF+gGKC6p4DG7uEuRTaqzwqYKm8ragBaKwOnaz85e+a3QOzIv3CId1E74hgwCzH5z
         Dk3fwvADeOuAu1EdT9QIEfSAm64I9JJai+KRMZmIsZMi8DZ+Va5PHESQY7Ihy8hvpjRs
         yPEw==
X-Gm-Message-State: AJIora/zXTGhdRufczDeDU+lURNC8G6zDcngiua4ciBqLAOlz3hsqy1o
        9ueWHvT8+R0EED3VgITChMpaSQszAjzkEH+SgePVjQ==
X-Google-Smtp-Source: AGRyM1uGD77koW0RRJfnMM6EDfinAQ/fahDa0nnfUQ3/CQ84ZaurP9aWMq1mLoIaZ+43uQY+Gr1UHw2X6uSkEkp+QUo=
X-Received: by 2002:a25:3b52:0:b0:665:f89b:708b with SMTP id
 i79-20020a253b52000000b00665f89b708bmr2008486yba.483.1655230727620; Tue, 14
 Jun 2022 11:18:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220613181233.078148768@linuxfoundation.org>
In-Reply-To: <20220613181233.078148768@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 14 Jun 2022 23:48:36 +0530
Message-ID: <CA+G9fYuOvZS1vLU7dk5Y_HEXLKOy4CTHkLGbu8wHhMsy3AjpZQ@mail.gmail.com>
Subject: Re: [PATCH 5.18 000/343] 5.18.4-rc2 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 13 Jun 2022 at 23:48, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.18.4 release.
> There are 343 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Jun 2022 18:11:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.18.4-rc2.gz
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
* kernel: 5.18.4-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.18.y
* git commit: af2e7a038285744a8a78048530b20adb9c867089
* git describe: v5.18.2-1224-gaf2e7a038285
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.18.y/build/v5.18=
.2-1224-gaf2e7a038285

## Test Regressions (compared to v5.18.2-880-g09bf95a7c28a)
No test regressions found.

## Metric Regressions (compared to v5.18.2-880-g09bf95a7c28a)
No metric regressions found.

## Test Fixes (compared to v5.18.2-880-g09bf95a7c28a)
No test fixes found.

## Metric Fixes (compared to v5.18.2-880-g09bf95a7c28a)
No metric fixes found.

## Test result summary
total: 123179, pass: 111271, fail: 500, skip: 10729, xfail: 679

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 319 total, 316 passed, 3 failed
* arm64: 64 total, 62 passed, 2 failed
* i386: 57 total, 50 passed, 7 failed
* mips: 41 total, 38 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 65 total, 56 passed, 9 failed
* riscv: 32 total, 27 passed, 5 failed
* s390: 23 total, 20 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 62 total, 58 passed, 4 failed

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
* ltp-sched
* ltp-sched-tests
* ltp-securebits
* ltp-securebits-tests
* ltp-smoke
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
