Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7C4433810
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 16:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbhJSOLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 10:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232682AbhJSOLD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 10:11:03 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17154C06161C
        for <stable@vger.kernel.org>; Tue, 19 Oct 2021 07:08:50 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id y30so12152259edi.0
        for <stable@vger.kernel.org>; Tue, 19 Oct 2021 07:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sl6TRXG8dGdor4UXTJjg2nfq9PmQ5t6JZMxma2/u/hQ=;
        b=UO8V/cOM646I62LCXaZTAodRLe/AtTXmaai9Gqz5KuTLju2SgV7v1Et+G6FqrlX70I
         fu0vxVN2ENngFvcQ3Owk/q7YfCaJiyLZ/NVekkdaDaIILu92fQJrKJnuykKk36iOn5HJ
         /y2V30q/88CU6hxh9oRKh3fVnm4awJiBEiXFllEi627EKQjGzz7obzqvHJPWVikwLBTC
         6Yw/whtbKbn/1Oo6Ggy+QCZdhCt2kRJZ+wZEPAqdKhJVZk9VWjxX0dyr92aSsSv2FL0I
         OFmiRQj8/0nOO0Jtj68RXUFdbKMKWV7DYBhWO1R4pHJRQaAiQdcjSx5hRZELXu7Ma1Wt
         l5cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sl6TRXG8dGdor4UXTJjg2nfq9PmQ5t6JZMxma2/u/hQ=;
        b=XwuKfaUFUK92b7Ih+qXvsdjnHvVfSOcU4n1tKkJh1JAMwtBdgDB7+QoL0pF7obP2+D
         xuWbJW+qSD9mWIZc1UQZ+yYqwKaaxOWZ1BvwYE5whoj32QSglTeG7XfWI/c7paAmSIQY
         JBxZjKd/twwYDTJgsyf5rG+ekx+DNMJ8nwBexoKedNYnKFTwr5ZokKR+l0L+DMZ0gWEB
         fqxEz3UOC/s4BfZ6gBUHxltpdwlTA0JKgM+RJ978C/R+xg+UNNnMT6uSkDOo+ivtId6K
         e5Eg7oxjLtwdTVhn2pOI8T0eX3OdGyMRc63BqBKe2UHBzeqe8brCTWKRkmCKx1MT6iwu
         JW6Q==
X-Gm-Message-State: AOAM533/z/l4TL46VACuDqB9Av9YXiuLP27nugXGv560vKq0WWtLv1aF
        KNHffNAE7mpLHMAyZCdpLi8FQxBj9pssMROAHIcLFn1d5ciKww==
X-Google-Smtp-Source: ABdhPJx+itqr0L6RxTVPTcoVDXDI8OgBIK9PhH1BaN41cJX6+hdIJ6ivEBcFaA1u6f0x724tp5nxi5DesZeZNMf/h2U=
X-Received: by 2002:a05:6402:90c:: with SMTP id g12mr54735754edz.198.1634652445451;
 Tue, 19 Oct 2021 07:07:25 -0700 (PDT)
MIME-Version: 1.0
References: <20211019061402.629202866@linuxfoundation.org>
In-Reply-To: <20211019061402.629202866@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 19 Oct 2021 19:37:11 +0530
Message-ID: <CA+G9fYvK-B6Rp8NCgu=vGTogMaCbTy-O5uedi1-LXQKhmy6E7w@mail.gmail.com>
Subject: Re: [PATCH 5.14 000/151] 5.14.14-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 19 Oct 2021 at 11:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.14.14 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 21 Oct 2021 06:13:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.14.14-rc2.gz
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
* kernel: 5.14.14-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.14.y
* git commit: 6b894d18a514aeedc4c9464f976c72a2730043ef
* git describe: v5.14.12-182-g6b894d18a514
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.14.y/build/v5.14=
.12-182-g6b894d18a514

## No regressions (compared to v5.14.13-152-g20eb7f403c90)

## No fixes (compared to v5.14.13-152-g20eb7f403c90)

## Test result summary
total: 87941, pass: 74754, fail: 595, skip: 11848, xfail: 744

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 289 total, 289 passed, 0 failed
* arm64: 39 total, 39 passed, 0 failed
* i386: 37 total, 37 passed, 0 failed
* mips: 39 total, 39 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 36 total, 36 passed, 0 failed
* riscv: 30 total, 30 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 39 total, 39 passed, 0 failed

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
* ltp-cve-tes[
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
