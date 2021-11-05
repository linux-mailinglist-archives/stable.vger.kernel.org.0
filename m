Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81BA8445DDF
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 03:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbhKECWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 22:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbhKECWT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 22:22:19 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1801C061714
        for <stable@vger.kernel.org>; Thu,  4 Nov 2021 19:19:40 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id l7-20020a0568302b0700b0055ae988dcc8so7858882otv.12
        for <stable@vger.kernel.org>; Thu, 04 Nov 2021 19:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tloI40ylJsVwbi4zvk8ixRYi8PdLY8g3wNJ+BLEIGZU=;
        b=O/5knYFxpQJ8mlOZMA1ZbUzO88b4wQujfNY26MOpQqGlNmxujU5Va/r54u+ISNJ4dE
         5sekvLY69bEgiIt2YoGzDYR1WVlMReMvILkkcj8M5fqwQMAr1adVxSd38zcpzNoFyBjQ
         bnKXHyXBq4ok+JvD8poBHPK4nO1kFFu5tWY64aBGv5P6RVi5g2/rAUNwwBn8Y0BUAvzJ
         nRhMdSVZav1I2bU0cZdIKF9HeGU2oT8nUopZS4t7PExWUDwC6WtapwPuAfxArpFVBQ+u
         tsiHp2QtgMFIyw6ck3CmyVv+1L7/nIWLWQMIFMekfAgd6qK3Evke2cqQ0xm2zMLlBoYZ
         oTMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tloI40ylJsVwbi4zvk8ixRYi8PdLY8g3wNJ+BLEIGZU=;
        b=PI5hBRdYTy8ukpfpPO4j+TpiBathbWePR7vW/yB4s/fu9C2Qddab3jKHLQDZWbyPYR
         XxH9bKr57pAgaLBl6hcfBpeb0Q7Bi0IJdazps2wQqfp5Nq9q8egFhx+A/5nfAFBhGAH+
         z9tqJ84IltZJIgZ/q6Ab8l+QTJaKNRN3HR0xZHVE3pj56JspNosiuAWE88PzlUGlaf5S
         /eXTUPqXkURUrVk+NebDTCStB2xmDHxE1+FGw+dLPtMzceg+NizK5gRU7ItVLtSmt2h4
         knSCtG2w1djBckvKn0NV6qC2X0X1r16e1a8wmrwv+vC5AVfWaY5W6Jv8PSR3dHI+Cd8R
         aTqg==
X-Gm-Message-State: AOAM532WgrqmtFzlf3FHNAl3uNnEGK8e+IF5+y+KZCAwElGWaHmwUHIA
        MsXVAFm6lA75rrFDzAWWdZ3Jyg==
X-Google-Smtp-Source: ABdhPJwhb9iXEt2zZJd/G+fYtPP71lGhchOue+a6DMq3iC4n1R7lc1aIGKPR8PgBxD6Ds+ywIpUdbQ==
X-Received: by 2002:a05:6830:1bd6:: with SMTP id v22mr4422166ota.1.1636078779598;
        Thu, 04 Nov 2021 19:19:39 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.75.83])
        by smtp.gmail.com with ESMTPSA id c38sm1968043otu.52.2021.11.04.19.19.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 19:19:39 -0700 (PDT)
Subject: Re: [PATCH 5.15 00/12] 5.15.1-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     shuah@kernel.org, f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
References: <20211104141159.551636584@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <318b707e-9e3a-d762-2ece-55d29989231d@linaro.org>
Date:   Thu, 4 Nov 2021 20:19:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211104141159.551636584@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 11/4/21 8:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Nov 2021 14:11:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.1-rc1.gz
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
* kernel: 5.15.1-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: feb80b14f66dd9b7c828d80089ab163ed5478840
* git describe: v5.15-13-gfeb80b14f66d
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15-13-gfeb80b14f66d

## No regressions (compared to v5.15)

## No fixes (compared to v5.15)

## Test result summary
total: 91819, pass: 78019, fail: 1416, skip: 12384, xfail: 0

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 291 total, 269 passed, 22 failed
* arm64: 45 total, 42 passed, 3 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 43 total, 40 passed, 3 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 40 total, 38 passed, 2 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 40 total, 38 passed, 2 failed
* riscv: 27 total, 25 passed, 2 failed
* s390: 22 total, 20 passed, 2 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 45 total, 43 passed, 2 failed

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
