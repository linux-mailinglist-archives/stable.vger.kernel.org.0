Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C36783FF0D2
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 18:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237201AbhIBQL6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 12:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233599AbhIBQL6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 12:11:58 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C87C061575
        for <stable@vger.kernel.org>; Thu,  2 Sep 2021 09:10:59 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id me10so5581662ejb.11
        for <stable@vger.kernel.org>; Thu, 02 Sep 2021 09:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=N5rJrXAUGfySu6AfVg8JgX7fXzkXWAcfJM39VbAvS5g=;
        b=i7IvruK27Ovwbgqi10TGtEx+92bcyvel7S0ZSP7KQ6dRX6sV0d2gcKBRi4q6GCYMCA
         zeuBLFsGZbnbNiXMwkaHJg1e2AeqeCrro5/CThATPCBV5/FKGUu52SM0DLWnA/PJlfaB
         zaMsr4v1b78hZqM7UuUY00CI9vj0CWAKsdAVe3ZWviTTXB/AnFLd4wPZRRouuKqvW0Rz
         LlFpMB4zBdqpZJGJHwM4Z0rSqYH1iY2O9qoHwUYGp9lgheGDh14qtmFsxLp/5u7Qdu13
         7U2CXHPkhTCySwijqAH7Nn5OgVVTzZs47br3C8bwiRvzP6Q5L8YsD8c5FAvStJ3YaAS5
         WfXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=N5rJrXAUGfySu6AfVg8JgX7fXzkXWAcfJM39VbAvS5g=;
        b=O65S7Vg8mWRAexodilYCjTd86aEyMpZX+xytKnvWOstS6brdRKtDDSoHVol3RWd4vp
         GOz6AL/sv6vYEAExtrpoe7SlTmvZINVO4eXN36YrhxyvxSlPLQzhvdBsvmwiIsDZ9HTZ
         4L9f7V612g8HWRdAkd/eMqTrVbivCfeTCK+Sx7XyeA89UFYmBhQULl6yrfYsnE9ltexb
         bKWyo9IHTfz+6vC75UdmQF4hsPfoRX4FO82plEfu5WQD0XfoFyjlsbb0d7qZHqf4yO7b
         jYSGrC6VzePU2SwqEtlRkDZ5yck2HIL7V2V3eDs42z/r/sy2VS2sLCLzJ+Q8aFPjao+V
         +tSQ==
X-Gm-Message-State: AOAM5326PV9UZOwZw+V/knpixYmVjG5y/eb9w0BrjQIpUkuvpPgBJiDz
        S6qLcRVPNhUq7pG57/iViPQaWk5G9v+M5ebZ0Bjd0Q==
X-Google-Smtp-Source: ABdhPJzecaW4Om7O73rs0opLM5xkKyr3rPWGmMgxLXNaQ556BEsSADjZY85JesvZAUu8GFqXWFjwRPzggAvDdefIpXo=
X-Received: by 2002:a17:907:7785:: with SMTP id ky5mr4630099ejc.247.1630599058303;
 Thu, 02 Sep 2021 09:10:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210901122248.920548099@linuxfoundation.org>
In-Reply-To: <20210901122248.920548099@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 2 Sep 2021 21:40:46 +0530
Message-ID: <CA+G9fYsq0yOsC4eVs9_A-WazZPAp+8Vhz2_tj1tiG4-s2mmn-w@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/16] 4.9.282-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 1 Sept 2021 at 17:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.282 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.282-rc1.gz
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
* kernel: 4.9.282-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.9.y
* git commit: 8256eac057128912fe69a399bec3c22f7f9b77d0
* git describe: v4.9.281-17-g8256eac05712
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.2=
81-17-g8256eac05712

## No regressions (compared to v4.9.281-10-g68fa8d648bfb)

## No fixes (compared to v4.9.281-10-g68fa8d648bfb)

## Test result summary
total: 74774, pass: 58730, fail: 805, skip: 13068, xfail: 2171

## Build Summary
* arm: 98 total, 98 passed, 0 failed
* arm64: 31 total, 31 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 15 total, 15 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 36 total, 36 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 15 total, 15 passed, 0 failed

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
