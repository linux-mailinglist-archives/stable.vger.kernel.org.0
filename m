Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD0DE27F795
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 03:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730349AbgJABpU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 21:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbgJABpQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Sep 2020 21:45:16 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECAB4C061755
        for <stable@vger.kernel.org>; Wed, 30 Sep 2020 18:45:14 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id e5so4552259ils.10
        for <stable@vger.kernel.org>; Wed, 30 Sep 2020 18:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Vb+aAGlypxPRY1YD9Fg0Abn8HSUZVznFsHIiE+0oQfI=;
        b=WZI7PjwsifO38eSMpQcxqdHaI0kOB4K7oqIbgei+AebpQ5EB0imf2/7NjTCATj5pPi
         Y4+xSCTwxrGVi8o7+igACRlVvF2pNlJyG7iG4MvTtRbJjtIYABuWzcIHseLKFsbj1etJ
         XCe1D+A/Pt51eVYiiZUqz2r1114M00KX7kzBvR8mKlfGKYzTGfFmAuQkDPQAyLxQ5K47
         jNbsCpgaO9II5SXOas5GzqCdp8hjyJyjNJ0wN4gnZvP+owyZZ9EBNwd6IFOAz8tVDKDp
         0peVAr+gBYd7ZG7OF51wWzW8XCALsoq7hZ4bOpi8Ge+qvyb2tvS7aiVtJAsvn3VK1VnT
         mxqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=Vb+aAGlypxPRY1YD9Fg0Abn8HSUZVznFsHIiE+0oQfI=;
        b=p5FiUsbnpMGQuMW94wnCstVVv+LYW/NKE1z0tfmB8jt0vIVfVZlM4NtlRdNg9k8L5n
         K1DFZ45ywYATsmYjWtj1M9WUu7pqXQhp6hXVLinFaQGb9U5CE+XJzXse8S7ROaex+fpW
         zhjAgFRDIooOhSCMZ4nxgKZjgSckdqgWOJlXHSC+yZznmz9cuCLrtKanaWXVvAm+5v4a
         NWQ1lj2ZP5HILObtGsRPF6gTtSjqW+l6p1TqIPNJoRe3oPCNMwE/4ONhwwyt7KDBVjwN
         emAG0N20nRhHvuecnzbcxkAPDtCxMEWJ0iqs1FseaoYZ4RvXWhBQZE/t/BPjOy0IYZAc
         0lWA==
X-Gm-Message-State: AOAM531B/VYoA6gR+2R7xSzal9+kX2iszSOhj0DrL/hCiC9NCGi0nQcf
        PUiGoC1Fn7j9Y2KOLhaCFNrRAQ==
X-Google-Smtp-Source: ABdhPJwoQXts3YhXLIEMUKzFNW5Dm/dDIzuWBfk53UEOkUNtxYEbGmiVLGD3kceoqnlZR+OCjrbGmQ==
X-Received: by 2002:a92:aac4:: with SMTP id p65mr592514ill.136.1601516714188;
        Wed, 30 Sep 2020 18:45:14 -0700 (PDT)
Received: from localhost ([2601:441:27f:8f73:8a14:ee62:2db2:372a])
        by smtp.gmail.com with ESMTPSA id k16sm1391033ioc.15.2020.09.30.18.45.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 18:45:13 -0700 (PDT)
Date:   Wed, 30 Sep 2020 20:45:13 -0500
From:   Dan Rue <dan.rue@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/85] 4.4.238-rc1 review
Message-ID: <20201001014513.wgwkonfup443i4pr@nuc.therub.org>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
References: <20200929105928.198942536@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200929105928.198942536@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 29, 2020 at 12:59:27PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.238 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Results from Linaro’s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.4.238-rc1
git repo: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git', 'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
git branch: linux-4.4.y
git commit: 0d240bae7702c50af56209b177e48d81d371b555
git describe: v4.4.237-86-g0d240bae7702
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.y/build/v4.4.237-86-g0d240bae7702


No regressions (compared to build v4.4.237)


No fixes (compared to build v4.4.237)

Ran 5245 total tests in the following environments and test suites.

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
- x86-kasan

Test Suites
-----------
* build
* linux-log-parser
* libhugetlbfs
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
* ltp-tracing-tests
* v4l2-compliance
* ltp-syscalls-tests
* install-android-platform-tools-r2600
* network-basic-tests
* perf


Results from Linaro’s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.4.238-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.238-rc1-hikey-20200929-822
git commit: 1e94ff9d5cbda806b493b89b01eb99c67ec9ed4c
git describe: 4.4.238-rc1-hikey-20200929-822
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4-oe/build/4.4.238-rc1-hikey-20200929-822


No regressions (compared to build 4.4.238-rc1-hikey-20200928-820)


No fixes (compared to build 4.4.238-rc1-hikey-20200928-820)

Ran 1686 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
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


--
Linaro LKFT
https://lkft.linaro.org
