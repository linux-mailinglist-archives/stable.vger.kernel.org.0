Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6671D88C1D
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 18:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbfHJQCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 12:02:51 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:46874 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbfHJQCv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 12:02:51 -0400
Received: by mail-ot1-f65.google.com with SMTP id z17so25848829otk.13
        for <stable@vger.kernel.org>; Sat, 10 Aug 2019 09:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=+RIEl06ySyLSnlx8jSsdqHWCv3Y0byPqxjldRRobvLM=;
        b=ujgT0NfZs3NhG8cLMnUlIJzkdkAudel90cnisjM24pLGXv8ON9I6oTn11XFTe0OXt8
         rzY1PnXuJoO2K+qIb/CDY88xUggcL9q/uCl0eJUvuRF8w+aLVLOvhJdl1b5HTAstv92F
         og1AapRKUwQWceXQOF139omG11h5SYalG2IEVxOD0dd44ac0ac7VwgM6LaYi31/rnLgT
         ICEP+diL/OYDKM7HgnBRZ78XCFruCKvmKqTHZwKfIXLNciQHRoJ+dfNBeVpBRxlI2oBC
         c4OwKVLySyQNCdwFQLaOX5dthSg+ULkBK4/aL4IttViMICckb8BAREPbC+Tj69S9kDTC
         gBAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=+RIEl06ySyLSnlx8jSsdqHWCv3Y0byPqxjldRRobvLM=;
        b=eJ171pBkt9yAu2GKJpZFiuTMkPss/o/Uytx9RL0VusaonaLqHls1Sj1AHgwiD21Lxp
         uxvcuJgzakuCgM936hlyZvCLtPnqa2R448z13cgN7Fg5twKNAz+47mkGmU3hXOOs82bV
         thcTddJs/BIdceMpqgw7v4CdFVpUSRkGkzt7ylOZjvUPTlidEWONDZEQEQNv7FAJXznh
         ksb7Rdj9PcmvhcxonfUXMa4bIqtlzuTY4MuB4jQuQo6oKYcHHr8nrVlhrKQiCio/iw6s
         hEJyl8KTMR+uhlE59/x/Q1W0Aelyu9mb+6gHF82KDpAcCwTttChYn333T+0v5DucCtVW
         3JSQ==
X-Gm-Message-State: APjAAAWTrgQsfwcQuQ2/M2GuuR9UOb78DkikdnomCCgIwekx8MvixccT
        995/kE+OQqqQ9JyHt/VaF2f3fFtrvIE=
X-Google-Smtp-Source: APXvYqx59ifhEPEV2tLfxvbXw9OBiOOBi47mUgYWtczqhpttzemRCHxW3xpeq/WPzFYQypsRrj/bMw==
X-Received: by 2002:a02:a703:: with SMTP id k3mr28032262jam.12.1565452969652;
        Sat, 10 Aug 2019 09:02:49 -0700 (PDT)
Received: from localhost (c-75-72-120-115.hsd1.mn.comcast.net. [75.72.120.115])
        by smtp.gmail.com with ESMTPSA id p3sm156289916iom.7.2019.08.10.09.02.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 10 Aug 2019 09:02:48 -0700 (PDT)
Date:   Sat, 10 Aug 2019 11:02:47 -0500
From:   Dan Rue <dan.rue@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        ben.hutchings@codethink.co.uk, stable@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux@roeck-us.net
Subject: Re: [PATCH 4.4 00/21] 4.4.189-stable review
Message-ID: <20190810160247.6dx3k63wwps7gdpr@xps.therub.org>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        ben.hutchings@codethink.co.uk, stable@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux@roeck-us.net
References: <20190809134241.565496442@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190809134241.565496442@linuxfoundation.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 09, 2019 at 03:45:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.189 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 11 Aug 2019 01:42:28 PM UTC.
> Anything received after that time might be too late.

Results from Linaro’s test farm.
No regressions on arm64, arm, x86_64, and i386.

Note that test counts are a bit lower than previous because we are
having some infrastructure/lab issue with our qemu/x86 environments.
There is no evidence that it's kernel related.

Summary
------------------------------------------------------------------------

kernel: 4.4.189-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-4.4.y
git commit: ab9a14a0618d99ad7e0b7e589a97f3421ac4d662
git describe: v4.4.187-45-gab9a14a0618d
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/build/v4.4.187-45-gab9a14a0618d


No regressions (compared to build v4.4.187)


No fixes (compared to build v4.4.187)

Ran 16774 total tests in the following environments and test suites.

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
* ltp-timers-tests
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

kernel: 4.4.189-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.189-rc1-hikey-20190809-523
git commit: ffbfd13890f25f989c107e0a79063ff644d02753
git describe: 4.4.189-rc1-hikey-20190809-523
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4-oe/build/4.4.189-rc1-hikey-20190809-523


No regressions (compared to build 4.4.189-rc1-hikey-20190809-522)


No fixes (compared to build 4.4.189-rc1-hikey-20190809-522)

Ran 1550 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

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
* ltp-timers-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance

-- 
Linaro LKFT
https://lkft.linaro.org
