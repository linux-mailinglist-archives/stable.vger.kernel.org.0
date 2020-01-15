Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D59B13B77F
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 03:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbgAOCIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 21:08:40 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:36190 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728890AbgAOCIj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 21:08:39 -0500
Received: by mail-ot1-f67.google.com with SMTP id m2so9878448otq.3
        for <stable@vger.kernel.org>; Tue, 14 Jan 2020 18:08:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GzPKMHc3Op1OEoA3J43WzBLZT6I0/snk0tNLdQMQmYc=;
        b=xtitrX16rffIlFxYwfbeBb4TQm3WrYatpMRiPvIdHCl+hEcLE5JtO8ohYpnpXRjHNJ
         r4dyMkVsM91vFg7LYIKfZWxNTzTCYRqzSfVww8dmXGjnUKV7Yplz+f1uRHmG+dyBXNBR
         lsQhZH7UFrOQJwvOcNd8lDNSI9yKaPV7OOgwWKe7paOqxbrF727sawvXbgquofBbU54O
         c36TgXyM5UJnfBGJeDl9T816Th/G2vOZbG9vyRlFFdlfkAtGWZvY7ZSlMvwnMlgjBjPH
         nHMjL8GIuZ/QkQBnxUZoQzfUkKXzwIk0corOqjj7UxpingtpAVnt57pOFiy6vipYa80f
         K7Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GzPKMHc3Op1OEoA3J43WzBLZT6I0/snk0tNLdQMQmYc=;
        b=SfOfWyATMjZ2p3tICp9MBYgZ775rh+DvAaJDRrz50/dehHRf++oXJtUMvF0WRKyGll
         TYJLY3Mki4mlDT4ZKpECcFKJYEVdN/6aVsOWRj9rypTKeQa+WqRUs4jo0obw8VWnCGgv
         v18njTypO3kG13c0nr3pxztI0br5/K6AiGrzJ+E7ysAd2KR2WhlZYjMyVgxAv83bQXoA
         gsQiOZXjkGSCN98yno/ZF+pzXvMq1uHIwSzd+lwnxymmb1LbJFZgyuGz0giaxNuF9K65
         jZQCK5e6dik1Wab29huMYSiM+9D1ejzqVOAC+A/cWztGq0ZPNfptkre1CzjgGiR57CFL
         zspw==
X-Gm-Message-State: APjAAAVTibIprtdCmn+fjUah9pDPrOgdoheT5M6BouX691O/R0wx9FU1
        YRybr/pHMINsGw6zW0cPlU0Rr3sQMUMivQ==
X-Google-Smtp-Source: APXvYqxs3KOmVG3b8xPJqEtdVYNAEGQqPTdzo4yoGXPppDbyiU6SOKMfeFnVU20JioYAnANEmymCzA==
X-Received: by 2002:a05:6830:9a:: with SMTP id a26mr1127235oto.131.1579054118218;
        Tue, 14 Jan 2020 18:08:38 -0800 (PST)
Received: from [192.168.17.59] ([189.219.74.147])
        by smtp.gmail.com with ESMTPSA id w201sm5225492oif.29.2020.01.14.18.08.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Jan 2020 18:08:37 -0800 (PST)
Subject: Re: [PATCH 4.4 00/28] 4.4.210-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200114094336.845958665@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <28b6d866-61bb-494b-ca22-3ba5e69305e8@linaro.org>
Date:   Tue, 14 Jan 2020 20:08:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200114094336.845958665@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 1/14/20 4:02 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.210 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jan 2020 09:41:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.210-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro’s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.4.210-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-4.4.y
git commit: e249b6762aa64944a407b6e00bb99590fdee9091
git describe: v4.4.209-29-ge249b6762aa6
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/build/v4.4.209-29-ge249b6762aa6


No regressions (compared to build v4.4.209)

No fixes (compared to build v4.4.209)

Ran 19907 total tests in the following environments and test suites.

Environments
--------------
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
* prep-tmp-disk
* spectre-meltdown-checker-test
* ssuite
* v4l2-compliance


Greetings!

Daniel Díaz
daniel.diaz@linaro.org


-- 
Linaro LKFT
https://lkft.linaro.org
