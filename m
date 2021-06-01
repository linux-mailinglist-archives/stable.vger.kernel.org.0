Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD5E397438
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 15:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbhFANcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 09:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233938AbhFANcT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 09:32:19 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E54C06174A
        for <stable@vger.kernel.org>; Tue,  1 Jun 2021 06:30:38 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id c10so478927eja.11
        for <stable@vger.kernel.org>; Tue, 01 Jun 2021 06:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kKOh4wrNyJe362NzAi1yzZCGJgSv/lcLZ6R5aT0OAQE=;
        b=oli0AEGTibHr+X4BBq6ryNZ6kU6+VTDFuoYIpRqB62OJRMQPVRJKaYesaAqA07M4EM
         EdbvchSzKuzv0e22u0bfHBN5cMcR3lPKE+rBI6lCeHJTYRNtBeX8ZRc+QpiZzReF7DL5
         gCrikxlDOKXZrjcaPJNbpuVmjS9YxDBGVJ9vDyjYFX0prY0IXvzDHp/Lclf2WS+oAaRx
         u+mPeMNB0zAngRuTxcBw8A+Iro+ieWOou+tu6BWsSwox08tRHNVXiaQ0j8qGTPUdCqVv
         X1PnI5INMdch0RywVA3kNZ7+TzygZktxeqrqJ0gc9atCIiLLcojQPHrLH7bH/YONKGo8
         /LWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kKOh4wrNyJe362NzAi1yzZCGJgSv/lcLZ6R5aT0OAQE=;
        b=i4Q7qzGUu+/yfvotE10T8C6R/OSuTxSOC1ULsgOPplkgsrGAp1o+rI7e2pbilxdG5g
         x68AC3tPHKxkDywNXtEdB58Jz+SASYrV2ThT1bID30Lk0Dy6Y09XoAZWbyvZcrMHE2hy
         rMHWJeTq5egUOciy6gIlRVoP9Qm6oOaQ6wuSdxYQUMyKUh4uQLgRBy5WPKl+OANvlnsW
         898DM5enuRX4gEyN/qlHyPSPf5jy/wNpIKjKKBXrsMGJenxR3KeADM2kFADduCg6zk0w
         H5WdpzyBYaSM+8vv2a/ecg3DhXAJsBeS+wkWsacU7JCHWE2n45PlYSNr1LJOlhGLUhAC
         GuTQ==
X-Gm-Message-State: AOAM531uZf3u0cceVvmnYQkNJZQ8onUHAMjkfcoP6RW/xcLCNEnElK0j
        mnz3WCzAOAWqLpwU0iyHDg0S9y7DtEVDh4nwhPh7NA==
X-Google-Smtp-Source: ABdhPJz7rEw5+UuX6nNDwDbflC7I8zzwHvfk2Ad0RKiQ0Uw6pCAFxoyqfG9E6wADau5iuq+9j0y7qHlzZuEYbWu9GyI=
X-Received: by 2002:a17:906:8394:: with SMTP id p20mr26473972ejx.170.1622554236515;
 Tue, 01 Jun 2021 06:30:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210601072913.387837810@linuxfoundation.org>
In-Reply-To: <20210601072913.387837810@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 1 Jun 2021 19:00:25 +0530
Message-ID: <CA+G9fYtaDQWR9ir0QX9R-n_+G+8n8p0LnuoBbo6fsxFQK8j9MA@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/84] 4.14.235-rc2 review
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

On Tue, 1 Jun 2021 at 14:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.235 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 03 Jun 2021 07:28:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.235-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

This set of results are from 4.14.235-rc2.

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.235-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.14.y
* git commit: 709fde45859bbcf6ad058f7f29761df9adfc26b4
* git describe: v4.14.234-85-g709fde45859b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.234-85-g709fde45859b

## No regressions (compared to v4.14.233-38-g535f9ea88cc8)

## Fixes (compared to v4.14.233-38-g535f9ea88cc8)
* ltp-mm-tests
  - ksm03
  - ksm03_1

NOTE: The LTP test suite upgraded to latest release version LTP 20210524.

## Test result summary
 total: 64130, pass: 51268, fail: 1497, skip: 10559, xfail: 806,

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
