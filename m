Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60B96CE95C
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 18:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbfJGQhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 12:37:07 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:44543 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbfJGQhG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 12:37:06 -0400
Received: by mail-ot1-f66.google.com with SMTP id 21so11499310otj.11
        for <stable@vger.kernel.org>; Mon, 07 Oct 2019 09:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IZLWASCjbu6D/P+ZICftXZeMrq/yAGXEHUQsfndiqNQ=;
        b=Ege9LyT2tOY9wE7hQ5zQr5KhCevVdL0L9EeqjZoxWdaoQsjwlJJr+fWYZ3MRouDy71
         61qyMgC44wt82yrVC/gs1TyHwUYNKR/Cw86VN3P0UoPLjebaYTWCYUhV6K2+03wT5GLS
         arUx/S5D6NAplPdNu+hk5Mg4jyJvKZTW0PlDfqChIp/3rKYI4ll7GOGvINjMWPSwigKo
         9HdrLPhS10dq09/i8IlSmxVmkD1HPDUtwycEP9tAMqXZz9JprDLddCpCHJDQctVI1Yft
         GJ6Z9uzoy1aZEvNIPsULUFPa1bQsYUwZGeDKQSnWvGAMG6oMgnRTgr22u04hsaNmeWeT
         3RHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IZLWASCjbu6D/P+ZICftXZeMrq/yAGXEHUQsfndiqNQ=;
        b=B4os1yJSv+rLk/fliDzX6xFgSjGnTd536RmaO4kOoOo2/z++d5nfaa3foc/ZJ0DGWj
         fgNN18KWDrKoa1tUg5UsFbuiHwgXSjY9OTeIm93psIpUy3uK+eAIkDYzxgMR9f/Aj2D5
         WMV5AZB2BR6erkqPSZfL19Uo0evJhpCaYCXyJEnTU7SSOX0Tvg/XRnCoZWHYc/SLXg9X
         XCP4zTk9UMGZR289IRlVn5vMRGzEXY6UoJ9s7Rlr9BSET/3lqiOd7f1Q0MRfYtELVd+J
         wkH2kxVQyufptC/fVbalznCVS5yM2SikGmFg7tt3SONgKWkx4skp5uaqWJCZjxUIma7D
         xJ5w==
X-Gm-Message-State: APjAAAVUrNtcREI42+9J//EFh84E/o1xfwsoS/TXOqDPY9S9bHps4Uwt
        WFIIPo/5mHgOyAAN/XxgsqzIXT3EnE35Lw==
X-Google-Smtp-Source: APXvYqxeX+GkedQBIlrnuDolFQSEic6i804WIcVagavp2bVA6UvcVs7eXpXNMsjmwLuWElyQBf8Cfw==
X-Received: by 2002:a05:6830:14d5:: with SMTP id t21mr13122141otq.352.1570466223690;
        Mon, 07 Oct 2019 09:37:03 -0700 (PDT)
Received: from [192.168.17.59] (CableLink-189-218-29-211.Hosts.InterCable.net. [189.218.29.211])
        by smtp.gmail.com with ESMTPSA id m25sm4428432oie.39.2019.10.07.09.37.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 09:37:02 -0700 (PDT)
Subject: Re: [PATCH 4.4 00/36] 4.4.196-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191006171038.266461022@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <785ba642-2e01-2a1c-dd33-8d39c18bb90b@linaro.org>
Date:   Mon, 7 Oct 2019 11:37:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191006171038.266461022@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!


On 10/6/19 12:18 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.196 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 08 Oct 2019 05:07:10 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.196-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro’s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.4.196-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-4.4.y
git commit: 13cac61d31df3572c7a2c88f2f40c59e0a92baf2
git describe: v4.4.195-37-g13cac61d31df
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/build/v4.4.195-37-g13cac61d31df


No regressions (compared to build v4.4.195)

No fixes (compared to build v4.4.195)

Ran 18597 total tests in the following environments and test suites.

Environments
--------------
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
* kselftest
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
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
* ltp-timers-tests
* network-basic-tests
* prep-tmp-disk
* spectre-meltdown-checker-test
* kvm-unit-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* install-android-platform-tools-r2600
* kselftest-vsyscall-mode-native
* ssuite

Summary
------------------------------------------------------------------------

kernel: 4.4.196-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.196-rc1-hikey-20191006-575
git commit: 49d2751d5f3cdb81b162d5c1f7ffb0fe210f005c
git describe: 4.4.196-rc1-hikey-20191006-575
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4-oe/build/4.4.196-rc1-hikey-20191006-575


No regressions (compared to build 4.4.195-rc1-hikey-20191003-572)

No fixes (compared to build 4.4.195-rc1-hikey-20191003-572)

Ran 1520 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
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
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-timers-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance


Greetings!

Daniel Díaz
daniel.diaz@linaro.org


-- 
Linaro LKFT
https://lkft.linaro.org
