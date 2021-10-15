Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA04342FA99
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 19:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242449AbhJOR6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 13:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242434AbhJOR6O (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 13:58:14 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8631C061762
        for <stable@vger.kernel.org>; Fri, 15 Oct 2021 10:56:07 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id 62-20020a9d0a44000000b00552a6f8b804so13285219otg.13
        for <stable@vger.kernel.org>; Fri, 15 Oct 2021 10:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xALEbjNVXyv3PrPndrIJeGhX8nsK5QlmxYjBbwJFbTE=;
        b=sneUXGAeZFYws5sYhJ932bTtUrYUrKtO+wLy4ZJKTe8GzKluV2cecpJu1HOX6ZRlwb
         snvrIXcEqi3pfR30GB0PjQve2MEd2Yb1CHhk+jLT8naIT7bUxdDfT2d+5RDWZhVNVOeL
         FT9JcqvDbhMgCDaE2FfgyX9KTwJhqJMIjxGGivmlyo9dkEtaOR1xLPzlD9aARC+6WsSb
         /9VNLInhKzg2yEDIPgarnSVzOaIKn9RdjhevVy2nifWHhodNhzYruzmEEVofVQ+UQqV0
         qDX+8IMCMbxXs+mu8+ykWN18XinqgSRtP2tUpAjNcKrflfe0zCQwyGxiOoQeEtDQZDLv
         N/AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xALEbjNVXyv3PrPndrIJeGhX8nsK5QlmxYjBbwJFbTE=;
        b=Zzid1XdqlCpyFEpmUcfcizdINkI022xm6AglO9s5YfgKv+AqjgQY/uu5LrA+VPiRiO
         lcdcSQHXfb2dBXGgzo0fGfGwls4b+CKQew5e3K52yazZNRbm174x/SiE573aGbT6ATQL
         cLsYN1YKSM55CzwQdad3gJECa2awua/PfoWtQPMK3dWQ5Nz45Fnnej6XEoMU2ggFiSdf
         v8PjBGIL/5E4GvF8IKeqwBDKscUpMxA3FmxStH3bbRuHV09NFavKiAdPV01tuYvdijO0
         1P888BiFvC5Ztmo7Nlnn//mzWGrKB+Cu6OAWjAfSL+ZMdPiBiM6pG0ZZ+JJLvOssaZLF
         crFA==
X-Gm-Message-State: AOAM5337b/WwfmGOu04PTJtWMa/4/gPOwKH4YjeemMZ2OFt/xfutSrpl
        ShnkiFtSdSyTK+eB+i3tG9E4cw==
X-Google-Smtp-Source: ABdhPJxXvZcykfP6oL8sBqYYtIO4H9J3W8ukxsyqaKh70P4i4PTtn5pA9V/Q1UUlkbeZ65ieGvfOSA==
X-Received: by 2002:a9d:842:: with SMTP id 60mr9207702oty.302.1634320567190;
        Fri, 15 Oct 2021 10:56:07 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.72.19])
        by smtp.gmail.com with ESMTPSA id bj14sm175653oib.3.2021.10.15.10.56.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 10:56:06 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/25] 4.9.287-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     shuah@kernel.org, f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
References: <20211014145207.575041491@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <1481e7b9-77c7-93ca-5ac6-76851e89779f@linaro.org>
Date:   Fri, 15 Oct 2021 12:56:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211014145207.575041491@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 10/14/21 9:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.287 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.287-rc1.gz
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
* kernel: 4.9.287-rc1
* git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git', 'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
* git branch: linux-4.9.y
* git commit: 2660ee946a0246c54d930bc9fa6d2239ce8014b8
* git describe: v4.9.286-26-g2660ee946a02
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.286-26-g2660ee946a02

## No regressions (compared to v4.9.286)

## No fixes (compared to v4.9.286)

## Test result summary
total: 76652, pass: 60442, fail: 639, skip: 13314, xfail: 2257

## Build Summary
* arm: 129 total, 129 passed, 0 failed
* arm64: 34 total, 34 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 18 total, 18 passed, 0 failed

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
