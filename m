Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 014EE3A1061
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 12:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234054AbhFIJnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 05:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234022AbhFIJnd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 05:43:33 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD10BC061574
        for <stable@vger.kernel.org>; Wed,  9 Jun 2021 02:41:38 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id c9so16036873wrt.5
        for <stable@vger.kernel.org>; Wed, 09 Jun 2021 02:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0u3BrvPxE9s9HtqXoZQg3VN+cykvyMWbYmKSqX4pbHg=;
        b=s+64Z6Gpv7DQwEceBpkLHjHhWaPoYLquOI7iG5TYM5SY9xEur9PBEtxG0o98MKSgHS
         KDTfaEbHBlibRaMmVjfbNIiT0o4WRz0/LST+2xC2LPoaWHwL3KmB1RqKpP+wlkiYIHFg
         NUum1Dueq9RhJj0rNDzXFpzhUandKBzbhHBZj/eg4Xr6Bd1ANk7AonLQWv8YJv7rFQiO
         QhNnSGASVPzEtn124nBPaued+yErK73mbd8BtWy0TOpkPYFsr3ElaEbo3kLkzCqvM9ln
         cnHy6zioGmn1XqUMcCknqHCdVgp9pmc1wexl+2dof5m8ZToI8qDX8DbDA1JNHQ7vxaEv
         2gRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0u3BrvPxE9s9HtqXoZQg3VN+cykvyMWbYmKSqX4pbHg=;
        b=PFndvxGk7sesONUwG5hZ5ORUQX1Ktj4cbfW4QeweJgj/Fw5Ni24G/Ic24LL8Mq2m8o
         iotp8MHsEEeQlFbKiH7eFgbi3WaG+VTUh1lTthsIU/Ek2bx5C0tWrEvfvcAgvdYCj/sR
         Nc+asXZIrIwViNR+mM4+YqjmLu9kaEO8FSZ1MO0sMrJ3wjXliMrugZpEhfkcK3Iq3cIc
         VW5rLFeP2hUQ7OwGfqt/YSS+orl42vOigRgcpaW4BvrsBxVfcuvKufPaOr4xzMqFpcaP
         GLV7/iIofSCpB+euokHc4kySuo0vT8795yWEFUe1ZTDA5eOLLBfhInaXrKAZ5UCyBaav
         kJbg==
X-Gm-Message-State: AOAM531S9o0oFJMvDgOhwn/VgvFetYLiGSt258eLoXFsJuRSEUUWe87I
        xizDZb6XEAL08ZiRZhw/w+vXh6Xl+hguGAud6Q8kQy5BKQK8NGjx
X-Google-Smtp-Source: ABdhPJwcH3d9z/vd/7ZJawn3fwpFwXjmKvddp2MTRi1OIjgMqVJGRZ3Rw6JU8/3DB9wp6TQNM9k3GZRW5BiQtD2q/hI=
X-Received: by 2002:a17:906:d0da:: with SMTP id bq26mr28634584ejb.287.1623231289580;
 Wed, 09 Jun 2021 02:34:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210608175942.377073879@linuxfoundation.org>
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 9 Jun 2021 15:04:38 +0530
Message-ID: <CA+G9fYvWErw2G7ngP5gB3WReB9TjJj+SxHbeZyaTgb1=7CtiuQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/137] 5.10.43-rc1 review
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

On Wed, 9 Jun 2021 at 00:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.43 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Jun 2021 17:59:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.43-rc1.gz
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
* kernel: 5.10.43-rc1
* git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git',
'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
* git branch: linux-5.10.y
* git commit: c108263eaf06733c15c23cb4fdf83d188c0e2881
* git describe: v5.10.42-138-gc108263eaf06
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.42-138-gc108263eaf06

## No regressions (compared to v5.10.42)

## No fixes (compared to v5.10.42)


## Test result summary
 total: 79560, pass: 65027, fail: 2540, skip: 11224, xfail: 769,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 193 total, 193 passed, 0 failed
* arm64: 27 total, 27 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 26 total, 26 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 42 total, 42 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 18 total, 18 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 27 total, 27 passed, 0 failed

## Test suites summary
* fwts
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
* kselftest-vsyscall-mode-native-
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
