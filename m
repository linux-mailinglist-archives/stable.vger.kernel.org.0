Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F57235D699
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 06:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbhDMEq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 00:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbhDMEq4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 00:46:56 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF0BC061756
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 21:46:36 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id r22so17732331edq.9
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 21:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pN0LHrqGaKRGlgr57y3qTeLU7gHjzxAdil2RHw/cBbw=;
        b=Q06UDqT6oPS7d361IGiihne1YRjVc0b0VVJdLMN4W/Q0H+HmJZsWajUV3x4GbPHtCb
         Eh9fGk7Gd+nO1sTtdRJjIRUzhpGLFfuyM8Z4AV0xvyO5EtfX66t219pBA/DXMzVN9PXl
         5jR+lxt3FlS9AMBVhZsE+fEGDNkVjy3A1Wa04/9SVM3DAnFI2xgxW7KTFK4SMWd931xz
         nLlnrfNOF694zQRRMru7vl/rH/GAO2+IDS0CFfFuXGm7wJEkGPIi9ZSfG0awwDDzXce5
         Jy+cFRQjqu8mUq1HUtMwQos/NQwPBMW+5ZQJ0PL39+K6GPvWdY3l7ylgO5ZVbYh1su1E
         DMeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pN0LHrqGaKRGlgr57y3qTeLU7gHjzxAdil2RHw/cBbw=;
        b=ODPVVPChjFUjaX9ZbWpI6ULbm0JZQ4XgDaaX5tFiOx57PqZSckmPHWOW/w+6uBqMJs
         sjNQRekRUC66ddxY89LmVbu9RQvAoQd6pPXVcUGMqbQfz6VJD16daq1dE8vldFS5h0YL
         yoKHpQ/1N42O0CdP6fXHP5ceQvKaZqvX7NAq0LJJU/FYbgR756T0Wd/p6WpdaUgJ7R4p
         PUa2DAzlI/zVE1g9yzJZltd3bjefVu/uC4cdy6VouUc8sOL6wok9Ee55S4HavSFi5/5g
         /eKE7Eb86wfaxy6k8jxhxpiaZnNjoTFHGXf+p+fH/u64E7FAzpYhFlSomcLeen+i1pjH
         VrUg==
X-Gm-Message-State: AOAM533J2V4i+zWgZs2EYL1uGA4P9HWOGSmb1I4SzN/EqHo3sJam6Ii+
        ef2Fxk7uCRHqeL5bQRKSO5uprHnUyQnhWa58y3Cdiz3sFVhoAjae
X-Google-Smtp-Source: ABdhPJzqxDaN/p1jVmYsDjVg3BXMcFIJQokOBK4hd9EyKZyEMQ1Z5avRg7BxKKELCVMUo5eXoR79i18pM2FbEfqBCn8=
X-Received: by 2002:a50:eb92:: with SMTP id y18mr24560133edr.230.1618289195197;
 Mon, 12 Apr 2021 21:46:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210412084016.009884719@linuxfoundation.org>
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 13 Apr 2021 10:16:23 +0530
Message-ID: <CA+G9fYvrQFddwg2g6YRBqteimFMg38GZstpD7fDO=ABWhUWf+g@mail.gmail.com>
Subject: Re: [PATCH 5.11 000/210] 5.11.14-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Apr 2021 at 14:32, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.11.14 release.
> There are 210 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Apr 2021 08:39:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.11.14-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.11.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.11.14-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.11.y
* git commit: 7ce240e32fd44eb0ababbd16236a00ca7b7d005e
* git describe: v5.11.13-211-g7ce240e32fd4
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.11.y/build/v5.11=
.13-211-g7ce240e32fd4

## No regressions (compared to v5.11.12-46-gab8c60637a48)

## No fixes (compared to v5.11.12-46-gab8c60637a48)

## Test result summary
 total: 74763, pass: 62936, fail: 1599, skip: 9939, xfail: 289,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 192 total, 192 passed, 0 failed
* arm64: 26 total, 26 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 26 total, 25 passed, 1 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 0 passed, 1 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 26 total, 26 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest-
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
* kselftest-lkdtm
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
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-
* kselftest-x86
* kselftest-zram
* kunit
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
* perf
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
