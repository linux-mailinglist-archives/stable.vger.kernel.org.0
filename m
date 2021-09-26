Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8CD1418A2D
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 18:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbhIZQdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 12:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232059AbhIZQdf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Sep 2021 12:33:35 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F69C061575
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 09:31:58 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id q26-20020a4adc5a000000b002918a69c8eeso5165539oov.13
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 09:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AbphCI5gofwis/4oqY6SJlpUQkd5Fhn5nKUVns7Jsew=;
        b=GHFLixHrP90NL/HBam1v8HcQElVHRHjNROUzX68vBkMqxs/lpn6/nqYtq7Up7zS6yQ
         dPk9oNzFZg9CyHZpbKa4bAH6NEoOmrBqJd2RBf1esOJoyH5bKpM/3c1qXcDZcA0zFVR7
         1e7PZyrJGNTBUG8zMSVM7GD9YKZ4R7N1hRYKN54S+YCVTv0Z3jQsO300WugLjN4mUt+p
         OjQDcDQJdwfNz8QmraWnButxnyxXUkqNi33wwqq/CvrbznbWvF9nGW/ajuj4n6VLpTUm
         0fMfudLUlS7pkvNt3b4YNe1DPwBLoQrOqJKlkosTlw4+5n2uLvbSRbpmgoJ8bAw8J2FZ
         +KRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AbphCI5gofwis/4oqY6SJlpUQkd5Fhn5nKUVns7Jsew=;
        b=FJ+7256iniYChkbuNNhLTMQLfM0hetHZFIFfi/AW3MPWUZZd/moEwg5GHVQslKXgUk
         uwAjzKIqjcf5Xn3s6KW+3ce3BB0RwWpQybbO5zoes6cVUQeF8MMIMM7VI7cdKe8Lq8fn
         nE2f7BrbK3y1W2as9xRzuRTii1J6CUCe/kD6XNMPfB8pgieO/kSucNUBej7V0EdT/6pE
         9KxfPTk2huXWU0ayTS+Ttq/vTmRDxjI4jagxJ7/AlnyE07/eCtvrDRwRuBZYjd3f45j4
         x05GieEVVF25+e8C0PQvH/d/EubfPFZbGPJb7gTDZKO1FrpDA5HCFtMjchgvFWPUsxo5
         857A==
X-Gm-Message-State: AOAM531W1pO2fPabFgTeSYizNykKCjIC1nfjOsMQjHbrr8j25oTjJh7X
        QV7NTD7KLSaXohKP7hkJzEQozrK0TLvMQpCR82g=
X-Google-Smtp-Source: ABdhPJz8na6HtqTVBTGIEWRMjFJvTDgXtOeu2CusmZx7qh4/Srob6Ci9j+cBRhXSrebTDc43GuxhNQ==
X-Received: by 2002:a4a:bb98:: with SMTP id h24mr2299971oop.23.1632673918014;
        Sun, 26 Sep 2021 09:31:58 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.73.83])
        by smtp.gmail.com with ESMTPSA id s66sm2590815oie.32.2021.09.26.09.31.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Sep 2021 09:31:57 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/64] 5.10.69-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20210925120750.056868347@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <08a34611-1e2c-59ba-46c9-6d266de3a4ba@linaro.org>
Date:   Sun, 26 Sep 2021 11:31:56 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210925120750.056868347@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 9/25/21 7:14 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.69 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 27 Sep 2021 12:07:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.69-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.69-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: ab0c89ed74e1e05eac9f5d704db32feee0ab1fd8
* git describe: v5.10.68-65-gab0c89ed74e1
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.68-65-gab0c89ed74e1

## No regressions (compared to v5.10.68)

## No fixes (compared to v5.10.68)

## Test result summary
total: 77663, pass: 65130, fail: 530, skip: 11165, xfail: 838

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 289 total, 289 passed, 0 failed
* arm64: 39 total, 39 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 38 total, 37 passed, 1 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 51 total, 51 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 30 total, 30 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
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
