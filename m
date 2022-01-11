Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9724948A77C
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 06:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347587AbiAKFxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 00:53:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347466AbiAKFxZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 00:53:25 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06571C061748
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 21:53:25 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id m6so33916825ybc.9
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 21:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yN938ml7k9PlIkd6ze0V1+a9rSQZGwy40ordEAaydg4=;
        b=IqjlC4bQRs2eQOQ4nbZmDJ3511cQ2vN4UtkRoDqkE8bsEo6Rx2Jj2gWGZx5GiOP9xw
         VFn0ZCaSDkY57ERJr9ybfzJnUZ5zTaHB56+A03WIW9bgHqcLvJ97mH9sp08TuzJXg6I9
         W6N+gzFlpbSy/exxLHpMzVHneMcEK6/woqVz38DRFthoqeDU4DuSUpwnW7+T6vscYnzW
         lVy5+Fni6NNS6L4Cjvqch1NhDqk9x7BkjaeCHC9fYxCl1j4uNu50u+X+URS3o/EHZ+Ax
         wlwJ7QgT18QLJ7NzaJogTcvC3+X3vG9fZDkIeTlGBkhBDn9lCVUPl1ieHhCrJDPm2nSD
         BgMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yN938ml7k9PlIkd6ze0V1+a9rSQZGwy40ordEAaydg4=;
        b=nyjBpoS9zI8vT/+F9VeROx4SH2EvNLLdpgEF3Q4fQktmIBz12oFKUdQWvRhRDhYrJ5
         uh4iJcxEx0nEby4ZhL8/eIEZxjS42J9ddr1H+1Ay7fagk33WBg14EUdvfQv+EVddFRIN
         l+tiaew1dwF7bPjfzeP1n2RWfOvq9IOtOry2/1dJZMTgOZp7fU5D4nLKBEYLBSWIYThe
         xFwlx4J7c3lrdAGguiOXJ69YtaX+c1odOVNvuUsVIdxDPssvlAqAsg9SolTWiRul+DGh
         u+uVGOSItwWXch5U556H6Fp7+nO65gVagmwpNXpYBE6uCx/u4MGvXWgMSWZUo2yVMK7K
         mhlg==
X-Gm-Message-State: AOAM531wHzNC1WcHgoQOBd8XzvSDNiFUc+C7upNSctD6m64cuGCdx79q
        iHh+UZrVjYu4Ft4eXNHRa17BSjveYwKJN8teUjpn6iNoxlEUDg==
X-Google-Smtp-Source: ABdhPJxd8EjeWunO8vzzCSbiX4PSM+HDJaLQ7giUn3GFEKDYcwpEdJo6YIgb8gzOkmavSyTWlrAC0M9QU5+d40xD1JA=
X-Received: by 2002:a25:4b85:: with SMTP id y127mr3916587yba.181.1641880404066;
 Mon, 10 Jan 2022 21:53:24 -0800 (PST)
MIME-Version: 1.0
References: <20220110071813.967414697@linuxfoundation.org>
In-Reply-To: <20220110071813.967414697@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 11 Jan 2022 11:23:13 +0530
Message-ID: <CA+G9fYscwscohrs9H-XPN+i=MGpOBPRZtqiR0KAfLY3-xi7u4A@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/21] 4.19.225-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 Jan 2022 at 12:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.225 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.225-rc1.gz
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
* kernel: 4.19.225-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: 688dd97d1841df9fc689897105df7075ed3c50c9
* git describe: v4.19.224-22-g688dd97d1841
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.224-22-g688dd97d1841

## Test Regressions (compared to v4.19.223)
No test regressions found.

## Metric Regressions (compared to v4.19.223)
No metric regressions found.

## Test Fixes (compared to v4.19.223)
No test fixes found.

## Metric Fixes (compared to v4.19.223)
No metric fixes found.

## Test result summary
total: 78464, pass: 64044, fail: 626, skip: 12386, xfail: 1408

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
