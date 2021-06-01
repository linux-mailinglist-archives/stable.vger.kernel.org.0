Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE7F3973DD
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 15:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbhFANLO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 09:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233409AbhFANLN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 09:11:13 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C290C061574
        for <stable@vger.kernel.org>; Tue,  1 Jun 2021 06:09:32 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id b9so21529815ejc.13
        for <stable@vger.kernel.org>; Tue, 01 Jun 2021 06:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EBxyeOx+3RsWJVhTTc5ohpA2jwgveNW4SF62Y0kGAg0=;
        b=dsDckIPOp9TXBT/s7RdiUDvpov38qfYBx3AaTcisxYwVC6JrB+2zJLDNxXBoUSPQ6v
         hvUi3rlaAGVNYmhWyr5XDrs5ZxuZH/SjH5C8s0SYrS2NnhstttWyBaRwLyK8v1ui7awm
         sKLcam94uyM9oXyG95b+Hlqr/a5+iHlMHpVjiTdRH9JPI2dZsK+aopEPzj1CJdSkUx16
         fxVcPQnDRfsncYCqppvgbJP5kZY6lHTSNDk6+R1I7vEGhD1hlQ1qnMLSdzUHIvcB1qvd
         iP7PpcJa/SGPJD2N2EDiK7IcSNbnRkHUXfbc4ZNL7x5bNpL2N9PFG28C9BvdlwqYKP+v
         7jFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EBxyeOx+3RsWJVhTTc5ohpA2jwgveNW4SF62Y0kGAg0=;
        b=WfCojEhaSR9sZdSuCokTxeawv4dFgIeO3ZvUbnPl//bmpKU/b2NyebibGIxcr4xKyH
         +6eHziX06f7Pv/YoL9rLYR7rGQpwGxNYp86fpgFxk3Yc6TVG+Sw2hjWvzvBLqXVagG/K
         iHe8ctPNx/5Hri621Q12OI9kw4lZvQyYq2AIKKR85HBojgGgez5k8H5wXlcF0rmDNrVN
         J7iTwjlhq+HsrkXVRL07GNE9pKqb3q9sviA1z5staCiBpur3avJWqsXYPMXdwvER6abl
         Mc4dlt9P1jxIpMi6ZrZd49QvsskfRPfatl8tCgeMojP0exx+MZYAtSi0tjTv39hpGnaF
         w+0A==
X-Gm-Message-State: AOAM533hMVjiGCgH51wPtre5vaw3RsARK3xijZjnQRiuV/2ENojLGopC
        zknx5x+2MFWl4/pWHGJopJIUT3FxIOAy+HqUxmmgsA==
X-Google-Smtp-Source: ABdhPJzaJWShJBsE42YmVPyWkCZpCfZNLRBpTqLqq7WzlxkyzfSZXMAaBRl90OZDXy16OLV8GAIvXQb7vzjAFOk/GWE=
X-Received: by 2002:a17:906:8318:: with SMTP id j24mr10513958ejx.375.1622552970872;
 Tue, 01 Jun 2021 06:09:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210601081514.670960578@linuxfoundation.org>
In-Reply-To: <20210601081514.670960578@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 1 Jun 2021 18:39:19 +0530
Message-ID: <CA+G9fYtDntHBQ4Tu9JpO7mtE6hLC=ATToLVub=ON7YvN04RQug@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/71] 4.9.271-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 1 Jun 2021 at 14:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.271 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 03 Jun 2021 08:15:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.271-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

This set of results are from 4.9.271-rc2.

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.9.271-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.9.y
* git commit: 7c0244f56992aacc7d68dd6e61be593062aa0668
* git describe: v4.9.270-72-g7c0244f56992
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.2=
70-72-g7c0244f56992

## No regressions (compared to v4.9.269-37-gc1efed5276d2)

## Fixes (compared to v4.9.269-37-gc1efed5276d2)
* ltp-mm-tests
  - ksm03
  - ksm03_1

NOTE: The LTP test suite upgraded to latest release version LTP 20210524.

## Test result summary
 total: 57037, pass: 45364, fail: 1305, skip: 9522, xfail: 846,

## Build Summary
* arm: 97 total, 97 passed, 0 failed
* arm64: 24 total, 24 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 14 total, 14 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 36 total, 36 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 14 total, 14 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest-android
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
* timesync-off
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
