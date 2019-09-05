Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A595EAA9F7
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 19:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbfIER0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 13:26:33 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:35984 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727522AbfIER0c (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 13:26:32 -0400
Received: by mail-ot1-f65.google.com with SMTP id 67so3009289oto.3
        for <stable@vger.kernel.org>; Thu, 05 Sep 2019 10:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7SONzIMejv8ZmKkKCSVvgUA0IS9mWpk2e92R5J66SGw=;
        b=OdxG2QitdlLknZpx8DvyWk/AAKJ9wTiJ9AI1HU/6jMDRGqa2UJaDvOUQ4gh2P7Jul9
         f+6i0O1UQ5JtE0xCTzumSrlm3vwo34lJ/lLCGqBR6PqaRSCHuE/vJrlGgIuRNRHowkkp
         aogORNeK/zvEfU7mZVUkIz7Fg5symByfX0TAbYK/TzevXK/5MrIGiW871743ZRcvXZ85
         L51f8pxba5aGDqlqy3TfZeRRRCs0fKmedaopUiovMt45FsD4RBvZ4rUhNx8GE9+t0nwk
         A8FRdNxlwDyzXfVx5Ls0e09Dc+F7IOIUs27cu/UBF2E/6iCnZwRyVDiD5mMyKA7T5ZaF
         riYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7SONzIMejv8ZmKkKCSVvgUA0IS9mWpk2e92R5J66SGw=;
        b=hyMJQn1JAHewPmcn3AZydpb7CHOVKlVXKYvA5AiXMnsw6uTC/wfPugvMije4/JDhja
         STW2vgiXyI0vhhrmM3Gg1kLH5emze6FmjJs943/Xwk6aATdFOnqldhafqatStanqDWJE
         WgZ1Rxf67glRQwyOpkyDoxMl3by+gGdWRjG16ZUCvYiRh2qLjh9pCzFSwflIj/RFrXhR
         oXjcUUeqETOIa0sgAaaIT+N5bU73jgpKX2jZ5qnSz6QzJDcHTIxOnyKhZca9z2vm0UXb
         wvroDq/BY2Nij9meRfgD5NBL5FybCmKN3Mnkm74+uKMFRHiymGI1jDsAijb3CDxbGOBT
         AlSw==
X-Gm-Message-State: APjAAAXnYXSRkPp2gVyA6zES2G7YHEk6FAzD0YYgY0tR6Y/HOthKOmCB
        QUonV/2B1PY3TZfAGrvzVOjASzp5sFcVtA==
X-Google-Smtp-Source: APXvYqxtpATxfHarKyAxjZCpSB6PvqWri7DcKSogO9I6bKtxAs0uGcp31nTua75xusApxw2I1HrakA==
X-Received: by 2002:a9d:604c:: with SMTP id v12mr3596622otj.197.1567704391105;
        Thu, 05 Sep 2019 10:26:31 -0700 (PDT)
Received: from [192.168.17.59] (CableLink-189-218-29-211.Hosts.InterCable.net. [189.218.29.211])
        by smtp.gmail.com with ESMTPSA id c1sm651179oic.31.2019.09.05.10.26.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Sep 2019 10:26:30 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/83] 4.9.191-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190904175303.488266791@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <516396a5-25bd-c91d-7908-69598a5937fd@linaro.org>
Date:   Thu, 5 Sep 2019 12:26:29 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190904175303.488266791@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 9/4/19 12:52 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.191 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 06 Sep 2019 05:50:23 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.191-rc1.gz
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

kernel: 4.9.191-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-4.9.y
git commit: a232f5b3e31224799f7506f9e9d4257d3d357d1b
git describe: v4.9.190-84-ga232f5b3e312
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/build/v4.9.190-84-ga232f5b3e312


No regressions (compared to build v4.9.190)

No fixes (compared to build v4.9.190)

Ran 23512 total tests in the following environments and test suites.

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
