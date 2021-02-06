Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3EE311DA7
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 15:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbhBFO2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Feb 2021 09:28:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbhBFO2G (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Feb 2021 09:28:06 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A42C06174A
        for <stable@vger.kernel.org>; Sat,  6 Feb 2021 06:27:26 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id s5so12836794edw.8
        for <stable@vger.kernel.org>; Sat, 06 Feb 2021 06:27:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PktqN9cRlLYA052139XgKYF4870sQXKWYd5S3nLH7zE=;
        b=geBJ6ifNaPg2/9JEcup33g2SMk3jUpscz4jU3F5tk1T5UqV8jZrf0yEgbAFhd3Gtz5
         8SrBDjV+qKasj9QA1LjbbJUBsX188R9vMxjyK1EeKmjKlakDdtbgCLRd81FyFIk35YP6
         rcBSD8KJU63VisdRoFUAg5E0saL94kuvP6xTjVIRhXtjfGYg8CMZdm+UEYbM0hCmsK7N
         Qqrk/MrY3SJSdl38pBEMqf+8lDKsq2zWiUbyNe8lQji9AodI+pY6flr9ylPk5e4O3Yl6
         EiwZ00TNvCWlCDNTg3yIaoa3OJ9FtAyB302RZMy7Yvg2LwwIK3a9p7f8gn35f9ZJffE0
         mtPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PktqN9cRlLYA052139XgKYF4870sQXKWYd5S3nLH7zE=;
        b=UxL85+fGmc+TtmZc/dEv5+AVnHP5BQ1pN6eFyDXGNy6b3Qn/Nc31QDTEyqXZxqNffe
         3nZ+57n0awhpgf+bPKwl38kv+nLIwTM+WuErQi6csR+yE0XqAvd2cpuVrRx7SX1M/jpQ
         NzSVY5kJ2YFv/dbnbV21i6HeZM1QSNhI0kGeIWHGiUZhMH5wN3v1HIAFxGaKBdmjJCT5
         eB1Et4mnk4xFA25R07Tsw1UAz3cC2eBId8xzSqEsIXrcO9OlVCzBXyK8J9X8chjKiNF5
         F6GgKmzVRJgwQ9tCYHIBNuiVb3+175UUSsrMZdpPwhgI7J9u8uYHBTwfm3YsfBakbuQh
         7+jg==
X-Gm-Message-State: AOAM530aj2J3jaRFdSMnk15rKywQ8udUrbpoXfVV5eLSTYPr6t3wChS3
        pxIxz97j4PRLX2R1IBWHJbdqQxqPN0jdCEKkV6EnBg==
X-Google-Smtp-Source: ABdhPJx3KUdnhDR6bTAVF131x4DCkslTuPYIK+Kh2NC82mlk/Sgrs+TfBOoAT+tGvjmkH/Ok/+UMngPjLyTVzgm131w=
X-Received: by 2002:a05:6402:702:: with SMTP id w2mr8842358edx.78.1612621644703;
 Sat, 06 Feb 2021 06:27:24 -0800 (PST)
MIME-Version: 1.0
References: <20210205140652.348864025@linuxfoundation.org>
In-Reply-To: <20210205140652.348864025@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 6 Feb 2021 19:57:13 +0530
Message-ID: <CA+G9fYufC-FM6RzeOTbKC_kt5k1krnSoWtvfuiZjiUJnpSiGMQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/32] 5.4.96-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 5 Feb 2021 at 19:43, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.96 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 07 Feb 2021 14:06:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.96-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 5.4.96-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: da7c9d56bab5c4eb00d9d1545fcdc390ce75e001
git describe: v5.4.95-33-gda7c9d56bab5
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.95-33-gda7c9d56bab5

No regressions (compared to build v5.4.95)

No fixes (compared to build v5.4.95)

Ran 45285 total tests in the following environments and test suites.

Environments
--------------
- arc
- arm
- arm64
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- mips
- parisc
- powerpc
- qemu-arm-clang
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu-x86_64-kcsan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- riscv
- s390
- sh
- sparc
- x15
- x86
- x86-kasan
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* install-android-platform-tools-r2600
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
* kselftest-zram
* libhugetlbfs
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
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* fwts
* ltp-sched-tests
* network-basic-tests
* v4l2-compliance
* kselftest-kexec
* kselftest-x86
* kvm-unit-tests
* ltp-open-posix-tests
* rcutorture
* kselftest-
* kselftest-vm
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
