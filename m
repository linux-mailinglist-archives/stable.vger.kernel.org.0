Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E783418A2F
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 18:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbhIZQew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 12:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbhIZQev (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Sep 2021 12:34:51 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89970C061575
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 09:33:15 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id 5-20020a9d0685000000b0054706d7b8e5so20989685otx.3
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 09:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WRGvAE1MJG841lcVs9Lc/ywVssaWtYuETC3mMeoJXIA=;
        b=oEY76P2WnVdVkS2gIjf8BSK2eh7Ulms/LYI/qc/c9Q97sb4D/wW1dQ1eSKfxHwKggs
         sTbhwVD+anU75aqHQvIeOH2FZwOt8kLQHVqd7+rxUgFZGF6hqvQkjUQ5emOSmFywCv0h
         98T2nKL8V+a55dfW8BU9KEVwU297kb43FR+xtyWv7BhDAkdrjZ2++0UKdWtq2Rc0ylWN
         acJ8wcUMdzncTxyxgDYMNLOxlFKcMjKfuBICNehe5YoeHjN/8rhewh2REZunW5xmke1s
         wUP2vUVnbL+m0eqHXwt6ljg91ERBSlIN21qyMjnJ1QBkgCS4Pwh8imXOQI9FXZ+6K+Ur
         ESwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WRGvAE1MJG841lcVs9Lc/ywVssaWtYuETC3mMeoJXIA=;
        b=pieU2deBL9iiNtaAe76mSf9cd3Xl3hE9MKG/8o42WwK9TFV2Pv3FbG0KPe/iZE5UF1
         IONPmcaL3wINzdwc6RVxwNrGJPXJ6LiZfkETsvbADhzAyyAxljI6asrJLjW9PBAgb5y7
         2nRdvXpQLUBp8PHr3im9NbIqgprOj5hOwSGVFURh2dpavnKzX8QIEofAkvGWFv/+s8RG
         2jENpr6UyfGl5MWmoa2PcwGBSwqk0vKw63qCylgWmuWH63wfPqp5gAxiqxPPqfh8CXLn
         /Y8cc3IZF/QBGGNr8s/s78I9lq3wU6lOFE2KBT6iZam/5zY5yuaVgBddneh6KteBkOVz
         nPIQ==
X-Gm-Message-State: AOAM531YZ623jv8EK7MKZ2TrIVUJ3X07ei/r2jzwBhmBr/HPZUC2IF6z
        WrTYON6jHtisiudBuJoAM7RvsEiRajWiCEf0Ehg=
X-Google-Smtp-Source: ABdhPJxtgXz4Cfc2xR1zW80a3+lFsuIUxUh4aKJEGMgw7PxeVsYsi27Ib18dVdJ+KC8eXRfq8zVfEQ==
X-Received: by 2002:a9d:74cb:: with SMTP id a11mr13740156otl.45.1632673994589;
        Sun, 26 Sep 2021 09:33:14 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.73.83])
        by smtp.gmail.com with ESMTPSA id b19sm3484996otk.75.2021.09.26.09.33.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Sep 2021 09:33:14 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/49] 5.4.149-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20210925120748.206179334@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <d6bf77aa-1eb3-ba46-6407-970f14dc078e@linaro.org>
Date:   Sun, 26 Sep 2021 11:33:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210925120748.206179334@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 9/25/21 7:13 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.149 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 27 Sep 2021 12:07:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.149-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.149-rc2
* git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git', 'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
* git branch: linux-5.4.y
* git commit: e9755952d24071ff6f516d4c381e911abec76d27
* git describe: v5.4.148-50-ge9755952d240
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.148-50-ge9755952d240

## No regressions (compared to v5.4.148)

## No fixes (compared to v5.4.148)

## Test result summary
total: 79795, pass: 65537, fail: 605, skip: 12468, xfail: 1185

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 288 total, 288 passed, 0 failed
* arm64: 38 total, 38 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 51 total, 51 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 36 total, 36 passed, 0 failed
* riscv: 30 total, 30 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 38 total, 38 passed, 0 failed

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
