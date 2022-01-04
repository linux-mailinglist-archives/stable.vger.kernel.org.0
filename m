Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD882483B78
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 06:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiADFV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 00:21:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiADFV4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 00:21:56 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BA0C061784
        for <stable@vger.kernel.org>; Mon,  3 Jan 2022 21:21:56 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id g80so60897909ybf.0
        for <stable@vger.kernel.org>; Mon, 03 Jan 2022 21:21:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FDZVwBm9UOYVySEWu5ogyWtNTDn5NwYGtqJcwwMLQhs=;
        b=cSWZTbAH2f8dfvxeU0jTFEbeb3XIsUus4pZRoWzvPY5V1lwnhcs7zzAAR71bAZIRcg
         2gaS6lsziyXj3Clw8MZ3INQeO9FZoRce38qVdDPouC34PbRtjvs7ojM17syHSN5GgGAS
         5xym1yBy0o99F1gkMNf4rAo8ibWx9oLLS6j7FlUErpz4WefVuvU+Ljs/EFcLCZLAsImZ
         PNONkd+mCkrxnzskfxSe06hrb02UleZe4GBLb47RvHG1QCoj5fCgDpF8TE666RARhheg
         3jPKb8K9FYcpqpkZt+Aip6PBkWVCzMWK6djwXEs4hSJtNEHFukC7DQU+C06tpzgaykqW
         gfuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FDZVwBm9UOYVySEWu5ogyWtNTDn5NwYGtqJcwwMLQhs=;
        b=UXEm5pKu8zKyB7ixrYVdFWd/4Qe/GIRtr5zA0UCt69+Q+Z22Z2bKTPyPczuFcZZlcY
         dUBbkx+iNvJXpPfDnJy8hE4gADabuOfELgSVFnR47O8+cy1IVu91SlGW+zfwB+4xKixF
         ooBcC8DyD0S2y3G7MTeqrDK+EZEFwLrvRKHw4z+DnnzdQeuEJckFeYod+Cs+GYAg/bUW
         d2+ppGG0MRHy5tgodGyOpXwfz+5zoNaYau0upY/Cw1Kn8TN9PTQFLRvkoNdlqLEdT1zg
         0CgJZF6dCa9PjezgQKaDhrxcfRKbTbcQgzqKHEH3iZGaj8yrD2G7bJMHHV9AIphHvfUR
         foMg==
X-Gm-Message-State: AOAM533grfoBLnzio12vyQqYhBeL1QtZOdOPYFhAM2HbnoKY62EwXvPs
        DJo8rBgVxyf/ADX4ut0QtKneD/Okd6v7JdF4gn9DPg==
X-Google-Smtp-Source: ABdhPJw8Th2E4w3+YaGhVP7o9raJGrmneFkxMB6nh/34cVuRBrOVNV05NGoR1hOz8HUOVfh8frKrrNgWDLYMJo4N7Cc=
X-Received: by 2002:a25:84c3:: with SMTP id x3mr43350856ybm.553.1641273715101;
 Mon, 03 Jan 2022 21:21:55 -0800 (PST)
MIME-Version: 1.0
References: <20220103142056.911344037@linuxfoundation.org>
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 4 Jan 2022 10:51:44 +0530
Message-ID: <CA+G9fYvhZXdV75qbamXtQpkZTD2xyeB9+iJadtgHf0OP_sQQMA@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/73] 5.15.13-rc1 review
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

On Mon, 3 Jan 2022 at 20:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.13 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 05 Jan 2022 14:20:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.13-rc1.gz
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
* kernel: 5.15.13-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.15.y
* git commit: fbfd9867da50607c6a409bccb822c48823505929
* git describe: v5.15.12-74-gfbfd9867da50
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.12-74-gfbfd9867da50

## No Test Regressions (compared to v5.15.11-129-g47b0c2878802)

## No Test Fixes (compared to v5.15.11-129-g47b0c2878802)

## Test result summary
total: 98758, pass: 84383, fail: 1055, skip: 12352, xfail: 968

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 263 total, 257 passed, 6 failed
* arm64: 42 total, 40 passed, 2 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 40 total, 37 passed, 3 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 31 passed, 6 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 56 total, 50 passed, 6 failed
* riscv: 28 total, 19 passed, 9 failed
* s390: 22 total, 20 passed, 2 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 42 total, 40 passed, 2 failed

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
* kselftest-ef[
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
* prep-inline
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
