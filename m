Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC6053AAA98
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 06:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbhFQE7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 00:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbhFQE7e (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Jun 2021 00:59:34 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC731C061574
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 21:57:25 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id c7so1164586edn.6
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 21:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fJto5u8DmQctcTcV4LE+sFMY4MOz8SZ9HZwCgsAenCw=;
        b=WoYI+XXmLfQOGBc2qkRm5AjyqZj7Z8hjaH6BHifaRL+Buph+dalrksII11s40Uof//
         eAxWwnioKuc/a1rF/j4JHgZFUkkJ2eHrS51uhHBPBEo++9878Ph5MjPWum2iFwIKWgWI
         s7b8anPIMvy4VPKqIJwhG6aUESS2z9vpRJKLKT+FONVh9/y6sw5IxeCN8nifJ4FP9fWu
         hVQRShSXVbRuZFiHx8TUSwEPfzQa6UlXweuhRRzxNYgT97cGHJEbjKHKIMYX4WwbVoa6
         rNBPMS5/iu2+/fPbWnHHI/4pq7X59LZMcbTW6D1Cc0GGk6WLD7tpSbLL00+kfVnWGWjz
         r8sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fJto5u8DmQctcTcV4LE+sFMY4MOz8SZ9HZwCgsAenCw=;
        b=NWrjb5U3Klr4NZrJv+VPnQiISaqfw0iiRs1eBYQy3FI1P+ZrLq1Bu3IvejAeMSR4Xe
         +0R715Zn2fhtRQ9gXNYb/24bcPomLL7cvgx+oHhsVcGQPYv1ePI464yC3v6FFrNr1pdb
         gN9QTQXVYS6oCPmSoOOE52s+WOpxf5jQOmrsRu6kjtdyolWI8gKozEX3S6BN+ff0B/jw
         kp6ujtVW04xW9tRZcj+0s0YqXgwusWrbH9bzffYXv5/5dy1CpfoviP6kM17pVN2STRCA
         mEQ1aYgBd0Z3VDNGiY5MH8dTRIJrnxc+ywGsdR06I13B82waG5HmYF3ly/eTB61bC6ug
         Sd0A==
X-Gm-Message-State: AOAM530ImGX6TKkrmg5DoY0pHPKFHCLvCuf/poOggzGJPV6wnlq1p0NX
        +BxLRHZHH0pnuSQFNh97BylHL3TvW5OYHkBwwADFViNK7VJX2nEc
X-Google-Smtp-Source: ABdhPJzFkJSsGF+nwSDua+klS/0qR8fCRLMoV0BKYLKe1ndmAjYRssChGJYPrBXXt+t+6nD5GxpHUpiRRG9mUbzzJBg=
X-Received: by 2002:a05:6402:22fa:: with SMTP id dn26mr3862100edb.230.1623905844130;
 Wed, 16 Jun 2021 21:57:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210616152836.655643420@linuxfoundation.org>
In-Reply-To: <20210616152836.655643420@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 17 Jun 2021 10:27:12 +0530
Message-ID: <CA+G9fYsVgpgjjw+VQbdKEO=DugwnSNAydQKMqHO+i_QRTy9sEw@mail.gmail.com>
Subject: Re: [PATCH 5.12 00/48] 5.12.12-rc1 review
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

On Wed, 16 Jun 2021 at 21:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.12.12 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 18 Jun 2021 15:28:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.12.12-rc1.gz
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
* kernel: 5.12.12-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.12.y
* git commit: 3197a891c08a4cf4c9300437e2747af3d5cb55e2
* git describe: v5.12.11-49-g3197a891c08a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.12.y/build/v5.12=
.11-49-g3197a891c08a

## No regressions (compared to v5.12.10-174-g38004b22b0ae)

## No fixes (compared to v5.12.10-174-g38004b22b0ae)

## Test result summary
 total: 87611, pass: 70968, fail: 3383, skip: 12489, xfail: 771,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 193 total, 193 passed, 0 failed
* arm64: 27 total, 27 passed, 0 failed
* dragonboard-410c: 2 total, 2 passed, 0 failed
* hi6220-hikey: 2 total, 2 passed, 0 failed
* i386: 27 total, 27 passed, 0 failed
* juno-r2: 2 total, 2 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 2 total, 0 passed, 2 failed
* x86: 2 total, 2 passed, 0 failed
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
