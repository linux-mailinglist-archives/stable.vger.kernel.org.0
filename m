Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D8C418A36
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 18:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbhIZQkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 12:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232059AbhIZQkO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Sep 2021 12:40:14 -0400
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A9DC061575
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 09:38:38 -0700 (PDT)
Received: by mail-oo1-xc2e.google.com with SMTP id h11-20020a4aa74b000000b002a933d156cbso5189681oom.4
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 09:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ueq5zPQ0HsaVH9sy2AMihmTuD+nRcdfX9ibsOpP6KFs=;
        b=ROLCkBv8CGtqDCnat5cIj1IjjC8xuYvwQ2LsZgQ4J7CYBv2dSCZ9w/VcPr8JHFTZ2N
         tU5XpdZ0A2/Chdsz3Ip43V6oetf4OVTAZ7qoyKKzd/YrtmdWmJrBRNQpxTfe5td8bK6Q
         OB76bRaKT4HUaiCtiY/Ow3xLKW4VLL117laiSsoy3hrPGPn41mdEHPSyoZRIMadBbEJC
         qxTeMku1mT+6NnJ4WM19MAnfMM43DW3rOQLhuT+VCG3KK0OGLYBSCfUTCwSs8AWLB9lx
         1B//PvzNhiSChsRquQRrfVRo6C04dJ8Xb0zlmoTark+3ICL5Xxzvc2iqQdyWXAIhfepp
         pueQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ueq5zPQ0HsaVH9sy2AMihmTuD+nRcdfX9ibsOpP6KFs=;
        b=O4HvtmnALMBdL3q6QNC76dr8Ff+F4UwnCzlndP1xRb2j+3/b2fpyLij///cjEcpl90
         k36cp1woLS0hSinGcjfrClSVUK4sl7zKEZI2sz8HeJftSADTDRHZ6r/QbG7Pf/BSmLwN
         b32haCbPtuvwe/8OaQrSb/XjeyRZ7yqbO3ht5byjkNo6677TnPDeMlAFhhlx4E0B8tN7
         nLGwxtCuGwgHNF9KmYs1phF15wAcB8j/F7I1tAwlHYPB+Y1YA0RbUEAZsDkgpyzA+zTh
         otmT70BEACH7+x63POxtmmrR0+kU9b9CoIilDi3lq+QzRboi1ONRNe2KZ8MG2AW1tINO
         GhRg==
X-Gm-Message-State: AOAM530jlEKNrkqu421ckWA/bXsodPTphZMv/ERpZahv4+N3nAMI0imI
        YsBNk1v0tIbBQvYj8iMKk9wewO3DssJRkeZm87E=
X-Google-Smtp-Source: ABdhPJxzgXzilLrTTwp3sBsimxBtCnF+eBuMLInqVCsUGvfewaE/grOFeVsko0OgZke4q00ol2QGIA==
X-Received: by 2002:a4a:d30f:: with SMTP id g15mr16940850oos.32.1632674317217;
        Sun, 26 Sep 2021 09:38:37 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.73.83])
        by smtp.gmail.com with ESMTPSA id v186sm3592743oig.52.2021.09.26.09.38.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Sep 2021 09:38:36 -0700 (PDT)
Subject: Re: [PATCH 4.14 00/26] 4.14.248-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20210925120745.079749171@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <dbeee05f-731a-4968-de11-5ba28bb8e0b5@linaro.org>
Date:   Sun, 26 Sep 2021 11:38:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210925120745.079749171@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 9/25/21 7:13 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.248 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 27 Sep 2021 12:07:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.248-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.248-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 79e28eba79c6ddd0403c4d2433bdc46eca3c7224
* git describe: v4.14.247-27-g79e28eba79c6
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14.247-27-g79e28eba79c6

## No regressions (compared to v4.14.247)

## No fixes (compared to v4.14.247)

## Test result summary
total: 71737, pass: 56992, fail: 581, skip: 12068, xfail: 2096

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


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

-- 
Linaro LKFT
https://lkft.linaro.org
