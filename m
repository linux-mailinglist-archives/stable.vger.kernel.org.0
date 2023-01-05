Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFE665E740
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 10:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbjAEJEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 04:04:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbjAEJDz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 04:03:55 -0500
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BDEB50158
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 01:03:45 -0800 (PST)
Received: by mail-ua1-x933.google.com with SMTP id s23so3158575uac.6
        for <stable@vger.kernel.org>; Thu, 05 Jan 2023 01:03:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y89172gHat83R+XW0CVgCx1KzTJTkgHiOfvOklMLujw=;
        b=kxtt+AJpVGdmJCgA5vFkqAJggXETeyCwVxGTf1NBijRIzJ2T9O5i4M5JJ9TX8VNita
         cJPfqTHgKOd/UubW9pcphsRZO2tuUWdcU7D239w39Hy/TpSQbZ9mee0PMPzm+AIFFdCN
         BTQcqe2BsXFf16hr8adsec9heLXhd8NDZx6J3YDd20LMguPoeL5YuPUlknsTUPWFwyrq
         7mXXU3gZDYC+mGHLqshUDmYluFoLoDXX3RGT+/vBqAmEbD2i+xrKD27exHCJEZFVmNwG
         n6DYObhS0hZlfBph0oA3+AsKo3CrOcRSHgKeixFn4EPs6MweC+ZgMPFB8MZdId5zrHtq
         U8Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y89172gHat83R+XW0CVgCx1KzTJTkgHiOfvOklMLujw=;
        b=Ulc9PbRz09jV0CY7YXvXeZBBSBDwEW71XZyF9TfPKXgKiWzKc2EQpclC3PK3OC+M6F
         Jm0B4ADAEVq/Y5rK2FE/SNhx2NNdEmYO8DrAn9KlpHKr4/R82IwAyWyRpU8VE5L7w6zU
         R0w/yxoFHZ0V3L5mTZVsr5b6ZlT8o5Q9X4pEUj6QdcGmznN2SRCAjvIPEKDTHh5Ii//Z
         w9Cwb6euMQL1nhZTt9f40YXak6+fhW3WTTnJt33/xapMjO8dJ2Y261UYDYhsxNPeacWz
         oSuVe+yRr3TIHBqq3yLfDodnRmI5veKC+2spGB4vI718gQk/Y7kaV9xUo5S4Z9K7d/VO
         SszQ==
X-Gm-Message-State: AFqh2koR0mmFdPypGAj17g6CjExnyk6BglKpPAy0eY2+ggyZ9e4Z+4rH
        mkb3ygoEHM5eUw5XAvjEIjztjkzi15BxV5faXyDEiQ==
X-Google-Smtp-Source: AMrXdXtfhxFzrUpZZi1viint0vt7knF8vDywKAfGkezYKhyhSQRW0wKW6qXuH5l7k0bmtOmlghlkJ6V/1I8oHWtbn7s=
X-Received: by 2002:ab0:5a49:0:b0:424:e8b8:7bcb with SMTP id
 m9-20020ab05a49000000b00424e8b87bcbmr4723446uad.123.1672909423935; Thu, 05
 Jan 2023 01:03:43 -0800 (PST)
MIME-Version: 1.0
References: <20230104160507.635888536@linuxfoundation.org>
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 5 Jan 2023 14:33:32 +0530
Message-ID: <CA+G9fYtkNFcQU0SBBp-MOfvp0At3t6wiMKWkmwY07_1NO+qzEg@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/177] 6.0.18-rc1 review
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

On Wed, 4 Jan 2023 at 21:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.0.18 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 06 Jan 2023 16:04:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.0.18-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.0.18-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.0.y
* git commit: 84ff81fcb901cffd40f9a2e3855625dfe6de40a0
* git describe: v6.0.17-178-g84ff81fcb901
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0.1=
7-178-g84ff81fcb901

## Test Regressions (compared to v6.0.17)

## Metric Regressions (compared to v6.0.17)

## Test Fixes (compared to v6.0.17)

## Metric Fixes (compared to v6.0.17)

## Test result summary
total: 160249, pass: 133003, fail: 4216, skip: 22687, xfail: 343

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 148 passed, 3 failed
* arm64: 49 total, 49 passed, 0 failed
* i386: 39 total, 36 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 32 passed, 6 failed
* riscv: 16 total, 16 passed, 0 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 42 total, 41 passed, 1 failed

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
