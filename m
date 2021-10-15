Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A9042F741
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 17:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235145AbhJOPu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 11:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234436AbhJOPu7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 11:50:59 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D717FC061570
        for <stable@vger.kernel.org>; Fri, 15 Oct 2021 08:48:52 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id l16-20020a9d6a90000000b0054e7ab56f27so13340163otq.12
        for <stable@vger.kernel.org>; Fri, 15 Oct 2021 08:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=q42C57tLV5Tp914UjiJoJCdY248dckvuRxQiH0ZLm6I=;
        b=AiBpbwjam3dZjuZfFcnBDOJ7EmRxXTuWGZQCBbPyUuQ+7sC84zBTNhDovxqPykFEPG
         3hD5SbKExSMvt8diyAvLNCwZcfIOV8tBhyemcn6yZERBibkm6kYuRBeZswVdb6gwnXR+
         6tH2LPFyAgEc1K3CWFg92Yu2xXVKzRqjIy1aQUcAnHp/GGx75DxpWVbSZ/Yl/H5abSsS
         V6jsmqUZI1z3ckqY8UBK/LH4V5IZtoyt7wJWXle4wv9r2j5eXf2oRu68C0/j59n9SGz6
         OfOi5+9U2nM1rXBA/a0/os/2KYM4sBnmCqF950BM5Bp9syM3nf11BIhl7lQ10dbzNbvj
         tQTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q42C57tLV5Tp914UjiJoJCdY248dckvuRxQiH0ZLm6I=;
        b=V0Cv9A3IAobHrSt0A4hMqaJ/000tv6da/aZ1vHNLEEttTjltNb7Y2AuZ94Upje67zQ
         22gImWv2vqx2S1rIAPG6/4Wh1PMrHzzWsDgvsUiNilRR02FvQP73xSik2S7zUnc5EV3b
         VsB215VnyvArDDS8zLORbBahYuRb1C6LHzLvbvn6T3a1jZLY8hNNnhBaU3ttLpqyy0J2
         elQraNPtgZqRT+vK9uZtK4ZoPnHcOGU/vRHmszlQ+9AesDe02bT5UeZb9a4d3luou+M0
         A1R3MK1A2mRgd6lfNGA82hu/dhrfTgJV+cL9OiU+jBdl0HKB8Kzs0lAzawFjduLurOuu
         bmlA==
X-Gm-Message-State: AOAM531fEPVIpLdjBrH3JSeoMLep063mRfl1NEHZyT0tvV3ZzHqeH2LX
        P6JOBU055EbyJ52v6Ao1K9bhNPsxSvGMS3Rj
X-Google-Smtp-Source: ABdhPJw3Bt+otcHC6sbEe1Pu1acGYYyaiTFtpEAG7qY0HbgufcBSFEczFm+Fu+CzmJAC6IkFKgXvYg==
X-Received: by 2002:a05:6830:308a:: with SMTP id f10mr8695681ots.150.1634312932167;
        Fri, 15 Oct 2021 08:48:52 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.72.19])
        by smtp.gmail.com with ESMTPSA id s206sm1247272oia.33.2021.10.15.08.48.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 08:48:51 -0700 (PDT)
Subject: Re: [PATCH 5.14 00/30] 5.14.13-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     shuah@kernel.org, f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
References: <20211014145209.520017940@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <aefd828a-68c0-56f2-ee05-8f7296a96c35@linaro.org>
Date:   Fri, 15 Oct 2021 10:48:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211014145209.520017940@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 10/14/21 9:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.13 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

## Build
* kernel: 5.14.13-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.14.y
* git commit: c19d5ea47e557f382c94a1b21faf3d9eb9f60b5c
* git describe: v5.14.12-31-gc19d5ea47e55
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.14.y/build/v5.14.12-31-gc19d5ea47e55

## No regressions (compared to v5.14.12)

## No fixes (compared to v5.14.12)

## Test result summary
total: 95282, pass: 80179, fail: 1185, skip: 12909, xfail: 1009

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
* kselftest-
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
* libhugetlbfs
* linux-log-parser
* ltp-ca[
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
* prep-inline
* rcutorture
* ssuite
* v4l2-compliance


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

-- 
Linaro LKFT
https://lkft.linaro.org
