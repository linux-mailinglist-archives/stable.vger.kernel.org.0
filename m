Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5A2A3F7D75
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 23:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbhHYVFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 17:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232123AbhHYVFh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 17:05:37 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAEC8C0613C1
        for <stable@vger.kernel.org>; Wed, 25 Aug 2021 14:04:50 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id 61-20020a9d0d430000b02903eabfc221a9so758861oti.0
        for <stable@vger.kernel.org>; Wed, 25 Aug 2021 14:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=36Q0ofkarUnJnasxqh9o7dRjOpQp4XtGsHLoQ13K/cU=;
        b=kenzZ4CaHQobjrh5fP5Fvb/w370ER+9E6MBxFPIYmN922+5zScpqsivh+7h0F1dpK7
         +R8xRFaL3SWIBcFSUDDNWXXCzEqXPvHg4J1WbfSFhkhXg+Yg/HC6jrtI9xORlQMH1Nus
         iKmMoX9Tmm6pbf2OzG8Ir0kJC46/Ty/Trt/exLP3AZWBDe7GzzrSZb9O1zwnOFcvtM94
         6rSqW4SNwPaKFZjSoVYn1TV+D5i4dbYlE50EyZo50QEir877/CHHuVOFfybqPfKb2NHl
         /QI60urtFYcoZkEVPHVsQKhhhqnKpcugOIfCtz3ec0wCyUeBuf4s6UNiw9NX9l7d2kKp
         +Q+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=36Q0ofkarUnJnasxqh9o7dRjOpQp4XtGsHLoQ13K/cU=;
        b=dduFJvKtZQ9gdm9k9MncB/PY3qfOSuot114s5O7RykBM5ThyJH9lVqlq0oqL05bvWH
         aYdmD4HEZvl9z48vWZp4W8AMfVcsatETV5eScUOHY2hXT4zK501z+poNyX3ZXyJmJAIi
         T5FUHFxbMjOM8rdwVw56Tb0YAFyn2UQunO6vNfqAxEsRwwfqDWDfTu2vam1B2W+goNaD
         NcrHib+/f4j3j2ElxUB+wgzjxMncLdfiDl73XFAWSfk9ThzJ+bcwR0pITxNsQrXFp1Lr
         5TP7dllJZ6pqQOoUCplLMHE5hRtRWrQucApZ5zQhhD7Gf081SZcm+ndj5y2GTyXoefUm
         9M/g==
X-Gm-Message-State: AOAM5336g2Yuh8DEhm8JSZwZu3h9I/zDaP2B+FPeIFhUe/Lk6iAuor2Z
        AsHaW41LCJ806F90uvReG4rFZg==
X-Google-Smtp-Source: ABdhPJyV9BpFyupdvgbeGmXPlyP30XWPbBhiEOHeNRsGn2qnaIM+GvSzMK2zixJeysZcBB2fo5FbdA==
X-Received: by 2002:a05:6830:40c3:: with SMTP id h3mr362666otu.198.1629925490188;
        Wed, 25 Aug 2021 14:04:50 -0700 (PDT)
Received: from [192.168.17.50] ([189.219.75.147])
        by smtp.gmail.com with ESMTPSA id u194sm222292oie.37.2021.08.25.14.04.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 14:04:49 -0700 (PDT)
Subject: Re: [PATCH 4.14 00/64] 4.14.245-rc1 review
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        akpm@linux-foundation.org, shuah@kernel.org, linux@roeck-us.net
References: <20210824170457.710623-1-sashal@kernel.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <5f617100-b060-b176-f26b-00871cbb1834@linaro.org>
Date:   Wed, 25 Aug 2021 16:04:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210824170457.710623-1-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 8/24/21 12:03 PM, Sasha Levin wrote:
> This is the start of the stable review cycle for the 4.14.245 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 26 Aug 2021 05:04:55 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-4.14.y&id2=v4.14.244
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.245-rc1
* git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git', 'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
* git branch: linux-4.14.y
* git commit: 156fc46e6ef4f9c0821f84a6b7e5f60647b6cbf1
* git describe: v4.14.244-64-g156fc46e6ef4
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14.244-64-g156fc46e6ef4

## No regressions (compared to v4.14.244)

## No fixes (compared to v4.14.244)

## Test result summary
total: 65609, pass: 53110, fail: 525, skip: 10267, xfail: 1707

## Build Summary
* arm: 98 total, 98 passed, 0 failed
* arm64: 28 total, 28 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 15 total, 15 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 36 total, 36 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 15 total, 15 passed, 0 failed

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


Daniel Díaz
daniel.diaz@linaro.org

-- 
Linaro LKFT
https://lkft.linaro.org
