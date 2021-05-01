Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A4837063E
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 09:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhEAHrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 May 2021 03:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhEAHrC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 May 2021 03:47:02 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DABCC06174A
        for <stable@vger.kernel.org>; Sat,  1 May 2021 00:46:13 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id e7so633119edu.10
        for <stable@vger.kernel.org>; Sat, 01 May 2021 00:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=p8T708C5DjNrPFEpb0TPBJzVht0PGsjLXnkGrmBOKFE=;
        b=rCEwJqelJgn14DUrzXBJrQl7us2HqjPx0Je7BzXsoz3ZdP731Gg6lbqWuFgFtvnVku
         VSHec+znd2qrVzDJh4hpQA74g5s22M4o/571/tJzOTo9Yf1UNZtYRWkyNTIni+ll8wG/
         J7fA2lXOflyle46YJ+OAMsV0A1U6tPHZu5MXUj2d72skyw+8YPNZAksUwFxYB8X3Q2j2
         LdSWSbp63YHNvFFxOERSOnDaYd3Rfz0H3N2anWL2+U98q0ZVEta5G/HKsgx1GIfTERAO
         u5WuLPkqSKkYUtj2T3Duodhe064yy8dY7RG57ix1bb8UnQvUkJOADjff81ZStrSGrs76
         jiew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=p8T708C5DjNrPFEpb0TPBJzVht0PGsjLXnkGrmBOKFE=;
        b=YgKukN0cogKqRjQJd/vS3dSd1vbC5IBNgc/96EG/nMy5KyHYaS2WEh1Dv7SAsBLBU/
         63RkjLnDV+yhg3k2Lb+0P8YlRd74Gnj6W+Z/QW3fGrUwx/DU/lLbAfcYp0wy1AQYoGJj
         bP9MQZVs8ENHE+TZyPxTV2ZeAtMayFW2DNfx3MH43mi6kuelx2fx8KdgEDTctlrZ1kCk
         JD0AgZZiCxiqSH/vOi0omM5x9l9RPw2lCD+EJ1Na/VVB8bYJyNtzT2YYehUdUR0WXSVY
         POsrf6qyrTY7kXQ5cenEUKu8qWhD6ssuKlCt0sjz239NfMAH9D2MIXdbkNrM/DXYFS2Q
         m0Tg==
X-Gm-Message-State: AOAM531IvW82zTd44QnYXD1lg/tsW8q0fllnuQPilfM34iRiCeACPDd0
        Qj+TfY7axfSfWatI1RY7KPxyJaRcJGH0/Ird0ECpEtcGPtpvGMZs
X-Google-Smtp-Source: ABdhPJzlNaZRGMQg9fy6oiwy2jCs7adAj8fa5NZWFJQMrlOeNmzsNgPioljt3BWaNr+1mC9KzXTT8hEHuX1G5UWVnew=
X-Received: by 2002:a05:6402:145:: with SMTP id s5mr10060295edu.221.1619855171618;
 Sat, 01 May 2021 00:46:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210430141910.473289618@linuxfoundation.org>
In-Reply-To: <20210430141910.473289618@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 1 May 2021 13:15:59 +0530
Message-ID: <CA+G9fYt=R7TJT7jM2LhxSNaakAUtJZr5X2q9S6goNes5eJ0Y_Q@mail.gmail.com>
Subject: Re: [PATCH 5.10 0/2] 5.10.34-rc1 review
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

On Fri, 30 Apr 2021 at 19:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.34 release.
> There are 2 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 02 May 2021 14:19:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.34-rc1.gz
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
* kernel: 5.10.34-rc1
* git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
* git branch: linux-5.10.y
* git commit: 9fe3189f108d04763059a2dc87e213f4e2064ec6
* git describe: v5.10.33-3-g9fe3189f108d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.33-3-g9fe3189f108d

## No regressions (compared to v5.10.33)

## No Fixes (compared to v5.10.33)

## Test result summary
 total: 78188, pass: 63866, fail: 3046, skip: 11021, xfail: 255,

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
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 27 total, 26 passed, 1 failed

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
