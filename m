Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDAB343B2F8
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 15:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236163AbhJZNMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 09:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbhJZNMn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 09:12:43 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789B0C061745
        for <stable@vger.kernel.org>; Tue, 26 Oct 2021 06:10:19 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id m17so2527184edc.12
        for <stable@vger.kernel.org>; Tue, 26 Oct 2021 06:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OeP2uMz0vd+0Who0xc5ehw8wxwkBYkcsuWLBdD8sZ7U=;
        b=z46YN3gflREfqzH2Fewqg5rqttp063V1gzUTKhozcp0O//DAiziFvJ5k1RRxmF1XJp
         DEES3QEe9nSjSF+esx/B2RViby4BjvbMHU8IHQJmb9lTEPHJ/Dd6ocDHZPyh1yjuoHWb
         bI7TE4KKcE2PQucd2snFdgQzjDrWetiupT3IodK6PbgbbDfRFjU59j8+37uzLh9DMumZ
         xQUHks4YEirE55Qhqgi2JdOrlbfIoc9xggyYofqZZBZJUCf3DdZtNqAkYi7QdMHxmcUQ
         bIYMx6wCbOs7aUOhG8igwIO2AEVtSBnEzaKU1vPjpdlcRmKzBtRAOn1R8BdnJEhW+ILt
         O7kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OeP2uMz0vd+0Who0xc5ehw8wxwkBYkcsuWLBdD8sZ7U=;
        b=5R5tmC6q7PJ0AEOmR1l4DA9sXAiCCoPIhXWq1GUotnfXStMpH0T3VBauKbfN0Job2E
         beHop5vcwMtwd6KchC3xl6MB+O+LRkg7ipKYaj1JTnaEyGYSoBgeHdrMqzORlN/qsSB1
         AVt9CGp30hngP1BJDy/S9ANP18KB+MblO5UahYRokLHHmACbV6qxi0+PwIq9DIAt4rys
         MjVmRIEhYWAMs1Nn+gPdFHW4ii3joCdwWXC51mM0ksUsR4tSo+7gd1WMaUqnU2dprQQZ
         XwPmxvclukGS9KYcqcv220lSqZg78H3IXhFzm/TJeYykUB0VDpTvCZQsVMs9tP+KQbgO
         EYtg==
X-Gm-Message-State: AOAM533a0dbFpTyjyMJrSGENibuYBQ2SKLuO9DPKQqdXVp7rNEh9zu8l
        N+GXujDWn9qnCL0FMCQ7WLoU3jcHCEyBNCD7z7tR6Ee0jLmnlw==
X-Google-Smtp-Source: ABdhPJyv01ZPFZOXeyGnZa74PagrRNC+pdAHU7rGrGka/F21q2HiGVS8goget7VNBMF4v+tlLR0Zb2kelvRx6sYdA/g=
X-Received: by 2002:a17:907:971e:: with SMTP id jg30mr30149825ejc.169.1635253804651;
 Tue, 26 Oct 2021 06:10:04 -0700 (PDT)
MIME-Version: 1.0
References: <20211025190926.680827862@linuxfoundation.org>
In-Reply-To: <20211025190926.680827862@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 26 Oct 2021 18:39:52 +0530
Message-ID: <CA+G9fYu9u9frCeLs0+5Ok-3_+50BpdBPLbqNzKmJDn7gJBfCYQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/37] 4.19.214-rc1 review
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

On Tue, 26 Oct 2021 at 00:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.214 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 27 Oct 2021 19:07:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.214-rc1.gz
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
* kernel: 4.19.214-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: e9434cadcff7c1dce4bcc8c599149f87f266e486
* git describe: v4.19.213-38-ge9434cadcff7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.213-38-ge9434cadcff7

## No regressions (compared to v4.19.213)
## No fixes (compared to v4.19.213)

## Test result summary
total: 78293, pass: 63026, fail: 781, skip: 12713, xfail: 1773

## Build Summary
* arm: 129 total, 129 passed, 0 failed
* arm64: 37 total, 37 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 27 total, 27 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 21 total, 21 passed, 0 failed

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
