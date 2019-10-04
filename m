Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15874CBEB5
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 17:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389320AbfJDPMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 11:12:31 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:34981 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389196AbfJDPMb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 11:12:31 -0400
Received: by mail-io1-f66.google.com with SMTP id q10so14342593iop.2
        for <stable@vger.kernel.org>; Fri, 04 Oct 2019 08:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=cWRdLiwQJAJJAJeYx45YFgevjCqiCyRsVMde8/zsJ6A=;
        b=f0LGMOO+QGwV68JTQXruh+AqnwraIvphJ9rXbYuICywU3+WNjjBoC5yX90kY20UaPG
         oorPZEkmRyvxkFAIJVNimLUYleYdudogrG58Vz0F1YYs94ESlt4sD/JkVZRfJxZHaenT
         NRo2seZ06B71stP4w2Tk9nLWSOCbJ0ymeQ9TdDMGU9En/VrkRmrgL/E9P5gd58qGb5dN
         N4gLewWqvEji28X4e78L7waSh5spQL6DGGDA+lVJAzy/74nCl0K3F/nU/729hPgX+QBH
         WxbHVGsf6mI/0G2+jeJE5JDN01gVUGzDFFf+EB3oTlgLGZjcgE9bWSjcKaE4lnhy8UWe
         80Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=cWRdLiwQJAJJAJeYx45YFgevjCqiCyRsVMde8/zsJ6A=;
        b=GaimWHtc3tO5juMIDIz5ElUyGS/31h7iBuMFuG1UzvB0BD4N9oX0T/Ak0KNjU0zsDh
         t/iH6b3G4Q+Z9JlOTqkga4pnWAN9KA/kFmSTk/JrCwT1MYOjc8aN2iXATDxtodScBW2T
         Y+E19tmDd1UCMzSUmVMPr6mfIdzb0Cp591DZ5RZK0Ok3unCCoOoh+/pzITMChq0SmIJk
         x3rMsAIwluyovu3dQByc7mCmuRfh2j2xZRKMm04/j3/r/OCWZbtA+1aOd7ZXwQ4kw5wi
         LFXIF4PQJtWXnqU21Yu5Ety8wKyJ7BDwoZymDzeuuvAa15CTx5YgMI9vkU233tnYXmrG
         Tudw==
X-Gm-Message-State: APjAAAX/b/FvWqGfNCsKZc1lixY+KSXSO00FNn/r1vUWHUp64HH25CnZ
        gkLKDqWGADeVfMeAN74e+FQ94AHV0d0=
X-Google-Smtp-Source: APXvYqxqIXCzfNNEjTBNMu5NySqCyk/eRVksf1vOt8+a3Fv6hjdsOkifkyV9BcOCqt/nTTJdnhh7FQ==
X-Received: by 2002:a5e:df04:: with SMTP id f4mr13760675ioq.192.1570201950070;
        Fri, 04 Oct 2019 08:12:30 -0700 (PDT)
Received: from localhost (c-75-72-120-115.hsd1.mn.comcast.net. [75.72.120.115])
        by smtp.gmail.com with ESMTPSA id l82sm4099655ilh.23.2019.10.04.08.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 08:12:29 -0700 (PDT)
Date:   Fri, 4 Oct 2019 10:12:28 -0500
From:   Dan Rue <dan.rue@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/211] 4.19.77-stable review
Message-ID: <20191004151228.25fe3upo5jncvyme@xps.therub.org>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
References: <20191003154447.010950442@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 05:51:06PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.77 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 05 Oct 2019 03:37:47 PM UTC.
> Anything received after that time might be too late.

Results from Linaro’s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.19.77-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-4.19.y
git commit: 319532606385c7221dfbfba6f857bd03e97e20d0
git describe: v4.19.76-212-g319532606385
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/build/v4.19.76-212-g319532606385

No regressions (compared to build v4.19.76)

No fixes (compared to build v4.19.76)

Ran 22570 total tests in the following environments and test suites.

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
* ltp-open-posix-tests
* network-basic-tests
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

-- 
Linaro LKFT
https://lkft.linaro.org
