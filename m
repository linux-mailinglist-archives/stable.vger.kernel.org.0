Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0256A65BC60
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236949AbjACIkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:40:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237022AbjACIkt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:40:49 -0500
Received: from mail-vk1-xa2d.google.com (mail-vk1-xa2d.google.com [IPv6:2607:f8b0:4864:20::a2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC8C3A3
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 00:40:48 -0800 (PST)
Received: by mail-vk1-xa2d.google.com with SMTP id t2so5116384vkk.9
        for <stable@vger.kernel.org>; Tue, 03 Jan 2023 00:40:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8i88fFwQ2DfKICu2wgKkZM23uQG5oyHQDsmWR5cDPPk=;
        b=ghiREmEwTm+U8jAyW4BeyB+NeHQiHwBQpq5XZ/ra+Bx1KJlEPYg3vkeA8ZtT6LJnap
         oWtBaBjmmL+fD6ALi1kPgQAPpasXbE8cpwKl8CLn6SeHOFJ4Rp7XWBpXpXPFzq5VaEeW
         +EL+w03PhzRwJMfy2jCkuNn5fnJJSiKEocJ2smAq3airLZxN/S2hq442rTnYu0zSWR7U
         nHSEvmdpliAs9fu37PijemcWw3cJVPPeBd5eOQOyga8W0cynkt37xaHpDvf2bVKRhNtY
         t0X0snzSb0w/q9q3xVwMNEjDK7hDuOf5KjHjkBNjoYwLCbLJkhlFRVZ+kVcDVvmO7ewg
         +sIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8i88fFwQ2DfKICu2wgKkZM23uQG5oyHQDsmWR5cDPPk=;
        b=pLgdVMZ3Yhe7CUeI7zIaF/oW6/fDtS+hepyYuYuAXwTvAKADq7pTSqLU6Xjkm2Ra3u
         R+LGWMIKftRcQAHeeGOu+N6hacsIoaw7fuGurCYiFHWdW8vvwLVafjuguE7UOnr+MS/1
         F0A8HAE7bPKhr+HQIjlGf7aiir9zhWtZ2wuNrmLAui6n6Ok8HLMkylBwoLFDNw8BUN4r
         hqJROBfzgPZ+7I5Q7yqaJwOgMAKvRgnBShky9Bm2PIcjFx7QdNUOQn5UrQs06ZHDpR4w
         t0kOmDmhzFI9FhtadJwGQ9b528HowUokrXg7Co8+Th07SOOSbsYvsjrLFT5OS5n3JsTB
         nVXg==
X-Gm-Message-State: AFqh2kpC93xkEwHrJb3r+0AmvYW1mrwdAq/O23/RsRP1jTuEET5dYj/q
        csatJq1/mKfczUDle8IZuu665AVta/K0yJGxUxFsXw==
X-Google-Smtp-Source: AMrXdXsnNCKj450ZyFR2XB/uLFTox3prKEPRSZY4QvE83ouSiwLe4iLhIs2HIUOEWhv5mm1TDMrs1rmQ/8C7nkaGiuI=
X-Received: by 2002:a1f:9e12:0:b0:3d5:de78:715f with SMTP id
 h18-20020a1f9e12000000b003d5de78715fmr168090vke.7.1672735247886; Tue, 03 Jan
 2023 00:40:47 -0800 (PST)
MIME-Version: 1.0
References: <20230102110551.509937186@linuxfoundation.org>
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 3 Jan 2023 14:10:36 +0530
Message-ID: <CA+G9fYv8Rdm2px+=aywK91RKEb5zu8KNvMXmu1u7wJR4Y=ma0Q@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/71] 6.1.3-rc1 review
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

On Mon, 2 Jan 2023 at 16:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.3 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 04 Jan 2023 11:05:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.3-rc1.gz
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
* kernel: 6.1.3-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-6.1.y
* git commit: 6b5c4463f777f449d7e177fd1aa608e0b69f33db
* git describe: v6.1.2-72-g6b5c4463f777
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.2=
-72-g6b5c4463f777

## Test Regressions (compared to v6.1.1-1141-g9c94d2e408ab)

## Metric Regressions (compared to v6.1.1-1141-g9c94d2e408ab)

## Test Fixes (compared to v6.1.1-1141-g9c94d2e408ab)

## Metric Fixes (compared to v6.1.1-1141-g9c94d2e408ab)

## Test result summary
total: 166702, pass: 148814, fail: 3210, skip: 14678, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 146 passed, 5 failed
* arm64: 51 total, 50 passed, 1 failed
* i386: 39 total, 36 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 32 passed, 6 failed
* riscv: 16 total, 15 passed, 1 failed
* s390: 16 total, 14 passed, 2 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 44 total, 44 passed, 0 failed

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
* ltp-cv
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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
