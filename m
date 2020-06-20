Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B0B202133
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 06:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbgFTEJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Jun 2020 00:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbgFTEJL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Jun 2020 00:09:11 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD835C0613EE
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 21:09:11 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id u23so8884896otq.10
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 21:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l9K8ae+lidtyP5UW9uUxlzFHevmMqcLSZnLDpYLMTFE=;
        b=WLLHIkUcEj/EblWurrwwuMxHT6siwfMLCeM/oAufRIUTFaBrC2nwASuaTS/GC2TR3x
         0zhi4vnqVKnSXzsKitGHhoqlYnwgIG5f46bRznMTMjhbPcCE2ZLV04ahlZPe8leBIbWo
         lknb+3Ui8/LWH+oUNeODjwr4twwQfldfD+QzlC/aUBkcEFCB0BKwBLOaS5QJHjlULOAM
         hc39aCZFpevSO+GabqG7OZLtQaxfOvlCNm0mSQ/UPDseq74GjswhkSnFw3DZHumSsU0+
         qS7ZUgLPuBqOYm0jJVyzzzIeUZP/dYb6NtoeF0j18V44XERwoL9hLUIw+TAryEmeOHen
         xTQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l9K8ae+lidtyP5UW9uUxlzFHevmMqcLSZnLDpYLMTFE=;
        b=Z86Eef3gp42woXDreYAKNmC8rKpHZ8KZ1lPnh66yxEKU5tdlmrgaDBWblXVarV79Rx
         2Vxb6CegoS0KE7/7NroHE1Yud7OFca1K6cNocKmdfnmls7aqK50qumglEIfD4j3OI7cj
         5+Y2KLf9FYkDHZ4G5YRlfvITZAzr/nRlIT9CKb+UsmYl6iuzTaKfRFFj7MhNUZqU1NMT
         BG5DoaFoY8gVxbjB/0b5DF3vbCryKB2Ag8p5W8d/QnHWmVOyJSS7r5WWVY/CSiza59oQ
         ScJMjT4qgYHSbTY9UYhmnZRL6uqoR6nDidj1J1hj3a3nt9kW6mcafkMfBPRq13edbi5P
         UPqA==
X-Gm-Message-State: AOAM533c/ZnvhMcFIS/c1egPcEeA9+cP2ZU0XybO7Iyove5QhD+pajU5
        uWIBiXaEaofropew2Q393sZLBNk3z5AaolBI
X-Google-Smtp-Source: ABdhPJxNyiOETnxWNWj6BhThnhrjVRFWpY+PAc4gJDUsVoJ+NpVn31fvhb8Ea69z65L06x9/lUsgUg==
X-Received: by 2002:a9d:1445:: with SMTP id h63mr5495105oth.32.1592626150749;
        Fri, 19 Jun 2020 21:09:10 -0700 (PDT)
Received: from [192.168.17.59] (CableLink-189-219-73-211.Hosts.InterCable.net. [189.219.73.211])
        by smtp.gmail.com with ESMTPSA id v132sm1702345oif.6.2020.06.19.21.09.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2020 21:09:09 -0700 (PDT)
Subject: Re: [PATCH 4.19 000/267] 4.19.129-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200619141648.840376470@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <ec4b0b96-5d1f-448d-5f3c-da58ea07368a@linaro.org>
Date:   Fri, 19 Jun 2020 23:09:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 6/19/20 9:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.129 release.
> There are 267 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Jun 2020 14:15:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.129-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro’s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.19.129-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-4.19.y
git commit: a00c59b6375644f707a3554536d03d4ecaf17c05
git describe: v4.19.128-268-ga00c59b63756
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/build/v4.19.128-268-ga00c59b63756

No regressions (compared to build v4.19.128)

No fixes (compared to build v4.19.128)

Ran 34131 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
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
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net
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
