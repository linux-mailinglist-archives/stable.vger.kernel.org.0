Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664C149D9DB
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 06:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbiA0FLu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 00:11:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234894AbiA0FLt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 00:11:49 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66B7C06161C
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 21:11:49 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id j38-20020a9d1926000000b0059fa6de6c71so1450089ota.10
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 21:11:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0WavDbiXhuA03gYWGSNa5oKNFEZNZYp50LoM1mwUDtY=;
        b=Zc6MuVhQ+gpE5wvN06j4DMukaENtJlgOJjpGHJvG4HMHePI4RwBB6IxUrCpz5Eqn2C
         2kZCfjtC1vlSR9obsbby653CW+HBz0Md+1hw5wSB6o2rbss76dYi62BdTiN2coKNSsnx
         xpNDEphQgMWfVKO9AFO8gAqjTw9cKpjrCGWgm+EQj91jD4XmGukgUZHD9i612Q0rG7Yo
         l6PaPUYL5mzWeFcAOWtB+6oYFiwyHi1AXXx4NTcgu+KT5jLEc/vf0gqys11jQGhQQG0X
         A+kUacfP96LCrZ/oTIckExCmXBU7BUz7NYe39Ix6TavgNZ6hXkNvuJ3+MUUFOFx+hfCn
         fcHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0WavDbiXhuA03gYWGSNa5oKNFEZNZYp50LoM1mwUDtY=;
        b=1b+6SDPJFrOZfvuUjqvVD5VZ6uD00PPF2WRRsEKjE+ruNZVF8QhShVoXM9LB7GxA0J
         xfd6SmMx5Zl8FSA9Jy2CGx8qKGHAhTHhH8D30YBYm9bTKmEJUrtpfeUpHlzElpgcmnda
         AaAgIQtDhAniDXvtjoue10kSJCMd1F/gwF5QfLWnq0if8V0w3u3Z4ZvlGvddqXWIxpWV
         eGxNLvAWu9EVGZ5fw2uvln5foTWcPvF3HJNNsp2WSNlz1xAGxVb0dWXg5m2LuYxW9m3g
         jBEGpPtWq3/aqLeh/Hb5ue4xcAZ9qRc49j1/B0MwC9xhQoZC+LQAujoKbYv80nrEuWcG
         4ryw==
X-Gm-Message-State: AOAM531ltNL4umC0d71RCTnspFQFz/brf3jS9BQKYqCUCp4InTNhuaBJ
        DYsjWH0LkP0mvpQaJ7S3dhs8Aw==
X-Google-Smtp-Source: ABdhPJx8xBnOvSAnfruFGMB1nrLzSkHHCOYgTXNbPJc8IxD/rELkJfKx7W3wI8haHGPI2z61qY/HYw==
X-Received: by 2002:a9d:5d12:: with SMTP id b18mr1356048oti.168.1643260309053;
        Wed, 26 Jan 2022 21:11:49 -0800 (PST)
Received: from [192.168.17.16] ([189.219.72.83])
        by smtp.gmail.com with ESMTPSA id g4sm9070849otl.1.2022.01.26.21.11.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 21:11:48 -0800 (PST)
Message-ID: <ddd3f2e1-ed1d-82ce-cc8e-562be2ae5152@linaro.org>
Date:   Wed, 26 Jan 2022 23:11:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.16 0000/1033] 5.16.3-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, lkft-triage@lists.linaro.org,
        linux@roeck-us.net
References: <20220125155447.179130255@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20220125155447.179130255@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

We didn't get the notification for this release candidate. Thanks for the heads up, Guenter!

On 1/25/22 10:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.3 release.
> There are 1033 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.3-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

## Build
* kernel: 5.16.3-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.16.y
* git commit: 39cb7e05eaf4fd55c6445fe8fe9ffa7f8d329205
* git describe: v5.16.2-1034-g39cb7e05eaf4
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.16.y/build/v5.16.2-1034-g39cb7e05eaf4

## No test Regressions (compared to v5.16.2)

## No metric Regressions (compared to v5.16.2)

## No test Fixes (compared to v5.16.2)

## No metric Fixes (compared to v5.16.2)

## Test result summary
total: 105828, pass: 89914, fail: 1186, skip: 13585, xfail: 1143

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 263 total, 261 passed, 2 failed
* arm64: 42 total, 42 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 40 total, 37 passed, 3 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 35 passed, 2 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 56 total, 50 passed, 6 failed
* riscv: 28 total, 24 passed, 4 failed
* s390: 22 total, 20 passed, 2 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 42 total, 42 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
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
* ltp-fcntl-lockt[
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
