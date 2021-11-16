Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8FA453292
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 14:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235222AbhKPNJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 08:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234913AbhKPNJN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 08:09:13 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF68C061746
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 05:06:16 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id b15so87218940edd.7
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 05:06:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2Nsrxr85XX1Aed0/RFoj1lSPf2DIWI65u2IkWRBG0XQ=;
        b=PXP70a1FCsSxPR7meei5DO3Pi/+FO9ZoZaRJGPFw6QcRcX+6zaFaCcxKUgSm048Geb
         HYPcZV4cp8JbrY+KTSAfJ0f1iYjI3ZKzw1O5alI1SRlM4vqPS2tAGqo7CT3tTcv2kp9a
         CKsFxb5952TV6ZoQnbxCy0d5/JQwRC/bTXUztkAS/yQE9HDqtaEdnd2tuVbd7pkCmnNh
         u0JgXmFacVNeF5l55XgQX+jAQZkHIXnU/0oLVTPQbPXGLeNmtFQ6zxOswtT7vlwWKC6Q
         o7v8/2lSH/Ro+rJ7LCp+wibzX1Gv7CWZoO1EQqJ1WmuSsV48kqv1mj1E3RP10SNxaOL6
         gTKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2Nsrxr85XX1Aed0/RFoj1lSPf2DIWI65u2IkWRBG0XQ=;
        b=jwiDwz8BLXs/ECuddBph1cJEsF0zKwxDWWuz745oTJYEGh54Pakc2GVv2vmERCWHN3
         E3V8dk823bYam7ufZMtYs+e1om/+W6VXi54YbLKW0S9qMx4SLsvw0ZF8xt3WDNK2mT7c
         ss5OmDdX1E4hGOXd40+RXMyDMZqfJPtSJwuCudxJgIN6ySuLCtDPjPP3Jmqj5u7YWwWr
         KyW0MGuePfSkgaxiONhcxuGvLzfJWEhv5FWL9RQTKTBzUebWaBwwopYM2KnSwmm7Sk8x
         LvhkrJQLcmpu0QWwJNhHx4lo/ri46HteN6hKoBB707ZONgwDeBmmJPaDVhI4pWUNUA8Q
         rgQw==
X-Gm-Message-State: AOAM533EuVWulprKHfX6Ctnquupxqut7q6O7S8+yfy3BjK3VNlv+ZpOA
        ONxCwEBMq6I36sS+88s+wVZ1OiIhFq/apo0S7zBVwQ==
X-Google-Smtp-Source: ABdhPJy+pz9dPeW/ayXhprz/P/s/VMQKtDb26raGgIFBGYK2SnWEM2AjDyq1skAfK545rTYxTzMY2YAw3WZ2I/et0xI=
X-Received: by 2002:a17:907:7f90:: with SMTP id qk16mr9901106ejc.169.1637067974573;
 Tue, 16 Nov 2021 05:06:14 -0800 (PST)
MIME-Version: 1.0
References: <20211115165419.961798833@linuxfoundation.org>
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 16 Nov 2021 18:36:03 +0530
Message-ID: <CA+G9fYuTxafx-w_qf2s=-HSrX5oYXMQSSOf=ABNoog2AfxUS_Q@mail.gmail.com>
Subject: Re: [PATCH 5.14 000/849] 5.14.19-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Nov 2021 at 23:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.14.19 release.
> There are 849 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 17 Nov 2021 16:52:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.14.19-rc1.gz
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
* kernel: 5.14.19-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.14.y
* git commit: f9bb48b60e5a17952d2ad5b43826ffc2ce4b2255
* git describe: v5.14.18-850-gf9bb48b60e5a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.14.y/build/v5.14=
.18-850-gf9bb48b60e5a

## No regressions (compared to v5.14.18-154-g052582294dec)

## No fixes (compared to v5.14.18-154-g052582294dec)

## Test result summary
total: 95749, pass: 80866, fail: 1066, skip: 12961, xfail: 856

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 290 total, 290 passed, 0 failed
* arm64: 40 total, 40 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 39 total, 39 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 54 total, 48 passed, 6 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 40 total, 40 passed, 0 failed

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
* kselftest-sigaltsta[
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
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
