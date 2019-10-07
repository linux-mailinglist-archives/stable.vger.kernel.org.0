Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B191CE91A
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 18:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbfJGQZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 12:25:39 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:37217 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727830AbfJGQZj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 12:25:39 -0400
Received: by mail-oi1-f195.google.com with SMTP id i16so12203877oie.4
        for <stable@vger.kernel.org>; Mon, 07 Oct 2019 09:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/zonqR8a9bYRUArcQ0AsLZe2gFhECx4xlsiRxIugCpI=;
        b=tbKfnNQxobqT9l2G6cyaVZzhkV5ZUxI5OOtLp7CuMZLbAqbIZNG3Xslx6Qu4SgqWK9
         2pHzs1dWyfE4uwgkmY/SAFdGsXivyJY+L4Ff4kUEKMAreldnnH0EnrHL1YtbNUKHM2LP
         1liYwvxxVm+CRTD52MpwURVIWwDV2WSSlPHLlFQiLa1/9FszNXeDC+pYTLr86qA4a6Y8
         wUmkdHqrbfamuM80kJVuFJxsta8ollWvMkvdOoKSPBKq+IsKdQqlvJsF19Kw+dlGJHbh
         IjeY1UM2Ol9suJyo0IYvvVKxIiqBGooE/fXesMZgV72M4p2aEAPEuqSidxNtmQeMT+pv
         itpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/zonqR8a9bYRUArcQ0AsLZe2gFhECx4xlsiRxIugCpI=;
        b=GNQYUTJfcfZuSfRteVPXC3HTZQ3RRfo8CRr5Zm/DjwzPSml/2Yk6/lDu2QjAo3a7G3
         KmbMXgukatM/1PMNJdr3gCWoBYRH3z6yxbD0W/lN0pziBz4gORECdS9axR+VHYJ7NGyy
         7JWk4s75zjCHVlsjrb1JcbcYvx1KeayDfDZ8Sr/pEYqKkpRP4ijP+FHwYZXdSKBzczpM
         ogp6QZGqP2Q3Q2xTT9efGNzfycHTqd2IQPPPPgEXYywtMmNT/i1L2QsgXkswjFcphcyI
         1qmruCtFyZa44tnRPHZREFvP2nH0w+G+te9MJOA15KoKZjwcOSivuO2iiZ4a/4V++iR2
         rSwA==
X-Gm-Message-State: APjAAAVvV/uxFFKdEDE0nc3uZE//2ntXwqXAwltNRo/9amN1E0KetgmT
        ptoPRnt63RhwxXzlLCBG6s4yDg==
X-Google-Smtp-Source: APXvYqzSOxz3jgXnXSKOfwxCrVQXrib0f6vI0fA9tuSp2NkvBZS7YWpOPKHNoDP69HtOeB/fNWJYjg==
X-Received: by 2002:aca:f492:: with SMTP id s140mr82954oih.83.1570465537865;
        Mon, 07 Oct 2019 09:25:37 -0700 (PDT)
Received: from [192.168.17.59] (CableLink-189-218-29-211.Hosts.InterCable.net. [189.218.29.211])
        by smtp.gmail.com with ESMTPSA id 93sm4658080ota.16.2019.10.07.09.25.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 09:25:37 -0700 (PDT)
Subject: Re: [PATCH 5.3 000/166] 5.3.5-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, ben.hutchings@codethink.co.uk,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
References: <20191006171212.850660298@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <7148ff93-bac0-f78a-df3a-b9dbbee3db1a@linaro.org>
Date:   Mon, 7 Oct 2019 11:25:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!


On 10/6/19 12:19 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.5 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 08 Oct 2019 05:07:10 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro’s test farm.
Regressions detected.

As mentioned, we found a problem with the mismatch of kselftests 5.3.1 and net/udpgso.sh, but everything is fine.

Summary
------------------------------------------------------------------------

kernel: 5.3.5-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-5.3.y
git commit: a2703e78c28a6166f8796b4733620c6d0b8f479a
git describe: v5.3.4-167-ga2703e78c28a
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.3-oe/build/v5.3.4-167-ga2703e78c28a

No regressions (compared to build v5.3.4)

No fixes (compared to build v5.3.4)

Ran 25519 total tests in the following environments and test suites.

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
* network-basic-tests
* ltp-open-posix-tests
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
