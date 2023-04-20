Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8167F6E901F
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 12:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234644AbjDTK0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 06:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234668AbjDTKZp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 06:25:45 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89DF11FE7
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 03:24:55 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id s13so1836436uaq.4
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 03:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681986294; x=1684578294;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GzdmchMAmUCfWvR6UnZ1ij7PF5b4pmFq49R9wQoZK0E=;
        b=NVuhAygbPAMKwQGaKhEmFttmln1l2kICCz7DulpI9iwNcDtSsl7kytCZVTbApJkgHV
         xk/Aog3KGrLh6qBeW2kPBf2y5NgjfHTUGCZIe4HX7pDoLJ8Aj7ZTP7o5wzccCTRE4xT1
         aEHPqAhWnT54k4l/Yr88AxiNYNjcwgEaOM3+QvY4mgi9Cu3Bx9Tbw9nS9hT6+vIuKSd9
         oQV1lYpJN32nRGAUxveeVUEeKo7WAY7qnwgVr4zr9z3se0XesWXlMTV7JeTmv4PgmFHU
         wrHUkWF78/oxi3Ar5Zwq47NOfubI8YBFRiHT7sXkrYfHjkBqxlc6L+budz96QrBRI60e
         O6Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681986294; x=1684578294;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GzdmchMAmUCfWvR6UnZ1ij7PF5b4pmFq49R9wQoZK0E=;
        b=MTOr4CKIEwiKfmNeMOu5vGjslTNVRi2FuILys/NLaVVI7nRHXj9GR3qaahnwO5gCNN
         gwBj7PcWPuKaXEYjG33DXxMoHNRUULrj8ZMxfG8syTHfrFdUm5Aoj6SpMejTkBrZsWUu
         8U0aQWle6AHM0bn+pb2KdhN3ioTwdwvL5aMDgCprN980FOv/QqG78JK43+VnS/r2rqSQ
         MP8m82K6L01auDJ/+m6VemLu8sGx4inz/CFnBWnlZXqLG+LQMW9Rehn2q/hYi1laI3lL
         f1rZNkX4AL4K92j55WGUjebiu8/Ha9JZ8xSUuzv4GkhrERY/6d3Bv5o/+HgWsr3zsHqH
         xOtQ==
X-Gm-Message-State: AAQBX9fiqUlKXLPMOGzc8/J7nlgkcGicvbIfoJA5hr8Afh2vLgh2kmuD
        5wZnF97nNHUIAwyteLWja2aM7tpdEU9fce5lTFE0sg==
X-Google-Smtp-Source: AKy350ZnZnOqHxwdjE1uf8YLd9gJ9XZsKq6ApM1hVHtmaiZLc9Tmxs5NPBGNHFhRL/om6aohTMEAvA+sLlsUEwscqU4=
X-Received: by 2002:a1f:4146:0:b0:43f:cadf:9ef3 with SMTP id
 o67-20020a1f4146000000b0043fcadf9ef3mr432859vka.8.1681986293204; Thu, 20 Apr
 2023 03:24:53 -0700 (PDT)
MIME-Version: 1.0
References: <20230419132048.193275637@linuxfoundation.org>
In-Reply-To: <20230419132048.193275637@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 20 Apr 2023 15:54:41 +0530
Message-ID: <CA+G9fYvPWssNwsfAM=o6VgwT9=mN9ySMXZBfdZaVUNfnvNvusw@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/129] 6.1.25-rc3 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 19 Apr 2023 at 18:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.25 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 21 Apr 2023 13:20:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.25-rc3.gz
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
* kernel: 6.1.25-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 45df5d9a8cbd69338c2516c670817aef975185c8
* git describe: v6.1.22-475-g45df5d9a8cbd
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.2=
2-475-g45df5d9a8cbd

## Test Regressions (compared to v6.1.22-344-g3ffd355e5e57)

## Metric Regressions (compared to v6.1.22-344-g3ffd355e5e57)

## Test Fixes (compared to v6.1.22-344-g3ffd355e5e57)

## Metric Fixes (compared to v6.1.22-344-g3ffd355e5e57)

## Test result summary
total: 165987, pass: 140306, fail: 3995, skip: 21354, xfail: 332

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 148 passed, 1 failed
* arm64: 52 total, 51 passed, 1 failed
* i386: 39 total, 36 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 36 passed, 2 failed
* riscv: 16 total, 15 passed, 1 failed
* s390: 16 total, 16 passed, 0 failed
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
