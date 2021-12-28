Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47444808BE
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 12:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233991AbhL1LTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 06:19:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbhL1LTi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 06:19:38 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0CBC061574
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 03:19:38 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id 139so21277819ybd.3
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 03:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=V3v9cF6xHQZX39nYu8ym/1C1zcFj73ZTgDK4RjL32ms=;
        b=gnl36jDJR9soGWjIofVVra+AwEO0DbUyq2sf8gv5WVRGOft2Jn+fQPXax0RKXDDekb
         R575e8/Ps0nawi/CjHnuPG5MTZ5/BPSNynwsEsZl+QjBGx4mNBjD1m60y9Vo4ZExKcdx
         oV3mL9stk5vodNV5vdeQjbrESjIwCF0ZDnCTQ3rKZ+B/t77OtxIOPPNMOaz7FaQ4f+cG
         AxM8A7uqYF1fwLnTIT1Ab2N4cbe1OlD9Bpl7IlFXwoYcHjeVjjR0AFcBR1xnoMP/YjOx
         E5rbSJKDCrOraUDrxwrNk2oDuA0YvRa+pfdouE4Fl304uP8PSHdK5DqdykUZPuylec3c
         M5PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=V3v9cF6xHQZX39nYu8ym/1C1zcFj73ZTgDK4RjL32ms=;
        b=sDnI6mCWEL6JHbUkbSqYBJop1wzL/0+fvNTl2ZJxyrvPWJ5mZYtWu2xUETFrTPrc3p
         DwvyDAJOaQshB6StvyySXypHD36zZg+oKAbbzuBe3Nbc6zLZJmpfBXm4p6uwPVttLI7t
         nlG6885GyBLI+Ul4DL2ozCrLuwQL4YeYYA81ziq6nzYQiZBkHOYje8b88gF3pcP3sAjm
         r+nPtog6zknBOQeHv+PQ5LLm+C+8p9iTXMYM5j+Mw1JE2p9JnNxPOhyCnajMQ4VJHXno
         JBbx0lPO8VMWSFCIUaiIvzGerE9M6O12ZUs6SuEmMKRqW1iZlkBw3ZDAc3EfJPSrTVia
         zxhQ==
X-Gm-Message-State: AOAM530f4t+EjHLaBRJIbuI8QLalco90bY7kZAK0p/W1RY2SFyaRcyQ1
        TfJSg5KbdfeecEU2HOaOUC9AxKQyzFvwRrXD+8LrhQ==
X-Google-Smtp-Source: ABdhPJz+b7fJHueVaZA5rcxp8xzv5wy9X9DBv+Vy2D9Cer/VGWidIbYCrcCeAbU16InT8KuffmzrvLugRbzgydWDzz4=
X-Received: by 2002:a25:ae85:: with SMTP id b5mr14098587ybj.200.1640690377571;
 Tue, 28 Dec 2021 03:19:37 -0800 (PST)
MIME-Version: 1.0
References: <20211227151319.379265346@linuxfoundation.org>
In-Reply-To: <20211227151319.379265346@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 28 Dec 2021 16:49:26 +0530
Message-ID: <CA+G9fYuMGvFR4hq6KLJrj4tA-6R+H2xfUybAJuDOCnXg7eKX7w@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/38] 4.19.223-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 27 Dec 2021 at 21:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.223 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 29 Dec 2021 15:13:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.223-rc1.gz
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
* kernel: 4.19.223-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: c3b6f5a58bb324123904facb3806b3bcc00bdccb
* git describe: v4.19.222-39-gc3b6f5a58bb3
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.222-39-gc3b6f5a58bb3

## No Test Regressions (compared to v4.19.222)

## No Test Fixes (compared to v4.19.222)

## Test result summary
total: 84075, pass: 68731, fail: 620, skip: 12910, xfail: 1814

## Build Summary
* arm: 254 total, 246 passed, 8 failed
* arm64: 35 total, 35 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 26 total, 26 passed, 0 failed
* powerpc: 52 total, 48 passed, 4 failed
* s390: 12 total, 12 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 34 total, 34 passed, 0 failed

## Test suites summary
* fwts
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
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
