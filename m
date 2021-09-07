Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBF84023DF
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 09:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235953AbhIGHLa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 03:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237594AbhIGHL0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 03:11:26 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3425C0613C1
        for <stable@vger.kernel.org>; Tue,  7 Sep 2021 00:10:20 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id jg16so17780907ejc.1
        for <stable@vger.kernel.org>; Tue, 07 Sep 2021 00:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pIg/BmzC58zDRJnJdA1+1g4tK5vqEoBQVrKz6bF9y8s=;
        b=wSXKbmIlIfzF1DA+pXUUdvQ/ljWmDVDKIO3jXcPFVvuJKZx4SoPwVm0p9NUMPaBl+n
         lWUkc4mPegjXv1D8IJeNnhA955bbt8dLKMenXmTTx8t9O0IsxweimQhDMbw6VAiFSvtZ
         YZZMLedL71kH7ZeanfM0Hwyw97wkQjbFhZOrKc8EhuI5+Rr4IrJeTpspDnAZYCoWsoCX
         jSDlgL+mMl5c9Xoby7Fg7+sdiEukiNnB6y5iPRcNZgdpnnb1zWnhix+ryNNWNI2X3wLe
         iapUjp0rzHr3ZEpPK6parMKw8V3YJdg8BmfVmkKm/ZqeEfKfuMs8oPLxDRUJnRArhG6y
         /JbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pIg/BmzC58zDRJnJdA1+1g4tK5vqEoBQVrKz6bF9y8s=;
        b=peXROdjTAM1tDJ2R3nd702bdDn9XuC5yO4YqvbahYyflEF3JzTMGxgshhCjIFptwH4
         K6z7nf6Y8e3JITR8ESWfxGBsemaSLODZqsV7ME+UpRveoLh8vdtvF45lP1R1xEpMnpvF
         dAFzzl1C10w2QcZmlxyaXWfVzRIYVIvIOilKq33sqx/RqwoaSHZk5g44y0EMoHY8OPK0
         9/IS0hL4wLZwEfFVz5ZzvcDyrO8YuOOYzTlRjsFCELqZW8S/7wosr8O4D0EvGJtOeA0n
         TUbMsypYQEH4wo81NcKuRLMoS4hQPQZXA3GzvrrJw7wnn2au3YUNK7httCF/A5ROxASU
         9RYQ==
X-Gm-Message-State: AOAM532wAHQAtebAVZLOL2y4k6dQsrAZac3dr17za/+E3HpH6cgo+WKN
        DSWGfMGg/70MkjzTYHpTYjui5Z4EtjG/sKPzduFnZw==
X-Google-Smtp-Source: ABdhPJxCWzBLffRGE0gllNXmbZg04HM6nuj+f2UkBTFccUmlGOY/vHCQ912FnR9Ps6Yd5jZR964WGu3PAXUkS4COSgk=
X-Received: by 2002:a17:906:ae0c:: with SMTP id le12mr17174746ejb.169.1630998619389;
 Tue, 07 Sep 2021 00:10:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210906125449.756437409@linuxfoundation.org>
In-Reply-To: <20210906125449.756437409@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 7 Sep 2021 12:40:07 +0530
Message-ID: <CA+G9fYvaxuDJq4nxjw8AtvaeqMBfH13DEcpMECLuaEOYA+EtFg@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/29] 5.10.63-rc1 review
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

On Mon, 6 Sept 2021 at 18:27, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.63 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 08 Sep 2021 12:54:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.63-rc1.gz
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
* kernel: 5.10.63-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 49a2bcaf11be252cfbbd47ef9d1c3861b0a3ea95
* git describe: v5.10.62-30-g49a2bcaf11be
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.62-30-g49a2bcaf11be

## No regressions (compared to v5.10.62)

## No fixes (compared to v5.10.62)


## Test result summary
total: 88715, pass: 74649, fail: 534, skip: 12601, xfail: 931

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 289 total, 289 passed, 0 failed
* arm64: 39 total, 39 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 38 total, 38 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 51 total, 51 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 30 total, 30 passed, 0 failed
* s390: 27 total, 27 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 39 total, 39 passed, 0 failed

## Test suites summary
* fwts
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
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
