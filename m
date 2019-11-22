Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC59107B9C
	for <lists+stable@lfdr.de>; Sat, 23 Nov 2019 00:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfKVXuY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 18:50:24 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:45245 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbfKVXuY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 18:50:24 -0500
Received: by mail-ot1-f68.google.com with SMTP id r24so7666395otk.12
        for <stable@vger.kernel.org>; Fri, 22 Nov 2019 15:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=27H/jO6SKdw07s8tpOM/t7YPYQSoPypMHF0twkAApSc=;
        b=zWYU+c/iqEPK7MN4PCsat7CWV6TkFBzCnEIpdWgbW+evuXgt6sSPT94h+lYZT40Hp1
         0k5O7ZoahttU7ehodZAR3J2z6HBUkazPu0+d5EPiiOb6L3YLRggBJhUp7hAJ15m0GAKM
         aLri4ALUHwaS3s8WeSkiyDTOpVTQ2rA8QYnIzpatkoMzr4E+PtTckq0z6+rzt6L7vVo1
         2xLerRjKiBztZ7vZuS2gm3tFqZEZX3zd3/sKOfRjqJojfRdCmm1WDiON0nxIli6pmLrq
         C9vPD7IB8i9Xt0LuqZK1tbqPbp1mA9C+r7rZa+QTN2FGPtJ5oHgqhqpmDl5I/1Li6R47
         9RtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=27H/jO6SKdw07s8tpOM/t7YPYQSoPypMHF0twkAApSc=;
        b=b8T9WDl086CY5N0BEVSuH6bPWJCHzv/F2Ga5lHV43p28VDO5Qmvcg0Ck3hju5rvSF5
         MaF8s/j9KGcUaWXSKCHB9ErPWbBbLtPshCsfxHgSZL/Db7onv1GKTdmWmUTcBk50IjIs
         DOu0bqL1eLezAKkz5rnLGUlzYT6VyJerfpR3CoyAu/sXsre5iywwaVWUwZDIHiNRqE7O
         98nUCwf5pTyWbIPgiDnjfljVdOzXOhEy7HtJE/gdI+Ou2wcnwQWQd9VTMIPtudr8VLx1
         AFPfOh1NLzwuMHyiDlGRn8WIt6MdIuuyjVMa7WrOj+WNaIZhFpNUziWRrzUU2GoA8Z5n
         wc/w==
X-Gm-Message-State: APjAAAVQEymUU5REhtVX402AyD61ZoGnRLVryTPtiDfLOCTK5cJFBLxJ
        jAu1SXqAx8BIgj5xgE+3XWS69xBMPEd8jQ==
X-Google-Smtp-Source: APXvYqxzq2u2lnwn1pwxK79zDPEX/e9BX/oWJogNe5On+lDHyRebxLrSdtLWpGcCM3pL8XF+K/Tnfw==
X-Received: by 2002:a05:6830:4a2:: with SMTP id l2mr12784544otd.192.1574466621513;
        Fri, 22 Nov 2019 15:50:21 -0800 (PST)
Received: from [192.168.17.59] (CableLink-189-218-29-211.Hosts.InterCable.net. [189.218.29.211])
        by smtp.gmail.com with ESMTPSA id f83sm2569212oia.43.2019.11.22.15.50.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Nov 2019 15:50:20 -0800 (PST)
Subject: Re: [PATCH 4.14 000/122] 4.14.156-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191122100722.177052205@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <14c62cee-f274-1fbe-15e7-3635ab7a7bc9@linaro.org>
Date:   Fri, 22 Nov 2019 17:50:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 11/22/19 4:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.156 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Nov 2019 09:59:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.156-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro’s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.14.156-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-4.14.y
git commit: d40687ee9ee01c874516a9a510f5d6a56311bd83
git describe: v4.14.155-123-gd40687ee9ee0
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/build/v4.14.155-123-gd40687ee9ee0


No regressions (compared to build v4.14.155)

No fixes (compared to build v4.14.155)

Ran 24510 total tests in the following environments and test suites.

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
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none


Greetings!

Daniel Díaz
daniel.diaz@linaro.org


-- 
Linaro LKFT
https://lkft.linaro.org
