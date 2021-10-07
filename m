Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F6242575E
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 18:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242446AbhJGQH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 12:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241636AbhJGQH6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Oct 2021 12:07:58 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5931C061570
        for <stable@vger.kernel.org>; Thu,  7 Oct 2021 09:06:04 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id g8so24954635edt.7
        for <stable@vger.kernel.org>; Thu, 07 Oct 2021 09:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=B2GP95ACsrGPqNOFMP4WndjL9720rx1ixJlh/ODo5jg=;
        b=w+eWUeAt/TCC5GiBzNq1fW7u9PrHKEJm6D63j/CmxM6sVPajEBgv5k3CVPFV0eiZ49
         SrQejSvO8gX/GRhgjO8l6RO4kZxfethD1evLcPuzKgEB46Fabc15Ppj4Cp8I5MqHgl9L
         HDbTanpz0+1g6aWMFZDL1A3TlC4Nn3JIB4LUa66gx6LRjivKXifW2WFJqMQYhhFodKWN
         hudyr/RHuXBF6dB4WiOEz8X9uDhJg4ts1B9XFloPGVOnRjTW1uKFn7rDhVCTFKjvZmaA
         aOANeAl73C+1afNNcmUxL6DWQlLxWe79GCmNvFVXwyrs4w8eixAsawwD7B92lkIQK0Aj
         WH2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=B2GP95ACsrGPqNOFMP4WndjL9720rx1ixJlh/ODo5jg=;
        b=5MKtvCb01GfbqDeN1j0zxg6JY/DkzGQ0nBwlXpQWFhWD+L8GLEFcI7B/giJfPlsDIP
         8gY3IbAvTnXk6Rptrj59xFMvmvY2Oc3k4gRRBKKk8d+wIV3Q5abU6asq+zuGotIHfITb
         u/XhqhRh09j2ZZ9lmSeXn+EAw7V5Jhjh5DGodQfsgbseGUTzLeU+3ylFC7hhHwC03W2G
         ddGfO7eews4pHeEUYTS+xJtbojKO5xb+kkjtgMJ3D+uNeVGZwlh3sxjH8X64AcE0UxQ1
         /vUrOx7bz9ePr2u/nKzsub7HwqLxpPz428xAJAt8DlDIQubcBEWpyxqZA2yLvZGAfJdJ
         Q3Tg==
X-Gm-Message-State: AOAM530TMsyCXi5T82+mSnEl6HKF2vY1Mvvb8YThg8O03j6jXncdIrae
        Ef+svvJOyurJReZ/mclnatjf21V2wFnMEm/5JkMFKw==
X-Google-Smtp-Source: ABdhPJwbromX4cN4ky1jgs9USX6Ry/wldi67/IB1Vai/C2a66dHniysvFnWHCF5Hm3/YI2Xr/DFnkz8fqaNCTb2N4M8=
X-Received: by 2002:a05:6402:3587:: with SMTP id y7mr7366340edc.182.1633622761720;
 Thu, 07 Oct 2021 09:06:01 -0700 (PDT)
MIME-Version: 1.0
References: <20211006073100.650368172@linuxfoundation.org>
In-Reply-To: <20211006073100.650368172@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 7 Oct 2021 21:35:49 +0530
Message-ID: <CA+G9fYt0LXxYa4Su-v1Sc-M+J2knj8Ukpi-tRewKfT4gjis1Fg@mail.gmail.com>
Subject: Re: [PATCH 5.14 000/172] 5.14.10-rc3 review
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

On Wed, 6 Oct 2021 at 13:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.14.10 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 08 Oct 2021 07:30:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.14.10-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.14.10-rc3
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.14.y
* git commit: d1d4d31a257c9fb5087c34e33423b99ee508fdf6
* git describe: v5.14.9-173-gd1d4d31a257c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.14.y/build/v5.14=
.9-173-gd1d4d31a257c

## No regressions (compared to v5.14.9-174-g355f3195d051)

## No fixes (compared to v5.14.9-174-g355f3195d051)

## Test result summary
total: 77776, pass: 65121, fail: 1016, skip: 10611, xfail: 1028

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 289 total, 260 passed, 29 failed
* arm64: 39 total, 39 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 38 total, 38 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 39 total, 39 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 36 total, 36 passed, 0 failed
* riscv: 30 total, 30 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 0 passed, 1 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 39 total, 39 passed, 0 failed

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
* ltp-nptl-tests[
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
