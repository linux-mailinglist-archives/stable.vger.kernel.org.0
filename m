Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 154A44140DD
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 06:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbhIVEzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 00:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbhIVEzf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 00:55:35 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644C9C061574
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 21:54:06 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id c6-20020a9d2786000000b005471981d559so1816795otb.5
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 21:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DbIwczMNo80m2PE3x1B+uVOpZ5mKT2TGPWeExC51bDI=;
        b=qnqPB/dTkceEK9+X+hTr68Tli4FtBAh+4r0Z2/lSyeeNzxqAT/s+uECdF7Euyt5JTP
         o4ID1VI4DBp7wz32a5mZPDdS2OdPr0LqeW8sWOr90wEspzq8RWjmectPTtn4nS8oM6gX
         K0DWyZkJX+rkm51emHvS+20rtM9VVe7JHf9Z3SoLOqHTCdpJ/vTu+D5/qBS3P8LEpbGJ
         7ASSnltaSKRvXmp1HoXyb+bKgjUAPfmE5IPrpipyoJXkOlN6HNdB7FQA63MkBoP/iMep
         2p+B9OcvFBhX2iE1QkEnGgaqb2UnQ28P3HQ6QxUp/1dqSN6dMh3PMNLl1X7nPw9m6W01
         vT8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DbIwczMNo80m2PE3x1B+uVOpZ5mKT2TGPWeExC51bDI=;
        b=j7UVYzo5JgIqBWO8GzX64qw26TnLFW2ivQM03HfycU9qmMhBajSZOyKtI5vtB9ybxt
         uD21QIZIBcJVl2dbgIbUjX7WDpeCi/b5BI5pE4yc42TbI9Ko2CIK0zQ2j8zW9Nlkk45c
         MdfjOt9fieoqPd43oXW5ExtpMA8tgI/5H2pBN4HXpclDJlJOvIrcwZeWP+CRext2jM/p
         PEPu+tttEIZdBDFz6uKB+cagDhinNTlrMCRQsLehdbB11s7jiYNp5CKfaHtLBoxvAJ3I
         HxwpfN17pKtBDAnKveB73Z3/Vos8IEEYf06xfsz3wpLh9OoQrCIEFTvN/smFwojY+VVy
         DW6Q==
X-Gm-Message-State: AOAM531whb+zZlWzmcgj9naQPz20gp+lMvwR8/VqpAa7b1E4R5xvKt8w
        C0tds5nqSxo0E1xd+hsxee5+WQ==
X-Google-Smtp-Source: ABdhPJyHftI27PvCwF0Psg5FHshBVtTJn/XnPc7JGfeywuEPCe57PCX2IZXBEOUDLO8Of3YRbuWGvQ==
X-Received: by 2002:a05:6830:3184:: with SMTP id p4mr9470124ots.218.1632286445714;
        Tue, 21 Sep 2021 21:54:05 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.73.83])
        by smtp.gmail.com with ESMTPSA id v186sm290727oig.52.2021.09.21.21.54.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 21:54:05 -0700 (PDT)
Subject: Re: [PATCH 5.14 000/168] 5.14.7-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     shuah@kernel.org, f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
References: <20210920163921.633181900@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <35a539d6-9b20-c196-0838-29a2cdcbffe9@linaro.org>
Date:   Tue, 21 Sep 2021 23:54:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 9/20/21 11:42 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.7 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.7-rc1.gz
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
* kernel: 5.14.7-rc1
* git: https://gitlab.com/Linaro/lkft/users/daniel.diaz/linux
* git branch: linux-5.14.y
* git commit: c25893599ebc571ecb26074f1338ac0c642078e4
* git describe: v5.14.6-171-gc25893599ebc
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.14.y/build/v5.14.6-171-gc25893599ebc

## No regressions (compared to v5.14.6)

## No fixes (compared to v5.14.6)

## Test result summary
total: 91141, pass: 75795, fail: 1053, skip: 13212, xfail: 1081

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 289 total, 277 passed, 12 failed
* arm64: 39 total, 39 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 38 total, 38 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 51 total, 51 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 30 total, 30 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 0 passed, 1 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 39 total, 39 passed, 0 failed

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
* ltp-sc[
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
