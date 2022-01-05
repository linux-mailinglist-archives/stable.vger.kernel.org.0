Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC94484CE8
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 04:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237138AbiAEDgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 22:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiAEDgk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 22:36:40 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B038EC061784
        for <stable@vger.kernel.org>; Tue,  4 Jan 2022 19:36:40 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id g80so70143220ybf.0
        for <stable@vger.kernel.org>; Tue, 04 Jan 2022 19:36:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AqC1IHEx9dQuWnodrHASLopylxT4xjAMf5cAeN6buVM=;
        b=SN6tc20mOHH701za+plFKttZrD5wwyZ1DdpO6RSof2fzAhHP/DtJy62D768rv4z0Si
         a+f04aEC0l87hf/mG23OF33dOtzgzELjXOqjspSmVF+Y43DGKdpU3rB5bZk4UreRKwlH
         SQ/uAV2uhUu5hIlSYPg6e/FOvSKfbfdUpFI602RhSksBvDTHTz1drT2GfthwfDx0jhai
         A8rEssy1wK+OX3/YPQl8wL5lkyh8hd20illc/ccM3SOIp7srn1oyYAoljO99fNSjOZoK
         FCLBlGO4yi6clFI8APEI3doBybx4USrtn+qazZhncHFSQFmvrSN9Qj057hQ89hld3W8F
         rHPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AqC1IHEx9dQuWnodrHASLopylxT4xjAMf5cAeN6buVM=;
        b=MBR6C5VQEtjivn/uYsbkqHE8S5mhq90xepzSv2smPo9996pfhdMnnV0kC+5R6aRZaG
         vvGPEycjJAmXX/ig6XP6WUJqnh3aN5H4nVUwMulbwlJysJ5fvgIjW01mJWzzXC7wQLP/
         3qSIp0HE9GmcudEGilw5EFBJqIz15cLvcPaGxVnezgocDkoOlgERQ8Dis9+Wi7rGVq3J
         wzFdNPTFVqLm8cGU+CbrKGSLH1Y7CSz0TwTd63q9FAEH8ysei0Wls3vDzO/RtHjcebOr
         UdawLLBFSOGQB0uxzAoaV9FCdos3A70xSQXa/c8dlf2DbAT49UBKqR/TOGd4MHyuJUUj
         qgVQ==
X-Gm-Message-State: AOAM531PUzZeG0oreWc7oUJ++cyngyI6J7P+w/iA4lBS8z+/pDB149CI
        dhcrEOMUIWh38PZxQSTad4cPCQ5Z9OTvS1zHvDjJng==
X-Google-Smtp-Source: ABdhPJwLjfYSwS0nCOh4CQIZacRcEylTSvp+UC4D4cbPWQ+qpH2/2wO3gD0ZZehnT2LhnqwiK4WB5cY8fK4flE+GR3Y=
X-Received: by 2002:a25:414f:: with SMTP id o76mr52473829yba.146.1641353799617;
 Tue, 04 Jan 2022 19:36:39 -0800 (PST)
MIME-Version: 1.0
References: <20220104073839.317902293@linuxfoundation.org>
In-Reply-To: <20220104073839.317902293@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 5 Jan 2022 09:06:28 +0530
Message-ID: <CA+G9fYvyF=P49vo8EHAGp9gcpjhWhE4AUpP+Hhf9hYc3jdWw3A@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/36] 5.4.170-rc2 review
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

On Tue, 4 Jan 2022 at 13:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.170 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 06 Jan 2022 07:38:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.170-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.170-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: 80ddcc564ae91afb9de54b43ffb4b2167a7306a3
* git describe: v5.4.169-37-g80ddcc564ae9
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
69-37-g80ddcc564ae9

## Test Regressions (compared to v5.4.169)
No test regressions found.

## Metric Regressions (compared to v5.4.169)
No metric regressions found.

## Test Fixes (compared to v5.4.169)
No test fixes found.

## Metric Fixes (compared to v5.4.169)
No metric fixes found.

## Test result summary
total: 89585, pass: 74682, fail: 752, skip: 12738, xfail: 1413

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 258 total, 254 passed, 4 failed
* arm64: 36 total, 31 passed, 5 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 20 total, 20 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 34 total, 34 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 52 total, 48 passed, 4 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 36 total, 36 passed, 0 failed

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
