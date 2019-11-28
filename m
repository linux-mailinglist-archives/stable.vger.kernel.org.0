Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52DF710CF86
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 22:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbfK1V3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 16:29:48 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:44536 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfK1V3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 16:29:48 -0500
Received: by mail-ot1-f65.google.com with SMTP id c19so23206187otr.11
        for <stable@vger.kernel.org>; Thu, 28 Nov 2019 13:29:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=e2RH7F3RD7K4uIeBKMBnV6p64DBMWb5+gLz6yw1yZkY=;
        b=He6eccuItgOem62ODw0Yr1vvV9qVzTEvg+IhGKSDSkGH4RILVXZ69B9DMIwSIOiUCJ
         8Qt4Yt+WiLr5w3pRiseOazLMBKJMyu8tgZpRfH5cxZfvrnuN/dO2757w1POC1k8mf4Mp
         7hZoaU3Ip0SspHG+HHsSSPiFmndM3x0ac+2g3pSXYiT4c96DrX+cfTpJKG3HmI5vNsWb
         h4pEjooh98VEsHkFAYhM5CzwZrIvBGwTQ3JSZvP6grpGdwb1KXPD38isL9HrOdIqXJ0S
         hcmZhioZjKnOdYnLrR6TnnTMiYm4vCr04RKH1LHcisXSGZpTgW1Sk0GFzCFSfhE7JDIR
         keHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e2RH7F3RD7K4uIeBKMBnV6p64DBMWb5+gLz6yw1yZkY=;
        b=ZTZlBHHhI4Icne3CrO+pMcXRVx3E8/90tP4AnR5JUQaiOTldXvCtwsLnaLyD/g5t2f
         oyG/3Lo7PvCW+hq0rqLjJbbPOr3NtodqpMK77K8zd+/9zFAV4wHbWVZOC6jQkJnWf9VD
         lKteQ5syZUxuyWww0UFSz79fkrgsW4J+i+qjn7a158HP9K2LzKcMnVq0xufEQGejbq0A
         ymA8ltrAdB/uFrwADnhFjmnTJP0g1gzPGI5OOpKol6MK+YK0mDq7a7lhkcmVZ5MTLp1d
         QWVwZWZSV7q6tc03GxLVmfg8OywXzvtxu0bzdOIzr7Wd8bbyb2yiAhL2Ss9LSiJUq42W
         f/JA==
X-Gm-Message-State: APjAAAWC7XmN88vMuzVMUHvWXfQrlhxfiiclcu1OtRYeIk3Lcj+hwFTC
        W+CoMzfJyuFY8xJwWiCxyuZhas3lC7nUig==
X-Google-Smtp-Source: APXvYqzG17sWkzpmf8ZfK5ueZnXVK71cDOpTYRQc7ZxzN2vtvCFlXYM9s7p4ArruqGQixqp/ipL8qw==
X-Received: by 2002:a9d:65cd:: with SMTP id z13mr9163360oth.85.1574976585213;
        Thu, 28 Nov 2019 13:29:45 -0800 (PST)
Received: from [192.168.17.59] (CableLink-189-218-29-211.Hosts.InterCable.net. [189.218.29.211])
        by smtp.gmail.com with ESMTPSA id 64sm1796296oth.31.2019.11.28.13.29.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 Nov 2019 13:29:44 -0800 (PST)
Subject: Re: [PATCH 5.3 00/95] 5.3.14-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191127202845.651587549@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <7008c868-1907-08e4-e976-28dd0278e17a@linaro.org>
Date:   Thu, 28 Nov 2019 15:29:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191127202845.651587549@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 11/27/19 2:31 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.14 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro’s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.3.14-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-5.3.y
git commit: 27442d39830209266d439effe7503146b8f4d0a6
git describe: v5.3.13-97-g27442d398302
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.3-oe/build/v5.3.13-97-g27442d398302

No regressions (compared to build v5.3.13)

No fixes (compared to build v5.3.13)

Ran 24992 total tests in the following environments and test suites.

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
* linux-log-parser
* ltp-containers-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
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
