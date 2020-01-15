Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59E9C13B781
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 03:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbgAOCIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 21:08:50 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:46615 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728890AbgAOCIt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 21:08:49 -0500
Received: by mail-oi1-f193.google.com with SMTP id 13so13909704oij.13
        for <stable@vger.kernel.org>; Tue, 14 Jan 2020 18:08:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jDYx2catry9tBFBvHCgv2zKG9qdzLhJsaTk5RfBCNXI=;
        b=aXdtgxRttHhAn0O0y4f1jl1quZwJ+kP0CRziEOHCTxzTRHxT0Lm8ZZwwy688KjrmEs
         U50Yywjt2x+YFaWmJLj/+hhcdQDOb/Hq4Dod8zdHx9VTjeEm5VUS1swK0wEnVmI7jbA7
         Kyk2mGGREx9qFhq7EtmoL+0t84qlVL+GMeKzYxqlInh58pPhgPz0UnWjA5nCnL9uTX5t
         nENwgtkVpb2GT6f5avi5/k34qF1WjR76sfU6HRgK5CPtBRBkBoEQqHmxW9gxmidVypuR
         YWQX4N6z0D3ceEI/6YNhSPcc8llo54lizUi1meqTvNh+lWFlhIVkBS8iZiGYuDqByiJE
         Vq8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jDYx2catry9tBFBvHCgv2zKG9qdzLhJsaTk5RfBCNXI=;
        b=oTI5bzCneD8uS3ZV8Lh5dx4Q0PuoCxz9KEr7yNrjCwc9+1Fj5UtwmCUZOXxB1KiBk4
         TRemMJjknynd5xR3FZmhYVFIppMMyAGKhQ5TD/nyy1KFvhVV8k+RYAi3sOD+RyWcvQpi
         8VZ3HlpwGzojaay0YzeC0hXQo+GRY7plZFAcBhhpVoeg/SDc4BFe6/hIMKdKSXh9Xd88
         /lU3acZfFiQpdtKEsQ8s7Jvoj/27FjHzEDEc9eJ80rYatWvYVvIIM36DoNmVJYwo7b1i
         acyViNogg1re4wMuH5oCPMJhDwjVtuB7zt399Wsd6MkROgsADDGpz33kLQZZmo6fUtK7
         +eaA==
X-Gm-Message-State: APjAAAVG4z7rjbmqJ7ikN1CG5Neg45bst/TFR/sv9+JR6sCj8qt4yR+p
        dBzmnRCLru2Bchg1IVmeEuqMg+OesHoOdw==
X-Google-Smtp-Source: APXvYqxtJ3Yr3HTNwR7ZmY9xWYqWEOWKDwq0khXd3KuQ6dCEqz6qcLAVcAAVxweGVAENCkJb2OiWGg==
X-Received: by 2002:aca:4c15:: with SMTP id z21mr18191457oia.8.1579054128044;
        Tue, 14 Jan 2020 18:08:48 -0800 (PST)
Received: from [192.168.17.59] ([189.219.74.147])
        by smtp.gmail.com with ESMTPSA id i3sm6044584otr.31.2020.01.14.18.08.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Jan 2020 18:08:47 -0800 (PST)
Subject: Re: [PATCH 4.9 00/31] 4.9.210-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200114094334.725604663@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <59999f8a-e70e-cc5f-e18a-c8f8ab011d2a@linaro.org>
Date:   Tue, 14 Jan 2020 20:08:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200114094334.725604663@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 1/14/20 4:01 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.210 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jan 2020 09:41:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.210-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro’s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.9.210-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-4.9.y
git commit: c5dc66fe8ddb90fc0eeeeb75880cf7caa26b6cf3
git describe: v4.9.209-32-gc5dc66fe8ddb
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/build/v4.9.209-32-gc5dc66fe8ddb


No regressions (compared to build v4.9.209)

No fixes (compared to build v4.9.209)

Ran 20684 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* kvm-unit-tests
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fs-tests
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
* network-basic-tests
* perf
* prep-tmp-disk
* spectre-meltdown-checker-test
* ssuite
* v4l2-compliance


Greetings!

Daniel Díaz
daniel.diaz@linaro.org


-- 
Linaro LKFT
https://lkft.linaro.org
