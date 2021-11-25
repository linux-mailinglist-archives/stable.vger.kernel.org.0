Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5443445E092
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 19:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238858AbhKYSfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 13:35:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbhKYSdr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 13:33:47 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E9FDC06173E
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 10:30:35 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id z5so29181599edd.3
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 10:30:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0VXWosJRZAdkGHkgPUkUbLsblOpwkRU9t0kVTz+wwXg=;
        b=aZ1d66Q3FjxufcyDrG5sO7rBtW6xBxxncf529xeXVkFg7i084i42gBiUR0jPmg3eqJ
         ujLFKzC55+62dPTwmZrFaaWnO9LWDwnS4WnoVX+QFrBKqe8U6BsrzdWBH1s8Ie2gV7Pb
         poX3s2EO6OZ/lIUUyQeNUucwNdyUg1wgxQN2MnfRorRnxkaoIll656UH49dWZqRB38ij
         hm8tlVHsEU8laWxAlFWS+Yp6MLB8K0KQryRxgzeu7KkuIoGKGbqW21LkIIy4glntQLUt
         xstWzUL0u3dfqg25VOw/huexC+n5rrQ5hwykCxiJLhVydUyOYrcxWkRKYSONKh/sTT1j
         3G4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0VXWosJRZAdkGHkgPUkUbLsblOpwkRU9t0kVTz+wwXg=;
        b=QB5Zd6uxOqG5DrX/MnXcZJbBTMdms5KhJTnmnCe3ODXWSYDMov5aItq+0Lg85OeK4u
         YHUzX5ztm/2ysVfzXjVF88PyXQqfaJF0PJaojrxYmXvwErBKEJoZtccEU/oaH/bGlZW2
         xngtGMfVAq4MFrxclCK9ZMbu/gZQ09J94BQim4TjucBVHGgbGv2qaWBxupOEC3h3kngY
         o9aBgHlLIsoolwmrSL1hg1aygL1OlUXHXvMup1MWOdx3MzEW11hXPS23Zi5NH5hl2Zao
         zS/S6ioAUJHSo7uJcOaHo9whYHvoxVUwk6avPZkgKaQK+laUTB5YW3KHXu+NufAl6vX5
         shJA==
X-Gm-Message-State: AOAM531liovIlamprT7vo/LHVc2ORoUkBiTYR4A11ASoz5G570TnCkD6
        tG4B/H8Qkv9ZT4JSR2B2p5bwHwB6hliwiTsb4KhxRg==
X-Google-Smtp-Source: ABdhPJyUlVZeKNY4ZGd2psjPCYKQVLwpj/v/0iqY2LHayqcn3w2Ornp0N2FsI4dNLH70istMPTgJ4SpHdF1+EgO9DEM=
X-Received: by 2002:a17:906:c302:: with SMTP id s2mr33570132ejz.499.1637865033725;
 Thu, 25 Nov 2021 10:30:33 -0800 (PST)
MIME-Version: 1.0
References: <20211125092029.973858485@linuxfoundation.org>
In-Reply-To: <20211125092029.973858485@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 26 Nov 2021 00:00:22 +0530
Message-ID: <CA+G9fYsadBOzy2yNVTrq_N6DXNoKyH264M68HSLPVFA=+4VeTQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/153] 5.10.82-rc2 review
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

On Thu, 25 Nov 2021 at 15:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.82 release.
> There are 153 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 27 Nov 2021 09:20:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.82-rc2.gz
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
* kernel: 5.10.82-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: c7ee3713feb580103e956dd5980d3805868a677d
* git describe: v5.10.81-154-gc7ee3713feb5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.81-154-gc7ee3713feb5

## No regressions (compared to v5.10.81-155-gf8f271281cd8)

## No fixes (compared to v5.10.81-155-gf8f271281cd8)


## Test result summary
total: 89088, pass: 76022, fail: 464, skip: 11925, xfail: 677

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 259 total, 259 passed, 0 failed
* arm64: 37 total, 37 passed, 0 failed
* dragonboard-410c: 1 total, 0 passed, 1 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 36 total, 36 passed, 0 failed
* juno-r2: 1 total, 0 passed, 1 failed
* mips: 34 total, 34 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 54 total, 46 passed, 8 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 20 total, 20 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 37 total, 37 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
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
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
