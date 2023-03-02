Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 648166A8298
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 13:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjCBMtL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 07:49:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjCBMtK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 07:49:10 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3AA1ACC1
        for <stable@vger.kernel.org>; Thu,  2 Mar 2023 04:49:08 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id eg37so66955388edb.12
        for <stable@vger.kernel.org>; Thu, 02 Mar 2023 04:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OQI/f+ntz5M4Olnk/oXWleUzJcGh7PHcTDgD3KqTpU4=;
        b=VO8QARkqui3bdk9IgDxRJ8tx4sSXbFs0G9I1UfkB/mPtW5qbuuRsLbAz7IEJvCR5WZ
         e213cGsSB5qapFM9ybYeGn0bw2vDHRbh8qMRlfP+AgEKhs9iG3p4fD7rxJmiKWzXLigi
         8c22CgDUW8KROMfWXzj/ZMY4lr20WOXr7c457N3rJ2mSerL1XnkdtddJiBy2/lGmHsnx
         nisdhFNONZ4ytJM+aJHTFnh7U/EIkIJJDW7HpDTNvr4Q7UOiT7PmBLipBtp0w3uCeu9I
         iSw+vbkDFZQ9k0kzEGPifWsRB4nsgIR4DKKOcgY90ODVDMPLkq/3eWEeL4uGL4aCU37a
         pa1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OQI/f+ntz5M4Olnk/oXWleUzJcGh7PHcTDgD3KqTpU4=;
        b=BwxNahPUorXVIBimymq9EGej4E4t045jUJr1IQylRGxJo4e3FrjO31NHhpBm0WWQGI
         YSIKUYcRBNXSqRCTGgp/jR1C5PhlhFw3Ryu3zLUcdX6sRuxyJkJWlcIQQLs1ip1qN3Ql
         +5ZarRAfveaalqmWBcl1fNV4zPB3J7yXd4RzcF4jli6m++lRibt4OinNzzUOoo+sCltg
         xo8orl5BHdGFgvNHV7k7viq8eUIRcGJlUWhdEfxvu4y+ys1VUq6OlmpbE3rSOmC3Jfgh
         WfpNj6I2lhcoAYu5i6f8/jzKUAnIOfi4IYji3ddE+So/bFx0rriVlnqEniZW2nZ4Ot8x
         7/7w==
X-Gm-Message-State: AO0yUKVPbMv0spx5P/vcGoZtNa+6aEuyPgSjjmBmqyEimy3zUA6uTgvM
        qADGEIovzqrDPZ4qtaDdS9Fr61834Tgs/18vE8c0PA==
X-Google-Smtp-Source: AK7set+GzA4Iz2XRep1CHwWhdZQyez9Dskjo5QaBGEhnmuAfr806wQ+LW8fFYLjuNxLZakZkKnor0eSJ5dZ8PgbqZ9M=
X-Received: by 2002:a17:906:9d90:b0:8d0:2c55:1aa with SMTP id
 fq16-20020a1709069d9000b008d02c5501aamr4713780ejc.0.1677761346825; Thu, 02
 Mar 2023 04:49:06 -0800 (PST)
MIME-Version: 1.0
References: <20230301180652.316428563@linuxfoundation.org>
In-Reply-To: <20230301180652.316428563@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 2 Mar 2023 18:18:54 +0530
Message-ID: <CA+G9fYud5NoObu9b4qAbFtWibgwgmMHyMs8rRhXV+1MzKvS0cg@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/19] 5.10.171-rc1 review
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

On Wed, 1 Mar 2023 at 23:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.171 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.171-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.171-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 032c569d266c83563696ed018f5679bf7b5afe45
* git describe: v5.10.170-20-g032c569d266c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.170-20-g032c569d266c

## Test Regressions (compared to v5.10.170)

## Metric Regressions (compared to v5.10.170)

## Test Fixes (compared to v5.10.170)

## Metric Fixes (compared to v5.10.170)

## Test result summary
total: 134470, pass: 112238, fail: 3614, skip: 18316, xfail: 302

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 112 total, 111 passed, 1 failed
* arm64: 39 total, 37 passed, 2 failed
* i386: 30 total, 28 passed, 2 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 23 total, 18 passed, 5 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 33 total, 31 passed, 2 failed

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
* kselftest-ftrace
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
