Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 725D013B787
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 03:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbgAOCJR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 21:09:17 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:38548 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728988AbgAOCJO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 21:09:14 -0500
Received: by mail-oi1-f194.google.com with SMTP id l9so13933657oii.5
        for <stable@vger.kernel.org>; Tue, 14 Jan 2020 18:09:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PnhFTk7gqJDDaRK0lVEnnUphNHafM27m921+CgXfNnQ=;
        b=TFs6jg9++wnWwlTtKX6QArUnBqNWH27qPClWUnPpLwo+7VcQWJ7mTjUkH/qvEX/Oo2
         TKDDYs2Li6C/NXiMogqSDcsE4NhZrtyaPBTdWELsJBze5N5eKCe8xJcD0dvQ8IvKZfHq
         8HzWH2Q9+ONGmwnJfX/uTRWqOZjQ2GrOpWR60QUUssUhpR4v2wimnFkC1GEwjyM7z+OA
         zTHI+GNtcgP2YiS6WHEwEE0dfBMB0YUqQWyRglZ8LjhlQ2XgK5+KnYBvVsDhpWZruB5+
         r33i0YAV0ZR9NxThGuPbti4SQ4Wh20k6hDUP9sOfx295kSuerH7bAOvrZyl2pDseGwJn
         /w/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PnhFTk7gqJDDaRK0lVEnnUphNHafM27m921+CgXfNnQ=;
        b=LCrK/JWyJXQghSym+Pdw66igUn+4cOifx/hERQX5t8m/woOD5K3eA1sw7Au+WA1vVZ
         dcTCl4NTBC5ASgFnmIF7l8wGQak1Iu63eAMwJBLQBMjx5M2rVQpP8J0glt0fo7DQc7Pw
         SpSxhRxVDeVmFrsEnQzjf6sBfILyKMDiBFti16nvhYxhp9QVPDikXjY6oUeZj6hzEDwG
         zGxLHqqZ+WV1EOphp0UZOVAy7XPrOQELI5Xw9EkPvBcr5N29A0lHQGHtx3ROV7ULaFD5
         eEjrYQfOYjfiTqhYRAsbo+vKL+iOcT/FZ+rOnytJz0LHfGkgqmZj8ZiAUUIpZZRgp5Bw
         aWDA==
X-Gm-Message-State: APjAAAVD9V6y4n061Cuc9VxgzJKM7dwfryUxx/Q9XdIwkWOxcMcXH6eX
        0I0W32wQ8gw2wT0R/Y5dItunXHFBNqlCBA==
X-Google-Smtp-Source: APXvYqzbtLzW6cJV7emEVOUxnNItwX1hcj4AQ3DMpLQMdrVRbalXKiPd812mXutxSQHS+dvj2SUj2Q==
X-Received: by 2002:aca:ac0d:: with SMTP id v13mr18395902oie.160.1579054153020;
        Tue, 14 Jan 2020 18:09:13 -0800 (PST)
Received: from [192.168.17.59] ([189.219.74.147])
        by smtp.gmail.com with ESMTPSA id p16sm6003924otq.79.2020.01.14.18.09.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Jan 2020 18:09:12 -0800 (PST)
Subject: Re: [PATCH 5.4 00/78] 5.4.12-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200114094352.428808181@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <1d43091c-c7ff-ed26-c3f9-207a291ed157@linaro.org>
Date:   Tue, 14 Jan 2020 20:09:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200114094352.428808181@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 1/14/20 4:00 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.12 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jan 2020 09:41:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro’s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.4.12-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-5.4.y
git commit: 5c903e10834dc8905bf461f15b48cceb1ee8c0d9
git describe: v5.4.11-79-g5c903e10834d
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/build/v5.4.11-79-g5c903e10834d


No regressions (compared to build v5.4.11)

No fixes (compared to build v5.4.11)

Ran 23755 total tests in the following environments and test suites.

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
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* kvm-unit-tests
* libgpiod
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
* spectre-meltdown-checker-test
* ssuite
* v4l2-compliance


Greetings!

Daniel Díaz
daniel.diaz@linaro.org


-- 
Linaro LKFT
https://lkft.linaro.org
