Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9732344282B
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 08:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbhKBHWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 03:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbhKBHWN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 03:22:13 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3D2C061764
        for <stable@vger.kernel.org>; Tue,  2 Nov 2021 00:19:38 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id g14so10501178edz.2
        for <stable@vger.kernel.org>; Tue, 02 Nov 2021 00:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Tbu9/nDcoruYXq0v34C9MDD4hNvw09CUSs/P0rP2wA4=;
        b=roX2kuxQ7uDcwhd5XYeSGkiBgX0XraTYRjQN1OyTe1So8wjqRZ01aghO5JjkRNDrb3
         mqAOPX50AKy+yCp5BZYMcX1680EM91yP9QfuvV9SU1DY7M1sqyGwj2dfGVCY158gdC1I
         ly5wPBR444rR4xuNt9TbUEtVdgBRpV2SKtDOXnIYTKDMiknNBp6NyvOrr6uZi7JY2bvt
         cfgI4AUcy/LAxYNAIymDhmyswOmiUA+kYWtJvIsJymiDWcSbzwRK78LI2FHD4o4xCEx1
         M88dgvzq/uQapjx2vunzcyY4BPKmHkoGuV/qn8y0mcND1+jRFdisKTorH2XuzKOdz75g
         LznA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Tbu9/nDcoruYXq0v34C9MDD4hNvw09CUSs/P0rP2wA4=;
        b=Cfno7C1FZAj514Va9vg/52YGI+tUDS5aGfFK8n+5EXaZvm3aQBSCelYhxpOz/tkabq
         6ib3z3u3WZNZw8PGqsqgjWTwSVdtjPf88l/ElF/mOf/5V4cYnlMaYDb2foW14xMKxllC
         rS/rK9NvfYa1nq6NfSEpYUtfmoJvapUxZ4Uk+VnDLiuKhOdANfuts3N6xQjgssPOUA2l
         BTm9oyAE8aEf4FRc7+CVLTScXOGBdtdr2aWk8Swh+K4x8HVbJWaMw8xMW5vIJwik23U0
         hq2d9Ctwgr0lYej3aZ7dC/1WyEY7YuosunRxg2h+JYwl9tBGzJ8zxCaSBU8pkGxnyjVo
         6EnQ==
X-Gm-Message-State: AOAM532m9sObEZMf0ON6l6O5vKpVYKQyof2xXsxSEbXmp17ztQ5YBZ5J
        knolG+1FdRMjcnumaBe7V7J22MUPqEKSe7ZFXzrL2A==
X-Google-Smtp-Source: ABdhPJyARKggcDVSp92WsxoZw09RWWBsxLa+TgvBeWNK+nsHHGCFy23UN6ZsaX2ITLxK2NPiFlbdOhrygz62DumVgPc=
X-Received: by 2002:a17:906:4bcf:: with SMTP id x15mr19087441ejv.493.1635837576699;
 Tue, 02 Nov 2021 00:19:36 -0700 (PDT)
MIME-Version: 1.0
References: <20211101082533.618411490@linuxfoundation.org>
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 2 Nov 2021 12:49:24 +0530
Message-ID: <CA+G9fYuCt_D=M_j41eLqScv4qWF4LrKLCF_VaZMZu_HyKbm5Cg@mail.gmail.com>
Subject: Re: [PATCH 5.14 000/125] 5.14.16-rc1 review
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

On Mon, 1 Nov 2021 at 14:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.14.16 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 03 Nov 2021 08:24:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.14.16-rc1.gz
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

NOTE:
With new gcc-11 toolchain arm builds failed.
The fix patch is under review [1].
Due to this reason not considering it as a kernel regression.
* arm, build
    - gcc-11-defconfig FAILED

[1]
ARM: drop cc-option fallbacks for architecture selection
https://lore.kernel.org/linux-arm-kernel/20211018140735.3714254-1-arnd@kern=
el.org/

## Build
* kernel: 5.14.16-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.14.y
* git commit: c99063ce032cc300f6046ce43af6a0f5155171d3
* git describe: v5.14.15-126-gc99063ce032c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.14.y/build/v5.14=
.15-126-gc99063ce032c

## No regressions (compared to v5.14.15)

## No fixes (compared to v5.14.15)

## Test result summary
total: 91356, pass: 77480, fail: 764, skip: 12385, xfail: 727

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 422 total, 370 passed, 52 failed
* arm64: 40 total, 40 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 39 total, 39 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 36 total, 36 passed, 0 failed
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
* kselfte[
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
* ltp-[
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
* v4l2-co[
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
