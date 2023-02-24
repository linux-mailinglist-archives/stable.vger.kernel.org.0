Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDDB6A1A49
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 11:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbjBXK2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 05:28:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjBXK2X (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 05:28:23 -0500
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B07C816307
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 02:27:54 -0800 (PST)
Received: by mail-vs1-xe2a.google.com with SMTP id o6so21134134vsq.10
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 02:27:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+wQ0LnxDqyXNhIiasmsXcdl7r1rET+0V+JAvqOijLUA=;
        b=nIZ9s6rS3Qxe7IMXjl7HGHCiKAPJVNiKVTwyTEdGP6qCPxoh/M2th9Vt/Z//AhxYan
         ihujjmW0z2LoIuQQ1AwHkmic2ZJsXTI23ulor4XGEOGw6a5bN+JggC/TRwDMfDMw6vKe
         SzeArBj/0fTrnjDKW1PmxRSxIhOxfPIcfzYlkMoQg/0hKhrY3s+s/Lcipq5vnYu3wkFK
         qrp0r7UV86upv4A9BEh8Ck/Zcs/dTcgMjjinlpwtMvmKC8u9t7qnJ6W4RhEfXqRB2UBm
         v92VKtf3/vlDBuYf25o3jtTucnroE5GnPHc1jVx87Vby7EHAwsv5JGy+dWDTBTqUcC9+
         WZUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+wQ0LnxDqyXNhIiasmsXcdl7r1rET+0V+JAvqOijLUA=;
        b=Q7AybWjEnnfpzCTbwS2LfrOL3OovEL2gI/cWO840Sd5kzSAa27Pll8d5q/fG0ZFDMv
         5FheCzYS9TrluZaauyfSrM5K2S0Vu9AAzD1jetMfMgtRafGQCwgWsuZ0jcR6C8VVB4Im
         v5PR95PlJptyjtylPRs3mDYiUs/oM+JhwIV4JzuGyYLtx1BT/UOMSANPvbcl6wbVReYy
         hb4J8DBeB7XzBHmuq5TGbqlv0HZ+5an4sWj/cY4pT/5hJHcvSg5Jw+Dwgc0aPcLkfBC7
         zJ5pA9UBtpsT+EMrdm49ZPxdtLPnYkVsnR8hBbvyPlQYQxUNCcYihiiHBWzbNcK43vOO
         cx6g==
X-Gm-Message-State: AO0yUKVRx/kD5p7JGjk19V/WPwoZ/OTgGMzM5Gio7nEQkUZFdyaRE6sc
        LOsDBP99Epa+wh5zvEV6J5vJ98oJzoRJVaENEWoxXg==
X-Google-Smtp-Source: AK7set/hvgIAxYTcidM2yJpC4ZO+bxxX1Zd8baIlkBw23OgUiir20lPqowqmJnzRBu1faje6vD50pG1qZ36kqtrP9YE=
X-Received: by 2002:a67:fbd2:0:b0:411:fff6:3cc4 with SMTP id
 o18-20020a67fbd2000000b00411fff63cc4mr2131876vsr.3.1677234439212; Fri, 24 Feb
 2023 02:27:19 -0800 (PST)
MIME-Version: 1.0
References: <20230223141539.893173089@linuxfoundation.org>
In-Reply-To: <20230223141539.893173089@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 24 Feb 2023 15:57:08 +0530
Message-ID: <CA+G9fYvDYddWyEY1yVk8i5cU2=8iJ6cdhT5Wz+qoHu-qxLnhbg@mail.gmail.com>
Subject: Re: [PATCH 6.2 00/12] 6.2.1-rc2 review
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

On Thu, 23 Feb 2023 at 19:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.2.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.2.1-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel:  6.2.1-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.2.y
* git commit: e81fdea0bf0d8e461d39e9eb1ffb2458509df8be
* git describe: v6.2-13-ge81fdea0bf0d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
3-48-g342b7f3b3ae5

## Test Regressions (compared to v6.2)

## Metric Regressions (compared to v6.2)

## Test Fixes (compared to v6.2)

## Metric Fixes (compared to v6.2)

## Test result summary
total: 180513, pass: 155979, fail: 2816, skip: 21718, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 146 passed, 3 failed
* arm64: 51 total, 48 passed, 3 failed
* i386: 39 total, 36 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 32 passed, 6 failed
* riscv: 16 total, 13 passed, 3 failed
* s390: 16 total, 14 passed, 2 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 44 total, 42 passed, 2 failed

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
* kselftest-net
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
* packetdrill
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
