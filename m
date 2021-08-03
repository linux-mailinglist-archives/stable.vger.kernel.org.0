Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDAC3DEF3B
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 15:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236205AbhHCNqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 09:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236209AbhHCNqG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 09:46:06 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3FCC061798
        for <stable@vger.kernel.org>; Tue,  3 Aug 2021 06:45:54 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id g21so9785680edb.4
        for <stable@vger.kernel.org>; Tue, 03 Aug 2021 06:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iLnRfpyJvjR8TuAqQswR0J3zsW8FGGiK4F3r2vWum9M=;
        b=D6H/9ljakjYnSpBOO4qF5SCNaeje+yO/X6HbSLyf1XjZLehZAF0+UCd+pOsZCenr5J
         /SU1ArosXx59JgIUTyZppMTTES2IF5VPAQFWPG/X2rYn2pQm+ogP62rKq3JDLDWeaymT
         RgZkWndiT755iPdrDgN1oooEZnzhcOqT6syPeAuOBpAXP//9n2V/FU/ytIfnUV7R2LHM
         a8/Sscr4PsiDUDqrR0tCUolr3Cq6ssk3s1F4EOCFScz9FYm2w5+JCjDY0bYgy30cFPJ1
         DClkxXa3dW8o4FKXAClvZGz0X86a4oQJRvwo8bncb5aOY6ZROx8in/+o93X4rXCmiz8B
         w/yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iLnRfpyJvjR8TuAqQswR0J3zsW8FGGiK4F3r2vWum9M=;
        b=IZ40aw00uz/hadvJWUdiRzWYOuQvjnROuqBnWSex6ht4WJ3VquLJ0QVDvmS26agZpM
         dWrWwX1n3JHcRp7H5rMhi3HOVEiS5l0GhJLarO9rc89JsvHkTUkbpSYPCn7p4HWxmq+X
         ev62Jg9SEUDPKoyzy+R/y7Y6DUFy0jiBpNraGKZCOtx3IVQGo+TGcMjvkY3Qywede9Ut
         Y0J1dMfGxVViY2sjimQzsJdNxp1K/3/feCeD54Zl6vkdOFSzYKNaG3Tw665WzDWj1cMm
         2MapzRdfwvmm6NsPWidiu0V3rPs5+mYe3FcYa7ixKE4Dbgf6/R5c6lpXbJM1kkkKgv73
         CVyw==
X-Gm-Message-State: AOAM5307JYXSZE7CeFkhrcRoS0KvJukowBDMyDSWAxK/rSqtlpJ+qKCn
        WxjuBJmZS39A4DtRfkZISghJRAp4PbSkLttvU3HsuA==
X-Google-Smtp-Source: ABdhPJz+Y8ekWJDeoT9uI5GS8jSRM9G3pewbffKoLeVCtd8dor4XBH4os92lxGMbKXGtK16UF25xWME/ihPWTdYtRyA=
X-Received: by 2002:aa7:cb9a:: with SMTP id r26mr26001428edt.78.1627998353103;
 Tue, 03 Aug 2021 06:45:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210802134332.931915241@linuxfoundation.org>
In-Reply-To: <20210802134332.931915241@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 3 Aug 2021 19:15:42 +0530
Message-ID: <CA+G9fYtD2BR2Z0jOs0iRNSeyQartZamF=-eXGZvqqtpzbjNSTQ@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/32] 4.9.278-rc1 review
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

On Mon, 2 Aug 2021 at 19:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.278 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 04 Aug 2021 13:43:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.278-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.9.278-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.9.y
* git commit: f567818b24a32b0562fc2306ffed54821ee69c38
* git describe: v4.9.277-33-gf567818b24a3
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.2=
77-33-gf567818b24a3

## No regressions (compared to v4.9.277-13-gf890c3a34d9b)

## No fixes (compared to v4.9.277-13-gf890c3a34d9b)

## Test result summary
 total: 63809, pass: 49610, fail: 616, skip: 11807, xfail: 1776,

## Build Summary
* arm: 97 total, 97 passed, 0 failed
* arm64: 24 total, 24 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 14 total, 14 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 36 total, 36 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 14 total, 14 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
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
