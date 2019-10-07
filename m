Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B884CE913
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 18:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbfJGQYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 12:24:16 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:35919 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728081AbfJGQYQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 12:24:16 -0400
Received: by mail-ot1-f65.google.com with SMTP id 67so11503065oto.3
        for <stable@vger.kernel.org>; Mon, 07 Oct 2019 09:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tksmqDEetT4Jfd6bcd4CpCDTY6VaW//L/GCny+19DKI=;
        b=FQAlZ5gsYYHvhvHTZCVIIOg01ZFrjtBUCfVmwRGnqxN+xEPqAQXPJ9/8fiYYVHep92
         ZsTbM8QAC00qlRJ6o7POaC/6b61t4Pt/8hGEIbEH2DPo5B8QRpDSr+3BRG8BJXm0O6Dd
         C4vRMgagPe5GaE8/Q0ATUyz9r8hmMkGBsToiJ3Bxp4qKJgbTK5Q6wgUp2LweIJKWS4/7
         woPT/LtfMb/hjD9OhVahYzMe549Kl++6sM3v1SBsQcXQL3rRFDKKIJT5Nx6cNvk5Dqi9
         7sheMm6O69qs7POQIIQYBboG/5KqfxNm3l4ogSALnDtEHMfRtsC7T1yOUgfEkLgV2k/P
         58Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tksmqDEetT4Jfd6bcd4CpCDTY6VaW//L/GCny+19DKI=;
        b=DiSyzPlYzMVjgfUdQlrY47EUxlK+AAr8zryky1X9fkPkdnwD+IvDMSJ5kEh8+p8Jno
         dCgatMKoovxjrvqnVuypZZc/ofP7j+Ti6ZNJv0Tf1fhIs3wikKSc8S24MyBXKYeYaR6/
         p3RYFMiaFJzPCykHyMtDpyxmzph0eqm2Bv8AkVGYlOCQKpTUFMzuKhGe0cGFQOOpAQuS
         pmoJZHmxdOsBdBqYFf1kOiTBSCfMRLqcRsgzC50Ljy9RkBuahdOnwHcrEJndtky8pUgL
         gRyvLAjaDmrdG2cu41/5i8UgzWmBBjSg+zg0B8N6yK2sgWOlTpgTrp7JdgZGrtCWTkl7
         UBxw==
X-Gm-Message-State: APjAAAU9LgA1PrpypkTBF1BA8F3iRh2+PQ0Kl1B8b1fPuTdXMiFNuNVk
        thErZ5B84paRthH83t3/6HKtBg==
X-Google-Smtp-Source: APXvYqxrX2R8yzNecySvL0MpDJRtEb4PovYJVxS390kiE/N21puzEGCoYMy+ohW6WvYzYG9u1imv9g==
X-Received: by 2002:a9d:64c8:: with SMTP id n8mr704587otl.342.1570465455116;
        Mon, 07 Oct 2019 09:24:15 -0700 (PDT)
Received: from [192.168.17.59] (CableLink-189-218-29-211.Hosts.InterCable.net. [189.218.29.211])
        by smtp.gmail.com with ESMTPSA id c93sm4627682otb.22.2019.10.07.09.24.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 09:24:14 -0700 (PDT)
Subject: Re: [PATCH 5.2 000/137] 5.2.20-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, ben.hutchings@codethink.co.uk,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
References: <20191006171209.403038733@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <3edd8fca-9c4a-6547-58ca-c0f7275554de@linaro.org>
Date:   Mon, 7 Oct 2019 11:24:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191006171209.403038733@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!


On 10/6/19 12:19 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.20 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 08 Oct 2019 05:07:10 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.20-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro’s test farm.
No regressions on arm64, arm, x86_64, and i386.

As mentioned, we found a problem with the mismatch of kselftests 5.3.1 and net/udpgso.sh, but everything is fine.

Summary
------------------------------------------------------------------------

kernel: 5.2.20-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-5.2.y
git commit: c7a8121be8ef67066e07c79b2204dea12511b17b
git describe: v5.2.19-138-gc7a8121be8ef
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.2-oe/build/v5.2.19-138-gc7a8121be8ef

No regressions (compared to build v5.2.19)

No fixes (compared to build v5.2.19)

Ran 25451 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* libgpiod
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
* ltp-open-posix-tests
* network-basic-tests
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
