Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D826751137D
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 10:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357234AbiD0IeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 04:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234193AbiD0IeL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 04:34:11 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 677031C100
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 01:31:00 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id e12so2002116ybc.11
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 01:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=M5VmPqHrZbz5RxJOMLq0v7WV4KFPghsC4N72JYyAcgc=;
        b=m8dsEZ7i9DbfzsZTq/8hmxpARYz78hH4M9KHP5urmMPk/j0rRrwz/H7LFoUIhEudIy
         cTwQgobqlpnAx3Xg+fYqz1nimO7LazxwBFdX4rGns2I+UP00UUg/DXq9YQmXnFp8NFjc
         dB9OBtgNsyga72WET9bPVoF4D8gmG5frA9z/RlIuKTG+jJ+LP0o6AkIxpZlmzcdHJGlo
         MBCKXeCBG3JD36x1sSHB+RVgNqg56L6vRcIGRhAAyYNGFUJYLguvT7oNvKmKYeGoxfUu
         RD7Bd7CqbnIAe9cf0YG7iSpX+ZC6lPpi8cddkK1XT1V2OSv5sJ868OOse8MS9BN+LCy/
         vIYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=M5VmPqHrZbz5RxJOMLq0v7WV4KFPghsC4N72JYyAcgc=;
        b=V/M9Qf32i6E2OaE+K2MdvAlaso7jb0L1j5XPpWDSRRZiJn2K2Zz97al+L92evEC7lC
         hdpZqGRxoMR7skx1tQUhwBSPh7DE+9AR7pUDmiVOyRNyJbnuAYI7EMSv+YnIpEpblnJR
         UjtnfbaRgF+hk3bcvuzBV8Mlh4IIj85rRrdN7LfjdNouG+YvEi7SOzv4y1tf3wNjkLn7
         +3CobAmvZdegSCfTi6ZEKYGOkLBmjzrTTczj6M4ulwak6p0i3QIvI/Ghd/uziZeLf+Qf
         IbwyVAV3y3CCLWs2C7btU6jlnQWwQZKtLyEgkmjmzZtm4LrL9Rv5VO6uaDnfwUHUaLxb
         xJ7Q==
X-Gm-Message-State: AOAM533/mwEbBTWa8JccMMh9pR1g553/eIfC8tiJtNLy2ovaZ9BXUmUc
        K6TBzqrF0Eb27o28S82hJI3W8TxGfq226CPC/TFUOQ==
X-Google-Smtp-Source: ABdhPJzL/CasNcwH2cgK6gj+aQ8DI2yhE9T9w2UyDiZ7/A07vlkRpLC3Z0ettblP3Qy5dCXjomPmVOnKFAz42Jeu0/s=
X-Received: by 2002:a25:8f8d:0:b0:648:a703:defb with SMTP id
 u13-20020a258f8d000000b00648a703defbmr6642306ybl.128.1651048259513; Wed, 27
 Apr 2022 01:30:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220426081735.651926456@linuxfoundation.org>
In-Reply-To: <20220426081735.651926456@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 27 Apr 2022 14:00:48 +0530
Message-ID: <CA+G9fYuYGaQZ-SB9zRwghM+b9_EVVyYKj9cqdam7wMO5=3XZ8w@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/53] 4.19.240-rc1 review
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 26 Apr 2022 at 13:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.240 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.240-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.240-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: 5e5c9d690926bf43bc1405d163e02768a56c56dc
* git describe: v4.19.239-54-g5e5c9d690926
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.239-54-g5e5c9d690926

## Test Regressions (compared to v4.19.239)
No test regressions found.

## Metric Regressions (compared to v4.19.239)
No metric regressions found.

## Test Fixes (compared to v4.19.239)
No test fixes found.

## Metric Fixes (compared to v4.19.239)
No metric fixes found.

## Test result summary
total: 81844, pass: 65248, fail: 1145, skip: 13273, xfail: 2178

## Build Summary
* arm: 281 total, 275 passed, 6 failed
* arm64: 39 total, 39 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 27 total, 27 passed, 0 failed
* powerpc: 60 total, 54 passed, 6 failed
* s390: 12 total, 12 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 38 total, 38 passed, 0 failed

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
* kvm-unit-tests
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
* vdso

--
Linaro LKFT
https://lkft.linaro.org
