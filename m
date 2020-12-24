Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9032D2E231A
	for <lists+stable@lfdr.de>; Thu, 24 Dec 2020 01:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbgLXA5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 19:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726288AbgLXA5j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 19:57:39 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9592BC061794
        for <stable@vger.kernel.org>; Wed, 23 Dec 2020 16:56:59 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id 9so982385oiq.3
        for <stable@vger.kernel.org>; Wed, 23 Dec 2020 16:56:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jTWiCCpsDpikEglHQLMP42MD6s10JjUIBnzJLj2mBe0=;
        b=b2Vjgs2PfI6zGh4AK2YyE0lWy5Ui7yQjI8tvdFNN0HMUmCp0OPIkHERN2e2B0UgbSe
         n+n1RqQfnhZicFpd1K+mN7szWT0V/PdFvWHHMlL1EOpy+flvKZFYjMEN8qmkUCUWqh8R
         Yycjfo5P3E2z1CpGqyUo3QIzmzFDGGrmFWlnBkjfzu0GpwgV9jPXiEAatAJTnVcwxNbv
         we7b93+H5DqxPciZK+TcelbfcOde6LtrtzCFsuYz6qCHRg4OK6y+Ag/qaTwSqEkWYc+A
         DyudtSv/OKKIbtxPTwmakV79QwAozdAZepkBVM29E6xsdEyGz44w1mjee4PNWzivF2q9
         V64A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jTWiCCpsDpikEglHQLMP42MD6s10JjUIBnzJLj2mBe0=;
        b=KVuLhp7DOszQ/+gc7JgO8BTA9MYDibKx4tGUvMe8LS8d66MXDwn4tATDYD8XJnhpU/
         GxJYwdEerFic2Kg29U3gIdUPi9F8tKV0L4SWTF9IqmuvZk+Re8YDv/e7gvC/25hL5+KS
         KjBqBusO/wUGS1eZxcqn/YvkGTvvPU2D8ujtjpam8Cw2NnnQZEobzShsx8AI22+TJYff
         g/9ylyoiL9FhGl81RsNl3hnmk1jWX0Rg1uVvrjNtV/NYepiuulto8JXgXrE98Q080x/l
         cRjSC8czdjDKwFrV6EMRAdzB8ntH11mikm4gcflHCO5ClSj632V2TSghfiDhrzOeJ+1h
         82EA==
X-Gm-Message-State: AOAM5328KSsnm5wWajObpJd2jjhb6jivSF+maEuFcVOKo2SWZR+FTvtG
        RC5uBv4NvBc9v2bjLqw+Xjclvw==
X-Google-Smtp-Source: ABdhPJx8J5u590gqk6tGv8VpDVxYCPlBuEAcEwpczKqxcglx6KQiYvMBRLStEiQpmmWOzCxYGoDbNg==
X-Received: by 2002:aca:b943:: with SMTP id j64mr1551236oif.71.1608771417930;
        Wed, 23 Dec 2020 16:56:57 -0800 (PST)
Received: from [192.168.17.50] (CableLink-189-219-75-211.Hosts.InterCable.net. [189.219.75.211])
        by smtp.gmail.com with ESMTPSA id t2sm3337122otj.47.2020.12.23.16.56.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Dec 2020 16:56:57 -0800 (PST)
Subject: Re: [PATCH 5.10 00/40] 5.10.3-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
References: <20201223150515.553836647@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <60e63371-98cb-8cf0-4d23-0e1185902fa4@linaro.org>
Date:   Wed, 23 Dec 2020 18:56:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201223150515.553836647@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 12/23/20 9:33 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.3 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Dec 2020 15:05:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro’s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 5.10.3-rc1
git repo: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git', 'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
git branch: linux-5.10.y
git commit: a5ba578b52286e2a855f6b172c851d7afbf68e60
git describe: v5.10.2-41-ga5ba578b5228
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.2-41-ga5ba578b5228

No regressions (compared to build v5.10.2)

No fixes (compared to build v5.10.2)

Ran 50032 total tests in the following environments and test suites.

Environments
--------------
- arc
- arm
- arm64
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- mips
- parisc
- powerpc
- qemu-arm-clang
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-i386-clang
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu-x86_64-kcsan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- riscv
- s390
- sh
- sparc
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* fwts
* install-android-platform-tools-r2600
* kselftest
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* kunit
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
* ltp-tracing-tests
* network-basic-tests
* perf
* rcutorture
* v4l2-compliance

Happy holidays, greetings!

Daniel Díaz
daniel.diaz@linaro.org

-- 
Linaro LKFT
https://lkft.linaro.org
