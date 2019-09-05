Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 542C5AAA06
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 19:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730498AbfIERaE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 13:30:04 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:38768 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730909AbfIERaB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 13:30:01 -0400
Received: by mail-oi1-f196.google.com with SMTP id 7so2539963oip.5
        for <stable@vger.kernel.org>; Thu, 05 Sep 2019 10:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kBF+CuaGO/4t9r787l/NvQpCVlHO+XpSE/VVcC9xB0g=;
        b=MixwydiqafoO/9oDHJjeqXj8nOxXl6nhwPlsWhZrQ6pBDbMhQ2WootX1JBpKr2S4RK
         0ydyuafEzJ/fZwWnzAmueOSLX5oPL/BipX1iqBX6NxvsOFOZIkbCwNAbiK5+r5qprt9S
         GSMYVpjMWLbDJDYplqw2hlqXhBpzjBofU1umpcfRy1AX0lNbCebs2Qsa4DqopsHihJhr
         JcJNK99JuuUZ7owZUf1YzKuexAoXI+MW0cYlyokYQXkkh4OJANtEpMSyr1M9xXKVRFaU
         L95WmfLnWRy/i9UQv8TWKqZc8p7Jiu4ekL9PpuzjsWX7HIshBzCILW2FFEemEyFSTyGi
         MR7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kBF+CuaGO/4t9r787l/NvQpCVlHO+XpSE/VVcC9xB0g=;
        b=dEVP2GIszS56q0dIDEj3EGcgoTO9I4azQc9KFRvFOHBsXlhuVU6cMNJ/ON+cK91WBQ
         mJTqLnqJsCloNMirxNNSrf9po/69sqyqL47KZm+ERi3nSlqTadxmVKkChAEpDQtFCnEd
         5CZYypdEVEZys+JjFlI5kuRs5HrSFnQqfOmCqDnXsxT2FYVR7axC03ykRM/NgNzpcAqM
         V4HMGPd5t0mkxlUhlxA9iu3v7GIroMFXpOMAUmU8DeSTLGMaevRAQo7uyROWiKKGAo5k
         /CpxMQlFFerUNvc4YM/AHtVyWmhO8KC9zcIE1h4+6rACftK7GES184ZO0TuZvVY/9Tgz
         J5pQ==
X-Gm-Message-State: APjAAAXBZufGJT9XlrpsLyk02/7N5v3XKQ4jiSUQ39oNFZLU//t4nM3K
        q3IwAdy5GXhpqF7gl9eGL73xvQ7zQKkhLw==
X-Google-Smtp-Source: APXvYqxacE8CnPcHpxF5hEOku3dIdnrDOhHApz2xMT82tnZ85c/NJ/GSqaXGJ1PHl1qgoxSBNxrVkQ==
X-Received: by 2002:aca:c592:: with SMTP id v140mr3593099oif.92.1567704599657;
        Thu, 05 Sep 2019 10:29:59 -0700 (PDT)
Received: from [192.168.17.59] (CableLink-189-218-29-211.Hosts.InterCable.net. [189.218.29.211])
        by smtp.gmail.com with ESMTPSA id v2sm668830oic.49.2019.09.05.10.29.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Sep 2019 10:29:58 -0700 (PDT)
Subject: Re: [PATCH 5.2 000/143] 5.2.12-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190904175314.206239922@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <f1f7fd91-061b-9646-20e8-297dfa2262c4@linaro.org>
Date:   Thu, 5 Sep 2019 12:29:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 9/4/19 12:52 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.12 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 06 Sep 2019 05:50:23 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro’s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.2.12-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-5.2.y
git commit: b6eedcb8cf6670234e137d277a5ae1cdf5cd141c
git describe: v5.2.11-144-gb6eedcb8cf66
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.2-oe/build/v5.2.11-144-gb6eedcb8cf66


No regressions (compared to build v5.2.11)

No fixes (compared to build v5.2.11)

Ran 22474 total tests in the following environments and test suites.

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
* network-basic-tests
* ltp-fs-tests
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
