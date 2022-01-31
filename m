Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1484B4A4FCD
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 21:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235449AbiAaUDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 15:03:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiAaUDQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 15:03:16 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09265C061714
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 12:03:16 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id m6so43954579ybc.9
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 12:03:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LHdwUxOkdFI4O8jVd/OiXDTXOnVsI6qhk5sOaa4A7wY=;
        b=SnhUphN0OXMmAb8/5T3MBmascvlhQB2BI5T9+fiA7Bmu6bjdcaMUVcGEyZ+bQ+3ran
         wS31ic0nYCwTPcS8X2JyQnzep706//0f955UjktfD9CNiCGSM3Uc2JFzafI5LHqTnwFV
         XjP3aYqpNHghiTfsBcYAttYj8YCBmibWF29u/5jJMGOhM2uS8is1i3hpg81uXzNNptgr
         lkKSctxIwVRXK4jwgz3wXaQxN4V9JxPjwjc9aB8/2zQiIQ7T8Vqz5kmkSY6QcBlGYSYf
         Mo8c4G71y7V5jcb6WfKmqwZ0rRc0YvGNIQXCbn4qJfYStTnN8XYJ6OKRf9JUMZVMHtEo
         IpEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LHdwUxOkdFI4O8jVd/OiXDTXOnVsI6qhk5sOaa4A7wY=;
        b=L9w703vF6aFEnQufK/bjrKuHJxivIk7pH29WXD4EbjkbYG7FTQwchfZ2ygddGtq0mi
         2RLvODW6OC6zZTTgCj5qFdcnuTQ+nz0YjWx+VuuGs9E3Q60U2E45EIfyDDa542YYCxpO
         5xL2R53/Pa7bkUJLCR8nfGJIp+8XI95BLYEtb4REV/eV8jeQGLybzO/RUElb5VIxdJHG
         mk8+8a0m7GL+ZNjsFnCZv/Wr4M3GN88xGVC2sowNjV1kLOFdDARO2bOfrZiakmK2sLxJ
         4SpM1cBQnEZ9s2t5U/81D9iJtTcdsLgSVCh7/d+RMCp2vlZf1xx5Tt+4oAtXAfJvUeM2
         DNgw==
X-Gm-Message-State: AOAM532jhELH9dvOcNQ0brqNjL666YMfzbU4t79jO+oztRfoWphagHS2
        XN9bzy8fuqWcEaHp8neYNlyH5PD9V4RbVj5JwWQ1YA==
X-Google-Smtp-Source: ABdhPJyPKtQx/6x+6SkHVDhECNbPXc7V5tnuJqKS4p0RX/C1P5ue7qP/we2SwX9Cs03Pjnv8kceVnFNZkvhTPnxmbIE=
X-Received: by 2002:a25:324a:: with SMTP id y71mr31668021yby.181.1643659395031;
 Mon, 31 Jan 2022 12:03:15 -0800 (PST)
MIME-Version: 1.0
References: <20220131105229.959216821@linuxfoundation.org>
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 1 Feb 2022 01:33:03 +0530
Message-ID: <CA+G9fYtd8XPrxLVvtWzDtA3zcR5S7tDU4v9sGxD_xRED0wLtnQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/171] 5.15.19-rc1 review
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

On Mon, 31 Jan 2022 at 16:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.19 release.
> There are 171 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 02 Feb 2022 10:51:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.19-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.19-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.15.y
* git commit: 39741c5e5973d935ea274c740a2f63118b5d19f6
* git describe: v5.15.18-172-g39741c5e5973
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.18-172-g39741c5e5973

## Test Regressions (compared to v5.15.18-86-gb85bbf0129c8)
No test regressions found.

## Metric Regressions (compared to v5.15.18-86-gb85bbf0129c8)
No metric regressions found.

## Test Fixes (compared to v5.15.18-86-gb85bbf0129c8)
No test fixes found.

## Metric Fixes (compared to v5.15.18-86-gb85bbf0129c8)
No metric fixes found.

## Test result summary
total: 89842, pass: 76186, fail: 1108, skip: 11698, xfail: 850

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 259 total, 259 passed, 0 failed
* arm64: 37 total, 37 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 36 total, 36 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 34 total, 34 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 52 total, 48 passed, 4 failed
* riscv: 24 total, 20 passed, 4 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 37 total, 37 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-
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
