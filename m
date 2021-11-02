Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA94144285F
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 08:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhKBHbU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 03:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhKBHbT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 03:31:19 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52EB1C061764
        for <stable@vger.kernel.org>; Tue,  2 Nov 2021 00:28:45 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id f8so51036914edy.4
        for <stable@vger.kernel.org>; Tue, 02 Nov 2021 00:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cxWHL2V8mPHZBwLVhPzyF2zYMkIP2xx0HETqHhyGJcg=;
        b=iey7kGkTQNS4cdfGrLnzmco9FYAcaG3/Lt4lTcV/ulyAh1Z2y0joLzbSJBglwa7aGO
         D2vriEeB4RfYHANCz0k/6kcwYLK3oGMkfaJGVi3BJWuhlV+xsFP5zKjJ5mI+NCj4/X3n
         bw1cl3F1ERhfsW66v3xYOv2DJbSWjoFNA3KxdbMnR/JiIJPl/5VoHBsKQem4D4zXawdc
         rlHqCE+mcldGqDj29EDDjRRXwIJZbSsV/I5rhvCSlcXuY0+aFZnXQlGttPNYGoXYYVFP
         XrZ2yGpg8LBv/4zoUV0hkjqQtxYcfNBV8bgfVjht6YrcnJqGi764/yvKNuVnlGzxWXCl
         s/Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cxWHL2V8mPHZBwLVhPzyF2zYMkIP2xx0HETqHhyGJcg=;
        b=ZLsjCe0dfTiXxXEhDLFkEUVJKq7cJ9tyiovlkXHnqEphxWkaHAU6FkBOS8Tracrenw
         VgkLXMpZPUzHQv6g9c84Pf4wHGrD8+v9vxY3ZaQ0M1IgkMg+tRViyUFbOKo3yPSo+9xS
         HB1uCOniZCsg++Z2OvTwDSQKi+u5iRN580W4pkXTS5rzNo8U0JLWJNdi3hs87QGTC7UF
         +rra79mOy1ivJtdjwg3YzED5JYHHsWb6LndMrk7MsTJi43UEALylsPiMblHDCB2Hodvd
         flvbe7lZSwZcMAVAKUqLEOSCObq4nuUxqnqDt5EPOYcJ5Qd5QY7r5HqzDlKgPFRKXSb/
         sibQ==
X-Gm-Message-State: AOAM531XaoeHfLWZ1zbbuwdJctNUWVbI2kXdM9EG6e+UCsmvlcZy4vzs
        bErwau2hDJvcVhM7929c0i5jqQwyMft0PTwfA7oWjQ==
X-Google-Smtp-Source: ABdhPJzBUn1XxjtNqfsSYCgfNEkUxIwv7rDpDKzciCK8euvDYZt3owKWYY3HP8+mzViVfwrZ9eI1dDMMBnbYpy0Ba9M=
X-Received: by 2002:a17:907:7fa7:: with SMTP id qk39mr43447345ejc.384.1635838123761;
 Tue, 02 Nov 2021 00:28:43 -0700 (PDT)
MIME-Version: 1.0
References: <20211101114235.515637019@linuxfoundation.org>
In-Reply-To: <20211101114235.515637019@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 2 Nov 2021 12:58:32 +0530
Message-ID: <CA+G9fYu9-sr7u9Lqf364pg07Zk-a3OBiBHPE2RTJPnYPxdZs+g@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/51] 5.4.157-rc2 review
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

On Mon, 1 Nov 2021 at 17:14, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.157 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 03 Nov 2021 11:42:01 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.157-rc2.gz
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

NOTE:
With new gcc-11 toolchain arm builds failed.
The fix patch is under review [1].
Due to this reason not considering it as a kernel regression.
* arm, build
    - gcc-11-defconfig FAILED

[1]
ARM: drop cc-option fallbacks for architecture selection
https://lore.kernel.org/linux-arm-kernel/20211018140735.3714254-1-arnd@kern=
el.org/

## Build
* kernel: 5.4.157-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 48b0aec9543c78e79579e887ded0a2d96126081f
* git describe: v5.4.156-52-g48b0aec9543c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
56-52-g48b0aec9543c

## No regressions (compared to v5.4.156)

## No fixes (compared to v5.4.156)

## Test result summary
total: 82388, pass: 67744, fail: 799, skip: 12415, xfail: 1430

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 420 total, 369 passed, 51 failed
* arm64: 39 total, 39 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 20 total, 20 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 36 total, 36 passed, 0 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 39 total, 39 passed, 0 failed

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
