Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49EA41B463
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 18:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbhI1Qsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 12:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhI1Qsg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 12:48:36 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C861C06161C
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 09:46:56 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id dj4so86214231edb.5
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 09:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TUxglweC6N1WY79ISdseA2NBR0rjJM+nm4q/sPuPvsA=;
        b=ORghtTfTJlUjmS/iU/IOM0zHv2l5wotpDxzaZJP0qH2UabwgsPuO55RGX4n2YAkccf
         NgxUgtAKvNjHvp0+rhawdMFNacSNNZv81hjdx1Q4EAOdX4YFZqBDKFEcsV4/UqTv3Cgz
         4j9CNi6uFwBwneW/h97PtvBzG+QB6unQhG3XZzMtN/TL0fgBFH3CBvPDo1wK+KVlfyfj
         iqGZ1xPszqaQVbOHupcPZGQNt3vn/zIv7Ht6li3AouYpM/SeiBNfNk4VkPEt8dxjWSUA
         i1gqkXiR3AsJ7alttSk17M1YFwhr8d2687VpjNNpx0N4IOtBWxAL4XS+0xh1t9ZWPB81
         si9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TUxglweC6N1WY79ISdseA2NBR0rjJM+nm4q/sPuPvsA=;
        b=ABTtGxUAGQb6bHj2A/w5Nfz722H69omQmI3Ms3TPSLKqOtGny47Z79eMtKNjtEQDtc
         7wckl7ptSTofqHKjxZw4nIGL7RAS9Yz1JbEEA/xQKAp/qwW+Gl0+aZHelreuL6Putpxb
         5DwhlrZ179ZqDz8GMqi9gYtC0tPr6ZC89+vSZnmsJhtjMLShYV35dEP7PnN4bMMMr4Eg
         oRK1F/WmsFDBnf6vwTWIvH5TD02UjtV7NYcHRfBqnGWbK0A33pwMD0zB7FYDzQA8rTaX
         ZmaKrJNtcy8HUs0u7+HnfF++IrfkaWT0eWCkR73qJkB5A17SM87a8VnSsEX/rGaT+7/4
         tnFA==
X-Gm-Message-State: AOAM531NSQTBntlYHYMqAcBcLLiWqWBefZR9BzhihS8cWu+yz9gfCf2N
        HO0P5mZdd8vpFacu8d8OPlwn6c9Ss1LDzm43Hsnzbg==
X-Google-Smtp-Source: ABdhPJyoQ8w3rXfIaAKPbUHV7IKGbpBzKG6kA3uJYEVUw8UsKwgpcetJC6CjtuU0Z8lM3P2Grz7Et1wVehMdUw8Z9hQ=
X-Received: by 2002:a05:6402:5146:: with SMTP id n6mr8547850edd.357.1632847614431;
 Tue, 28 Sep 2021 09:46:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210928071741.331837387@linuxfoundation.org>
In-Reply-To: <20210928071741.331837387@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 28 Sep 2021 22:16:42 +0530
Message-ID: <CA+G9fYsp=-fDNdY-NYx6oZUmaembx5MqPZh-YA4Cwn=TVLm12w@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/102] 5.10.70-rc2 review
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

On Tue, 28 Sept 2021 at 12:49, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.70 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 30 Sep 2021 07:17:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.70-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The stable-rc 5.10.70-rc2 report,

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.70-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 9583b61453b7d7bd52b2b593858583715f37f254
* git describe: v5.10.69-103-g9583b61453b7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.69-103-g9583b61453b7

## No regressions (compared to v5.10.67-125-gbb6d31464809)

## No fixes (compared to v5.10.67-125-gbb6d31464809)

## Test result summary
total: 83364, pass: 69629, fail: 554, skip: 12129, xfail: 1052

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 289 total, 289 passed, 0 failed
* arm64: 39 total, 39 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 38 total, 38 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 51 total, 51 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 30 total, 30 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 39 total, 39 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
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
* kunit
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
