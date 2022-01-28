Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622D949F7DA
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 12:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348046AbiA1LIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 06:08:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348023AbiA1LI1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 06:08:27 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38167C06174E
        for <stable@vger.kernel.org>; Fri, 28 Jan 2022 03:08:27 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id k31so17403893ybj.4
        for <stable@vger.kernel.org>; Fri, 28 Jan 2022 03:08:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lO9i/7tiw1jg/f73d/YFPz8lyvK5KGNvKNKqwKL/0U4=;
        b=sbUe+/c/fiMN9HVja46pA1A4kyF8x+DRfNpGmZNZxnNZk7z+qscTQKGlGWtJObsTm5
         Q1uGNvFJk0Lz6EYy7+9iM32BkGcX16w0H12aVFEukSJQWf4HCs+/hlLOWhSZiJKfUi1y
         M4XErpiI80jOheP5RlWrvX02Rp8DePtRLSHoP09Y37iXiPN3Jdr8lY7XaihXyhZJobDq
         iM6Gbr6Rldij+0csWcxOo3FHrBM6xkQ9CCchhW1GXLg4zrsh0qA0C8nmFH7ujVh2cLr2
         9TbGHDwi00jHynBQsqjmA2gXU9ewrUofndlDOKsqfXRA+VhOkAUKLNn3AYf2HucKgTK/
         BaWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lO9i/7tiw1jg/f73d/YFPz8lyvK5KGNvKNKqwKL/0U4=;
        b=Kg7qcRBHp2ImXiJ6fn+dE9rqkT/OgSgyu42CzTO8yFIu7VGfQWqOmE+xilA8oHVzQo
         fvMc7T0SNIwoOoTArmh/vJdgO4L2PUzAOo/RS2sDoyIFw8o7VMX6kqSTPICoTyuSctH2
         dbwFJNDUyWiFGKUgOMIvi9Ayd+4qm/sNic8MZaTStqDYBb4D91rWcUTdGe/rnW1BY8Gp
         B+3qP2DwfmdfV8aUDUtIF+f24sYSFhFTHpFYeerY5I5+Awgcov0g52p/oWmvtOUb9yKx
         Gcpr7OE8NSoj7oEBY5Ubeuo8KqM9cBExSvEPrkIsI4Ek//HWUcTkLg4KSJ0hSpnC3YRs
         KFZQ==
X-Gm-Message-State: AOAM531p7Fwkxkx6RKe/3AHgq3rMJfSwrkNgw6eYNdl55Eup7D3ZV48M
        TVrbVfL5BqPbI04QH74igK8WBTAv11TYq5PH6mF5Ig==
X-Google-Smtp-Source: ABdhPJyaeTAYzVKHMXIlwWNuEs35Ttxny0l/LAFqAfv+YZlUjiYfihmEAFIdBIOwMNjoas3M3oogS25cDE55Em1JQVQ=
X-Received: by 2002:a25:97c4:: with SMTP id j4mr12517532ybo.108.1643368105927;
 Fri, 28 Jan 2022 03:08:25 -0800 (PST)
MIME-Version: 1.0
References: <20220127180259.078563735@linuxfoundation.org>
In-Reply-To: <20220127180259.078563735@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 28 Jan 2022 16:38:14 +0530
Message-ID: <CA+G9fYvpM5pqHNogaGu--bNqKQWUVBVWqCapwEU1p_w8ab99MA@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/12] 5.15.18-rc1 review
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

On Thu, 27 Jan 2022 at 23:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.18 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.18-rc1.gz
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
* kernel: 5.15.18-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.15.y
* git commit: 1985ebe37ea5497ded496bbf90dce6f216a0945b
* git describe: v5.15.17-13-g1985ebe37ea5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.17-13-g1985ebe37ea5

## Test Regressions (compared to v5.15.16-842-g384933ffef76)
No test regressions found.

## Metric Regressions (compared to v5.15.16-842-g384933ffef76)
No metric regressions found.

## Test Fixes (compared to v5.15.16-842-g384933ffef76)
No test fixes found.

## Metric Fixes (compared to v5.15.16-842-g384933ffef76)
No metric fixes found.

## Test result summary
total: 103202, pass: 87990, fail: 1071, skip: 13242, xfail: 899

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 263 total, 261 passed, 2 failed
* arm64: 42 total, 42 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 40 total, 37 passed, 3 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 35 passed, 2 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 56 total, 50 passed, 6 failed
* riscv: 28 total, 24 passed, 4 failed
* s390: 22 total, 20 passed, 2 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 42 total, 42 passed, 0 failed

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
