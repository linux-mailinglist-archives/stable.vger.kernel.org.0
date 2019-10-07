Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26DB1CE84F
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 17:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbfJGPwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 11:52:49 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:41150 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727711AbfJGPwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 11:52:49 -0400
Received: by mail-oi1-f195.google.com with SMTP id w65so12093128oiw.8
        for <stable@vger.kernel.org>; Mon, 07 Oct 2019 08:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=12ALqaDC3v3cYyVy/bFXTdcUuL6p/Xn/37qQBbhEtlY=;
        b=W7kiBn3JKZJ9UvrWm0D0Jggm9a7qw6cZnjwdK2LrjfFklIQaBuacN5lUOFnNRlpR44
         DXw2lBd6mHGZE7i983pHw+hNxvZHetZJRX/7cX2vDuaOkTc+R55u6DU2qsnRGunu+ykb
         VWmLdmJvbMkSD6/Wt/N4fjdy3PhKXrV1yLIoOhfQGdT+l5BOzeeyAqzGejgLPG76WmQD
         qvWDNuvUMByBhLdWXgjUF42xCkkW8lln8+ctqiXZFeLcc8Ap/gd0EGj/ZiCBMc8k8Go/
         zJAbVv/lW/+Y0/P01LwE7UZ/RMYwgCksIEDtRRGbgGQXFx9V3MD/cEbvxG6ffdHLleUR
         GqKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=12ALqaDC3v3cYyVy/bFXTdcUuL6p/Xn/37qQBbhEtlY=;
        b=PDYnZPGiNqhgkAyPy0+XdhNhjJeWQo8piNV1quWVmWMJB0cgFE3v3q3QOEWbpmfJ3J
         VQW5tBwwxlURF6tQ7VassD2vaF90ITC1T5d1myJAWBEZCxUgT4UpFbP4uSuw3wSa1Sky
         9twjraak2yirnDRqmzqsKn0yuqA8nbm16sK3HSlErQAoA3by2CrfSE4rRjQTVsebOSqD
         tAxcKy4jpwrS7vmWauIn3v5EZ9Md8EQHoRE9YOmT0Aj34P08+rQvq40pXojMZFYDHpHq
         cZ0pVJQhtuv5cTRFjNbELYWaQzSVXXlo/tbrDpfW8aiwPoD7cgARA0TmR2J4XhlS8phX
         ERWw==
X-Gm-Message-State: APjAAAV4ijOBstWNvKTJm6rgfDrZb2dLzMVilqKHtMviAM86kzujV2d3
        Wr3azTUCCkaYbqpO4fCdfknz6jGmt0mYGA==
X-Google-Smtp-Source: APXvYqwKCgvkl+v42MR98xVsK+56ACzjwkv7mGVEm9CDmaOTjQXqgUN3tU26IpVIlEadT1pxMzDXXw==
X-Received: by 2002:aca:58c5:: with SMTP id m188mr18131347oib.74.1570463568088;
        Mon, 07 Oct 2019 08:52:48 -0700 (PDT)
Received: from [192.168.17.59] (CableLink-189-218-29-211.Hosts.InterCable.net. [189.218.29.211])
        by smtp.gmail.com with ESMTPSA id 91sm4753211otn.36.2019.10.07.08.52.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 08:52:47 -0700 (PDT)
Subject: Re: [PATCH 4.14 00/68] 4.14.148-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, ben.hutchings@codethink.co.uk,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
References: <20191006171108.150129403@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <f952f3cb-42e0-af22-33e4-f08d995a6af7@linaro.org>
Date:   Mon, 7 Oct 2019 10:52:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191006171108.150129403@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!


On 10/6/19 12:20 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.148 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 08 Oct 2019 05:07:10 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.148-rc1.gz
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

kernel: 4.14.148-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-4.14.y
git commit: b970b501da0bee5eba4e61ea7d424adab428a165
git describe: v4.14.147-69-gb970b501da0b
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/build/v4.14.147-69-gb970b501da0b

No regressions (compared to build v4.14.147)

No fixes (compared to build v4.14.147)

Ran 23798 total tests in the following environments and test suites.

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
