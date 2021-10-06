Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDAD042385B
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 08:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237332AbhJFGxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 02:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbhJFGxu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 02:53:50 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADB5C06174E
        for <stable@vger.kernel.org>; Tue,  5 Oct 2021 23:51:58 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id b8so5954792edk.2
        for <stable@vger.kernel.org>; Tue, 05 Oct 2021 23:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=F5MlL7aa9V9SQKA0yy2JIPNneUruJSM8OKi/Btkdfhk=;
        b=YypW2bkn9zqkz6q/b0vu98l2xi0pOgzjdESrjyF4r2lBbN+zey7L7eZaqB0fmC1Ows
         RJGc7OwNFFYQsZmxB3Rjde/ewoNa5cTDqLnbfvpQ3xisAipxLeyiUbLBxWXgMo2uAOJ/
         lMwREusbVEXriIjnmtdb+mBb+o0/4kLZMYBtehW5mhdV/ej5ie8oAhIYPreBFLv3vzK9
         j7rB8Noq2poA/9jOfFMSVcwai3Fp5vYf5XMiepXtwB3+9XuK51SM1ZgvrE3I0b5R7sis
         G4kJwfC0pPjCU4A5+Edqc5T7ElDCKfwgIImgnYOVO+6VNU/untDflRKPI3vqnmUqK6sU
         8X6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=F5MlL7aa9V9SQKA0yy2JIPNneUruJSM8OKi/Btkdfhk=;
        b=W8El4EmWNG8d+VHKjxR64/JYDnWfz7x2crwSwedKqqz3qykQhPIV4Z1hKTXaJ1QNXz
         KfTSITZ/RTmiwFWd4rSMFMmhfZ4RcqGpxSffTO876YPLidDKdUtXI0eSvZ5OG1hP77C9
         8FV3vvPx/oCktd7Wgf3xEsZqTgtmDoatdjyBzGC6s6u7FtFz77tj1CQbd0ueYB7J8hTb
         QWzhd/apeSlg3oZfeSFSBGHcC8QKuKi7BfUWqHZuUo82qcr1jFhepML54lk9vLerHlHd
         9110Sb5Jg89ttVx+FkHXd1nLhcj67MtUnyyzURXzTIjQEdtLuyeIjTUzX58R8EoCwwHv
         nmig==
X-Gm-Message-State: AOAM53234CLo0+Y0WbcNSN1u1KCpTnhTgOHFBLRRPNAzaWlC+xRC5YEw
        N0d/GD1TXTYGSmYNs9naNLNO+b9sdxFjb1WSGVnd1Q==
X-Google-Smtp-Source: ABdhPJxYidtZmrZoIHsrMwpd2mnKmQnLP2RvNBEEOg0CM7ChDAIYy4Ixd/iAU+mf3ocYKcITOgzZQvIt47giAV8thl0=
X-Received: by 2002:a17:906:c7c1:: with SMTP id dc1mr31737145ejb.6.1633503116005;
 Tue, 05 Oct 2021 23:51:56 -0700 (PDT)
MIME-Version: 1.0
References: <20211005083256.183739807@linuxfoundation.org>
In-Reply-To: <20211005083256.183739807@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 6 Oct 2021 12:21:44 +0530
Message-ID: <CA+G9fYtJFM4FG9VMNsk2uQkBdBzGLik-+10M7J7-B69_MAAF_w@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/53] 5.4.151-rc2 review
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

On Tue, 5 Oct 2021 at 14:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.151 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.151-rc2.gz
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
* kernel: 5.4.151-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: f7188f3f8d712443cf29de94ef1b644d2cfc5692
* git describe: v5.4.150-54-gf7188f3f8d71
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
50-54-gf7188f3f8d71

## No regressions (compared to v5.4.150-57-g86031298ba66)

## No fixes (compared to v5.4.150-57-g86031298ba66)

## Test result summary
total: 83333, pass: 68064, fail: 663, skip: 13037, xfail: 1569

## Build Summary
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 1 total, 1 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-arm64
* kselftest-arm64/arm64.btitest.bti_c_func
* kselftest-arm64/arm64.btitest.bti_j_func
* kselftest-arm64/arm64.btitest.bti_jc_func
* kselftest-arm64/arm64.btitest.bti_none_func
* kselftest-arm64/arm64.btitest.nohint_func
* kselftest-arm64/arm64.btitest.paciasp_func
* kselftest-arm64/arm64.nobtitest.bti_c_func
* kselftest-arm64/arm64.nobtitest.bti_j_func
* kselftest-arm64/arm64.nobtitest.bti_jc_func
* kselftest-arm64/arm64.nobtitest.bti_none_func
* kselftest-arm64/arm64.nobtitest.nohint_func
* kselftest-arm64/arm64.nobtitest.paciasp_func
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
* libgpiod
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
