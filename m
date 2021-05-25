Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF30C38FAF6
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 08:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhEYGdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 02:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbhEYGdx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 02:33:53 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83A9C061756
        for <stable@vger.kernel.org>; Mon, 24 May 2021 23:32:22 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id z12so44040103ejw.0
        for <stable@vger.kernel.org>; Mon, 24 May 2021 23:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1Npec4j21TKcPJnHz/t9cKkJ+ksFmk6C4YwBaFuicIo=;
        b=YAD0Y2U2SNdW6AmTzETze1shnoNYUN9OFgFgNfjCFstBiArSx7KspTTu1pIW2CqZ68
         jnKnXKl2Vx7XfBiVk2mMUxFDx2SOSj1xWnzTrBPBa/5F+vmiCm9ZSrc1jaiTcKNqn1iU
         SMLhCHZc+TRj8djWGezYBEgM2w2wSYq4qj/ymfLFkyjKY3O5ZOmP1eACbOND7kY7h8vw
         FCm5wDknp2snGrBtUHB5rSvrtSIr1H/ZOValfctrnCxlkDDkpDB+NKhrsS3bll1ChpIq
         9Jyapk+WKaLEg8bOW6r0ZN4Q3gYKsOunKYUSulj97sve1DEMv+yQgR6SnyL9Gi/W2Yi5
         pz7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1Npec4j21TKcPJnHz/t9cKkJ+ksFmk6C4YwBaFuicIo=;
        b=MZyAIllfGtf81O9CVzcUDTg/1cYICYXQZuD5Hv905FzWVXwbjfgblcDq2m52HXIAzn
         lIc/7D9jQBLbNKkzv727fRSTyI2Luph2sPLPa0+KuclpaLNuApS2w1jCMo2mAW+zrDag
         xUnr5PEX/DoY91tRngoikbgXIWoI6Fm0TtCDGA8LNyS37R1pxyMvPZ7mn3Zn0zDwRJQ8
         3REqbA7tsKAp8hZIsRGrpthn7+451/UKd94rTCUXLdud0nkLlvrRhb947qJ+EAKCvr4U
         +qB6MnWFGb8mVq/MfempVxsT5UQmvS9Op1jyPeZsU7K0bIcS5RDNh5jTWb7sVsoy6E+n
         WHRw==
X-Gm-Message-State: AOAM530WD65bRmuGcp9idAS4SNoUClmusm1mSuS7DJnmED4tBG2Dnqk/
        CPFC8uoicixrq20aaw6IvaY9CRDynnjN3w0exVvtvg==
X-Google-Smtp-Source: ABdhPJytCqlexeIP8Ii4HDaw0F8r74XDTUDMJ0xaWE6dZbP0B8Ce8JwIv2b6n6GJrW1VC4Khsp3Tvb+IvBw97sgXsCA=
X-Received: by 2002:a17:906:4e59:: with SMTP id g25mr27101842ejw.133.1621924341397;
 Mon, 24 May 2021 23:32:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210524152334.857620285@linuxfoundation.org>
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 May 2021 12:02:09 +0530
Message-ID: <CA+G9fYvOABhF_WjGp1NEeWTqBx=0YxNWydr_g6uQGhN5AOHE8A@mail.gmail.com>
Subject: Re: [PATCH 5.12 000/127] 5.12.7-rc1 review
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

On Mon, 24 May 2021 at 21:14, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.12.7 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.12.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.12.7-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.12.y
* git commit: 63b7a7baa77d39a089c1c64e5b046712ef598dc0
* git describe: v5.12.6-128-g63b7a7baa77d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.12.y/build/v5.12=
.6-128-g63b7a7baa77d

## No regressions (compared to v5.12.5-44-gee71fa12d93b)

## No fixes (compared to v5.12.5-44-gee71fa12d93b)


## Test result summary
 total: 80158, pass: 66564, fail: 1593, skip: 11381, xfail: 620,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 193 total, 193 passed, 0 failed
* arm64: 27 total, 27 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 26 total, 26 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 0 passed, 1 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 27 total, 27 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest-
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
* kselftest-vsysca[
* kselftest-vsyscall-mode-none-
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
