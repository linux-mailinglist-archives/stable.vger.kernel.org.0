Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C28E8AA9F1
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 19:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731785AbfIERZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 13:25:04 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:35579 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731753AbfIERZD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 13:25:03 -0400
Received: by mail-oi1-f193.google.com with SMTP id a127so2542973oii.2
        for <stable@vger.kernel.org>; Thu, 05 Sep 2019 10:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=prRRMkWToJI2bk2y8u3lik5ZQgNLz/rRSFTfZW1+xRE=;
        b=rVfiUwIg5ZCp5zoSDiVXFhpuFqUDpm/sqowOzruH/p8Tv5aO+YkQj1flrXqfzRRKO4
         dWCs3dfP3n1Do0N5MqYn+8Bz5vK3R/IN9I5UEa7ryd5bxGccc4r68WQUBGoT885WCmjk
         V2shp1PcCdRZmKoqas3qNE3XsgdF9aPI18waQiMTKQ8+GWjXKXz3GKYqP1J7jr86VNEg
         wB1nMIW/4VBhbhEZarAdEHd9Vjx0gL7AQF1SCGZPtbyvDr2eqEH5C988trCNr+hjJHOV
         TtuPZRKUFcRL0kNCGVjZ6oSP2qsFA8fjqS34Td5PV3IfHAKxKVfX5brCgHa15qQ9y0gt
         mQag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=prRRMkWToJI2bk2y8u3lik5ZQgNLz/rRSFTfZW1+xRE=;
        b=aPvVi3EZMCBu1iy1Ign8IAoQPWYxnpk7CAvUrRrk+NIMt6tl2I1Y7ht3mQoMIMcbUn
         nI9tOyLON5Y6E5NKL/H7nIpN4FOX71I3lyLFBjPMQHunAu1oSQSsrSeGSfCi5+GwAcpO
         DZDYNbrwAMvkMrVQe8V/13k3P3upDmRQaSK0lv7ojg9zzN/7wq80TsXLUUV93U+c2Xl7
         QEyQ5rtIfI9U+d3dOwaBYHhz6SHhpmsNBzlqZ9bYc8C+jtNLlPKJvt9TBZzDFmQG9iH0
         NgVqcpNj18n0pAieIybz30X4ZkNE/zoAmC2EPMbiH6apo+jc+sTXSUDjZnFjdJAWgKXL
         CFPA==
X-Gm-Message-State: APjAAAUqdxhRvcS/Vh7Dvp0UG3Un3lcxMZjrgsufY0eEk4MLbmOdxlGE
        MC4IvqxzuxlCHLWeSx4ygYtB+TJrXFiyjA==
X-Google-Smtp-Source: APXvYqyj4InvlG7DmO+ETwCSJE8YGyhVeNOTYqgactH87hCQvyev+cZWGnu9dMbZsYmmyWgsE7yZ0A==
X-Received: by 2002:a54:468c:: with SMTP id k12mr3570100oic.63.1567704301518;
        Thu, 05 Sep 2019 10:25:01 -0700 (PDT)
Received: from [192.168.17.59] (CableLink-189-218-29-211.Hosts.InterCable.net. [189.218.29.211])
        by smtp.gmail.com with ESMTPSA id e8sm323924oig.1.2019.09.05.10.24.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Sep 2019 10:25:00 -0700 (PDT)
Subject: Re: [PATCH 4.4 00/77] 4.4.191-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190904175303.317468926@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <ba63522e-ece8-5de5-4615-5e96f9c0c920@linaro.org>
Date:   Thu, 5 Sep 2019 12:24:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190904175303.317468926@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 9/4/19 12:52 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.191 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 06 Sep 2019 05:50:23 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.191-rc1.gz
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

kernel: 4.4.191-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-4.4.y
git commit: fab7823b08aae873a7ab1918c9a0a5125dc89754
git describe: v4.4.190-78-gfab7823b08aa
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/build/v4.4.190-78-gfab7823b08aa


No regressions (compared to build v4.4.190)

No fixes (compared to build v4.4.190)

Ran 20009 total tests in the following environments and test suites.

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
* ltp-syscalls-tests
* ltp-timers-tests
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* kvm-unit-tests
* install-android-platform-tools-r2600
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* prep-tmp-disk
* ssuite

Summary
------------------------------------------------------------------------

kernel: 4.4.191-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.191-rc1-hikey-20190904-546
git commit: 0f182005f060ccc4fa2d14084c4a207aaa2207e4
git describe: 4.4.191-rc1-hikey-20190904-546
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4-oe/build/4.4.191-rc1-hikey-20190904-546


No regressions (compared to build 4.4.191-rc1-hikey-20190827-544)

No fixes (compared to build 4.4.191-rc1-hikey-20190827-544)

Ran 1533 total tests in the following environments and test suites.

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
