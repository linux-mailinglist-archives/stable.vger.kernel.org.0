Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A284453F57
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 05:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbhKQETU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 23:19:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbhKQETT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 23:19:19 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB874C061570
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 20:16:21 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id g14so4810765edz.2
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 20:16:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YeOQj1V46ExROESTAfziUepvMUXb43v48ZSMfpexbsQ=;
        b=P5G6Lt8z9SHeVxA6xpZ6KJaUIYVIHVY8atXsNLE0AiDoWWJGh4NGjSJOHd4shp9LAf
         bT0EypucASBbxqF3t0zffaTo8CVq7mDdT7VdkGUdQtTOI2t7zeF5QK8gBJo9WISbw7+n
         GQH+PVvzbk8+7CUWhLAbpQIhQaF5DMr9ej6NLHLNY31S8cwnqAmc1SFRAPDSuwbXRawu
         OAQQK+TXyxHvLDMs4VNL0VpPmrOGRtb1hU/1bYK5wsY4A6hJygiz45XqXDYi05/eK7//
         DWMG0VohhLVCMgwkH0V3ifksTG/x5UWMWavWOBF5BBqHV5LJigyrvo0TkT8PFHec5WIr
         Lxrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YeOQj1V46ExROESTAfziUepvMUXb43v48ZSMfpexbsQ=;
        b=4L9lrDHiB8MfnJwzcIjH6kIgjIvqUeXpFkxP9jUTpxyVJm2oHxqoezwEuVZ28zcCmY
         srKtzNLyLlgkzbZocsYR+NsaF/253IsI4gdpA+GR9vQ3b2VoPcbOP2rwsrb1TQO0DkDV
         99kcKXb+PlsEWsdFsqg94qr94zc9luSZ+vuexkHgImIImweOXCO4ezTQNn4Kl1J/9yyZ
         lOXN2LBSv/gf+bgA7zCbl7tb02jnYQy1TfFJHwiD+9npbLGy/oSnGtV7RVgGvBS4c5PR
         oDTZ0bcc0R1Ts2Ay7ULYVdrWpOCDp020H7PrtC5xxdxJaiqTNFbSTR7UfM7o69wgAOd7
         418g==
X-Gm-Message-State: AOAM530rOu+PVxIFN4smY0YzFkP2poKAnVtn0ka6duCchY5JrxoMxxtv
        7uSD29m+v9SFdQ//utym3Ty/+dizeuUWzu58hSDQww==
X-Google-Smtp-Source: ABdhPJxbbeZMf3MxXU9tozPUHZU5egdtze2vhm0uEhYrA9VjLwnB/vd4ZKUdrjUuMSCPV/5LT6v8CTC+NlbgERVv42A=
X-Received: by 2002:a17:906:7955:: with SMTP id l21mr18527088ejo.6.1637122580133;
 Tue, 16 Nov 2021 20:16:20 -0800 (PST)
MIME-Version: 1.0
References: <20211116142622.081299270@linuxfoundation.org>
In-Reply-To: <20211116142622.081299270@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 17 Nov 2021 09:46:08 +0530
Message-ID: <CA+G9fYtVtQS5FNH6dTcDi7CQ7rOcsVSuc0qBjfnoBDx7VAuKvA@mail.gmail.com>
Subject: Re: [PATCH 5.14 000/857] 5.14.19-rc2 review
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

On Tue, 16 Nov 2021 at 20:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.14.19 release.
> There are 857 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Nov 2021 14:24:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.14.19-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.14.19-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.14.y
* git commit: c82fd5d7547b63f57ed82dab402dae9b29bb8935
* git describe: v5.14.18-858-gc82fd5d7547b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.14.y/build/v5.14=
.18-858-gc82fd5d7547b

## No regressions (compared to v5.14.18-154-g052582294dec)

## No fixes (compared to v5.14.18-154-g052582294dec)

## Test result summary
total: 94837, pass: 80370, fail: 716, skip: 12848, xfail: 903

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 290 total, 290 passed, 0 failed
* arm64: 40 total, 40 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 39 total, 39 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 54 total, 48 passed, 6 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 40 total, 40 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-
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
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* linux-log-parser
* lt[
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
* perf/Zstd-perf.data-compression
* prep-inline
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
