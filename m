Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62470370618
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 09:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhEAHDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 May 2021 03:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhEAHDL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 May 2021 03:03:11 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA481C06174A
        for <stable@vger.kernel.org>; Sat,  1 May 2021 00:02:21 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id n25so587482edr.5
        for <stable@vger.kernel.org>; Sat, 01 May 2021 00:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7t1HzNR855ij8T7x5k0451CO3JLZIe3QNp/FZ15Cs1U=;
        b=SWrtV5pLIYZy15fGJjBouIgbICBER+BO4rUnluslLM10Je5lFJYPuAa0XTdTOrDK/t
         5rmCOfKE9f7ITUrfZxkF9ZEhYATQcGvx3c9pWX7oHG6+pXgP4MLFl4HKuBis/UATmEmy
         U9twE/nEstuODLtC9aNrQpnBh/oTMRYhrBjCy72UYNsMNkKwr3SRz7aewIViED7SnBCa
         weDZ23i85aUtM2ZsFbHJo+0Ln9rnEh6d+FQLs430vz99PAA0n0k0awymU4Agx1+gOdaK
         vA2h6NZsSYrxURC8lQiruwTOV1fax5zlcpriAhI92iQTfKTlXOXcpfka+kub51Zxo4wb
         eE4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7t1HzNR855ij8T7x5k0451CO3JLZIe3QNp/FZ15Cs1U=;
        b=B/jfj40UToJtpce+2UWtPt6rsGbs8odikTbQXXPejPRR1mohgJQs362umHBu8kiFHb
         h3f5rT9vg3JU4HmxgQozxvYkWOOjETWYZPTapItckSYxAC8OqfRa6Lnn2QpttfjfIrhe
         3AXmk4Fx3BGF4afFbfK5TMiTuwEhsa2N2DyJvAzBsRZS8VrWOYHv1dTWVJYFWFRy26at
         QHvAEuE9pIeXY2szYzpAk+NRmr/flYDNcWNSortT4JHiu70OT+AVAAEnAgaUHlW5C795
         soEo5JuvfMMV48AAeWWCEUFloLa1M3r4xgogo47rLoWzZ2Tw5q5XXT/OUfruMZF438pn
         VMHQ==
X-Gm-Message-State: AOAM5315hxXXXozvt3n0k0rRbTCoIHy10hg1/S7ZKPc764pFSDQV5iz1
        CSw8MosnGC1NLQI9LEEkGUvUWT/kBmUFpjay+PLKog==
X-Google-Smtp-Source: ABdhPJwePccsKVeOwmljCCRVdhnIyfyz0MYeSLyQAf3+5gdJk0SBoxGbt/ODKV+W0iS/EvybkzaoKgG3pzErmXtX1uc=
X-Received: by 2002:a05:6402:12d3:: with SMTP id k19mr10074517edx.52.1619852539986;
 Sat, 01 May 2021 00:02:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210430141910.693887691@linuxfoundation.org>
In-Reply-To: <20210430141910.693887691@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 1 May 2021 12:32:08 +0530
Message-ID: <CA+G9fYuMthUeebXT723HZFtt6v4+1Wm3XgYRuPzSkNvSUfT2cw@mail.gmail.com>
Subject: Re: [PATCH 5.11 0/3] 5.11.18-rc1 review
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

On Fri, 30 Apr 2021 at 19:51, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.11.18 release.
> There are 3 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 02 May 2021 14:19:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.11.18-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.11.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.11.18-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.11.y
* git commit: 517c2bbecb70f9804b941c78a3b63d7bcd3e011b
* git describe: v5.11.17-4-g517c2bbecb70
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.11.y/build/v5.11=
.17-4-g517c2bbecb70

## No regressions (compared to v5.11.17)

## No fixes (compared to v5.11.17)

## Test result summary
 total: 77859, pass: 64310, fail: 2171, skip: 11119, xfail: 259,

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
* x86_64: 26 total, 26 passed, 0 failed

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
