Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68E863F7D91
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 23:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbhHYVSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 17:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbhHYVSd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 17:18:33 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27682C061757
        for <stable@vger.kernel.org>; Wed, 25 Aug 2021 14:17:47 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id y14-20020a0568302a0e00b0051acbdb2869so748607otu.2
        for <stable@vger.kernel.org>; Wed, 25 Aug 2021 14:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ph3rbd3VZXkqD2O3S/ggsw10ocnIzOxhUeRpv/iKwKs=;
        b=w5wZgYEvyCpFTUqoknGXeK7NuNTB+3nVFB5umpYtjM5kcJhOjC/Amub1fvuMnsMptl
         tDUDoSwqZc7DKeXPssZ09h4zLBMOJVOnMJO82X1pUBKMJk2eOfLlolSLsaSk4XpCZqHn
         A/lHnNCyEdcglE2WXuxYsn9PuPTNcNzMVn7aQBjJ+D4hZ0Q4pkTzPwNWTTKM3jI3Prf5
         NgzDgR2iVKZ+x++VnfWIfLBLGPep95SY9NGAeOOH9pXaBiJ+2k5khENfmUvLV8hQsC6E
         mLmFat55WLquc8dV9VpI1NgmfFiv4gjuYtXfUn9/m85cZLljimDv1fMaf2U6oBu3j5wN
         Vj6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ph3rbd3VZXkqD2O3S/ggsw10ocnIzOxhUeRpv/iKwKs=;
        b=Uqau1SlbiyKUkGxwU0Xc6lrS5DKkq7iBI+Ns2wieO4XLANJldHuxlaiB6Hy0mnxBIS
         KYrCBet3+2RxDSWaks3CXKFjkDRP5qLToTJipSNrKTCMfrFo4p7L73aXgo9dhly9SsX9
         JKJP5MP7Z62pQvOiNbAqFpLfJ6ZhJY5HsGIrdoLdy0ku77PZ2ZqqFubN+OIrem/gfYdL
         QGTPVvZwc+1Uv0TlZjGYYi4XLrdO/p3+fb3LnDkJzA87DnQjNgwhzjId9K7tZBlOOkLg
         z1Ay4t8AVZ9o/kiBR2woLhx6T+p+DTqrMwXepuF1o52prwBx4yR/MycG4S5aApgi06rU
         fsEw==
X-Gm-Message-State: AOAM533+sZYGwdgAoF7GCgg3l/mnPm2FUYJCgzfoq/4vWzON76DEg5zZ
        w4l4bUcSSKaXUNtSuEobUEATMA==
X-Google-Smtp-Source: ABdhPJyLm3BEwhZDTBiECPFilhJF/AHauFPb+kSxoHGC5Ef8Nkki9ZUdG3beghSMRFJqG1PgBDUktw==
X-Received: by 2002:a05:6830:20cf:: with SMTP id z15mr386535otq.7.1629926266540;
        Wed, 25 Aug 2021 14:17:46 -0700 (PDT)
Received: from [192.168.17.50] ([189.219.75.147])
        by smtp.gmail.com with ESMTPSA id y16sm192315otq.1.2021.08.25.14.17.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 14:17:46 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/43] 4.9.281-rc1 review
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        akpm@linux-foundation.org, shuah@kernel.org, linux@roeck-us.net
References: <20210824170614.710813-1-sashal@kernel.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <334c0d43-2c48-4445-a7cf-d7d480cb0609@linaro.org>
Date:   Wed, 25 Aug 2021 16:17:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210824170614.710813-1-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 8/24/21 12:05 PM, Sasha Levin wrote:
> This is the start of the stable review cycle for the 4.9.281 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 26 Aug 2021 05:06:11 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-4.9.y&id2=v4.9.280
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.9.281-rc1
* git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git', 'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
* git branch: linux-4.9.y
* git commit: 3d204357a2ed1b927c75e0166f31aa67a5d99c4e
* git describe: v4.9.280-43-g3d204357a2ed
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.280-43-g3d204357a2ed

## No regressions (compared to v4.9.280)

## No fixes (compared to v4.9.280)

## Test result summary
total: 63783, pass: 51053, fail: 476, skip: 10349, xfail: 1905

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
