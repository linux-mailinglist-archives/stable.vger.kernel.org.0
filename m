Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4182107B97
	for <lists+stable@lfdr.de>; Sat, 23 Nov 2019 00:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfKVXtn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 18:49:43 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:37464 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbfKVXtm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 18:49:42 -0500
Received: by mail-oi1-f196.google.com with SMTP id 128so20832oih.4
        for <stable@vger.kernel.org>; Fri, 22 Nov 2019 15:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6dDtx8TFTILA/cId63d3nJB9eUdnG02yExBByH1DaL0=;
        b=K0qdrttB5dB1Kpr11S/Ogh1KrNnoIjTOWQ1vRHLJR6l4t6Sozbi3k6xnKksQvrm/wY
         grg+aL3jYFsXGGS5LNtORQE16ySQmA8+OnYf/4xA+m0xXIohY+CmwefFW1QNkZXlalsT
         0djFA5OrB5Qv+f5h3ScH69Xhw9v/unvIJC+y/XE1CsebRH72eXTs+AhwfKNxUO36pMDg
         7zOxOKXIIBtAXTxz5Br1O3715OI02BZy8rSKk0BDymmSm4yxpmMVqDzj5vsNBfUNuKYQ
         4NdxXF5LfWQRfZf5efEIKnTJ+kCw11q8RWgkXmfJO+6P0XM+AlugnW1C4Ocs2tCughQw
         7gyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6dDtx8TFTILA/cId63d3nJB9eUdnG02yExBByH1DaL0=;
        b=kvQUC7zML7lLTIi0SKPZhSxRGgOEfMLnxH3vcLEATe5xiyDFqNZuw+IgC71jry9AL2
         sbXRBQ4P8O5Zw8NikQcOAOruoAMAZiTAbo82kZKpYX/D/W5f96tAqu4QcVcukA2958Y2
         zPqYk0tsalRgau8bljTQyST/Uc5QoQnvL6GJ6yRTjbTRIRDH6w+Il2woOj8GM+z2oOuU
         nOsTziFusNW4nbjJSufFWjOBRiiDbl1ZEdXgaTGfqNLenxdK7hKBupAlIlFrCzXBVBp7
         At8hKelBQsdco7P641fU01igkRTxM6la8e06PcTF0mg0vWrLz9+Cr6+YtCXPnTue8XOv
         De6Q==
X-Gm-Message-State: APjAAAUV7UnJhuZUDnB8CeA8OztD8KaeVzEZ0usGn5c/d4eZVmIb+SDa
        Di4X+jXWI/rJu/3zCKzSDCFtAL929fNk2w==
X-Google-Smtp-Source: APXvYqyIvSOGxzbbb7majIiLV3sKznMXLvhpPhO+iDFtIzBhitxL5y2otdPOg9rAQ//JxPaROKKLPA==
X-Received: by 2002:a05:6808:88:: with SMTP id s8mr13754545oic.109.1574466580943;
        Fri, 22 Nov 2019 15:49:40 -0800 (PST)
Received: from [192.168.17.59] (CableLink-189-218-29-211.Hosts.InterCable.net. [189.218.29.211])
        by smtp.gmail.com with ESMTPSA id t2sm2695637otm.75.2019.11.22.15.49.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Nov 2019 15:49:40 -0800 (PST)
Subject: Re: [PATCH 4.4 000/159] 4.4.203-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191122100704.194776704@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <145b78b9-5518-8fab-7861-4f40e5edcabc@linaro.org>
Date:   Fri, 22 Nov 2019 17:49:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 11/22/19 4:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.203 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Nov 2019 09:59:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.203-rc1.gz
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

kernel: 4.4.203-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-4.4.y
git commit: dbaac4c54573d428113956f3e4c56f9d94920c28
git describe: v4.4.202-159-gdbaac4c54573
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/build/v4.4.202-159-gdbaac4c54573


No regressions (compared to build v4.4.202)

No fixes (compared to build v4.4.202)

Ran 20213 total tests in the following environments and test suites.

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
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* prep-tmp-disk
* spectre-meltdown-checker-test
* kvm-unit-tests
* v4l2-compliance
* install-android-platform-tools-r2600
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite


Summary
------------------------------------------------------------------------

kernel: 4.4.203-rc2
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.203-rc2-hikey-20191122-613
git commit: fd5ba88e671977887fb59d54fa2697987c38931d
git describe: 4.4.203-rc2-hikey-20191122-613
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4-oe/build/4.4.203-rc2-hikey-20191122-613


No regressions (compared to build 4.4.202-rc1-hikey-20191115-607)

No fixes (compared to build 4.4.202-rc1-hikey-20191115-607)

Ran 1605 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

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


Greetings!

Daniel Díaz
daniel.diaz@linaro.org


-- 
Linaro LKFT
https://lkft.linaro.org
