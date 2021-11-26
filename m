Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2FE45E85C
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 08:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359222AbhKZHUF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 02:20:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359102AbhKZHSE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 02:18:04 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F231C061758
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 23:14:52 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id e3so34921619edu.4
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 23:14:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PGZaZsF4EEc9XJ4D4bs2n2YA93FNTJvPRvvwgPjhqc4=;
        b=W/k2gqxv+jtRh0g+zQiB9dCNWO2wF6PR0H4q5yR1KylyrnUTGOA7SU5a6j9OBV/7YD
         co7yD5YIwVCfU+QuiG4N6Ph7q7QQVH3EPIl+HE7WqhS5sawelTaizu4+x9Hj1g6+OMy2
         nH/dBe68Hu03OhuLvnjjeAGncmjTaGbzwotecVyuJhfyo/LzscaWI7IQ8V9DCX5kSyO1
         wHIfn9NvXI3649vbCg8QhKwYzkOzO07qmFYLPmSE1Om3NmlbiOKWRrvz+Als/2uWorVL
         CCzy8NJPYg3Mc3uf9NvYpnr+MFj52nCMcakQgdDM9gVW58GyGJrIapbUMhJkxl2idKhw
         es2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PGZaZsF4EEc9XJ4D4bs2n2YA93FNTJvPRvvwgPjhqc4=;
        b=prTlJuxorNCvyv7gSd9aUUaIJxBtW8MsyzPOqthSBzPe0ELc6EAqhE2EmR6HCU2SGu
         YPSHZh0c+vo+B+7xEITlX9ZaPA1jcFSPs6LEpKqF7vNXIEB1/KVB5NiW+8OOXPn96Kwp
         GgJZAxtAk6eUJIiaHjKkfHc+sFhynZtbIk5crNUyfDOKnknPmywuuiW2xMT28qiH9bUu
         u1a5s31D/dhwtUEH+OE01mQ78MUsKBb99WXZzPBuBtSTWxEQlWCeXf+z80hIRMIdEKB8
         iNBLaelRA9ywsoCjzPGXW4ZktNQc2fxrC3fMsve8+upy0uros72LxV2ft7/TSQUGz1r0
         ERQA==
X-Gm-Message-State: AOAM531nQRCsVcjUNB6K8smYN4osLbTE6GXuAX8E1Adq0rFqBQ0ygO1a
        C0HIcNp+WVX9Y1xuX9du5bYJyye9qg4JY2mnoIcacQ==
X-Google-Smtp-Source: ABdhPJwfYTlvO8igc642vud2krop4us0/PqOfA9T8jWGOjB2R791aI2P3dPIDSLeLf4KVyhkmS3kZ5EWcjxelnCUzZc=
X-Received: by 2002:a05:6402:4312:: with SMTP id m18mr44459592edc.273.1637910890442;
 Thu, 25 Nov 2021 23:14:50 -0800 (PST)
MIME-Version: 1.0
References: <20211125160544.661624121@linuxfoundation.org>
In-Reply-To: <20211125160544.661624121@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 26 Nov 2021 12:44:39 +0530
Message-ID: <CA+G9fYszi_Onb4tOJWnjyFyLqyKoHupiF+5TTWjJJeYCzcH4pg@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/320] 4.19.218-rc3 review
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

On Thu, 25 Nov 2021 at 21:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.218 release.
> There are 320 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 27 Nov 2021 16:05:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.218-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.218-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 616d1abb623837b0f3740984b9209ce6d488c24f
* git describe: v4.19.217-321-g616d1abb6238
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.217-321-g616d1abb6238

## No regressions (compared to v4.19.217-323-ge179aa5db430)

## Fixes (compared to v4.19.217-323-ge179aa5db430)

## Test result summary
total: 76935, pass: 62199, fail: 752, skip: 12436, xfail: 1548

## Build Summary
* arm: 130 total, 130 passed, 0 failed
* arm64: 35 total, 35 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 26 total, 26 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 22 total, 22 passed, 0 failed

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
