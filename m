Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF63202137
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 06:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725811AbgFTEKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Jun 2020 00:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbgFTEKv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Jun 2020 00:10:51 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC26C0613EE
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 21:10:51 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id n5so8922253otj.1
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 21:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IQ5IeDM9msEJF+0vVLvnULhlkra1wu615tqY7kXkaOI=;
        b=XVuY9mFSpNQDJXF7POeh2bS7eU6xp4W7GRiJL/zAFkvy1ROHSe4xBIudU3exoKWzuP
         wMyRUIbV87d6yE1epBO9y+84PYkdNpjCNJIZik1HYLBHBHcWqyU3Ukgb5hCPmbqR2+JP
         i1Vuy7lXFb5QxyKFN0I4dwn0YlJHdejJbi68alsKrPr7TjrlyiSxO4olK+lpp2Yrp0GS
         WOf96mWpua4OoT2ZPoHOsJTlGE98hB4elkacilohQWYId/hSU9FSKDYO6/HFv4RZmzJ4
         /s8I36/ZU5+n9mes7RHXFCSXgVpPea9cFIFSOPiguWtg/lwnERe79bPHingbC1qq+PSN
         AAVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IQ5IeDM9msEJF+0vVLvnULhlkra1wu615tqY7kXkaOI=;
        b=QxxoCyeRDR+He7AI1U3WiTDqdGBc+7F1m9Pr7l4+sk0EE2mIxrc0Y8Gaw69emgV53W
         mZnbM5SWMDFHmVvvo3MlPJ5ZoEEDbjYupBObOm5DzKUxDrT1LBgPVVWOFip1E4lS+8kb
         4vDe/dZq+NNnh8i1Nqw/xB+SeX2iT/Q1R1jc36Sphh+PKoMo2fHLO+njl8ubjwfq5lYe
         YILPuFVqt0ovBdr7933VuKCezKaQsRBK9E4SR7FM/NbenNy7R/YAmTQ3n1UTC9g0L3vQ
         Ao7e7LnS7k4YEciRL0qRM/eXhjEMzMF2DZoYjvSL/EC/IBVZPZLD8oXlaTpEssj1hgs5
         j11A==
X-Gm-Message-State: AOAM53241y5oCEoQ1Y9Ek5+kmXE3r52hrOcFP/dn8/xkpQ37OgUnfcHv
        d/Qw1gVCo4Kl2loPFBj1XOXcBa4/I9aF0xlJ
X-Google-Smtp-Source: ABdhPJxkvhUOeuMZ+pAawsq1wwn3iK6HYjdqJ/tPCHFJl3FnDQFyGVN0CNqkOshS9RNVg8o1+aGNPg==
X-Received: by 2002:a05:6830:120a:: with SMTP id r10mr5368048otp.169.1592626250237;
        Fri, 19 Jun 2020 21:10:50 -0700 (PDT)
Received: from [192.168.17.59] (CableLink-189-219-73-211.Hosts.InterCable.net. [189.219.73.211])
        by smtp.gmail.com with ESMTPSA id l65sm1735663oig.27.2020.06.19.21.10.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2020 21:10:49 -0700 (PDT)
Subject: Re: [PATCH 4.14 000/190] 4.14.185-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200619141633.446429600@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <4fcfa7d2-70c9-064f-ace2-593e737cb48c@linaro.org>
Date:   Fri, 19 Jun 2020 23:10:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 6/19/20 9:30 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.185 release.
> There are 190 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Jun 2020 14:15:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.185-rc1.gz
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

kernel: 4.14.185-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-4.14.y
git commit: e26bcff6a5af4b6e19e350a39e88637307e07eb8
git describe: v4.14.184-191-ge26bcff6a5af
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/build/v4.14.184-191-ge26bcff6a5af

No regressions (compared to build v4.14.184)

No fixes (compared to build v4.14.184)

Ran 34182 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64
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
* perf
* v4l2-compliance

Greetings!

Daniel Díaz
daniel.diaz@linaro.org

-- 
Linaro LKFT
https://lkft.linaro.org
