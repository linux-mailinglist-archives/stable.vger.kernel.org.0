Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFD14DD6DD
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 10:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234236AbiCRJL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 05:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234222AbiCRJLz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 05:11:55 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A662817ECF6
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 02:10:36 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-2e592e700acso84716507b3.5
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 02:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SoOE7enjlczkaHcgpHmrsmr2DcQS+ZcmLdn0xvYngVk=;
        b=vDTC/X/BKsT1CpIB1SoY9u/5aWsxLWDeb2d55fKMk68OLcNVxzNpozhCDDEbFtUp3/
         Ky2ZAfnCvwQIgemXjYHLbrfVPbuayv5RNmwPUJbMwXO65C6x1UfkjBCekGMScyj3P6sM
         rsoTWDoOmLcY4aWt6uOjvv2LZvjPoiHumEEllj1IJjQDraxGbhDlqbGPbkBYA182hi9G
         V/t52NxKJi6tR5Vr5sUJ2UKlLGsfn1G1eM28GDa1oNYNmIa1oMQqo8eUEXzjaxZYXhoh
         g0475O7azSdRzIiQ4rq6nIzyGd9mpUAvLsfw5N389XUoNPjZUCY797RUcbTO1rXcKBST
         pH2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SoOE7enjlczkaHcgpHmrsmr2DcQS+ZcmLdn0xvYngVk=;
        b=DavB8IeslghbdL5G+rirW+NA4WPOolfqiHHCiw0JpJzGgnVgQ7H6V49oOa6qcahcXT
         lxWXVR5dDOD4FGvJvky9XO5t6QgMI2Ko2QA9pcBsWVRU0t760xInHdaEk59cfel97uES
         J9zargLPCvpIZt5FrXVk2BDF6sR/PLplBENtJX5eUZcHritvM0B+efBpqM2J3OqEJn+C
         tGI/FLfanNVguCQdjqOyw+J2IHZKljH2/wxjwpMan3G0OiLSCAhEWK6r5V9lcqTJW1kC
         9nIn3t4GL76PBCxGvJR3EQo+ZZ0lSkLXRVZInTM1NS5RcViDSrLz/SyuUpe37P+5yDW2
         eDOQ==
X-Gm-Message-State: AOAM530h0vHzQ3Gl7l+gInDzPru5sJ/gJLJUbZhbfPHoQ0gLQR0enQ0L
        8+4sigVXv81IHsEN/2M71QUAWh3zO7LtQxcKI3r17g==
X-Google-Smtp-Source: ABdhPJy8TixQgbClgZ5uoJxgJPjIe9tVY2iGR+lsYCpCozh+7gd1M4HOyB5Fg1JtlGtOAXLkpeBsI9dOh0Sf+/gWiDE=
X-Received: by 2002:a0d:d187:0:b0:2dc:5d83:217d with SMTP id
 t129-20020a0dd187000000b002dc5d83217dmr9945161ywd.189.1647594635542; Fri, 18
 Mar 2022 02:10:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220317124526.768423926@linuxfoundation.org>
In-Reply-To: <20220317124526.768423926@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 18 Mar 2022 14:40:24 +0530
Message-ID: <CA+G9fYvEFwrMDC30XLh6LWP-N=NATqSnkRkgo2QRk_Hs1uct+A@mail.gmail.com>
Subject: Re: [PATCH 5.16 00/28] 5.16.16-rc1 review
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

On Thu, 17 Mar 2022 at 18:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.16.16 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 19 Mar 2022 12:45:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.16.16-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.16.16-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.16.y
* git commit: 106ac438092ed9bef8fb4c61ec6ad5aa9eedda32
* git describe: v5.16.15-29-g106ac438092e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.16.y/build/v5.16=
.15-29-g106ac438092e

## Test Regressions (compared to v5.16.14)
No test regressions found.

## Metric Regressions (compared to v5.16.14)
No metric regressions found.

## Test Fixes (compared to v5.16.14)
No test fixes found.

## Metric Fixes (compared to v5.16.14)
No metric fixes found.

## Test result summary
total: 108765, pass: 92041, fail: 1149, skip: 14385, xfail: 1190

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 296 total, 293 passed, 3 failed
* arm64: 47 total, 47 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 45 total, 41 passed, 4 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 41 total, 38 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 65 total, 50 passed, 15 failed
* riscv: 32 total, 27 passed, 5 failed
* s390: 26 total, 23 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 47 total, 47 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-
* kselftest-android
* kselftest-arm64
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
* pre[
* prep-inline
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
