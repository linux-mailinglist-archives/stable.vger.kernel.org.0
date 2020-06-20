Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 207F6202130
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 06:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbgFTEHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Jun 2020 00:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgFTEHQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Jun 2020 00:07:16 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722A1C0613EE
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 21:07:16 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id k4so10370818oik.2
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 21:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l/HAjPlfoiEvgX9pobrjzlwlewSItzH9tKn3gKHEo9E=;
        b=DD/PvLczKkdkttj3SjGg/nDc3nYav40SYustntFwP3Zb0tWc960xfFF9eA+f1zxgRh
         Jo6CxsPbGVwgjoiCKKOlpc/BWnN7HG95nJsIGWqjNJkiFbQ3sKtosyA+PXoOuRCVh2Dc
         slFQ/YI556Y0kF4eg2+huR8I1mQboRuu2cE0WJlcTQgIZRxlJIi7XTo74MX1nRvNQDeZ
         qPgqe94FSP+NUPcUQTVw94J0nVIjEwWLz0PnqA1AL8NHCH5nnWHjg7MlvK9RhNGw40Z0
         /VwqMzd5Vf4dJ01wkx5MdBBR4uWEsgJnYDiIhy47hu0KhV3S1BMmkiTXLj+lsikPe6D+
         DgoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l/HAjPlfoiEvgX9pobrjzlwlewSItzH9tKn3gKHEo9E=;
        b=ARf+dwum2LqxzPmYqWA3lKIptWOU/7X7F9gtsUE6EH+NGZNNsHYE2ZJBrAd1mYn4N/
         TSi32IYQOA5kvVZugfFkIUncRJqMmTi/FVtYChpHcCpRohkzO6FwTrP0IIKghOZ2Moce
         GZgSbFTpvcRvLAN8Y25teFVy6FS3B6VVEXdGy+NVxzg8IJg1isg5rO+/x8KNjU++p4yj
         aOXFeQkfpxKSzBZ2F9kNqziUX9MimEbpbOL9xr5tqBhBm/U8zcb7MY7FxQ+BBRFZREay
         IhIvQm3PgSN+wQ1oAFUjqlawfIbeTlMW/SLuxi9XezaMZYDj3TjosHW9augUHLQu0k1h
         RNiQ==
X-Gm-Message-State: AOAM530asCeFZ5WligEKsgX3SDGubYOqFNdpnv06+WGvVJbQ2bq7wFo+
        ZaCnMctuxPLkGxrahPSrU2zVTeiyJojVJvIM
X-Google-Smtp-Source: ABdhPJwkzNDLK/hlGDCkbiBs09QRalu4wiaCvGqJEjiriWbreq0VW+abQgPuIBAbKh6qHbIvjR7h8A==
X-Received: by 2002:a05:6808:149:: with SMTP id h9mr5676239oie.107.1592626035040;
        Fri, 19 Jun 2020 21:07:15 -0700 (PDT)
Received: from [192.168.17.59] (CableLink-189-219-73-211.Hosts.InterCable.net. [189.219.73.211])
        by smtp.gmail.com with ESMTPSA id z5sm1776295otp.28.2020.06.19.21.07.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2020 21:07:13 -0700 (PDT)
Subject: Re: [PATCH 5.7 000/376] 5.7.5-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200619141710.350494719@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <253bcb22-78c4-6dd9-12cd-5eeb942c5bbc@linaro.org>
Date:   Fri, 19 Jun 2020 23:07:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 6/19/20 9:28 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.5 release.
> There are 376 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Jun 2020 14:15:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro’s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.7.5-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-5.7.y
git commit: 19411dc6b06179bc55c542f1be520764cdcd3aac
git describe: v5.7.2-542-g19411dc6b061
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.7-oe/build/v5.7.2-542-g19411dc6b061

No regressions (compared to build v5.7.3)

No fixes (compared to build v5.7.3)

Ran 37628 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net
* kvm-unit-tests
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
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
* network-basic-tests
* perf
* v4l2-compliance

Greetings!

Daniel Díaz
daniel.diaz@linaro.org


-- 
Linaro LKFT
https://lkft.linaro.org
