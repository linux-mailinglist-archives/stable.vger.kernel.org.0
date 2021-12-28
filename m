Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4E92480C02
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 18:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236730AbhL1RQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 12:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236729AbhL1RQp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 12:16:45 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F86C061574
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 09:16:45 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id d201so31851183ybc.7
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 09:16:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fBHTW9XyDZXFQTZHLhPeVNuKnCi/t7jrqDsu56FRMsI=;
        b=oQdxw9uCiZI1f9XR0jhQtCsIGRHlivms0kEHx9r2Z6A4bO0fMXXAypfHDds8Hs2TON
         vhdeAiUNU1Z1UoQlYVK7hyMaZh93NR82lB8+AjIyvfVw80SN1wavExyzrsrXWx6P1iFd
         HaFB17sz0pXhFBbY3HdUe8dMT0T43zxeQAalSEAnMyVZrGWNu9GsbzVYcjPeSw9uVune
         KzjVOPXxXhV4j7VmF5MA2XxEZKKFas6ZCVvKUezZdhXGhMQWTZjtx3dxmSuaqhxPfSk6
         Kw220Uxtv/dWzGbfyLfpa83EQqlw7/cIKSSXYKGv6BynLiq6ISLuNtQP2rymsPjqZO1e
         Vgcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fBHTW9XyDZXFQTZHLhPeVNuKnCi/t7jrqDsu56FRMsI=;
        b=cBMSe4YjYYwKsI+0Xjg4CqfAT14pmY+BzWfUmoF+AJ7NfmX+MefNfw0ZMg5hAYKLDv
         0zZXqFfmGgEzwb9/8zIt7XCNxXXTViGXf8kO78cXD0ncq/nu65YFzWNOj4AoUXlo7qTK
         UUO7iZNFiClKGsbPDkk06yDjsRRMbPoPp5cabjXjm+6bMl2DsHm7mQQxiIB91cvigCGG
         nVNKbeLVe02gN3mVLdUn/YkgZuapfjs887EX2UqPxVDamrqaw9GUIbuundHwcsp8las8
         OBZuQ4zfXVeidtc08Q2aqmsbQdMaYu3TkDtSMD7zmgwxCbFx5hOAMl4tjGq/Ut6z/ett
         oFtw==
X-Gm-Message-State: AOAM533jn+UkHhLuvvQkd+xecZYyoBUk+HQroBW73Zpy9IKF+S/UopV1
        kzQzL3/9uLcGH63YBiECdfZss5wFue/C5vVDDEVECw==
X-Google-Smtp-Source: ABdhPJw9cyzzM4kTxprbFeBNuMjlt+eVpcblsFiUQ3a9QG2eNANrna1V24TNx2nk8//76Oqa9vx8J/26+LQrVjTB0ss=
X-Received: by 2002:a25:300b:: with SMTP id w11mr29628188ybw.108.1640711804281;
 Tue, 28 Dec 2021 09:16:44 -0800 (PST)
MIME-Version: 1.0
References: <20211227151315.962187770@linuxfoundation.org>
In-Reply-To: <20211227151315.962187770@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 28 Dec 2021 22:46:33 +0530
Message-ID: <CA+G9fYtsPxNJfUJeNreUi8VhMgqXYAWcC18NxydPsWeBn=7P4A@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/17] 4.4.297-rc1 review
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

On Mon, 27 Dec 2021 at 20:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.297 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 29 Dec 2021 15:13:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.297-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.4.297-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.4.y
* git commit: ea28db322a98fc90032bea9e517d2beec25bf5b6
* git describe: v4.4.296-18-gea28db322a98
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.y/build/v4.4.2=
96-18-gea28db322a98

## No Test Regressions (compared to v4.4.296)

## No Test Fixes (compared to v4.4.296)

## Test result summary
total: 46781, pass: 37737, fail: 196, skip: 7823, xfail: 1025

## Build Summary
* arm: 129 total, 129 passed, 0 failed
* arm64: 31 total, 31 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 30 total, 24 passed, 6 failed

## Test suites summary
* fwts
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
* kselftest-membarrier
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
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
