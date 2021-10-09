Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF560427C72
	for <lists+stable@lfdr.de>; Sat,  9 Oct 2021 19:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbhJISAD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 14:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhJISAC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Oct 2021 14:00:02 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A07C061570
        for <stable@vger.kernel.org>; Sat,  9 Oct 2021 10:58:05 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id d9so25155915edh.5
        for <stable@vger.kernel.org>; Sat, 09 Oct 2021 10:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=26GX/wGEIQiVWrxm/nE9sssXMxKWNLT2XSFrEZkSKSY=;
        b=Fw2UjsGpFJELrlkB2qrFVTWEiARpurxZ7FvArZ/GWC/4RwjPSHY5cdUaL2yG6jaAxV
         7eBu0L9+qubQuKxJoZUAvTyK+DnfX+ktrDnUXg2ArgfEl9EFmTAlpG33CnImkXeNjs+x
         jny3MzlKp49DlmFhSUIeqJvEqiK3Dq4IU9IQV6n8g+VmmswzP7BGtqdp+MvNKx4X19AK
         Mvzk1NCPd1a+C99Yx3Sghgg/+eLyf5RQm9TndtZfzxWEOVXJSOgItXk/9W4COdzAAIOf
         6YzA4YainqNJ4j0ZCnBhVdrmavsJRx4u46xUtdHx8aiOq9iQb4DcbikhXcpkm5qCiULP
         f11A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=26GX/wGEIQiVWrxm/nE9sssXMxKWNLT2XSFrEZkSKSY=;
        b=jv/Y3U5tWzQ/aXt7VpjsoGRghxqc+OeVu91FCyAlma/QFEbeEL3KM86t0rnCwZOMVu
         4LtazLNarBFQSVJPhH0EhmJN0lTo525t/aXzt61IO5HvAEQL7aydQMbLIBiOn8Oy/8LM
         lfMrh8J5VkDspY3hVUGtsuPBn3J8SB/aLJB0b2iJesutZl1IWwNGBLJa/ntQ1PU3XaA5
         PJ3sQa9GQY0F1MLWMZc/wSYETpv5OqDNnQDf2PvTUbaFjXfC1urOQPkUM7Rt8N5VIAMu
         STJe7YJ8txyn48bh8E2GPipJIChZJRBEm09g9JUA5rocps0qix7V84G2kd9wLrOV9EhL
         ly2A==
X-Gm-Message-State: AOAM531AH8EGud7yMXo5DNLGyBaTtKjpxdehZarhH2+Xn5GdHCKLQ6w3
        s8U44Yv/IbxiUHVQmEooUCmlLQ690nswUjyEvEUaWQ==
X-Google-Smtp-Source: ABdhPJySLYH4bizNUWoi7AdOiuFRRvf4L/Or8Zvshnxbk7Qd1H0G98fLTYii1DsQ32UmASkBq3EsJ4ZBuuYal9K28z8=
X-Received: by 2002:a17:907:7601:: with SMTP id jx1mr13364976ejc.69.1633802283629;
 Sat, 09 Oct 2021 10:58:03 -0700 (PDT)
MIME-Version: 1.0
References: <20211008112714.445637990@linuxfoundation.org>
In-Reply-To: <20211008112714.445637990@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 9 Oct 2021 23:27:52 +0530
Message-ID: <CA+G9fYsMfNPa2HQWQA4jYC1W2N=1fiVGc7m2uGVUKaLznytkbg@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/10] 4.14.250-rc1 review
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

On Fri, 8 Oct 2021 at 16:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.250 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.250-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.250-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 7d769cc629ad98f5af7d44e0b70717708a7b323e
* git describe: v4.14.249-11-g7d769cc629ad
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.249-11-g7d769cc629ad

## No regressions (compared to v4.14.249-11-ge016eae29d2d)

## No fixes (compared to v4.14.249-11-ge016eae29d2d)

## Test result summary
total: 75800, pass: 61082, fail: 609, skip: 12086, xfail: 2023

## Build Summary
* arm: 258 total, 258 passed, 0 failed
* arm64: 68 total, 68 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 35 total, 35 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 48 total, 48 passed, 0 failed
* sparc: 24 total, 24 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 36 total, 36 passed, 0 failed

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
