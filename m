Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2524842A7
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 14:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbiADNju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 08:39:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbiADNju (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 08:39:50 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13207C061761
        for <stable@vger.kernel.org>; Tue,  4 Jan 2022 05:39:50 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id w184so88332781ybg.5
        for <stable@vger.kernel.org>; Tue, 04 Jan 2022 05:39:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3RLDMN5GN9app8NkTXBsRwExWzCfe/qwhipZnnWbO6c=;
        b=g2cmAsZAIBrEu/+aGa7taNXZhunMfbtjUcnpEZrJ6zgwQ7LPXS5rF2gFB4SgTlIJTH
         YIGvkD0OABe4I0H+SDJMAf9adegR0zArwCwivciTckMcx/UG+0K/r75gYEQLjSgGA+my
         RLB878VirLAwCebjJnZJ0quYEi+Xgrgh6M5nVDF8y7/X4GbkcXpSkhivdtzTvQCC+1BS
         YNHxKScSEsKLqwGAH+nYU2iSoOFIzULV+BaYqD8BXPcfqNsh5RxvdmB6M2gMqrU54QHk
         y3ihnW7a9EimLLI2l5y9j9xouFr6+7NLUP9kbh8yW3MbNK9Aco6P9acrtMFz/W4EqfC3
         QAIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3RLDMN5GN9app8NkTXBsRwExWzCfe/qwhipZnnWbO6c=;
        b=ryelS1h/j7aus6Q810iPCsCBV2SMg5MY+5aHfPE12uzMttx6IAQbutyDeUgEMgFzO0
         TMeUN92HEiVS4Xr/1WAqKsqlkTno4mC55Z/2ZfI/lQ5NS2kd0r6oKbcKXLaP0hL2XLaJ
         h5Rz9jnlgEMVBTyobDARdg+lY2q+RNfY0yoQBAnVcbptq6oimejKjqoklCjkPKEuFQaI
         ao0QZXeG+CcwRcL4Hq9tzFIr4rXHBeDIpwb+GJuznBx8e8Wuvrgbx5IXQsp+yWRrMp31
         DG/iPmAA8RkXQBmM/UjYDM7ufIU4sfAcjLRk7Wy4j4QhDjiSb0TKqdr7UqP03BQDqwP6
         00fA==
X-Gm-Message-State: AOAM532g9nbIomkLVL0miqGimwjnim0Npz08Mh/wpD5X096Cp+GvCsYB
        N+dwU7SiTBBEg2/scYaEjvvJSMcXBGx7VxJqAsVnEw==
X-Google-Smtp-Source: ABdhPJxet8972V5uC1CqcKMRXNUo6eWhqx2DuuVAw4/O6RmH4zbig0NhOsEOKYAO9wAlsJF46ndBWcgMzLVTIRiFk6k=
X-Received: by 2002:a25:4b85:: with SMTP id y127mr61093665yba.181.1641303589035;
 Tue, 04 Jan 2022 05:39:49 -0800 (PST)
MIME-Version: 1.0
References: <20220103142052.068378906@linuxfoundation.org>
In-Reply-To: <20220103142052.068378906@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 4 Jan 2022 19:09:37 +0530
Message-ID: <CA+G9fYu4Q1JJLBRZAJ-8Rd_nD=6B1KHUQ350JEztgqJDrckw2Q@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/19] 4.14.261-rc1 review
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

On Mon, 3 Jan 2022 at 19:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.261 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 05 Jan 2022 14:20:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.261-rc1.gz
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
* kernel: 4.14.261-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.14.y
* git commit: 1e980b44673d11c0bb0bed2afb54341e7541c083
* git describe: v4.14.260-20-g1e980b44673d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.260-20-g1e980b44673d

## Test Regressions (compared to v4.14.260)
No test regressions found.

## Metric Regressions (compared to v4.14.260)
No metric regressions found.

## Test Fixes (compared to v4.14.260)
No test fixes found.

## Metric Fixes (compared to v4.14.260)
No metric fixes found.

## Test result summary
total: 70912, pass: 57256, fail: 577, skip: 11331, xfail: 1748

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
