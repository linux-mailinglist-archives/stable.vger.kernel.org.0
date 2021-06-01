Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83EDA397072
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 11:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbhFAJe2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 05:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233237AbhFAJe2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 05:34:28 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB57BC061574
        for <stable@vger.kernel.org>; Tue,  1 Jun 2021 02:32:46 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id dg27so6718194edb.12
        for <stable@vger.kernel.org>; Tue, 01 Jun 2021 02:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fHw4ZWuyvNTlnwaFaZfgex/OMd+zKnx4/Agz2TtONeQ=;
        b=yv6feGYELgn+8OwtbsI4GmssW+drxxCPt++Ja6yrHXEFAF+WbUSdU9Ra3Qr2a4OOtw
         yXwyiJTEB5IJGpCaJcJdvRI37wgd8PLtSXblBnx3oLZM3G4rytLXF064aa/Y2DwbDNZB
         vnRQEL1yZOEyL5w+a3RtzT1XYqEXRR6Y1gYETZiQubnGCVPUfe9Ha+O+B+bJTSioSKhG
         ZJJRCnDpLxbks8XvUkxoBeprp9cHS1VRBF2p/6AHsA7cd46YuRqNRvAYJ93LYjmS2tpe
         Wr3HjHU3oiER7B1B1RhdV5O6KserwGyLBRZ3By121ftBFAmvaHwjInLaq6KP8AOuHdka
         emng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fHw4ZWuyvNTlnwaFaZfgex/OMd+zKnx4/Agz2TtONeQ=;
        b=WBqD5m/Y2LNLt7J4lDaMIN/RL3KQrdgoUv56w16l/Ku4W2Utm9RZYwu4/dFQ7yv1r0
         Hbd2JGxChOvKGElqVIdoKQMq1NCsVwO2vQ7zF/Uaoohd+h+C0Pj1dudN02/liRE2XJMs
         9VqoH/tAHmVGYjFQZJbQciTU4qfLSXNiLI6y9IXECFoOGxbaWtYGuEHu6TA5cjMaeoFR
         YZq2mfqwFcqE0wAJU2ehGoYOGn8/KCeD5nADeKwW5eRU8Tr0Bjcaw9HdU7y5tJnJMndV
         w83RhyFn8PNOHjKI7lh2JGfoH7eau6DKN6MFce4ZnjLnLLar8Fz+j1o+jeKlqqio0cp0
         zLEQ==
X-Gm-Message-State: AOAM531pyij8DGlLk5bNZtEm/Zbhgpuwx8jLtipzsNIROAzz5rM6elnS
        7cRrzY9nEp6dbSm0CDqNIK81EXOtAYUK797Lipw11A==
X-Google-Smtp-Source: ABdhPJwbKb2JxZd97XUfBzbSl9OUS1rQtgJuB7iMPIER2LH9Z7Y9/OPCj4J/38ZoIJsrfXqAzwlOZlwOseFw6/ucEi8=
X-Received: by 2002:aa7:d786:: with SMTP id s6mr30590261edq.239.1622539965289;
 Tue, 01 Jun 2021 02:32:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210531130640.131924542@linuxfoundation.org>
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 1 Jun 2021 15:02:32 +0530
Message-ID: <CA+G9fYszhenHuzfsv+yu+JKoSD+r8nNV7z8WXgzBcmu7J3+hoQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/116] 4.19.193-rc1 review
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

On Mon, 31 May 2021 at 18:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.193 release.
> There are 116 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 02 Jun 2021 13:06:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.193-rc1.gz
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
* kernel: 4.19.193-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: a36d9536769615470fb664509e528787a54a26fa
* git describe: v4.19.192-117-ga36d95367696
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.192-117-ga36d95367696

## No regressions (compared to v4.19.191-50-g01268129ebb2)

##  Fixes (compared to v4.19.191-50-g01268129ebb2)
* ltp-mm-tests
  - ksm03
  - ksm03_1

* ltp-syscalls-tests
  - semctl09

NOTE: The LTP test suite upgraded to latest release version LTP 20210524.

## Test result summary
 total: 72900, pass: 57060, fail: 2715, skip: 12247, xfail: 878,

## Build Summary
* arm: 97 total, 97 passed, 0 failed
* arm64: 25 total, 25 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 14 total, 14 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 39 total, 39 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 15 total, 15 passed, 0 failed

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
Naresh Kamboju
https://lkft.linaro.org
