Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB543F7D9B
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 23:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234810AbhHYVTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 17:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234138AbhHYVTg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 17:19:36 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A92C0613C1
        for <stable@vger.kernel.org>; Wed, 25 Aug 2021 14:18:50 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id g66-20020a9d12c8000000b0051aeba607f1so696609otg.11
        for <stable@vger.kernel.org>; Wed, 25 Aug 2021 14:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hOF+sh5G76VmHpf/N2MkHcBuycy7v0DHca5nZVaJcW4=;
        b=RjCUI+jkYOpC2vwRld2S6qi2H12Y/Sa3KD/3HKULno+qBXsWZL0wyDnG3lJYWe5cZu
         3k+HB9EhiymTAjmbjwOg+RAcV9rk0ENMzOGsM6eJjKUsI2MQGdouSIvCgCc2MifsI24K
         0MnGiwIU7C8Bn1vN2wcThJvaSXdsKIbd9sT3yfYpafIL89Aq304Ri0Ryj+FDFlqxI1/j
         hg72Kq3WX/M8MXfsZvFC8Snu82XwvJ7L/s83pramPmLoyl7w4OVP9cpsBuNZAEyadwrL
         DS3BqqaqT+3wCSaCrLm8k6vtWFtH/F2H2Z6JArZhM4y5k59on7XgtRL4We2gaAwW2FoS
         ktfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hOF+sh5G76VmHpf/N2MkHcBuycy7v0DHca5nZVaJcW4=;
        b=mZH+SAPWTG21gYE+egvJMkyufwmCm4bPh4htgCpeXwI+5EzqPnRmFDHKkO5LWwhVth
         DX2Q8wxX1vSr6B0Mgz/aR4KhwqXzCqd0Paoji7DYvmFaDSj+rjyK3wY8+blY1t+pGuwO
         hNcPhiWI1bmwsW/D1547d9B+hTyxt9o8b4QJsPB3VFCey67kWu8mKGrAprC/pue/pAz5
         7vSvESSsDfV9DPBMqZNjAIn+UTn4KU1azSKhAjqBHnDUqLVsQ3MWeJ+qHEx/mqOcwdLI
         Qw1lOH1Oz84Da/e+Is16wq8VHOj4C5ajmhfxKVDaH3ybjEwxY/hBTmXwjs6+Om0C7Jxm
         W/lw==
X-Gm-Message-State: AOAM532iHIIxRZoRD++wYDeRzEAY3boFL40C87pbwz1i4+/Ewx0mSFj0
        jCZrvG+fCWfLgcqwcMj+oOzzcQ==
X-Google-Smtp-Source: ABdhPJzeXxOFFpeP1yhl0b9ZhJv12CduQnJjx/ToXvAmZG5iFS2vs4YJUMwb+UNTThCZB0X0KYgF5Q==
X-Received: by 2002:a05:6830:402c:: with SMTP id i12mr368736ots.287.1629926329596;
        Wed, 25 Aug 2021 14:18:49 -0700 (PDT)
Received: from [192.168.17.50] ([189.219.75.147])
        by smtp.gmail.com with ESMTPSA id s206sm234326oif.44.2021.08.25.14.18.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 14:18:49 -0700 (PDT)
Subject: Re: [PATCH 4.4 00/31] 4.4.282-rc1 review
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        akpm@linux-foundation.org, shuah@kernel.org, linux@roeck-us.net
References: <20210824170743.710957-1-sashal@kernel.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <c8d7c5e6-a503-3628-f044-a44181fefd47@linaro.org>
Date:   Wed, 25 Aug 2021 16:18:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210824170743.710957-1-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 8/24/21 12:07 PM, Sasha Levin wrote:
> This is the start of the stable review cycle for the 4.4.282 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 26 Aug 2021 05:07:41 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-4.4.y&id2=v4.4.281
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.4.282-rc1
* git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git', 'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
* git branch: linux-4.4.y
* git commit: a11850845e9394a250678b2ec8b714825343f776
* git describe: v4.4.281-31-ga11850845e93
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.y/build/v4.4.281-31-ga11850845e93

## No regressions (compared to v4.4.281)

## No fixes (compared to v4.4.281)

## Test result summary
total: 41546, pass: 33742, fail: 202, skip: 6656, xfail: 946

## Build Summary
* arm: 97 total, 97 passed, 0 failed
* arm64: 27 total, 27 passed, 0 failed
* i386: 14 total, 14 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 36 total, 36 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 14 total, 14 passed, 0 failed

## Test suites summary
* fwts
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
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
