Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCA6507D2D
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 01:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346943AbiDSX2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 19:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241729AbiDSX2l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 19:28:41 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2964205F9
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 16:25:56 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id i11-20020a9d4a8b000000b005cda3b9754aso13046798otf.12
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 16:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fbC8P7hOXMpnp+sh787eKlbgR/TI3YJiHhXx9K4eNaU=;
        b=lupH4UuTD7jFcMCP/Uq2v2b2xdK3N7CAT+zLj00cB1s1VdsTvNpSKfJnjVSxOjUw0E
         zakxxjQKp7jnDIiBO3x7eK6Vt69iyH5QtWqG5g4q011RW+y6hEt9Gos9VGP54ABT+IY+
         xvj9jXSj0W1iSLamt2ZZBdAUdpS1mlOWzHHcaJkPt3SfGWCmwsCJOZxL1QrDxr0PpiIW
         d8j42eZTkVdfW9VOhdcwJRn7D42SFnq1kQg8HZ0W3YBsZs4rK8kIW1e22GwEyb6/nyGS
         ANS+MJt8AZIRrImgKZALCwSpCYBxuk6ja2q6yCmXrnINA3B2PLQ8z+dUUvXIC13rTPct
         y/WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fbC8P7hOXMpnp+sh787eKlbgR/TI3YJiHhXx9K4eNaU=;
        b=GOHYJckSlIxLLlGnz6WlxbI26cwCssirMoGm4IucrcyrbnTBz3yoTGBNi4vr1bR464
         Qqrozaiosuqg7ZBHxhHqhmEx+HGNJ1Y+pouzBhLqmAjtAhQF4LriysDj5B/cHSwF5JCF
         F78qTSY69To5AAkD1GaQLy9fJ+mPqsAIThlDUgt/4yDt1G1TtSLOB7QXLpM42zzA41xa
         lobbuclWwO84Mgs6lJeOMxSBmJ/NBAxUPvpiilUtu+5girMALCaC5ALYB/LY1PVgwnMh
         1HPQGViYJbpYCwCD1zrenNOsC6VX3Liw45L7B+g0YifZxBTxC4rbqhiwIt8zjVpd6qm3
         P6SQ==
X-Gm-Message-State: AOAM5302t1MJfF5aDK5U067kB2TQUhy6sAI+8T245W50vZaRQrAXkeM5
        SiU0bibFDm9q7ninMipVps4jdw==
X-Google-Smtp-Source: ABdhPJxS9cRhHxRG4ymXQ/PiXn7gnutgUna8GbrralMi8i9b5uMB9XeRbwm1NFCF1fnAivE/p2gS/w==
X-Received: by 2002:a9d:7319:0:b0:601:6908:4b5f with SMTP id e25-20020a9d7319000000b0060169084b5fmr6749736otk.305.1650410755952;
        Tue, 19 Apr 2022 16:25:55 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.73.83])
        by smtp.gmail.com with ESMTPSA id d1-20020a056830138100b005cf2f29d89csm5891236otq.77.2022.04.19.16.25.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Apr 2022 16:25:55 -0700 (PDT)
Message-ID: <bc25b6b5-d202-18c5-a485-217f858fc986@linaro.org>
Date:   Tue, 19 Apr 2022 18:25:54 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.15 000/189] 5.15.35-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220419073048.315594917@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20220419073048.315594917@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 19/04/22 02:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.35 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Apr 2022 07:30:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.35-rc2.gz
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
* kernel: 5.15.35-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 1c064f1350394a38644845cd96a9ee02ab604cfb
* git describe: v5.15.34-190-g1c064f135039
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.34-190-g1c064f135039

## No Test Regressions (compared to v5.15.34)

## No Metric Regressions (compared to v5.15.34)

## No Test Fixes (compared to v5.15.34)

## No Metric Fixes (compared to v5.15.34)

## Test result summary
total: 104881, pass: 89188, fail: 655, skip: 14244, xfail: 794

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 291 total, 291 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 39 total, 39 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 54 passed, 6 failed
* riscv: 27 total, 22 passed, 5 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 41 total, 41 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-arm64
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
* vdso


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

-- 
Linaro LKFT
https://lkft.linaro.org
