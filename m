Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3106C457B1D
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 05:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236283AbhKTEbl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 23:31:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236900AbhKTEbk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 23:31:40 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 356E9C06173E
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 20:28:38 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id t23so25723222oiw.3
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 20:28:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eaf6YWH3zdLZq9h98VDLUZfPOVqzv7JmYdALRJ3OMcs=;
        b=sZtmzSNdW/jKYoskYuW3TLZmJj4u4G8tq8XjImN7ii3hduTd1fY4TUIR+aAwOzqmyM
         vi3xy+6sbafWrSuUkLriGT1xLcAqY8ZWWOaSh4NU+LI3SzVIx3sTh5otGUERyEXmTj1C
         p8KF1yiq+WkN/aJmThkJLRoph7LHMBUrmVvmcDz7TTyqJ5AKjDJULXLpMlPeuYG1hVRq
         yD+n6629ZuYTlYvHDTvRQaWIgtiFYv+lTqNWECwlLQyjTgLXEAR+vn7kI2Ml5FpnlaEu
         BicY4Z8k4NzsMRNmpm4Qi/IjJF5Zbelb0+UyR12BbLHXSCApmxm7BJvLX6UXUmG0OssA
         Sn4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eaf6YWH3zdLZq9h98VDLUZfPOVqzv7JmYdALRJ3OMcs=;
        b=v1RkA0ZONPc6fTwop3pmW+u9981ifwM/f0VJZzIr/xhQly9do0b6BQAJrIN4JkXQMI
         YnhctR+G/850A2Jj+pFGoBWZ391MNOtj71P5EwNbBYXP02UMS1iLOGbw1gMkI+vWnsmd
         rUwKIzKQnOlN+ykI/srQH3OypDuusdMpOKLn79A3ed3X7LaRwG4oBsFeSTfV47dN8Xit
         5O7+lWMSo5PqbhFazAeELAO6sD5j5ZrNROhACSrWkSzUyYdhsTp9wLUnwx/0Sg8wSur9
         npVZV0K/qlqb4cODYpK5YhxojWJ//KIOW8zCJLPvIRQsBwe2higKc4MbfPNxqsvZpJlZ
         lfTQ==
X-Gm-Message-State: AOAM531f8QdoqRIAgXEk3swtzGFDvsalOoHz1r8U6kjUcLoKFjZzTBj3
        Sb1dajnYu/DETXWcGBSoikbadpf52VVBZA==
X-Google-Smtp-Source: ABdhPJxsIyCm2Gr+zCJYZkCHA7GHIVGhD+Up9AKf8vxzE2he4QJGe1+XYxer+Vx37/1lSSVinLLU3Q==
X-Received: by 2002:a05:6808:a8f:: with SMTP id q15mr4770539oij.65.1637382516551;
        Fri, 19 Nov 2021 20:28:36 -0800 (PST)
Received: from [192.168.17.16] ([189.219.75.83])
        by smtp.gmail.com with ESMTPSA id n189sm431449oif.33.2021.11.19.20.28.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Nov 2021 20:28:36 -0800 (PST)
Subject: Re: [PATCH 5.15 00/20] 5.15.4-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20211119171444.640508836@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <169908ff-0709-2967-d21a-dd947c4fbf0e@linaro.org>
Date:   Fri, 19 Nov 2021 22:28:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211119171444.640508836@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 11/19/21 11:39 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.4 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Nov 2021 17:14:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

## Build
* kernel: 5.15.4-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 9f5b4a585c82d545acbc198579edfa8991532019
* git describe: v5.15.3-21-g9f5b4a585c82
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.3-21-g9f5b4a585c82

## No regressions (compared to v5.15.3)

## No fixes (compared to v5.15.3)

## Test result summary
total: 93274, pass: 79148, fail: 681, skip: 12567, xfail: 878

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 260 total, 260 passed, 0 failed
* arm64: 42 total, 37 passed, 5 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 40 total, 37 passed, 3 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 35 passed, 2 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 49 total, 44 passed, 5 failed
* riscv: 27 total, 25 passed, 2 failed
* s390: 22 total, 20 passed, 2 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 42 total, 40 passed, 2 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest
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
* ltp-fcntl-loc[
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
