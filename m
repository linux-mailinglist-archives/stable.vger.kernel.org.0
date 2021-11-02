Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3317442912
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 09:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbhKBII3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 04:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhKBII2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 04:08:28 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A35A9C061714
        for <stable@vger.kernel.org>; Tue,  2 Nov 2021 01:05:53 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id r4so72278620edi.5
        for <stable@vger.kernel.org>; Tue, 02 Nov 2021 01:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BpUXHehpO0L4RH7cQq/HeK6Cl2xp1SAYTz/IbfVB1Fk=;
        b=sVhhf4hLr1hHL0FAWE/2GzyF7iHYiiI5a57k0YqAmDolqT+LeRDJV4pnjkrq+nI612
         LtYkk36qFXfJ5omIsnQfpER6PdVacQjfhWUkANedhj9wmJqwgTmYWospdXmU/UDpwkED
         dsIqyvf6pJ3CpHOw5cYwQXeV2iWaAxjoc8/+10EC5YTOie5f1OlXTzxX1nShY3u0ZLn1
         w0DCSLZoq9ROh1qtIsw23RDby3lWuhmM5Gpr4Et3drgO/3K1SyOFendMm1FxcsbzKaVr
         aXvNpnjZeB4rgEkGNzDC5iz1olLNMXS/UI0QerlDC8UmcJPBrFRba5XIu3qg3rOrNGn0
         b8ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BpUXHehpO0L4RH7cQq/HeK6Cl2xp1SAYTz/IbfVB1Fk=;
        b=Iawz7HL7Vqq9rLtBUjOMS13uQu32MlkG7Ga29RYC2FxHUBOYXei/2bPHsbHZyrJpSL
         5CHzg0HGCGG9dsgS8WDTci8XkxW5BO/qCSvvw5zG8QufJvMnwhLnoHa0qcYY6WoHb2m+
         XEF4F9rARMpQOwgnfbxurFSTADuFe7Nk+SiACCkauZtIHDdfze1zYwuhMXGwfFPgnII/
         7OOUGiJAMSgpDcFUth+xYsR1iqgKzv+rMRQ1vcRVULcHg2rvCk16Cr6tmmXTpwVmHTio
         y5VQ3hQbm+Cwq8wK8R9Otx14nWVMo2Lweb+h7gBQg0vWY79Uxa4R9nMQqwdkmx3ngtZV
         BJ7w==
X-Gm-Message-State: AOAM531dH0norFgfTYpDjXoIoPa1DRahj3C35AOC/kXQ3J5rvm5mb5jt
        aHpcUpo3IyhUtEF3oVp9ncWjk+vkUOLjR0YL6aresQ==
X-Google-Smtp-Source: ABdhPJy6oeKtwjzN3+JAeygl+bciukufcgFxfnRBe8VWVO8u4C77zVI5TTDK44YkbRh1L60+3uyAVOS7ZVGkzeahrp8=
X-Received: by 2002:a17:906:4bcf:: with SMTP id x15mr19367236ejv.493.1635840351988;
 Tue, 02 Nov 2021 01:05:51 -0700 (PDT)
MIME-Version: 1.0
References: <20211101114159.506284752@linuxfoundation.org>
In-Reply-To: <20211101114159.506284752@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 2 Nov 2021 13:35:40 +0530
Message-ID: <CA+G9fYvjAXxuVj3ZT1W0DbOgA2PNs03NFHqV0TGc+G4CSdWZaw@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/25] 4.14.254-rc2 review
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

On Mon, 1 Nov 2021 at 17:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.254 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 03 Nov 2021 11:41:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.254-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
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
* kernel: 4.14.254-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 64fad352ab39db2d688622d38f866978ba7a7ded
* git describe: v4.14.253-26-g64fad352ab39
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.253-26-g64fad352ab39

## No regressions (compared to v4.14.253)

## No fixes (compared to v4.14.253)

## Test result summary
total: 76449, pass: 61036, fail: 681, skip: 12640, xfail: 2092

## Build Summary
* arm: 260 total, 210 passed, 50 failed
* arm64: 35 total, 35 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 19 total, 19 passed, 0 failed

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
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
