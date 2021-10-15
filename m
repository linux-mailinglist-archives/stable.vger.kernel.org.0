Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E98442F819
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 18:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241277AbhJOQaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 12:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241310AbhJOQaK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 12:30:10 -0400
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08927C061570
        for <stable@vger.kernel.org>; Fri, 15 Oct 2021 09:28:04 -0700 (PDT)
Received: by mail-oo1-xc32.google.com with SMTP id n15-20020a4ad12f000000b002b6e3e5fd5dso3158999oor.1
        for <stable@vger.kernel.org>; Fri, 15 Oct 2021 09:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RgIDQ0FG20osRDpTRNFAIet2HylHqSSCsjU4120MrAI=;
        b=PllHVHZMs51VlTKRux3tLKSSyB/q8Xv5kEQu9HCq45HdyBVISFlGgwGCI+WOdI9Umj
         10KyNhvTKZzbdirzK9rpF4ZdGCW8ZmhEqigSizPcRcOq4DeRZgItB4/dMPQFU5KbJYFL
         AcDInzdpv7XjujbIzyBcvGhfxH6Mvt6O0gFp45zqipwCcEsmMRJfqF6jv7/UBxviKKsk
         zCbmTQWx0HDH/JpFHS3e7+8wXL313lLkTrXm+dg0gHF0u5/9RkQbGnOEwh8CQdWoXKcz
         M+KT40gEbItZY7f1aKH0Bz0ZwlTqW9vkXydsDgT0tyAilzGw7k8X4dBLuoMPmG32JVdF
         0HxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RgIDQ0FG20osRDpTRNFAIet2HylHqSSCsjU4120MrAI=;
        b=FK2URrknwlFP1WKFu8XxgGyw5+IDco2QZNMJspOZD6tsjGhgGoIHAUS/Q3ab5INAQw
         hnmoPc3JsFJxjDPcmI9XFyk2crZ4qFRTIrmgPKziqRvzJuZG0qH4b6DomqbiOvGhPxJx
         2ylz1YLrKU2j8tV9Plx9v2Neuc99kR1di7ywTjWeireOpTlJJZgqHGyUCgRkQ9RX+xRr
         WzdY9LQctEla/f4LIvjLDWHH1IDSwyDcGEowWjgBlnvpVbtRMJYdOvaiJtpHF0DptJwv
         6E+Em3e5U/XQfOMuGMktAxq1DicXtcy/TivUcrm2f9/TvQOcU/iIwDKLyM88I1n2DS6C
         LFfA==
X-Gm-Message-State: AOAM530DkUXnroaSkRjPu5KJDHXswtqT0UmMj2yJQRrkvTRSWy1zhxPF
        GWU0KYqmBoEsAtNGT/TrW4nUDh2gYV708DYO
X-Google-Smtp-Source: ABdhPJyXO5Y2cCfWU5uq3Q2vd2dUzS2qs+KvKHyLrYjXEBRhkXaq73F7k5W5kTQgK3kR7rMO1pg7YA==
X-Received: by 2002:a4a:e093:: with SMTP id w19mr6596702oos.63.1634315282423;
        Fri, 15 Oct 2021 09:28:02 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.72.19])
        by smtp.gmail.com with ESMTPSA id bf3sm1251401oib.34.2021.10.15.09.28.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 09:28:01 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/22] 5.10.74-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     shuah@kernel.org, f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
References: <20211014145207.979449962@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <dc5be9a8-5e5e-1070-758a-d18f8c8b6af9@linaro.org>
Date:   Fri, 15 Oct 2021 11:28:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211014145207.979449962@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 10/14/21 9:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.74 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.74-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.74-rc1
* git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git', 'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
* git branch: linux-5.10.y
* git commit: bcc91adcbbcd65b4413d295cb433daa73ffa3700
* git describe: v5.10.73-23-gbcc91adcbbcd
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.73-23-gbcc91adcbbcd

## No regressions (compared to v5.10.73)

## No fixes (compared to v5.10.73)

## Test result summary
total: 91036, pass: 77180, fail: 547, skip: 12462, xfail: 847

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 289 total, 289 passed, 0 failed
* arm64: 39 total, 39 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 38 total, 38 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 39 total, 39 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 36 total, 36 passed, 0 failed
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
