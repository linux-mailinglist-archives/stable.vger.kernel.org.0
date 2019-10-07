Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1064CE840
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 17:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbfJGPtH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 11:49:07 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:39961 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727814AbfJGPtG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 11:49:06 -0400
Received: by mail-oi1-f196.google.com with SMTP id k9so12073675oib.7
        for <stable@vger.kernel.org>; Mon, 07 Oct 2019 08:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lqdycZwAUgSnFpwK58qs3gb8tItxjMETyqFXTQ1z01w=;
        b=foJTk12zlYM7YGOv/O1ov+SYFoGnSGvv8XTyXhhbhxzcrv3GC2s9/nV4bXwKQG6a6d
         vXyL/+YICgCFc2rXboVLYobwa/Wh7i5/u6sazz0IS94L7L7WFusQ1U/QJKYT8y4eX8EZ
         OCQfNcBer+T+f5qwS77cvORv8fYSpLcxCeZF3bexDIQ2G9700IWiM4uMB/iQV1pG4Tol
         7HFWXo6QOFEFikpBqiSU4y8IUBFif1k46nZebdbzH1QK/ZFcricvvG5HF8ArIzaTYUTP
         Deo8uE66hov5s+xg9RY+yR/ZZ0Cm7bBKRTyUtW0CtQNem29WaL/gSKzx3CocDdekimBB
         ZXWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lqdycZwAUgSnFpwK58qs3gb8tItxjMETyqFXTQ1z01w=;
        b=mK1WuelDIVMn1jv7U0s0d/5220iqCuZWq7LdOuefIFItXslA4oohLry9wwfDV+mfzz
         zEQe4mXwdklwf1/q5Y14EfmPz32bwL4evGnqwRm55koi7lGmelaJEGyJJw+e1uz04AP9
         7kJ6MT1eyA4gYCaPnDj66PJ2OHkFzu1UyON9V/vmH+J76RPyHYcQm9PAFopNRl2KPr5y
         d1DRwOIvdH+Nu66G5wLO2IhC/0aGwUrO3L6/M/pXrBTFeugQIJtnEcj6woOEzcFlMPbz
         pPgnM08AVz7W34ROXpRxkhV/jBg1qUiPvayqKNmmAcH7L7Sv7JgGrPLvn91LuWYPdGnV
         Y6xA==
X-Gm-Message-State: APjAAAVotdATIlqb9SrOJ+B49LV2d1RM0xlblH/bkRjvx0DhTZlhb5GS
        +Ogk1kSdGxIEP/5HTmX1NWF8SktrsJM=
X-Google-Smtp-Source: APXvYqyLu+ZxQLtY0z98LGGU4aZ9g+j64raLKyccytCbUoZcvgofZr8J5hqnbAYA4jHmShe7+wbPyg==
X-Received: by 2002:a54:4483:: with SMTP id v3mr17723716oiv.41.1570463343919;
        Mon, 07 Oct 2019 08:49:03 -0700 (PDT)
Received: from [192.168.17.59] (CableLink-189-218-29-211.Hosts.InterCable.net. [189.218.29.211])
        by smtp.gmail.com with ESMTPSA id w20sm4539170otk.73.2019.10.07.08.49.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 08:49:03 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/47] 4.9.196-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191006172016.873463083@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <f53672a3-efad-0bcc-0cde-b66ed1172a66@linaro.org>
Date:   Mon, 7 Oct 2019 10:49:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191006172016.873463083@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!


On 10/6/19 12:20 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.196 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 08 Oct 2019 05:19:59 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.196-rc1.gz
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

kernel: 4.9.196-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-4.9.y
git commit: ce2cf4ffcd946bd02d4afd26f17f425dc921448e
git describe: v4.9.195-48-gce2cf4ffcd94
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/build/v4.9.195-48-gce2cf4ffcd94

No regressions (compared to build v4.9.195)

No fixes (compared to build v4.9.195)

Ran 21656 total tests in the following environments and test suites.

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
* network-basic-tests
* ltp-open-posix-tests
* prep-tmp-disk
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite


Greetings!

Daniel Díaz
daniel.diaz@linaro.org


-- 
Linaro LKFT
https://lkft.linaro.org
