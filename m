Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31554CE8EB
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 18:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbfJGQRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 12:17:17 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:42837 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727935AbfJGQRQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 12:17:16 -0400
Received: by mail-ot1-f68.google.com with SMTP id c10so11464047otd.9
        for <stable@vger.kernel.org>; Mon, 07 Oct 2019 09:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5NNDRGuw4E8tRqLZeKUWfA9igqLooVyNgv87qkHao28=;
        b=EjeOuYoSqmZwiYeNfUd2qY/pS0xWLxanV0/rTSFD1mRhKgPNxPmwontZA2gaD2cN88
         jbtL4AWa8HdsQHt0OLz/hQIqbmQsq1fCWB27fP2lTtVbjU6EMt5CQd/OqlRjpv0TNUHn
         19qoA67i7mf4UozSL3EMiiemI1eDXmkgU7o9uBTHL1n9Uu6gkFTEPbnbqLfFU5vKyqgb
         ftHbM6fTFkZBLt7m61JMTLfjoWD5qU6muyBrlVcU147g1SXkh6y9WXhWWf65buqhizDx
         kBtuy6m9QKgEWbr1hepQku5VcMPAlLKoynYzCS0AxsPw+rJNW49eNs5jAuWym5Bx95iM
         vaXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5NNDRGuw4E8tRqLZeKUWfA9igqLooVyNgv87qkHao28=;
        b=M3bvsaQIs8BMHz3NIovgT3f7Z38EWttdcFMNU6xsjFm9liOrg5Fyu3vkl7zXAMxTMc
         q6hP5FAGlh95jvVaDG9P5CBQDE5sfboktzY8R8vHsLcE+w6wLnRmGPbVeoQFBn1dHsDK
         le+d0IIwQ/LSkrJogQxdgLVRAPbXsYL47sHpI0IRT7gpdJ35ZBNZNg6Fa81x5F7/eL5U
         M6hiRj6tZOMz//j9u40iYatQsTk/63ChDm27FgaAsZ+mv8xfy6Y5DrLYaeurLC57ZA0P
         p3YE9VfNGocqJbRq9G0AUxw3+uI8gB7aTp6fd4ZYB23Eq/CtX8MeRKUmqbHWg3GxNnyt
         eG4w==
X-Gm-Message-State: APjAAAVh4JuPRCqA5cw0zzbgG59/81lgxilBY428UtrgwmUUufCQa3uV
        Hj773/a+XVqIuTaEu/1EyMiPPd7grkoUpg==
X-Google-Smtp-Source: APXvYqwcVDFwBD5fp/rl02Ofcf0tHjvUnX6Lz7ZmFDDl3APADQwmgA0AJImMmk/i2iaBzEhwJ4vB/w==
X-Received: by 2002:a05:6830:17c1:: with SMTP id p1mr22329586ota.188.1570465035651;
        Mon, 07 Oct 2019 09:17:15 -0700 (PDT)
Received: from [192.168.17.59] (CableLink-189-218-29-211.Hosts.InterCable.net. [189.218.29.211])
        by smtp.gmail.com with ESMTPSA id b4sm4336346oiy.30.2019.10.07.09.17.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 09:17:14 -0700 (PDT)
Subject: Re: [PATCH 4.19 000/106] 4.19.78-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191006171124.641144086@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <79dfbd7b-ca99-b286-04d3-dec24d5eb73a@linaro.org>
Date:   Mon, 7 Oct 2019 11:17:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191006171124.641144086@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!


On 10/6/19 12:20 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.78 release.
> There are 106 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 08 Oct 2019 05:07:10 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.78-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


Results from Linaro’s test farm.
No regressions on arm64, arm, x86_64, and i386.

Patch "udp: only do GSO if # of segs > 1" updated net/ipv[46]/udp.c and the kselftest that goes with it. The system detected a failure in net/udpgso.sh this time as we are running kselftests 5.3.1, which currently includes a now-outdated version of this test. As soon as 5.3.5 is released, we'll upgrade kselftests and this test will pass again.

Because there's no regression (i.e. it passes with the updated test), there is nothing to worry about here. The same can be said of the 5.2 and 5.3 release candidates.


Summary
------------------------------------------------------------------------

kernel: 4.19.78-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-4.19.y
git commit: 61e72e79b84d3a2519ad88c10964d7e4fa11ef1d
git describe: v4.19.77-107-g61e72e79b84d
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/build/v4.19.77-107-g61e72e79b84d

No regressions (compared to build v4.19.77)

No fixes (compared to build v4.19.77)

Ran 21962 total tests in the following environments and test suites.

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
* ltp-fs-tests
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
