Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6693D8864
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 08:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234852AbhG1G6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 02:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234525AbhG1G6t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 02:58:49 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D493C061757
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 23:58:48 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id h8so1801083ede.4
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 23:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VlNH3ndS749l7fmwikZcN1n0TEVhY+MmUtaZd9dxEFc=;
        b=biJR+qX9D5N3PpsDfoRhW0IaD0XIGK/zrHZ8SUEnU8/3OSTo35OOql6OoykJsJ5O1Q
         2IA+DPYhDE95QbbFy3ekUhYW/pe0whmNIuQiX0Lyn7i9xUhq/hzJ7mr/MLYd2WsP7bY+
         y1BDaJAsXQtIamWzxJpMTh/OyipI/VR1KMAtigYHb/MRwSuxL53k5qwhTs3riPa/iLO7
         HbUvGZDo6aISWEwor++qgPKUbN5X8fcY5EwukRTAM0ixRar2r/U/sc3zI/VDZshSVgCQ
         9qvdskWdPT1yxZW4/k15ez0wcayp58y18h3ypFf3/J3UQZFOBUXhWXslh8FRtAxoU9zo
         Dtaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VlNH3ndS749l7fmwikZcN1n0TEVhY+MmUtaZd9dxEFc=;
        b=DztlCB2K9BkjdqHdJ07NoZSv1AxGInDJ9+ISUatHgoiGqdGRhJ+qw8j3Y9g3scW65z
         0rEoeC5xvTHCTmDj8VjlKjm8DBaWk5Z+Z7F0xR/RnrgJ0GnirskzjiUMoS47LgtvQYvZ
         tRDWoKxq+Q96Oa6klooBgRctyVbpRkbbzHyg5OV7cBvxiNTm9pBy9E003jBIcpxYLAsf
         OCbe+eAUaNazJUPAA3p2i/RnqP9+g0SQecVcIRvqvK1tY74dC497S1PnqvKAnnsvXUTd
         IqMo5MNqxfOb6Cg+c7KZ/0p+ovWfEAP9kDC5oXo1R0mnpa+pXeHpRK/0YTfNx7vqYX4Z
         STBg==
X-Gm-Message-State: AOAM531z8jRnD54640+PwIKWkurIR74qfD/y+SqcBz1PZosVDeGN9bR5
        dNZExa5I/QxYs8R8GFiv1aX3s9GG1EgDd63+M3qKKw==
X-Google-Smtp-Source: ABdhPJwrzP7ptUPx5opz/YMdxPWG2NA1LS+fdGUOMPaJQyAMr/Z6AH6coxJc51s0MasK98F/nyRM6Y5zlUIQSeeKfTQ=
X-Received: by 2002:aa7:c647:: with SMTP id z7mr2209608edr.52.1627455526940;
 Tue, 27 Jul 2021 23:58:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210727061343.233942938@linuxfoundation.org>
In-Reply-To: <20210727061343.233942938@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 28 Jul 2021 12:28:35 +0530
Message-ID: <CA+G9fYu_XhafF95t46gK2YNR=f+6M0Sbn-n32g2Wjs64u2f3zw@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/59] 4.9.277-rc2 review
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

On Tue, 27 Jul 2021 at 11:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.277 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 Jul 2021 06:13:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.277-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.9.277-rc2
* git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git',
'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
* git branch: linux-4.9.y
* git commit: 7f2ed58b6df732109b078b5d71ea38972190241c
* git describe: v4.9.276-60-g7f2ed58b6df7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.2=
76-60-g7f2ed58b6df7

## Regressions (compared to v4.9.276-61-g35f19b074ee6)
No regressions found.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## No fixes (compared to v4.9.276-61-g35f19b074ee6)

## Test result summary
 total: 63539, pass: 49204, fail: 549, skip: 11643, xfail: 2143,

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
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
