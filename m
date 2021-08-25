Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C47C3F7A6A
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 18:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233289AbhHYQW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 12:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235089AbhHYQW1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 12:22:27 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2565C0613C1
        for <stable@vger.kernel.org>; Wed, 25 Aug 2021 09:21:41 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id p2so429464oif.1
        for <stable@vger.kernel.org>; Wed, 25 Aug 2021 09:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8fQvfIZZ8pqSEhGTsBpi6VyqU2V9n2LFFeq+H7l97f0=;
        b=b8CGPZ5tvfjvdRG4BxmX9KLWApAyIplyR9glm/HtpUHAkjAW2VvZOLSD01LjYz/I8J
         OxvKh57p4gG72QsQPDy/SrgwJgoJOSGTr5F4uTaqg3afgwH+ES1z2Z/8CV2Hxv6o+xJ6
         r64d8a5zauoTjuBugFbleqD84WocBwIaxtMDSHsmt7IzMg0ZJPDe4R8JbDlMUCodTEel
         1dE1NR43wxzfCXmdXzXOpPssKKD3tVLWPYq5RL5cigYBznRpniSCw/5doC0z7i/pcE7Y
         XpdjoSnoEGanMz+ra/Po0CKEGlNXPVPbn40Ihe7x/tAIVIriud2UoQVEarUwT2OktgyK
         9hGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8fQvfIZZ8pqSEhGTsBpi6VyqU2V9n2LFFeq+H7l97f0=;
        b=IJ7FZQ2xPFQSsw51Jops8pRfHkUzeoxnuV9y0uLn3eTaX+4pzT+mCg4BNIGHk8aMno
         HX4kfZer7dvRWuf7wS/ZdLp61xln+0r+Rl9hs70LlbLYXLdcencowISh2BbU0ZQ/SG57
         bccmj0MXbhPrEIHbdEs1a25mcj+boG8zQNsDO4sW1EGTx24HC5SSbmXidBEbRJ5hAOO2
         CDNgGiS4W+1yWxv21RajWlQsT6Nz/HRd7FoqYkrClLo7bK+2M3kN0Wvp4QWCrICvav9I
         QNyluIvl6/bDR4y5MsSxx7Ekysx9NnfKU/P3FN8q06snV/0pZImYijp56Qte/dUqafDU
         pBDw==
X-Gm-Message-State: AOAM533dA64CVlSkf9Zbr+MCrZW7w0TpRJLIWy7MQC+OouK5fxX9qlwJ
        kMXyYA2XXMK61K1VDbeKcZQGHg==
X-Google-Smtp-Source: ABdhPJz/xaEApaYOhAS3r2WU6AYrV1Fk6qUOCI9fTu85pNj+1nuMfnv5L9jfluc2KneklpTAJtzQew==
X-Received: by 2002:aca:4509:: with SMTP id s9mr7552187oia.38.1629908501134;
        Wed, 25 Aug 2021 09:21:41 -0700 (PDT)
Received: from [192.168.17.50] ([189.219.75.147])
        by smtp.gmail.com with ESMTPSA id q5sm67286ooa.1.2021.08.25.09.21.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 09:21:40 -0700 (PDT)
Subject: Re: [PATCH 5.13 000/127] 5.13.13-rc1 review
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
References: <20210824165607.709387-1-sashal@kernel.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <b4bef2f4-0c5b-527d-4f24-788d3265f5bf@linaro.org>
Date:   Wed, 25 Aug 2021 11:21:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 8/24/21 11:54 AM, Sasha Levin wrote:
> This is the start of the stable review cycle for the 5.13.13 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 26 Aug 2021 04:55:18 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.13.y&id2=v5.13.12
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha

Results from Linaro’s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.13.13-rc1
* git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git', 'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
* git branch: linux-5.13.y
* git commit: b85f43f33b05cc36ebcb5b64122a56c9fb949a79
* git describe: v5.13.12-127-gb85f43f33b05
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.13.y/build/v5.13.12-127-gb85f43f33b05

## No regressions (compared to v5.13.12)

## No fixes (compared to v5.13.12)

## Test result summary
total: 80677, pass: 67984, fail: 1034, skip: 10884, xfail: 775

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 226 total, 226 passed, 0 failed
* arm64: 32 total, 32 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 31 total, 31 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 48 total, 48 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 0 passed, 1 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 33 total, 33 passed, 0 failed

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
* ltp-cve-t[
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
