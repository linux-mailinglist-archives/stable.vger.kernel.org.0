Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E3D3F7D71
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 23:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbhHYVCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 17:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbhHYVCm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 17:02:42 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A00CC0613C1
        for <stable@vger.kernel.org>; Wed, 25 Aug 2021 14:01:56 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id i3-20020a056830210300b0051af5666070so683451otc.4
        for <stable@vger.kernel.org>; Wed, 25 Aug 2021 14:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l7QZIuqoxh5rDUWPchzZzHS9/CL3/b/d6Vx0THL5INM=;
        b=SpIyuAOzDflRfjfOemc0rtSYDKS23Jtekv6Sai2edqlVzmWe5N0eQkAihtHNQoScIk
         OBQkGxr/kPgOl1RBmoeAPjl+5SXbAukXUtg9DF+7VVfUeUT7lIAE59v9CMsVb0Dxl/gO
         eJUkElni0S2SN9k41zGfs7I3ywL0RB41leB56iUKja5YTZbFvbv0f0BslgCXYTbap0Pc
         WqXQvKqdHW6C6vztVkfTwISRLQb2H9idgA+FazL1sBKqil8Tvnq6GD57NVSZMtPxLIDC
         nu2ve9t+xuz7Zh1mRadiRnz+lM8zuZjMyw2Fi4uZIpdCrQ6S/F4Kp9vuTDu2yIAO21oG
         JN7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l7QZIuqoxh5rDUWPchzZzHS9/CL3/b/d6Vx0THL5INM=;
        b=hdSO0zoZ6WaYzb7gyGZP3JYqaI0VahnTnJjPwrGB4r6u4xnGb6oyiJMM1Nil6WlXwC
         247StF+Cz8wD//7YAJSONhIyjrccpE8bVKze0LCCr0YwEmiu+B3a6O380dACgqGK8z9Z
         SfTlO337tDw1or3lgicgK3KECmSZjV5brgnv6uMKSRfDpRh+QywiNHKI9CnFbbejGn8o
         mMeKgfMh+k4EKdcUxYp1/MGO9H35M8LV9M2tGTYlgXpLoZGlD/ERW2ObBoBl61aEjKMe
         jh6L0ejCnhHCsn8JDNyrerTY3UkZrji25Bm3QKYvkavOS95sKMbo2ctzj1zUFvw6lOzY
         er1g==
X-Gm-Message-State: AOAM5322DCUJQj1J1iUAdPXIez8Yg+cNqNOUR34BDIPQK+SackL9qp2b
        bKRq5k/HFSBmU2LzCOKMNQ2IOA==
X-Google-Smtp-Source: ABdhPJwYgJPesOMMXkD0jzC/1j5+TakMPBMvL+gEl5KTCOIsPQFtxYV9cIQwEKTBzSaDai7hmgPtQA==
X-Received: by 2002:a05:6830:2007:: with SMTP id e7mr353198otp.80.1629925315439;
        Wed, 25 Aug 2021 14:01:55 -0700 (PDT)
Received: from [192.168.17.50] ([189.219.75.147])
        by smtp.gmail.com with ESMTPSA id t1sm171620ooa.42.2021.08.25.14.01.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 14:01:54 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/84] 4.19.205-rc1 review
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        akpm@linux-foundation.org, shuah@kernel.org, linux@roeck-us.net
References: <20210824170250.710392-1-sashal@kernel.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <f2aa7056-3949-306c-8a00-b11590339e9f@linaro.org>
Date:   Wed, 25 Aug 2021 16:01:53 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 8/24/21 12:01 PM, Sasha Levin wrote:
> This is the start of the stable review cycle for the 4.19.205 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 26 Aug 2021 05:02:47 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-4.19.y&id2=v4.19.204
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha

Results from Linaro’s test farm.
No regressions on arm64, arm, x86_64, and i386.

## Build
* kernel: 4.19.205-rc1
* git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git', 'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
* git branch: linux-4.19.y
* git commit: c1eea862e3bb2aec599f5b1b2aaaa1ee48e709b8
* git describe: v4.19.204-84-gc1eea862e3bb
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19.204-84-gc1eea862e3bb

## No regressions (compared to v4.19.204)

## No fixes (compared to v4.19.204)

## Test result summary
total: 69147, pass: 56533, fail: 531, skip: 10703, xfail: 1380

## Build Summary
* arm: 98 total, 98 passed, 0 failed
* arm64: 30 total, 30 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 15 total, 15 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 40 total, 40 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 17 total, 17 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest-android
* kselftest-arm64
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


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

-- 
Linaro LKFT
https://lkft.linaro.org
