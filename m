Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8816948A751
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 06:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245627AbiAKF1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 00:27:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245608AbiAKF1A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 00:27:00 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B5EC061748
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 21:27:00 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id j83so44223491ybg.2
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 21:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=R1bERSQCaqkwr4Ier9XvdFqneg9JYofIHhE7gfGWTaM=;
        b=lzax8mQ17EiCCj1+UXKW1WimqNztElqWeuJ0aJqQwrZg7UOBOQ4J0Low5yhm1NNEFG
         l4QFpbgS4Ess8CJMYHfgh3o+eJU0jgpoccqnLB/RJWUeqcgk+ELov5WF/KLNIc7uS8V6
         Dnn+G8gm9FJPdJQTRWV/NB0UOpCC8OAsyBUnkBP+mUWdoTCxwCa2BUbnbdwwtA6hDr4g
         X6WdtGMLDEskYcBrIBRwg22ywWsAVDUy6Y35a2nK9JUs9vfeDcEBJOR5owW9OPDM/+Ar
         p3fARHGb30MwUsLHbVqsvlEzJMrpHirMDbYs4dgaatozwXAA1iJCiByTg5m+rAwzAgvH
         r+Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=R1bERSQCaqkwr4Ier9XvdFqneg9JYofIHhE7gfGWTaM=;
        b=l/Ab5M+pE2/DdHO9Em+WB0QCLiQzXYqkW4xxMccBfhtGhSqBiD7XIOCXJkKEwzfkfK
         HrZXZwxq7Xv+VrdWUC02h4kTcLuW4iX6N5TwWtzb1RU4CJMIP3KAdWh0LqFDwU4brDrD
         vQnHCQKylKshgBnipFL0v6y/0hS9j0AYyghI3nBlK+pWqeacMRQ69JuAQVIEn/SWd8HL
         xwKnmNIO2KyoSFdORPhOcr+cUU4+5miI3pn0Cvh+duXxUfhpOcDs0X82IkqFdsF+Awrt
         yFgClHP+FTar6BLalsiBeuiMRMqvsKXor9M5r2Xx3H8bOJR481aloYD71xs6hatUf2tE
         lVRw==
X-Gm-Message-State: AOAM532Hkz19Z8mPFqSukH4a/SPHlsR9dp3xgjpghIpu23ConOx7de+u
        gc5qCMdLf4jSkCNfCLUTwzXe4HfIopmUe6CmgJbDFw==
X-Google-Smtp-Source: ABdhPJw9cNwxDEP5Q3LctsGL5fl3poAUrM2xtvkA18XjpkcqDuNeDzo/EB7m5i26BeO52IOHvy7SfpCg06c43zrV1Iw=
X-Received: by 2002:a25:4b85:: with SMTP id y127mr3838777yba.181.1641878819258;
 Mon, 10 Jan 2022 21:26:59 -0800 (PST)
MIME-Version: 1.0
References: <20220110071817.337619922@linuxfoundation.org>
In-Reply-To: <20220110071817.337619922@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 11 Jan 2022 10:56:48 +0530
Message-ID: <CA+G9fYtGyJT9pxtLW7WOuKbxwB_Eznnv-9R2+_-+=HfKbtJ6Rw@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/43] 5.10.91-rc1 review
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

On Mon, 10 Jan 2022 at 13:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.91 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.91-rc1.gz
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
* kernel: 5.10.91-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: 83e826769db74cb48cb7063c726e75555a0e241f
* git describe: v5.10.90-44-g83e826769db7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.90-44-g83e826769db7

## Test Regressions (compared to v5.10.88-77-g44b3abecd41b)
No test regressions found.

## Metric Regressions (compared to v5.10.88-77-g44b3abecd41b)
No metric regressions found.

## Test Fixes (compared to v5.10.88-77-g44b3abecd41b)
No test fixes found.

## Metric Fixes (compared to v5.10.88-77-g44b3abecd41b)
No metric fixes found.

## Test result summary
total: 90181, pass: 77272, fail: 575, skip: 11411, xfail: 923

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 259 total, 255 passed, 4 failed
* arm64: 37 total, 37 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 36 total, 36 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 34 total, 30 passed, 4 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 52 total, 46 passed, 6 failed
* riscv: 24 total, 22 passed, 2 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 37 total, 37 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
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
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
