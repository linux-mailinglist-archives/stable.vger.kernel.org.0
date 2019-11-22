Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 551DD107B9A
	for <lists+stable@lfdr.de>; Sat, 23 Nov 2019 00:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfKVXuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 18:50:11 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:37979 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbfKVXuI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 18:50:08 -0500
Received: by mail-ot1-f67.google.com with SMTP id z25so7707084oti.5
        for <stable@vger.kernel.org>; Fri, 22 Nov 2019 15:50:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=t57slOuWwliy5KRFy4MHilj06UwBXFBw1JnSZThbwak=;
        b=SQ27AJZA0dBzR7SLv5npKwSrM/Yo13QQCamlQa+DyBw4taXqRcGha/YqnL9jfe9c5K
         YsMBIr2VdEi+NNvbHZpi5SOtNQBbIbD1V/XK4rZ0xbMmzfSg9kEVwPh6CTM/ynHSNfRQ
         8I7hwWxznPV0rN9hatPsycbjVQli/Qo51OTGjAp0851ZxYLthWQN+AnNcfarzJscxAHn
         tpiZ9KJYNAxxrRjzsnLbaT1KcLlKippnrzJgrCAeL//Fn25yVRGBv+uZT2b2vfOPudov
         NemkGmNC6dO2oL3lndbbywp+DC4QZR210K6FdBu35UmV56jIXTXBjolaprKKvbTc0smG
         v0bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t57slOuWwliy5KRFy4MHilj06UwBXFBw1JnSZThbwak=;
        b=qaYiJJa8z3f0ZEOH+3MKhhIjTtHqbiqlibbwoUBXLfbdwQ/aVvsdhJrLypBlVReZ6C
         j99JuJotrbkNQIGfajx+Zg2kJ1uZT+7F9fWPr1ssbVV/qyiffOW9qMpjQ+uXD9cc2/tz
         x/EmYPk3NoaKmLDeJVYoFXfNhZYaznrGnipeCw5BK66XP5tIC5BWu/Wny+rl/6u5tbEw
         y5+/Ptl51509zhuLF/Pn465eUMjcpRrJ4jKBJ6/ZM0ztBKIjAYefNH2uZnSK7M5kInsj
         02ZvDLvvQhgAr2z7XibeO52rLGbr5mMzlGAC5BAFSum4CWMLft9JYgxgDwbU75E3lVrP
         oQzg==
X-Gm-Message-State: APjAAAVI68pNmFiaU3Q2c1feNnnyds8bSRIKOt7SdAT4pnhlDiVrCOqM
        dGQULtXRumlhhC69eBVuhFi+hAPAet2baQ==
X-Google-Smtp-Source: APXvYqwgNdTHZbdXEp7O5/QHtBZBfhqBa6CHQs2leQEMKGnwJCZYpJbLB7obLx5C4hPtOGXdgYomxQ==
X-Received: by 2002:a9d:6144:: with SMTP id c4mr12368918otk.53.1574466607035;
        Fri, 22 Nov 2019 15:50:07 -0800 (PST)
Received: from [192.168.17.59] (CableLink-189-218-29-211.Hosts.InterCable.net. [189.218.29.211])
        by smtp.gmail.com with ESMTPSA id h39sm2781332oth.9.2019.11.22.15.50.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Nov 2019 15:50:06 -0800 (PST)
Subject: Re: [PATCH 4.9 000/222] 4.9.203-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191122100830.874290814@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <d8954989-12a5-9b81-48bc-941b5df768c5@linaro.org>
Date:   Fri, 22 Nov 2019 17:50:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 11/22/19 4:25 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.203 release.
> There are 222 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Nov 2019 09:59:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.203-rc1.gz
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

kernel: 4.9.203-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-4.9.y
git commit: c2ff777d9ae88f46236e8fdb9654a87b0468b28b
git describe: v4.9.202-223-gc2ff777d9ae8
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/build/v4.9.202-223-gc2ff777d9ae8


No regressions (compared to build v4.9.202)

No fixes (compared to build v4.9.202)

Ran 23946 total tests in the following environments and test suites.

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
