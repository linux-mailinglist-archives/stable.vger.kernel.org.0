Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 183DA48A7B0
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 07:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348093AbiAKGY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 01:24:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232725AbiAKGY4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 01:24:56 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A328C06173F
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 22:24:56 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id g81so17140403ybg.10
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 22:24:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WwmauCVdrq+FXfUH8oNp0SlmDL8nIxpMugq9CoBOA2g=;
        b=sLcU+VaaD1MR94Cg7s3cO1Adf6yQDTRrGn3LhMXlZ77JUEcAfpv/7ezHbYsY1TvQYd
         LdBufUd3EzwQUrEkHb2r2lCkOH3/oFU4MjerqQYBq6h1ZrG3+e+m/udBk2hFlpeU1Hk1
         Yb2vPQNrUtKzei+0x1wfLkOzwpVcBj2b5tH/0JWPgB6nXg6Ys7GjihYJ/aN6lvS/nPBU
         T2CWzFIh2Y+umXOt7Z3WAg9Rwy09GTRv1Ct0n9p1BD26EVZB6c8ubWHz+73LKEXRjgBy
         aIiUHIcaalQfoCDlkH+IGO8znduarta3r6xRQnDJyJTKVXK1GwbxKrVG3AwIagkzx4ap
         s28Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WwmauCVdrq+FXfUH8oNp0SlmDL8nIxpMugq9CoBOA2g=;
        b=mdnm53CgNI+2duTm+1TymxfZpAvtuLpnDHf+9AV1IHzpdmMfcnaFoN8PTv1JYecyGw
         SNCvH6RmGpSZe5/GdmSJqov9tBAVxgt2O2s1GLtq4mY5ZgU/GvDoUzFZSC+0tMYCRRcr
         kuFD5R52FY9pDbKwpdownynoVYJy/MvpnOBaz2H8EP9nHS8NAKNv64pwEuXl8bwfab33
         mQzr0eK9Hw8ZEMD0BzwXBAPKlWcOXfA/xLp8SMCZEFPT8+p/E0R3W4MiFgmnt0yf78FG
         7US06l7sNCm7aHOrZWGy5LDtIWnRda5Sj7RfXwlyQXQiJ4n61mLNaKV49YrLtApzdI3k
         4ghw==
X-Gm-Message-State: AOAM532axjsh4x8D8lMqe9gIz0rBYUYDjldAtslcplWE3RlBEVxJNiuT
        wJRQFoDbXYP/ppR+WF5LuqxEaAQtcZ+r15RMo97oFw==
X-Google-Smtp-Source: ABdhPJzvWSUadKuaaEoRnzj4acqmhDEmcO4Jv94DaM8LA0W9MbU3tZ1X00sQheAJbT4kc1//Jcvl8rWLG8uQhN4nP9s=
X-Received: by 2002:a25:4845:: with SMTP id v66mr4218998yba.704.1641882295054;
 Mon, 10 Jan 2022 22:24:55 -0800 (PST)
MIME-Version: 1.0
References: <20220110071814.261471354@linuxfoundation.org>
In-Reply-To: <20220110071814.261471354@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 11 Jan 2022 11:54:43 +0530
Message-ID: <CA+G9fYvp9qr8bYDddrOg-TYNQkkJXZzOd5oN=JarJ9VZEfos6w@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/22] 4.14.262-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 Jan 2022 at 12:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.262 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.262-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.262-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 96488a6934b1280ad419a37de3385c2503e04710
* git describe: v4.14.261-23-g96488a6934b1
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.261-23-g96488a6934b1

## Test Regressions (compared to v4.14.261)
No test regressions found.

## Metric Regressions (compared to v4.14.261)
No metric regressions found.

## Test Fixes (compared to v4.14.261)
No test fixes found.

## Metric Fixes (compared to v4.14.261)
No metric fixes found.

## Test result summary
total: 72036, pass: 57967, fail: 605, skip: 11458, xfail: 2006

## Build Summary
* arm: 254 total, 242 passed, 12 failed
* arm64: 32 total, 32 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* powerpc: 52 total, 0 passed, 52 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-arm64
* kselftest-arm64/arm64.btitest.bti_c_func
* kselftest-arm64/arm64.btitest.bti_j_func
* kselftest-arm64/arm64.btitest.bti_jc_func
* kselftest-arm64/arm64.btitest.bti_none_func
* kselftest-arm64/arm64.btitest.nohint_func
* kselftest-arm64/arm64.btitest.paciasp_func
* kselftest-arm64/arm64.nobtitest.bti_c_func
* kselftest-arm64/arm64.nobtitest.bti_j_func
* kselftest-arm64/arm64.nobtitest.bti_jc_func
* kselftest-arm64/arm64.nobtitest.bti_none_func
* kselftest-arm64/arm64.nobtitest.nohint_func
* kselftest-arm64/arm64.nobtitest.paciasp_func
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
