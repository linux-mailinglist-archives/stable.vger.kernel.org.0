Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F98365A357
	for <lists+stable@lfdr.de>; Sat, 31 Dec 2022 10:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiLaJVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Dec 2022 04:21:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiLaJVj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Dec 2022 04:21:39 -0500
Received: from mail-vk1-xa2e.google.com (mail-vk1-xa2e.google.com [IPv6:2607:f8b0:4864:20::a2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD1D65B6
        for <stable@vger.kernel.org>; Sat, 31 Dec 2022 01:21:38 -0800 (PST)
Received: by mail-vk1-xa2e.google.com with SMTP id f184so7082755vkh.2
        for <stable@vger.kernel.org>; Sat, 31 Dec 2022 01:21:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e/g3qXNGRKmpAJr9x+wMFG6BWocLHHPOUAPrClOrnX8=;
        b=KHFR/yCf14ocvWsRcis5VrME6m9q5/Z0O5PgzXSZtNRCE3/nVKZtFyuLj3IZ3NAKsf
         MWvzyEGtOFX2veVqKgVjgSpxKzMsLISNzdCVzJFiHSS7rCtUZuzcrEXustPioz8ByWKp
         ibUiOSA9BLDoob+z40bhk93UOt94lG5GYfmaO6XwA8m1lo1p8ptaCE894voCXL6piQZ4
         p85grAtrOEON7X3dHDDpeTRWSRlEuL9UhOFqXpAIKMyn04DQYYAFR2Yw76c7ePia4kun
         8a2NqJfN1uU+o0TH+5OKVt1QhthIprsUj4RxbrAm7znlaKge8HBjQmNID30+pIET0yOr
         AQgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e/g3qXNGRKmpAJr9x+wMFG6BWocLHHPOUAPrClOrnX8=;
        b=WSrtEYuaSVB6hCPtJB/GE9NKoQ2xbFT9a6+/mAhULKmwATjmm7qv6i0a9lMWRarvQk
         JYx3ceyIV3k0fBs8y6GnWGaAC1nlyTQ9zy+QVniT7NCXGPoxkiuz9axJ+Qomo4Ja66dd
         Um8vZ+4n9awsv5IrkQn6OhLIdvWSPchBM1x7qVA6aiT1aH5X5BoMW+iZN46bUxnHonjk
         X36ibekBY6ltJTw6wOJDITTZiHqgkRQ/F3yhNTSFS9fB3VKWschagq3YBkvKfpXQgq1f
         YtPmUOoniIj09TC7/5FmQiQgvhc0tVnfuE8VTmhpe/FchrePbnmVHWKh7GUlxE03bLaX
         pljg==
X-Gm-Message-State: AFqh2kqn6K2uZChvpR4vzqQ+EdmYYygvNgsO/mUVHCc4ZE9QGWk7uI/C
        XrLV4kuEgdxSOsv5+/HobkuPWW6CQwkeg8QiMO0sHA==
X-Google-Smtp-Source: AMrXdXucb3y7egc4n0bgvS6vU7e6IYdGE6P41ZQlj96u0r+RvOAsz5O67TlLJTsKRGbSTxr7Bw7rgiyiVK/H79Z1soI=
X-Received: by 2002:a1f:6282:0:b0:3d5:555e:49c5 with SMTP id
 w124-20020a1f6282000000b003d5555e49c5mr2137106vkb.39.1672478497736; Sat, 31
 Dec 2022 01:21:37 -0800 (PST)
MIME-Version: 1.0
References: <20221230094021.575121238@linuxfoundation.org>
In-Reply-To: <20221230094021.575121238@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 31 Dec 2022 14:51:26 +0530
Message-ID: <CA+G9fYvhnE8jMrgWe4VHOmirsnmVQQJZO=dsfH5XROGsUNkbpA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/731] 5.15.86-rc2 review
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

On Fri, 30 Dec 2022 at 15:19, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.86 release.
> There are 731 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 01 Jan 2023 09:38:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.86-rc2.gz
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
* kernel: 5.15.86-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 84004df288ffc0239ed4fa69d10ce885ca8b858e
* git describe: v5.15.85-732-g84004df288ff
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.85-732-g84004df288ff

## Test Regressions (compared to v5.15.84-18-gbef75c6188c7)

## Metric Regressions (compared to v5.15.84-18-gbef75c6188c7)

## Test Fixes (compared to v5.15.84-18-gbef75c6188c7)

## Metric Fixes (compared to v5.15.84-18-gbef75c6188c7)

## Test result summary
total: 148583, pass: 130402, fail: 2875, skip: 15101, xfail: 205

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 148 passed, 3 failed
* arm64: 49 total, 47 passed, 2 failed
* i386: 39 total, 35 passed, 4 failed
* mips: 31 total, 29 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 34 total, 32 passed, 2 failed
* riscv: 14 total, 14 passed, 0 failed
* s390: 16 total, 14 passed, 2 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 42 total, 40 passed, 2 failed

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
