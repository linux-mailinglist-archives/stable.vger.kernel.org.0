Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFA9AA9FB
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 19:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388702AbfIER1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 13:27:45 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:36895 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388869AbfIER1p (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 13:27:45 -0400
Received: by mail-oi1-f194.google.com with SMTP id v7so2537901oib.4
        for <stable@vger.kernel.org>; Thu, 05 Sep 2019 10:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WAmS7Uw9e8bB1PTN/jfmWoS315U1NsxPNMRijsnDbxQ=;
        b=dkqsqXNKtTclKScxZkHGZibCTePLCiDheG7n82N6Z0YAhb9MhjwtpjI9iEh9mhoiDU
         Ae48MU3pA6l7531xauvCN6OPOVMPihk3vmHbTCfvQuud1iGXxK3orhUbNvSwED/Z9s3b
         ecCHlrhxja0B5WdKnMqViByl4fTwh6wqa1f1+rOiDl1Zqc/2y71h7mqjEGm2iLz3PTYL
         Sa08p5tS7vDvwkUqcyjt4eTIegsJPLA2LFKJPt3Lp1436zd2UtBsC31FdiX7OibZIsx3
         u+4tSqOrs4lGkwJytUMVIm4i4Uao+/cpbkPytXDZJJ0cWsumxQLyAA2bL+/elpwlU1cx
         Z2kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WAmS7Uw9e8bB1PTN/jfmWoS315U1NsxPNMRijsnDbxQ=;
        b=GzL7dUrTsXdBU3KRq8wcxbb1YvOOmCXXFER7Cmtkr2b1y9qYBohJOSCaaR/dpZUhAy
         lsNYMPMG4Sce1bnJ45+ifri1muwDO5/z/1GCA+jehYXdJ08VR7vn5supPSOXUpN5QQ6W
         DPKO6DosKmgjYQ/gkm1x7odXShZdRM/j+BC4Y0Vz17SMezZDcALRvr4LWbHjbzfY81xQ
         d8x0gfrFbgq+kn6/bVz6kAZsLoTF/WnPX1zX/xGUB31TrsLlqzf2WltGcK04bi+cNqG9
         IXRzgn7Z1CTX2F0IGtzIM0jJmpMT6JP8O/z2wXWC/H4DpcS409+28tQHaWwp1NiBLQWz
         8O2A==
X-Gm-Message-State: APjAAAXIaCcT3XTZszYb5Ok1HOuPV8KfW8eVlM1z2g/EKmUp/r8BgoHY
        w58PGtErp62CuQTATeWG2OBGQXL679sErQ==
X-Google-Smtp-Source: APXvYqzf61sR6IMOtL4FYHi37t+VAq6FMQiw2rdkpaDYnlAlDO20X/MzR54nMXzKFdu7sk4J21N5WQ==
X-Received: by 2002:aca:416:: with SMTP id 22mr3365398oie.93.1567704463807;
        Thu, 05 Sep 2019 10:27:43 -0700 (PDT)
Received: from [192.168.17.59] (CableLink-189-218-29-211.Hosts.InterCable.net. [189.218.29.211])
        by smtp.gmail.com with ESMTPSA id z16sm628100oic.10.2019.09.05.10.27.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Sep 2019 10:27:43 -0700 (PDT)
Subject: Re: [PATCH 4.14 00/57] 4.14.142-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190904175301.777414715@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <781333c7-645e-548d-28f8-cfd00779e5b6@linaro.org>
Date:   Thu, 5 Sep 2019 12:27:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190904175301.777414715@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 9/4/19 12:53 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.142 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 06 Sep 2019 05:50:23 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.142-rc1.gz
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

kernel: 4.14.142-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-4.14.y
git commit: 39a17ab1edd4adb3fb732726a36cb54a21cc570d
git describe: v4.14.141-58-g39a17ab1edd4
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/build/v4.14.141-58-g39a17ab1edd4


No regressions (compared to build v4.14.141)

No fixes (compared to build v4.14.141)

Ran 23684 total tests in the following environments and test suites.

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
* ltp-commands-tests
* ltp-math-tests
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
