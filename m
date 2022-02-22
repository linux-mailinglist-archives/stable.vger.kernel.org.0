Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 284DE4BF581
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 11:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbiBVKK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 05:10:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbiBVKKX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 05:10:23 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13BBB12867F
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 02:09:38 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id w63so18679573ybe.10
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 02:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZN9Mn7eKF7VEPOoqESh7YsrOHM1p2Rju/SK2QDt9bv8=;
        b=BAhFDjXk2l50R715eCkMXIgzDmGhcqetlaGPIlMnAsVojznLICv0HD0MntQW3xI0Js
         yZ78/w9KbyJgiRdOeir/u0C3kzucDr+WVlhOOoEDbofTh0QtI+ONsb92mn/rXeS220HU
         SMHosJT4cC7cPWAm2RqAw+U6vdpewSfxLFVnltEuGQSflaUFgYxB2xml97rOJTczZxBe
         QERNiXh2SZda4VTxZHrD1I7XmKswdInCZuiRaGWoACJVQgpfmJ9mWoocRl2q1mzyF8B2
         /TDYtD2sVTmHAPGvRjI8ijLX0GUl/l8WAbCTzmc/quvQiVkZoOynaI2mzTiB7JApwgTn
         nL4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZN9Mn7eKF7VEPOoqESh7YsrOHM1p2Rju/SK2QDt9bv8=;
        b=Yi18ob5URLf2d9/CHhOg5MhPc5mp/YWt+cKxC03xTrLudgoeg1THdlChpaTLpx5mbx
         CXqbXCGn8QAe0QBLf6FCr8Eq5u4z+KaS00xOMOy2zMSoyimUtozj2G9/4x/9mwbmGSJ7
         DEp7JxhZ5QWVv8Ypjdioo+qVPUwjK2jctVl7HFi4xL8whspsxu9gUSrYpyfac96f63NB
         ToWsOpQcla+typudLOerOuKlxB9jhVzGKYz21m/qtS8v68bRQ8GbTNfrobyEtvKklnNQ
         8nzd5ODRLfWj9IPqGri0RQcbipel+SPFJMj4j+/sazEzvt8odJVrjIyYPz6Jjlfy1uN5
         w5cQ==
X-Gm-Message-State: AOAM533vt8QdxqKZweM+xWazk1eSeVSEmsYk92XJbAPOl0iq/lyihCXW
        MgXGonh10M1mfSifSmuV1doUNjstchlIrLTQCHoHGQ==
X-Google-Smtp-Source: ABdhPJxFweseCasmpzAP6moZXTsTj32QvBmiCzulP4nUABjLxWd5aRTXPvDh73B9hq9aGMSuIdT49OUUdHlYUBCCphU=
X-Received: by 2002:a05:6902:284:b0:624:1c25:cda1 with SMTP id
 v4-20020a056902028400b006241c25cda1mr21755670ybh.480.1645524577153; Tue, 22
 Feb 2022 02:09:37 -0800 (PST)
MIME-Version: 1.0
References: <20220221084911.895146879@linuxfoundation.org>
In-Reply-To: <20220221084911.895146879@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 22 Feb 2022 15:39:26 +0530
Message-ID: <CA+G9fYud3yvjfK=R103kJyKUutq9CEwq03Jef6ej1BaO3zpHjA@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/58] 4.19.231-rc1 review
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

On Mon, 21 Feb 2022 at 14:25, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.231 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.231-rc1.gz
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
* kernel: 4.19.231-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: 354a12b76a6c54b40409ab943189cc91fc906ac6
* git describe: v4.19.230-59-g354a12b76a6c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.230-59-g354a12b76a6c

## Test Regressions (compared to v4.19.230-41-g73351b9c55d9)
No test regressions found.

## Metric Regressions (compared to v4.19.230-41-g73351b9c55d9)
No metric regressions found.

## Test Fixes (compared to v4.19.230-41-g73351b9c55d9)
No test fixes found.

## Metric Fixes (compared to v4.19.230-41-g73351b9c55d9)
No metric fixes found.

## Test result summary
total: 62331, pass: 52272, fail: 343, skip: 8895, xfail: 821

## Build Summary
* arm: 281 total, 275 passed, 6 failed
* arm64: 39 total, 37 passed, 2 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 27 total, 27 passed, 0 failed
* powerpc: 60 total, 49 passed, 11 failed
* s390: 12 total, 12 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 38 total, 38 passed, 0 failed

## Test suites summary
* fwts
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
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

--
Linaro LKFT
https://lkft.linaro.org
