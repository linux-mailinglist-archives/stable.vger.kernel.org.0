Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB58697901
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 10:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233980AbjBOJcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 04:32:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233724AbjBOJcF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 04:32:05 -0500
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3061211EB8
        for <stable@vger.kernel.org>; Wed, 15 Feb 2023 01:32:03 -0800 (PST)
Received: by mail-ua1-x935.google.com with SMTP id az27so1284219uab.10
        for <stable@vger.kernel.org>; Wed, 15 Feb 2023 01:32:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VSczsxLJDp871T8FxTcILfLyiC/JgETwP9EwHrfipw0=;
        b=FMTqZSI5bRp4pcsrpew7HhChMbxixFNPJetCw0GixdJSrEFsnk8LcapIjEbF4qM9Nw
         EkAM7lI1g1gbW68fCMsqrE9ZwW3SB9ysHI/oxtU8k1TjgF//gkSpBZAaqAHmbRiAZvwL
         g6MRYCVSyE0yPLg5lEo43FQ22UQA2Xm5DjzfnuT9686eWj7d0NpHK4qDdI8cADWREIej
         pB5GHzAzaBbYRNvc5bxE/Z0zuuZgOtHKnJnE67lRoU6dd0Oje2WZ04t0jTTyeUlNuKR2
         CqEt6JRji0AZZCz+poMhx0qgNfcLEDYyNoNKZ7CN+ZI5IA0RRF9czwWOeUzJyzzu0DzZ
         Pm1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VSczsxLJDp871T8FxTcILfLyiC/JgETwP9EwHrfipw0=;
        b=Hi9wubNc3ZUZACBbYrkRtXCYpCtJcoE3Z2sJLtxqFhoNP4lAHvj3muHyBRojhK0bo0
         TAc0oY9+KaAAm6n4JZfVZ2vV1o9HCkSOoD4DB3igX0F2wZfbzuYTIHzd28JRa83p54ar
         aKIq3SEQCabG6XN1RrPTCeWrx9uSGgKoL/BFlMTXZVksq5laRofIfiw6t5S7hJTXFCpb
         ZtMVawtiE6BnTC9k9Y8yq6QIy357RD0kERSTnsii52PVFF0NqNQO2VT30ekIPe/4Qhy0
         auxrdm51CgPde1PB+oCg3u+pQNX9MD/cYQuygdscMdhpPofGMEV117vpmMOj/bHBj58x
         ub+Q==
X-Gm-Message-State: AO0yUKUfqjXcHHV0Ym+/k/hVSiPRGqJTlCpa0iX5D97zAfefe1HbbP54
        JU/RRLpPugJVAiKV2DycSMipY1ymXZhnPM7A9xQS9A==
X-Google-Smtp-Source: AK7set9WWOEeiHBThTwUNguaTMOUHb/QkssNvX6+qWPO3NM0u5Nz3GV3Vk44Zl0CGnB7u7VpsTEArWl8moG7Hp7kH60=
X-Received: by 2002:ab0:539d:0:b0:68a:6a41:c892 with SMTP id
 k29-20020ab0539d000000b0068a6a41c892mr178048uaa.2.1676453522024; Wed, 15 Feb
 2023 01:32:02 -0800 (PST)
MIME-Version: 1.0
References: <20230214172549.450713187@linuxfoundation.org>
In-Reply-To: <20230214172549.450713187@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 15 Feb 2023 15:01:49 +0530
Message-ID: <CA+G9fYv6p5phurrw7VABq-Tdg=92bW996M5+UkT7CY2o0GLFOw@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/134] 5.10.168-rc2 review
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

On Tue, 14 Feb 2023 at 23:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.168 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 16 Feb 2023 17:25:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.168-rc2.gz
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
* kernel: 5.10.168-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: f90240a238a9596894598787d667151f6af55c58
* git describe: v5.10.167-133-gf90240a238a9
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.167-133-gf90240a238a9

## Test Regressions (compared to v5.10.167)

## Metric Regressions (compared to v5.10.167)

## Test Fixes (compared to v5.10.167)

## Metric Fixes (compared to v5.10.167)

## Test result summary
total: 158564, pass: 132104, fail: 3591, skip: 22651, xfail: 218

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 148 passed, 1 failed
* arm64: 49 total, 46 passed, 3 failed
* i386: 39 total, 37 passed, 2 failed
* mips: 31 total, 29 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 32 total, 25 passed, 7 failed
* riscv: 16 total, 14 passed, 2 failed
* s390: 16 total, 16 passed, 0 failed
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
