Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE86423AA5
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 11:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237909AbhJFJi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 05:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237820AbhJFJi0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 05:38:26 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67160C06174E
        for <stable@vger.kernel.org>; Wed,  6 Oct 2021 02:36:34 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id l7so7568766edq.3
        for <stable@vger.kernel.org>; Wed, 06 Oct 2021 02:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rcNh0r9T7kBrXbUl4kwoWlPX/sZ4eZ8cwO79sUZA8X4=;
        b=EVESwHctwsBLZQxT4NZ4k2CF1+9YMTfY6riM/UzylXVP6Q1hamfHIJPpHCfoo2gVv4
         oeNbRUs6acnCuFAz+HJ5wbyzwtKa6mDR/lZe2zsyfxUuSkbAZFqN65HyhbGdQXYrB8ui
         IV+qmQ6iJIBQ1SrrcZa4S5fU6NDbF20FSXbpbHKn8fBSa3ANYs39Q3C/A19zt/tqjH1A
         cvLYdgVip6zJ+NED+VAsKou7JM33+gXIZRVAGpABpvKiJXy2J0UXB/SqHOcJolE8O2fC
         xa6UqdAInGJoR2Ur4VKXoQyELZdjsyd13VnOp4jnZMkOs+T1g1wxXzctTKfS7cihbHZO
         uGGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rcNh0r9T7kBrXbUl4kwoWlPX/sZ4eZ8cwO79sUZA8X4=;
        b=Kpu4qJHCrrPsTQ9+eqE8p8rKCkueCqFdtnj+BBJ03jVoho7zTwtTiSpOCK+HX8PL0w
         ayGf7oUQmmbXsS+r8wlpS6qOJfvElimGteLyWT1ODh3irTZzgz8D6UHs83Ky+HMfoaQt
         q23NAqZ56fPEAOANCeq1DlO9pFxHEw3oLvL4HvVjtgbRLq8+w+npHAPaF7L3TK28XVuK
         XMadyNIpoE8uzqMqO7TgsErVE/JQN3N8A0+CFr1926/3+vIymmA7Px5WXfm9rjHMmKZe
         sdVaDSC54TEx5hbwz3rCXFSJY+iQYdN7cf2iqQiIw3kpfsRtsikCQxztD8rav0uJp1yr
         Dv/w==
X-Gm-Message-State: AOAM531tSHDzFYHrFkiKT6mLhs08HDFckbGI+a/tRL6DmkI4URM7KbBW
        TOwC2otXLmHqWZToYLT3I+qsolLpgMVpMbHFnXdePw==
X-Google-Smtp-Source: ABdhPJwV8nChSokFlOIMg6kZ0ARPzKO+d6ycSmuNYFHme9oxJewenlyUkr5aRjxeroI30BwiUe3To/lOHrglB81lMiQ=
X-Received: by 2002:a05:6402:5146:: with SMTP id n6mr32426966edd.357.1633512992885;
 Wed, 06 Oct 2021 02:36:32 -0700 (PDT)
MIME-Version: 1.0
References: <20211005083253.853051879@linuxfoundation.org>
In-Reply-To: <20211005083253.853051879@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 6 Oct 2021 15:06:21 +0530
Message-ID: <CA+G9fYubvAp1PpuMqabSvXnQjnKyhwTD5u82HfGPy0uYTmLLBA@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/41] 4.4.286-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 5 Oct 2021 at 14:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.286 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.286-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.4.286-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.4.y
* git commit: 72b93c7258429eb65b95794f69218e8d8e0caeaa
* git describe: v4.4.285-42-g72b93c725842
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.y/build/v4.4.2=
85-42-g72b93c725842

## No regressions (compared to v4.4.285-38-gf70f9a082d64)

## No fixes (compared to v4.4.285-38-gf70f9a082d64)

## Test result summary
total: 43887, pass: 34824, fail: 167, skip: 7877, xfail: 1019

## Build Summary
* i386: 1 total, 1 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed

## Test suites summary
* fwts
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
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
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
