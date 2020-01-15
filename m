Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64C4C13B783
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 03:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbgAOCI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 21:08:59 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:41133 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728943AbgAOCI6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 21:08:58 -0500
Received: by mail-oi1-f196.google.com with SMTP id i1so13928291oie.8
        for <stable@vger.kernel.org>; Tue, 14 Jan 2020 18:08:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N8Jlq8P7WNZDl6XDEHlEYDBINgPTySun+7YxtjMFlfY=;
        b=ozUgjWzRlE6j1aF8qoou4uHwbRKNqPiDLtz5VjcPJsQoy63RkKPLkuEvgKi7rEc7Ao
         FKGoPz+unuTqVyf4KIvsqbX95steSS/HeidqUYUsPMruMYlmN9wvsVhYcCYb16jcB5CB
         FsHj5Hq4+6p7CZKuuP8Haj8FNmaSXdM6ASI3XRUeG8uJnb1KukRDXmAM22TomF4u5kS3
         Vn1BcUesH/+jg1pbeDgdPV7ZOGwU3pz2PTdkvMwJurr4qjMBZaO/nD0pU+Q2n6KBg54l
         CuOJuqoVYB/adAcmFIcsJQbqo6yKQHVoyYAwxG1bjEsdkq+VZ04ewsktQSN6qGQwwXzS
         5G2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N8Jlq8P7WNZDl6XDEHlEYDBINgPTySun+7YxtjMFlfY=;
        b=JFT8q6CdIZLo7CyqwUgJPlTZP3qreOeKl/Qj7Q47ks9nuZuK/5Lk6Wio+laGvm8e/6
         ZiaUm5/Zw5xVz3S1V+CFQk6xJ+OEsQBndC3fEJTbD2LUwdEdokVuB1HIkSkgFWpYZJ+i
         yd2OB0VbVOJMoo8SNYiGbBCzTFKTKrRJbyeUIioQmk73juyQs+pudG/YsBVv9O419Mf+
         kQ8QnhVyL7DNX7N0xJePZvGed4QH0l+IoDICC8dJvvMqH1xWz9BgBabCkVhumkZsz6Hh
         OEVWdgA6uyglMJf8dCUlpZBspkV5Zejcaa79jM9aVhf9+Pt+yGUx9BrX/50scj8/M9AP
         E+RA==
X-Gm-Message-State: APjAAAVr4gqIvdlnnu+wgA+VI/qciViu/r6CYFEhwnwPBRS9cKff5LZr
        6UjD+B/7rQgmP4o88AYq/jmPE6Wol9nD5Q==
X-Google-Smtp-Source: APXvYqzIjOVsPgfRubsQ+EzzoXxxVbCvaq58hv//hHNkWDuHls6nGEHgvebujaTITV+hHhhW5Uopfw==
X-Received: by 2002:aca:a883:: with SMTP id r125mr20326415oie.56.1579054137159;
        Tue, 14 Jan 2020 18:08:57 -0800 (PST)
Received: from [192.168.17.59] ([189.219.74.147])
        by smtp.gmail.com with ESMTPSA id m185sm5223410oia.26.2020.01.14.18.08.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Jan 2020 18:08:56 -0800 (PST)
Subject: Re: [PATCH 4.14 00/39] 4.14.165-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200114094336.210038037@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <2b143f20-a8bb-3c7b-0731-983d03d8febd@linaro.org>
Date:   Tue, 14 Jan 2020 20:08:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200114094336.210038037@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 1/14/20 4:01 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.165 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jan 2020 09:41:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.165-rc1.gz
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

kernel: 4.14.165-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-4.14.y
git commit: e7b83c76590bff9d45ebc9dde116730878f8178b
git describe: v4.14.164-40-ge7b83c76590b
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/build/v4.14.164-40-ge7b83c76590b


No regressions (compared to build v4.14.164)

No fixes (compared to build v4.14.164)

Ran 24086 total tests in the following environments and test suites.

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
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* kvm-unit-tests
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
