Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F4D4A2D64
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 10:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbiA2JbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 04:31:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233132AbiA2JbF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 04:31:05 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29411C06173B
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 01:31:05 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id 23so25478425ybf.7
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 01:31:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YOtZKqMndwTJ2K1o3lCoF6KVIXX7KXLsUOp84/7hLbc=;
        b=PDiI3I4dP9Xj6RC6Xi/Evrpcn1+a714cITc6lly58Ky+dPlK5T1Xtd3tnITbZKyqbN
         b6oHoRj/Tk+na1Fn6yVRaKsqXVnW1i5Wok0nHcaf7OUCVWttMqN1zNlpIbdwp3N7xaUB
         evBxXL7OX9lDrgP2+JGnepJDHUNhWEVC8mGpz95zaZ5J3pARyDT10Mi2+zd1UFXwvCxr
         /Xd0lcg9Gg3SGNfpmpELMcMJqQBDdZ4NE5qo1rim5osT08AdbEAAXvsExhMsZLbUjrYe
         FTNbptIYUXVgv4LvHaWPDRErn8iVGQNM73BQozLEIVtwC+KddQDvuOLfS3cUM0hf3Mbp
         lMng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YOtZKqMndwTJ2K1o3lCoF6KVIXX7KXLsUOp84/7hLbc=;
        b=zE2rFietftkqQ9DyQ4GFLb64i1F+ujh4QpkFs+R/r+CZo7EW1QKjP+1nwTkTq7J0Iu
         kiP3BW8ux4GQbed0ZAd2qazUQPZqoICjy48JN+sZfdB16XeV69ClO20DcUwkBnoTnj4o
         EuFwRvbL/c3YSsOVPoc0ck7Y+sdiTK4tzMuibSmahlBCISHUFQfEECOzoOH5aEz+TT20
         vwtM3QpsSlQe+DVLwUUDGRtTBjpBBThebWcEWKCQzTeXhaXn9ekkxpVUa2S23XAo1HW2
         3qu4MeSN+EnpoiU22KJgS00y+Tsz6TgysJcTAsvUUPFOgzljSuZpklHVrD+gSTMO2zL/
         SJKQ==
X-Gm-Message-State: AOAM5332fcVOB0vY1HubQeKa6prheuWXKlv05Iag+lh+D3jjZDrZJlmW
        v0vrIPLEQSuI2NKs8tCQkjR/Gueqxyjh+moSjF9ozQ==
X-Google-Smtp-Source: ABdhPJwYJ/qgrTFxFJa3IdpU74VnZJ9Ie/CZbyAUdchmOB7XgeMyLy24wMEB8R2HpIsu/GCMy5WnYd0JSPFQ9kCa71k=
X-Received: by 2002:a05:6902:1148:: with SMTP id p8mr6536160ybu.553.1643448664210;
 Sat, 29 Jan 2022 01:31:04 -0800 (PST)
MIME-Version: 1.0
References: <20220127180257.225641300@linuxfoundation.org>
In-Reply-To: <20220127180257.225641300@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 29 Jan 2022 15:00:53 +0530
Message-ID: <CA+G9fYs_XgkoYBtMSVPke+CNnnSYT3kbZ+y+X7ZCB5DpQmCmfA@mail.gmail.com>
Subject: Re: [PATCH 4.9 0/9] 4.9.299-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 27 Jan 2022 at 23:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.299 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.299-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.9.299-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.9.y
* git commit: f4e33f5b11f3a84227cb47f295ec793d83af7eda
* git describe: v4.9.298-10-gf4e33f5b11f3
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.2=
98-10-gf4e33f5b11f3

## Test Regressions (compared to v4.9.297-156-ge1c2457686e4)
No test regressions found.

## Metric Regressions (compared to v4.9.297-156-ge1c2457686e4)
No metric regressions found.

## Test Fixes (compared to v4.9.297-156-ge1c2457686e4)
No test fixes found.

## Metric Fixes (compared to v4.9.297-156-ge1c2457686e4)
No metric fixes found.

## Test result summary
total: 62622, pass: 50324, fail: 445, skip: 10424, xfail: 1429

## Build Summary
* arm: 254 total, 238 passed, 16 failed
* arm64: 32 total, 32 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

## Test suites summary
* fwts
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
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
