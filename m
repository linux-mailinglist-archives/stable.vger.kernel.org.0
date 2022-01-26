Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEE249C8A7
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 12:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240714AbiAZL3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 06:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233651AbiAZL3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 06:29:45 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA2BC061744
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 03:29:45 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id g14so70301673ybs.8
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 03:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+Va33nfeAzMZW/tMs1IXvtrj8MnxTpme5rJKE5VcjMc=;
        b=hlRzkGHlU47aLEzQ8Bf+yh3l5z3TpOuA5U6Vh7t79b3Qlv+Ugi8ev05yns+U4kDwpp
         DJSAmAY9aPNgJc8AVotBxG1N5ts9ZJBux7fov8pkKxG8pGGlFvahBbMb0FjbkDb7qD6e
         zIGuIPaRiYbFjKBMVuwICmp++ZTZGlxaTZIEl38MlRi4fJ2v3zOvmanEdS1MZhzozrO1
         nr2tafXPvebP4PuzHqieFrOwsSj9/arzTM/jq/hp/lu8qrw1f53Pl7I7OKoHJsAdIj+8
         0IPyUGpCqOp0yCebTPGlYKQegZW4DdkNBgmUv4j6e50RUMjS9XGCG1r4JpnlNbnvndle
         DUJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+Va33nfeAzMZW/tMs1IXvtrj8MnxTpme5rJKE5VcjMc=;
        b=pbQ0eDV1fmwkiFm+r4PIvzdiikzP831IRYUuODz3RYzF1iBBseYuaF9TxvTmqLQBy6
         It/iTvhIaeLkQSDWUJY4Q2sb9R/TBYcStQXlcr7Lcg+6abevQ2V10CPwhFuLJyImj3uC
         +gP/RGIB192s5ANGSuAxHDdrTUfX1IwRHz35igPkEBWUfCW303RygAfJakxZ+gevNxIv
         FxnNxKrRXtkOvku1OggSRTkIV9ezAFcCTVHN29GjHW7QMNUomoHir0d7GJJSH5QizMko
         QMvToZEEa4UlR0LQzaMTNZ1VmsQKqDEq3gJ3rm2xAV+mGRhRcVDyXEhnA8ZdRs5Ri27e
         QxCg==
X-Gm-Message-State: AOAM533+wBLm7ART9T3Kk1umfylZEx3HsFj94jXklfkFvqP1xdEWGKw3
        OQpTsXt3htAQ4mTOiRCr9B+C8C/33vMeQj5kDpDlUg==
X-Google-Smtp-Source: ABdhPJzgkoKuI0ewWUqJ3CsdEdfeOZrEQHxW+vpJlgG1WP2xpaQNj7AjJFxkN/acYRM3y0v8NShZYZO3JzaFK74TyEw=
X-Received: by 2002:a25:ada2:: with SMTP id z34mr28377228ybi.684.1643196584374;
 Wed, 26 Jan 2022 03:29:44 -0800 (PST)
MIME-Version: 1.0
References: <20220125155315.237374794@linuxfoundation.org>
In-Reply-To: <20220125155315.237374794@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 26 Jan 2022 16:59:32 +0530
Message-ID: <CA+G9fYsAgQV6JjA8+SnrkWOK-e8p1+51-CP_L2nS7o8ktRHybA@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/316] 5.4.174-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 25 Jan 2022 at 22:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.174 release.
> There are 316 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.174-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.174-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: b9fb58c8fa638249487dbb2e90ffed66f1d742bc
* git describe: v5.4.173-317-gb9fb58c8fa63
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
73-317-gb9fb58c8fa63

## Test Regressions (compared to v5.4.173-321-g34a12dd3db7f)
No test regressions found.

## Metric Regressions (compared to v5.4.173-321-g34a12dd3db7f)
No metric regressions found.

## Test Fixes (compared to v5.4.173-321-g34a12dd3db7f)
No test fixes found.

## Metric Fixes (compared to v5.4.173-321-g34a12dd3db7f)
No metric fixes found.

## Test result summary
total: 93196, pass: 77436, fail: 828, skip: 13486, xfail: 1446

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 258 total, 258 passed, 0 failed
* arm64: 36 total, 31 passed, 5 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 20 total, 20 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 34 total, 34 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 52 total, 48 passed, 4 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 36 total, 36 passed, 0 failed

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
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
