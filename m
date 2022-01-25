Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7FF49B07D
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 10:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574000AbiAYJhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 04:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1574027AbiAYJbg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 04:31:36 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9694C061769
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 01:31:31 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id k17so4576549ybk.6
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 01:31:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uflDic+3dYMyur+pzOgW0lBnBcKIfn/jxiPD4K5JoUE=;
        b=PA6ZqysnN4fbZTUiJ88SodYcTzem8FLgBNmsfutc4TtXmCs27IKGren09M5I1coohZ
         25hbEn8GtFOBmmi+UhG8KlwI14LJcyx9D4X/j+5jM5dZ+xAMT3idZPG3jbU4e/LqscW4
         YPZlMyldHFiH+MMlUK43yLYRG4I6WVXOxIbSl1fWfNgXhqsbCOFMioi0AqZ/aDEcCDhn
         8/IoUlJI3fKppUtG+6l9X1OAjAvHlZy9xAoc+Zi9OunmlL8FuG/UsB4SY+Zpby0K6TVw
         erzlBrM3yL/KdFSlGmV3rw0XLdXrrzM0LE2pJSr/x9bcaug2Sid2cKKxjF01o1AEP/gj
         6ciw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uflDic+3dYMyur+pzOgW0lBnBcKIfn/jxiPD4K5JoUE=;
        b=FB5igpiBiu2vFM/hBGvHYprRCqN2QH5rfYZhy6b3EoHDMAnLLhhMRs8hKAw7XCNwoU
         E6yDDIlxanWbnqZXsWaygcJ1JnhF7P7wQhtvhEMCN4TeF+DhjvBWvact0TkpaImysOdu
         7BX3T/8hV7oGHrwITwCCpkyBHWj3KaZocPdVMNh523wJkTy/k4bFiiEuI/JHAmfOp+HR
         aqFk9uUopPpeDtcdV+fSHCnSy7DO9lGZxTHZxy897NuXQCzv5NxUuYtDqCIvvVkm2LcG
         2T/ZPaua4ruvCmQ2v5jleAdh0+OkSEVirQ65ez3T9cixk1HuH4rQ/LL3GwZK2r/BsIjU
         DWRA==
X-Gm-Message-State: AOAM530Ufs7zf+nqPharSD5JOMlaSc/yPS9r3PY+QA3JfuV3l+BVT23T
        inKVw6sV6H93Rz8iJriVa1Y5ny2NEJOdZYIwin0dcw==
X-Google-Smtp-Source: ABdhPJwUIIFYft0BR/NvApj8YkMD7cN4LvSJxgFjUZHQmZRG9BxGzwdumnRwZw4CnLazXBn5AiuDaerh1zdyhOQjT78=
X-Received: by 2002:a25:838b:: with SMTP id t11mr26489620ybk.146.1643103090974;
 Tue, 25 Jan 2022 01:31:30 -0800 (PST)
MIME-Version: 1.0
References: <20220124183943.102762895@linuxfoundation.org>
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 Jan 2022 15:01:19 +0530
Message-ID: <CA+G9fYsXmQvQG1VFQLFHXZTQDu4TR1ozgo_4onNzj8OXO_qagA@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/239] 4.19.226-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 25 Jan 2022 at 00:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.226 release.
> There are 239 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.226-rc1.gz
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
* kernel: 4.19.226-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: ebabcfeda281e1c6226b219845d71930c729dae0
* git describe: v4.19.225-240-gebabcfeda281
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.225-240-gebabcfeda281

## Test Regressions (compared to v4.19.225-213-gad801d4f7db5)
No test regressions found.

## Metric Regressions (compared to v4.19.225-213-gad801d4f7db5)
No metric regressions found.

## Test Fixes (compared to v4.19.225-213-gad801d4f7db5)
No test fixes found.

## Metric Fixes (compared to v4.19.225-213-gad801d4f7db5)
No metric fixes found.

## Test result summary
total: 85753, pass: 69950, fail: 717, skip: 13259, xfail: 1827

## Build Summary
* arm: 250 total, 246 passed, 4 failed
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
