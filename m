Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D534C6C22EB
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 21:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjCTUhe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 16:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbjCTUhc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 16:37:32 -0400
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B1C367D8
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 13:36:53 -0700 (PDT)
Received: by mail-ua1-x929.google.com with SMTP id i22so8850259uat.8
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 13:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679344610;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UNFVgDWAxfZd6z5ADUjqj4/aMzP9FIHByCOteARm1ys=;
        b=KJJe0UwWV4QjhRnYE3CvmlT41cgjiD0vT3se1oKJvN4UK2IT0GlQWgPJ4jIxUVhvRa
         ALXB2+YgHDcqMqsxlwFaEItFtN+Z+8xX6xvaPB2mpc1wO2LQ7nyC9YJo5f6Z49zDFllL
         v8KfaZbRJhn8gOLXJgmQvkWscG8C7bvsh8a/bvJ/C2El/gt0Djkk4ss2cUSYe5mxmOUv
         F1PAKctEzX7fBqzYNMp8CEMKWU0EniesstBn7m9HKUsFrVevHrBqPK0OznRXuRRaBFy3
         Gqj+x6d35S6ZahxK0U+BgN1E2+6R7k9htyFwAhwiamd3Z/e4Kpq5o5/nn4UrvrTCL6BC
         Patg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679344610;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UNFVgDWAxfZd6z5ADUjqj4/aMzP9FIHByCOteARm1ys=;
        b=EvSz1ayAy9DII0VGTgw9ygD8rRwch1hMjWjZGv5APiwof6T7vi9+Vd/diODto41ePC
         UW9ANjULwTM8l42lTkX16W7XtRf7UIbRWrhKdCDzI6Vl4z055FHh3zP7sSdw+7GjSLHy
         LkbnZcWBSkmiVukkE1TzfwkGSXDOmD5zCPnsohbHRIPbxa9jzs17M0R//ft9R6EAsdKd
         W4n1n9VrSBlVR2QiDdJlEZ7D0/IeCmDo2NOAlkeomlM/P2iMVr8K6Eiwyr0YCulZCZSm
         sTD29LvpN6HTvBfoliOZHRoBT7vo3vXA4x6SOz/h3y4wRMyoAppRvkFAIpHQWasR/kbL
         q+qQ==
X-Gm-Message-State: AO0yUKUGKaApVBSYesgfxqO03xYwFQ0nHhAphId+sE1fhxYEiRBoJUnD
        yngfhOoArRSw6P3Z1p/TlA3uB0+cGMMKz3tqlZTyjQ==
X-Google-Smtp-Source: AK7set/zpLOC8SNehffSFXMB1rwH25iIiVTVu2SJzVZ6/uX6VEqNFaJqMpjlico03breMJc9bVk4nt0kfgZEhEaH4FE=
X-Received: by 2002:ab0:78c8:0:b0:68a:8f33:9567 with SMTP id
 e8-20020ab078c8000000b0068a8f339567mr5199591uau.2.1679344609565; Mon, 20 Mar
 2023 13:36:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230320145430.861072439@linuxfoundation.org>
In-Reply-To: <20230320145430.861072439@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Mar 2023 02:06:38 +0530
Message-ID: <CA+G9fYv+NfAzwuzanTG9HLWRV4gYu72SsP3qjnYL+WbSxf0GEA@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/60] 5.4.238-rc1 review
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

On Mon, 20 Mar 2023 at 20:26, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.238 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Mar 2023 14:54:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.238-rc1.gz
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
* kernel: 5.4.238-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 1f8869b1deb887d66df4ca79b9e905f21ddfe1e0
* git describe: v5.4.237-61-g1f8869b1deb8
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
37-61-g1f8869b1deb8

## Test Regressions (compared to v5.4.237)

## Metric Regressions (compared to v5.4.237)

## Test Fixes (compared to v5.4.237)

## Metric Fixes (compared to v5.4.237)

## Test result summary
total: 92175, pass: 73460, fail: 2062, skip: 16591, xfail: 62

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 146 total, 145 passed, 1 failed
* arm64: 46 total, 42 passed, 4 failed
* i386: 28 total, 22 passed, 6 failed
* mips: 30 total, 29 passed, 1 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 33 total, 32 passed, 1 failed
* riscv: 15 total, 12 passed, 3 failed
* s390: 8 total, 8 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 39 total, 37 passed, 2 failed

## Test suites summary
* boot
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
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
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
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-crypto
* ltp-cve
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
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
