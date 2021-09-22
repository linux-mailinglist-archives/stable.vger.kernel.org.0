Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265334140E0
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 06:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbhIVE47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 00:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbhIVE47 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 00:56:59 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D74C061574
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 21:55:29 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id w64-20020a9d3646000000b0054716b40005so1832509otb.4
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 21:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rS7wYg+k2qkJTf9LoZ2Y1KvDFNhX5Y5oUdxqZyMUCyY=;
        b=TYr2DfbFcrMgoti7KsL8Mweaoba9xsjypq8mMKClf8pvGgrihbaPWuieabZbvc+fFs
         uHy0HSOwamPqBpHh8Cwo3WAl15DnMQdPstgMer1VsA51YOBbjTAuklmLphM+KH2GKFDP
         CZMKApN713JuXaugkVTqSuZUKPyrgzHDAk1JPuFMk4ilbB+r/t8q1tusgdA5YenrX+DH
         X+CUU5szw5Lt8lCqgCWeT6qwTMRNtkJhP5W8eD7PZvYIh1KFjNdXoVbqngUm94U+47Az
         /kag2VyN78ZEzvBz28AUGyCcEcOBqCwLHxtYF8bBbY5tC5BRHOm2W+r/hXudmO8xDw7Y
         QX+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rS7wYg+k2qkJTf9LoZ2Y1KvDFNhX5Y5oUdxqZyMUCyY=;
        b=h2ZzkTU6ncsunVzN0B/XMidUcz+/e8nCsW7EidZf4e5te8LuDXT9d9j+2xuNihke4+
         1Nm84CrHuvJvmRSEvcS5sCg/3jLkyz7COv1u8sskuRrp6cQEJ5Qax5a/PqrPIK2vXilN
         ltuclHkrQoyxoOVHXKy/357ELucu6PcaTec7/3MXKFdzhrq8jRsJAbTP9jbo76HJbLuT
         k6jc6Jb6cVDSQV3jmBPxNZQ8cEsFM142m24FWbXV4XsiP2Svp22iqB7KTQ0G4tmnVCXe
         K7Eadax0sSUbFr1GN910KGLI8m4U1DhAtI2M307eLbW633cC9UAN/au3hZZ1RBuleVeg
         NzQg==
X-Gm-Message-State: AOAM533ogD5MEdX3eZCXcdvzu2/VeU99Cku8YYMnlXyV//pkaZyAiN/y
        Khki97EizUZoZhDoEkVy5ygwuQ==
X-Google-Smtp-Source: ABdhPJxMJ+sXiTxxVXzLyJyn1DMeQ1GrO9Nz6v++lLnmB0jAEb7MqHFjPUf3piNd28oJB2D478+/mw==
X-Received: by 2002:a05:6830:2f5:: with SMTP id r21mr10173770ote.384.1632286529225;
        Tue, 21 Sep 2021 21:55:29 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.73.83])
        by smtp.gmail.com with ESMTPSA id 8sm60465oin.33.2021.09.21.21.55.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 21:55:28 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/122] 5.10.68-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     shuah@kernel.org, f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
References: <20210920163915.757887582@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <a9ff4972-335f-5a3d-221d-6dcc294cd233@linaro.org>
Date:   Tue, 21 Sep 2021 23:55:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 9/20/21 11:42 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.68 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.68-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

## Build
* kernel: 5.10.68-rc1
* git: ['https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc', 'https://gitlab.com/Linaro/lkft/users/daniel.diaz/linux']
* git branch: linux-5.10.y
* git commit: bb6d31464809e017d8cfd65963f6e802d7d1c66b
* git describe: v5.10.67-125-gbb6d31464809
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.67-125-gbb6d31464809

## No regressions (compared to v5.10.67)

## No fixes (compared to v5.10.67)

## Test result summary
total: 164462, pass: 138894, fail: 765, skip: 23000, xfail: 1803

## Build Summary
* arc: 20 total, 20 passed, 0 failed
* arm: 578 total, 578 passed, 0 failed
* arm64: 77 total, 77 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 75 total, 75 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 102 total, 102 passed, 0 failed
* parisc: 24 total, 24 passed, 0 failed
* powerpc: 72 total, 70 passed, 2 failed
* riscv: 60 total, 60 passed, 0 failed
* s390: 36 total, 36 passed, 0 failed
* sh: 48 total, 48 passed, 0 failed
* sparc: 24 total, 24 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 77 total, 77 passed, 0 failed

## Test suites summary
* fwts
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
* prep-tmp-disk
* rcutorture
* ssuite
* v4l2-compliance


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

-- 
Linaro LKFT
https://lkft.linaro.org
