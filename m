Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C423E38FA
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 07:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhHHFUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 01:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbhHHFUU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Aug 2021 01:20:20 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7409FC0613CF
        for <stable@vger.kernel.org>; Sat,  7 Aug 2021 22:19:51 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id cf5so19494078edb.2
        for <stable@vger.kernel.org>; Sat, 07 Aug 2021 22:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=szE9GFRCIHuxvVJhNeFP3Xehlnf1RTGGoQA9iVKN3rA=;
        b=tYf0wVjShWa20hsZNWJkVIc3BewnTkYlPaANvnoIanBWROd51qMVAfx4tSS1zWAkSl
         qbpXwDkrw2DdplpnXrLWSFQHb0DGhBIhax2hAVon/N1z6Jw/bs1SeV5BNCSt9YOPRdun
         5szke7ye98HVQOOsBg4m9eMZHGOFYxuQ55mYdzV31QEroff6KDpxS3JlVDzlQS/lNeh2
         KLacLoVDWS+BBq2x4EnH9Aic9kJsV+LRUB+KfzUYkEtLjMkoQG5DI8WKaMKYKIz7/g92
         4nVgJqCmzlx7028+/+MzVQBkiVAl7ZKcSidcMLXDXWHpvhvrCSNzC4SkeNLnKZFSDc6J
         iRtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=szE9GFRCIHuxvVJhNeFP3Xehlnf1RTGGoQA9iVKN3rA=;
        b=CsUJYeZT5wUihXGj8TBtGnZm7r9JDVdWpy9tpTrp/OkLfirM766wa9W8K9Rviq7aPk
         WIozMDxGzKZI/hrvMZePg/Dd915nLq+U84Ihmhs4shehxoB62cFC/o7CIiwb3ivYb7EK
         mekzwomDx/yd98ClxHWkIHv8zSy1dBR39MIXp1aRc/dte8mIfYhbIkpVBtDF6xkB1+vF
         wQmp+ja7tqLQZlqU2LL1zbrGCQkFGZyoxZw2QUwXkKPZmxT8S/zmf+eTade4pZ+CQwAL
         4d/s7MxbA9KmO/Yqwzh7xo3hIL5zy4IOgOwrAFCCBNIHAhl7RNfrcpqXMIkaHojg5hAT
         6m/g==
X-Gm-Message-State: AOAM531UvCaonmoClGN7/2Q4HTAXjwNg2PEya/u+OjsBC2OHL2xhMcST
        vUHkbIDHPGj4ME9x+/xPzC93/hfu/eyzC7mwT8p1qQ==
X-Google-Smtp-Source: ABdhPJz4lkrOiyCGk8pst8p3Iy11JyIH0qsqE8ujjPBarj+HK7x5PC7GQ29VtJRri6B66gmniv0TRb4zQTrSHey1vu8=
X-Received: by 2002:aa7:cb9a:: with SMTP id r26mr22449656edt.78.1628399989813;
 Sat, 07 Aug 2021 22:19:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210806081109.324409899@linuxfoundation.org>
In-Reply-To: <20210806081109.324409899@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 8 Aug 2021 10:49:38 +0530
Message-ID: <CA+G9fYuAWacnee28FEBZ3nPqmQJf_Eo7KpRQRu=RUnDipuM1jQ@mail.gmail.com>
Subject: Re: [PATCH 4.9 0/7] 4.9.279-rc1 review
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

On Fri, 6 Aug 2021 at 13:45, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.279 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.279-rc1.gz
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
* kernel: 4.9.279-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.9.y
* git commit: 36c4ea3b072f93b011cbb5d863808049e393bdff
* git describe: v4.9.278-8-g36c4ea3b072f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.2=
78-8-g36c4ea3b072f

## No regressions (compared to v4.9.278)


## No fixes (compared to v4.9.278)


## Test result summary
total: 64266, pass: 50078, fail: 611, skip: 11601, xfail: 1976

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
