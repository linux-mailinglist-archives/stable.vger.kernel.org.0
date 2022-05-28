Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C75536C76
	for <lists+stable@lfdr.de>; Sat, 28 May 2022 13:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbiE1LHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 May 2022 07:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233926AbiE1LHT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 May 2022 07:07:19 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C1E201A0
        for <stable@vger.kernel.org>; Sat, 28 May 2022 04:07:16 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id z186so7515381ybz.3
        for <stable@vger.kernel.org>; Sat, 28 May 2022 04:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NLRyw8M63UlSNHUrxP7vfA9gpWp17zvKChY5N/acJQE=;
        b=tYMtHyFpo+PqGRU7wftNpiB86NAzAfE/ze4Uh9AoRlBrhMZxOVh+Q/Mh/iTgnucnpR
         KUfnhfY+diqyQNjKGB/rzvtaxXVYMsg8NYbiDi4N14i4dm3Yh2Dg0Eny8QWxZC2Saq2W
         P6q6+Vtgj88S3fF7sS/cVX4l38Zi6FuAtbGFYxIJbyRv4BEi3imHRBlmP3+ahWGBk2aJ
         5zGDjy+SH8L2dSS3Pb9ExwKEBcZHM5jnZu3vOBro7bnhslIHBvx3pNkr6T+eRVuPGIWf
         Mvkz9a/i0CHgDHjHDDz5/uyCBtaftcKYbzH8j4K5327nfRd69elj2AR7qEl4TgjcUxm3
         Chog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NLRyw8M63UlSNHUrxP7vfA9gpWp17zvKChY5N/acJQE=;
        b=jHWNEl+igiciJdXInmzQyezh7lXEkwANZImCKM7ezt3W2H/3td8jc9tqMpaVg5c0zy
         SV88zp78a3fDb3nxJsHipiORikEXEd8VTJniqav0V1H+UEYV5YNg6v5++xaOB4FYjM44
         8OET4b3sppCKe5Z2sEuq1Fo+7z7U00Z5tqQfueLbxdsbtZBp9zLQPJCLupRaMnDbpRTO
         mgNA8c5/lwC3UcmWatzylfMU6LM6fZp2/Q5W5PwNojG7jaNJ6qnh/HQQ/pU/OQsE8Fpk
         ICPb3NF6PHMUXADKqPF7PqDqIIUzZdnP+YcTix3poGu7pMpNgpKpmTxL0WdtvT/URtDf
         5QqA==
X-Gm-Message-State: AOAM533yRC2M2t93fId3shdQdpL6+FCBoazPs1rTlLI4hKOrfojIxSKb
        grisfZqp0fC1LLg8Xk16DZ8+ECRhznQesjEMiCJIdA==
X-Google-Smtp-Source: ABdhPJzSC4eWVpMOstiRBA+YAUuqdiKGuh9KvwJBcAzZ6jXSZTdz/UU73h7g+j8HBYcp0OQk0nwS1jG7d6pPmW3ixe4=
X-Received: by 2002:a25:bb83:0:b0:653:ede9:90ae with SMTP id
 y3-20020a25bb83000000b00653ede990aemr20031403ybg.474.1653736035595; Sat, 28
 May 2022 04:07:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220527084828.156494029@linuxfoundation.org>
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 28 May 2022 16:37:04 +0530
Message-ID: <CA+G9fYugJvNzS048jMPFj2SF4qS-6eqz3fpOehAnhJtBJCcYYw@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/163] 5.10.119-rc1 review
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

On Fri, 27 May 2022 at 14:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.119 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 29 May 2022 08:46:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.119-rc1.gz
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
* kernel: 5.10.119-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: d318333bd3dbc483b4d566521dc6486ef9f6ba04
* git describe: v5.10.118-164-gd318333bd3db
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.118-164-gd318333bd3db/

## Test Regressions (compared to v5.10.118)
No test regressions found.

## Metric Regressions (compared to v5.10.118)
No metric regressions found.

## Test Fixes (compared to v5.10.118)
No test fixes found.

## Metric Fixes (compared to v5.10.118)
No metric fixes found.

## Test result summary
total: 94216, pass: 80324, fail: 458, skip: 12631, xfail: 803

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 291 total, 291 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 40 total, 40 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 51 total, 51 passed, 0 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 41 total, 41 passed, 0 failed

## Test suites summary
* fwts
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
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
