Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6FA418A38
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 18:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbhIZQlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 12:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbhIZQlU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Sep 2021 12:41:20 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD526C061575
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 09:39:43 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id a3so22259061oid.6
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 09:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FxymKu17wSgMktHaER6WVyFen4fZKT6hBAjzd179m7g=;
        b=cm5XjwaHIUx7vdfXlo3LHHpxG7AQsRp7LiqmE1MePhVywSeTtq6/hOFktbyPbQMuqh
         IqwfjgbGnpN/P8Up8ldLVlKyzecbuDPcH8SEWFJ6i91wKMwkReEFUGKZbH49cHXSKEbm
         iayOMV1ndRXG+CTxdw5nGpz4vGxrYLx53xkslh/0ttcCNlZxQM/tGp0/B9ZvcqveG0GP
         BJ9hDO/eVkIYPYSfOJ03H7mk+HBtHjUFNJkAsPCFqcRGHTnNpqgR3S0HlV8A/B6thtO8
         8fthtIc/bejGzRjmHPPzJVEXyOMNCinIHCl8aczTkWG4CY8DKCc5iV2UWbyPCHboweZy
         JnoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FxymKu17wSgMktHaER6WVyFen4fZKT6hBAjzd179m7g=;
        b=Src3jZGXdfCbmGdp4dnRpAL1GLREFLtmPIqxSaQ/P2f1Vufrc/gltlQxvp4MLBnh/J
         y0ldqphBIZZwngkTIe9jdZdWHIcHRJoqbwK7lElIGSC4tb/VhHV2NN46SrMO/Hk3+nTX
         3tt4K2Obfmv8ev61x82vK4ZWZd76FOYJeQivvtFjpGJu5ajhQVKypYdnlqoFWc7BybWj
         YmUxwkQUSbGwhvyHqLydSTIiqnmcF/un1EmjJVTC2BVVzUdUVK0IrLN1QU2AkhgkAAlx
         CC8mKmGHxj35P5tAgzfD+Y6olt3Y85SPShUHUzouIHDKiMDeIcJyL0TE8ODuJVmDvsx7
         8f+w==
X-Gm-Message-State: AOAM533oDYQRl/+WlRYQFjCOEC1cVyCWc/Ahm5t4vlRHUfASqNLmq2BQ
        +ytFLUEfOE61xEhc15mBWBzA1brrMQHkzy2bOSI=
X-Google-Smtp-Source: ABdhPJzQtnfLF4eNi6P7d9QuCOgZCgBKS54uR+4m3xnsFTStIRnsp6DVb/A7CelP6JKPuLjPyIrTXw==
X-Received: by 2002:a54:4f15:: with SMTP id e21mr8850969oiy.71.1632674382937;
        Sun, 26 Sep 2021 09:39:42 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.73.83])
        by smtp.gmail.com with ESMTPSA id p21sm3401662oip.28.2021.09.26.09.39.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Sep 2021 09:39:42 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/25] 4.9.284-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20210925120744.599320551@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <e6a740cf-693a-d5ac-5dad-5180f0e0d893@linaro.org>
Date:   Sun, 26 Sep 2021 11:39:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210925120744.599320551@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 9/25/21 7:13 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.284 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 27 Sep 2021 12:07:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.284-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.9.284-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.9.y
* git commit: 6dde448942531bbab9d0ecc5ec19f484651427cd
* git describe: v4.9.283-26-g6dde44894253
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.283-26-g6dde44894253

## No regressions (compared to v4.9.283)

## No fixes (compared to v4.9.283)

## Test result summary
total: 73023, pass: 57358, fail: 578, skip: 12791, xfail: 2296

## Build Summary
* arm: 129 total, 129 passed, 0 failed
* arm64: 34 total, 34 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 36 total, 36 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 18 total, 18 passed, 0 failed

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


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

-- 
Linaro LKFT
https://lkft.linaro.org
