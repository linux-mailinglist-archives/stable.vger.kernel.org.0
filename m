Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444EE202139
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 06:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgFTELm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Jun 2020 00:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbgFTELl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Jun 2020 00:11:41 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106B9C0613EE
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 21:11:41 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id u23so8887501otq.10
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 21:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ssy0hNZfHuOLzDs4L49vu5T6QeuXM2q3EwkxHIqwP3Q=;
        b=XmwGAL7jkPAvgYlXUBxtpTJ/9sFyrwUsR6v0TQLqniePIeX8d8C98NNAr+HtGzrMR3
         yIVlKwjYYQayzWAi12FWjfe7AaODE6GV6yPZw3eEO4cQCRB72IGbXkN4E3K9uwmdkr9A
         0z6dqdcu+/NraUHlqFnXpQOiiXGWEt6czMGOGRoQoN1coP1Xa6an532jEGjV7rOdgf9m
         agxLLGaWot7OE3yCRIcaM9uhMtM4qgoaZNZhKKCvx+vyo9Jf47jBOZQV2hpc+4C5HETg
         IICHN5+7V/J056vkHJO1tiUtlPkVOJhx++QINaAt0kfGBsD6E+E7xQYIIBBoIzeuFhuw
         VUGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ssy0hNZfHuOLzDs4L49vu5T6QeuXM2q3EwkxHIqwP3Q=;
        b=MQSmAkxnB5HEUHx9imm2jcr+rSMZ91O1+s8YR9FctE0rao8cRJCUTB5RFR3+cYm4ai
         mL9qCzB36Q5uMYQHRqZKFOEjWe2qy8p9tkbxGEzGwIYJErTYFwKO89ePVXvF8plYRYZK
         ad4nG6VSyJKUyg1HgFyVstwPt5wYk2wFt1JdIEOISnpLHqKT8psewA9b4umTB+H1n6q9
         FLMIdOh99X973SnNSeBCFSbMMgeKw8RMrS+RFSg/WlDEVK3XMWr3k+nSO+qwX/gtV+An
         SEXlonDRM5LRDJ85GF+UPhHikiLIuKCZDzYb0hEcwE/njszPuF6NbrN8Eh/A8SmKzAXc
         Q66w==
X-Gm-Message-State: AOAM532ax7POmmsCZ+PSviVUj+ID0UIDPzD6lc8lg6EBxQIqnROKtek2
        Ztx6U+tkmfc0WKsKiZ3bsI6M4DOJ4zG5Tunp
X-Google-Smtp-Source: ABdhPJzD8o+/590lILsklgEkvTO4a8EWdOEc7T3EcMbf1P/s5bFSkiP6d+AR73IggkP17Lg7L7TzaA==
X-Received: by 2002:a05:6830:120f:: with SMTP id r15mr5311766otp.348.1592626300017;
        Fri, 19 Jun 2020 21:11:40 -0700 (PDT)
Received: from [192.168.17.59] (CableLink-189-219-73-211.Hosts.InterCable.net. [189.219.73.211])
        by smtp.gmail.com with ESMTPSA id c196sm1690729oib.34.2020.06.19.21.11.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2020 21:11:39 -0700 (PDT)
Subject: Re: [PATCH 4.9 000/128] 4.9.228-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200619141620.148019466@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <a15caa3b-d17e-a4da-294c-7db81976e8b8@linaro.org>
Date:   Fri, 19 Jun 2020 23:11:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200619141620.148019466@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 6/19/20 9:31 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.228 release.
> There are 128 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Jun 2020 14:15:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.228-rc1.gz
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

kernel: 4.9.228-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-4.9.y
git commit: d0cfa25033bfd364a10be2446d64517b9deb0691
git describe: v4.9.227-129-gd0cfa25033bf
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/build/v4.9.227-129-gd0cfa25033bf

No regressions (compared to build v4.9.227)

No fixes (compared to build v4.9.227)

Ran 30512 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
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
* network-basic-tests
* perf
* v4l2-compliance

Greetings!

Daniel Díaz
daniel.diaz@linaro.org

-- 
Linaro LKFT
https://lkft.linaro.org
