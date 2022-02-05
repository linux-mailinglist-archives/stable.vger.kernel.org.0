Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC1F4AA733
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 07:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378347AbiBEGvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 01:51:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234002AbiBEGvu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 01:51:50 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77160C061346
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 22:51:49 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id 124so24397247ybw.6
        for <stable@vger.kernel.org>; Fri, 04 Feb 2022 22:51:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AfdtRuh+2hET7DIozfvJbH9tYRwZdSLV1MatljKLXvU=;
        b=cdFyXrDxnYUOmi5ROhNVnm6Qww6T54XH5uClc6mXWP1J5Q7hPyTdW6+8Ock9jwCmDH
         WKEilaaWuBtg+RWEVB1cPKY9yQOUu2AmsLX2lzw+bo2fbC67Ax0kb0+A4QbxK1ujHJ9/
         6Ay1pLicu9BVYjBD71j4HBKJOn6YdkD3aVQo7U0/H7ADR+NIYcbyWpkMSvJLOkV2wfZC
         nOx/pHrVzdfJLJqqiIR+xzKhSz0lJx0IdqRCrNFxa8tEMkdSqDGRUNC+MrhyjoWvTzgK
         NLC99BuOaGwb7TbUTG0Zr4MyJXTMkE2ZHcwfh8aDmeX2dq4kaqyQbNFHgTNRW9L1qQOI
         NLfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AfdtRuh+2hET7DIozfvJbH9tYRwZdSLV1MatljKLXvU=;
        b=cA6chttD0vJZU06vdhEBCgNtkmegRFPdCg3mAww8Lvow/eWUbN8ljnz/88kak7vvuy
         97utKytXjYH6prdWAEVS6z4SpV8iy9qOSVh6QnHu9h7O8738Bqqe+O0wCcveM1CMehZN
         JV81uubN11WOxqYg+6yWfF/bKd0KudgEdc3+2AQ/jNWDVKp1VU0dtAx6tJckZ0J6vILL
         y9k7zGeA2FzUTvZdeD4X1GXZVzxFRN42kNMPJucBhBRM0cj7qR8qRArf6Iz9RTfv4R7w
         sFce0WVzOjQ5e0ZdCy+NxQANHZoNP6csehP24LJT2Fs26/J0JwvfJ/EN0Dt2KmQ0PK/G
         viIg==
X-Gm-Message-State: AOAM5324ZWq9ncrz73BpokZ2kiQz1CNNw/UtWo/898LQZkmRjGMI8d5C
        V8RZoGRY523itp9wLlR4vfQOXErmi46uhOOgBgNodw==
X-Google-Smtp-Source: ABdhPJy2VLSDTxVYpEPs+Bln+VIVYOyoA/HSzfiHMuj+Bp5j1LmQzdxbFXy19mY2Bee5C7A9DSOAqrGQFAqfQ5DT1W0=
X-Received: by 2002:a25:49c5:: with SMTP id w188mr2454565yba.200.1644043908430;
 Fri, 04 Feb 2022 22:51:48 -0800 (PST)
MIME-Version: 1.0
References: <20220204091915.247906930@linuxfoundation.org>
In-Reply-To: <20220204091915.247906930@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 5 Feb 2022 12:21:37 +0530
Message-ID: <CA+G9fYskqJgYwp_m5uvDOYkY7JZqatdoDmVVPhYSbTszvcfi9w@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/32] 5.15.20-rc1 review
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

On Fri, 4 Feb 2022 at 14:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.20 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.20-rc1.gz
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
* kernel: 5.15.20-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.15.y
* git commit: 61f904d1d62716d179a70419e910118621910751
* git describe: v5.15.19-34-g61f904d1d627
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.19-34-g61f904d1d627

## Test Regressions (compared to v5.15.19)
No test regressions found.

## Metric regressions (compared to v5.15.19)
No metric regressions found.

## Test fixes (compared to v5.15.19)
No test fixes found.

## Metric fixes (compared to v5.15.19)
No metric fixes found.

## Test result summary
total: 104639, pass: 89348, fail: 1149, skip: 13256, xfail: 886

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 263 total, 261 passed, 2 failed
* arm64: 42 total, 39 passed, 3 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 40 total, 37 passed, 3 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 35 passed, 2 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 56 total, 50 passed, 6 failed
* riscv: 28 total, 22 passed, 6 failed
* s390: 22 total, 20 passed, 2 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 42 total, 39 passed, 3 failed

## Test suites summary
* fwts
* igt-gpu-tools
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
* kselftest-lkdtm
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
* rcutorture
* ssuite
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
