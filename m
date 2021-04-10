Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A9435ABA4
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 09:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbhDJH1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 03:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhDJH1k (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 03:27:40 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA288C061762
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 00:27:25 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id g17so8307853edm.6
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 00:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9t4IRZ/xinBCPXe8QPt8b+U2YfiOvj3rWWbVkVl9T04=;
        b=myAq0fm9w1xMepaESeemquQQy91gZRs5y3tN5CYWCGP7+xereCOGhNa9ayLd7u9rhx
         9w8GQ2LyefMz5tzQR7PsSb9bxn3EWGc/XqTo0nKxVlCebOHrHjJ4ZYdqylY0PVnx02TP
         aQLNIYGRasdkFKRv3xVMTM7NgZNH2TTzKCRDQqPs9P4WNvk3/UMprehVAZuS1kZOK+Ss
         GN5COX34xeTpToZLLMFvY8oKpNN/xmzQ5fvD4yOTTYZQ4zV+MDrfVfrD4DGyM86B+T3m
         nqPy46qKt4JcXWWC2uvXythgpwJ0nTD2YjPf1wZyxJRj1l/ltu0NjL4JRW5NCSG0crci
         BGVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9t4IRZ/xinBCPXe8QPt8b+U2YfiOvj3rWWbVkVl9T04=;
        b=L+IP0nfaHqM/u+6059QNbq3HlGXx/VQJgMAT7srQN8lOJVy/DiKVebZelr+3hWUCj9
         1B68rHVQq66hgWT7Ad+5Ew2y1YpJeOKnpzZskZyuMJ4v9AULmA2WXCQiD8MhN8vtsaMv
         QK8hRkZ3yH8COw33dqBk+V8iXEEaojZanrTOP9zOF09IapaUonDbgPNBnum7tzqgiT9C
         lUmY+e44Groo8Ev6wSqTNhBh2SXVuvZ1EAiSHGK4MPo0F1LnIgC5ygWZfqiK//gyV9Hh
         8R3UQU9qVlij/1NWxAysUtKSd5Rc+yvJzWsen8kSzSoEQSbkCzM4+fhoEYBqZ/k4FEzG
         saOQ==
X-Gm-Message-State: AOAM533bgxr6Bwo1hUyMPsXJchXhRVx0tYSXXNg83W0dsdKy8undyhd8
        pByKIR3/eZuEtnP67xeLvYj15zsh8s0kuU2aVtwXSg==
X-Google-Smtp-Source: ABdhPJwTilbpJpSK2NjPnCOgu3sFXGOexK40ZrbjnpEB9hu/CPBECSOySJ/eeP6qL/hw/wsB4aUYzPt0r5D2Oa/FhAg=
X-Received: by 2002:a50:eb92:: with SMTP id y18mr12874227edr.230.1618039644471;
 Sat, 10 Apr 2021 00:27:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210409095302.894568462@linuxfoundation.org>
In-Reply-To: <20210409095302.894568462@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 10 Apr 2021 12:57:13 +0530
Message-ID: <CA+G9fYs_RpXGYk4fscy-R-Nk6C3KyhiVD_J=pgA+3jQmSwdejA@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/23] 5.4.111-rc1 review
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

On Fri, 9 Apr 2021 at 15:29, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.111 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 11 Apr 2021 09:52:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.111-rc1.gz
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

## Build
* kernel: 5.4.111-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: 9b00696cdc423c6b92ee4d7cea65858137f8456f
* git describe: v5.4.110-24-g9b00696cdc42
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
10-24-g9b00696cdc42

## No regressions (compared to v5.4.110)

## No fixes (compared to v5.4.110)

## Test result summary
 total: 66085, pass: 54986, fail: 899, skip: 9988, xfail: 212,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 191 total, 190 passed, 1 failed
* arm64: 25 total, 25 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 14 total, 13 passed, 1 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 25 total, 25 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
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
* perf
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
