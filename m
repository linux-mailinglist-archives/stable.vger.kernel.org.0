Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAD03FEA6A
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 10:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244062AbhIBII2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 04:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244042AbhIBIHP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 04:07:15 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3918C061575
        for <stable@vger.kernel.org>; Thu,  2 Sep 2021 01:06:16 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id mf2so2335652ejb.9
        for <stable@vger.kernel.org>; Thu, 02 Sep 2021 01:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mQ6Ni1UxD1W4ZhufZq9rZG3ANUylWRHIbQWqjRNj5qE=;
        b=XZE0x0c/dr9zWxCHD7SAwrcDbbXD/vCF4Cw2jwQqXO99b9pzmqfw8pfmS57Q9iyYKU
         daVM9xpRkFti6Y2UMJsayCwwpPX24IvAKDCLIAmzcR3ZaIRZ4u//g635Pbjj2V0PmztB
         VOa8tbtrzKX8E9T/8/lCaZqVf8+fdhQj5suxf0ESd/4fX3rO7Co97gTwZF2mep+oW6TU
         BCPAKGTeIsvKwJPT03nvU4imUb4/3z5jtLPhOhQlVzcuCpcE3sHeh8ASzqlh2+ON8llY
         3xp4jShzYoOxMPZ5FsP4m/W1RwGeW79YkIZpulyG3lhIOq3om8rRfD2E5F5d4c+sQcQL
         8yBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mQ6Ni1UxD1W4ZhufZq9rZG3ANUylWRHIbQWqjRNj5qE=;
        b=dmfkWN7rCaCejkcNm64v964uOuunep68Nx3tqZg36gnsHCsSSapvMC8lQabBXYXzI+
         LZjmDyO3dhd3EmXv31Kl/0qsvyi2pUI0oEjOXlvSMcalwYeLUd6JrHFf3T6KPmaFOMwC
         F8MSlDXh9md2rCf2nddL8BGQkXy9iIcrRBUONsv8n7191jhJuE0lxWiA+yR6bX98Uy1X
         lCQ8b5GnP1LWcZuq/uK/Hj+jdHuzKGSpzRYZdOPXDYYFzbbMUTbaQcwQNAnyiowzt9Sn
         6wdUEpPPbwRdogkWLm5MBZyDjjkRQrLVs7RilQGBJASwngxnUwBGfQk0tNzAgrOLxRwX
         GhmA==
X-Gm-Message-State: AOAM531RONJ7pim8EVwQ1Jp3G7m+KEF0H0WVis3ZsOLKDN0A8OGa8YTf
        hBY+JW5LlhMMkleE7wZjtxEanCDss8NEhfSdj4pRAgn/7dXZlC+/
X-Google-Smtp-Source: ABdhPJy20AEzBg8DFLzEFIJfRaY8CmEIlME9YLfn8VG5AvHqD/YLKnYwG6zisshQrg4zuFdMeHdcGnTXpMDGJ4LBbeo=
X-Received: by 2002:a17:907:7785:: with SMTP id ky5mr2408836ejc.247.1630569975227;
 Thu, 02 Sep 2021 01:06:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210901122300.503008474@linuxfoundation.org>
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 2 Sep 2021 13:36:03 +0530
Message-ID: <CA+G9fYs52C2LOTK+wQmEyJ7YY8qXg9ZT9hNtd25fo6SoOSm12A@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/103] 5.10.62-rc1 review
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

On Wed, 1 Sept 2021 at 18:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.62 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.62-rc1.gz
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
* kernel: 5.10.62-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: ab8ec6b0cfc1050241cdbd05816acdac92a08bcf
* git describe: v5.10.61-104-gab8ec6b0cfc1
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.61-104-gab8ec6b0cfc1

## No regressions (compared to v5.10.61-54-gbe6d4d2932a9)

## No fixes (compared to v5.10.61-54-gbe6d4d2932a9)


## Test result summary
total: 86753, pass: 72586, fail: 603, skip: 12662, xfail: 902

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 258 total, 258 passed, 0 failed
* arm64: 36 total, 36 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 35 total, 35 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 51 total, 51 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 24 total, 24 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 36 total, 36 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
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
