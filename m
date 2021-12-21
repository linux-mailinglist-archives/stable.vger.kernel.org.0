Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD9547C4EA
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 18:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbhLURWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 12:22:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240365AbhLURWq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 12:22:46 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F11C061574
        for <stable@vger.kernel.org>; Tue, 21 Dec 2021 09:22:46 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id 131so40785573ybc.7
        for <stable@vger.kernel.org>; Tue, 21 Dec 2021 09:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=R3pCw4gmHP7nbUtLpCJSRrJ6QBuaaSPlAZfdmztAG9M=;
        b=q+pUQswpzxshvmdojEBW/sD4WtIQjhaFUQbYKo5SWFMd8Zb3XglDJm+DELuZgLSYGv
         wlaxyiq8SEOm7/BUfK7ha34aK+TMGJ82rKRwiU8XDUCYCEZ6jtu/VCoQjq00LWh1rKUu
         m1THhz5cFsjKY392VCVc/K0nv81A5gwl7zZnVvWJd/jxY/t/43LaF04BD/TKC4ZUKr1h
         M2MsoXHApCAbZfznd/wFit4vvrY2VFGAw52wNP8Tor6T7TCbOQx/gj6q/Q5FWHRnt4gn
         QTPGCpzXSpir2aFt+u5QllkzynSQGZfu+P5d5CeXEnBJtjBQJoGj7S2dRSMTirUkNsIs
         BXXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=R3pCw4gmHP7nbUtLpCJSRrJ6QBuaaSPlAZfdmztAG9M=;
        b=ZYpd6Mtqidmj9oYq5mNJPKrafuNQCm1rvuvPkQQByXXM14EnACCWIEpBy9uwiZnZGm
         xmlMyajB3cEra/zbQD7ir/VS/kqB4GoQCJgMqExKC8qLUqmMzlZoHqLmBeHzo0E0vn63
         TUgh1P/0mwCjjEeqe3oct8C5841xcdro/TJmOMGTrQW89yX2gCybN0AgA5Pokhy3Ny4E
         l7RmWpKWk2tDtOSsdK6LoPIZ9+vExnZcEV1n/UGnEKZ2noLfejj/5kKHoQAFa6U41+3u
         OIC3AE3BY6HDC/OJdrbqtlFnFxdz5REExZp4IzTQXNd5lkBdOcH3ULkFvWLbX9OdfR4H
         /vpA==
X-Gm-Message-State: AOAM531rT2t6uS3aH/cg0D0t7Gt2VC1pQ2kQdvsWdPWzYLOYtwbuc62e
        F93C09CDHUXj+rfyRMz2seGtEvz7apQN/AL6XctFYx7hANoYwQ==
X-Google-Smtp-Source: ABdhPJxb8QTXqWwUuy1tqHwGZ8h99rMkG0dszNFGCs6GuxiUEBedOLQhW3yuezpECpmK4ZTcYluTK6SVSPx1ZfuhI00=
X-Received: by 2002:a25:d68e:: with SMTP id n136mr6220237ybg.520.1640107365561;
 Tue, 21 Dec 2021 09:22:45 -0800 (PST)
MIME-Version: 1.0
References: <20211220143022.266532675@linuxfoundation.org>
In-Reply-To: <20211220143022.266532675@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Dec 2021 22:52:34 +0530
Message-ID: <CA+G9fYuZo2v6iyVbif40U8PpvsffKMjL2cXV5GjEZ9t9Mrm8og@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/45] 4.14.259-rc1 review
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

On Mon, 20 Dec 2021 at 20:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.259 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.259-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.259-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.14.y
* git commit: 5b3e273408e5c9c7147eaa73e314267fd8e7c830
* git describe: v4.14.258-46-g5b3e273408e5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.258-46-g5b3e273408e5

## No Test Regressions (compared to v4.14.257-54-gcca31a2a7082)

## No Test Fixes (compared to v4.14.257-54-gcca31a2a7082)

## Test result summary
total: 70666, pass: 57051, fail: 606, skip: 11219, xfail: 1790

## Build Summary
* arm: 254 total, 242 passed, 12 failed
* arm64: 32 total, 32 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* powerpc: 52 total, 0 passed, 52 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

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
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
