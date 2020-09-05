Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4AA25E8D7
	for <lists+stable@lfdr.de>; Sat,  5 Sep 2020 17:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgIEPme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Sep 2020 11:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728369AbgIEPmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Sep 2020 11:42:13 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928BAC061245
        for <stable@vger.kernel.org>; Sat,  5 Sep 2020 08:42:12 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id w5so1026764ilo.5
        for <stable@vger.kernel.org>; Sat, 05 Sep 2020 08:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=oavwsui6np9I0SfKH1zAjIQ7ScxL8JKCQoJQZLHKCqc=;
        b=R6WsoWXsX3lDoDV9TSgES6XDTt1pcEoS8Le8Le5Fk8z+JYSMc82y/2smFqKPoeZ3dd
         MqroeFGZ2WR5psSrtu0+5AmVDGxoTFmEXiLVrkt4kRvI5AwMCem47nWVGFzAM4nXgfwD
         x2+e30bcBj6cRLA401fxyESjAIuGE7C8Ynf2Xb9uOA+RTS9/cUF0hwKPOUKcIiCoPwcD
         eID/CMQS1b4D+D4oc6dTmrTBgvy36Zv0WEXpnGca84WtkA1xOmRYW1+dspml3u9vFmMf
         063LpY3dlQT8btXVH/eOE9qZexDLFkejTJ0r8MbjatMZouHK7HBZRB6FY2bDeoW6NuTt
         iCww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=oavwsui6np9I0SfKH1zAjIQ7ScxL8JKCQoJQZLHKCqc=;
        b=pzoWiOJ/9ewopy3Mf+Q+Nn8nlLd8ZGDR2tepFHj5hfvbxj04K4AYo9Q3Qa0vcDnWNQ
         zJP7Awq+bdUns471z5J3/cWYU+AB1QIOXrMcB3nBScxs4qqbeCYn7QztwHyyRHWJOb2C
         Sx3PON6t6w13N0vdUrIuhtrNZtM4G/liEX+UpnRbB4VZ5SfmWwGnaOKaOtv6maYW3k1q
         xypo5MT9WexifdKWQl02tbb7cHVfDnRJKAk0yUWLSdeL4yWDi4ewHG2WWla1QBDysg8R
         OMs6NQofrGPWynYhJEMrkuMlewtDXoV8hzxQzZwMUNvMcjhJVJVvrsZXSrwuo+5suwzK
         WCaQ==
X-Gm-Message-State: AOAM533+3y5u3y+x8TvkkqhG81hAKdPzK4MMYQSd/7rWVYkWzXQNsiyb
        gSkGZxxRZ03m+QXNbreVXdEJeQ==
X-Google-Smtp-Source: ABdhPJxcw6xsEQPHoX5ZPR5XyUr4+XR87kRTiIKJKtBnMz6G01P7DuSk7X6dEo44hRKuMAMUHyjJhA==
X-Received: by 2002:a92:35d0:: with SMTP id c77mr11513440ilf.183.1599320530673;
        Sat, 05 Sep 2020 08:42:10 -0700 (PDT)
Received: from localhost ([2601:441:27f:8f73:89be:770e:7358:ee10])
        by smtp.gmail.com with ESMTPSA id o12sm227414ilq.29.2020.09.05.08.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 08:42:10 -0700 (PDT)
Date:   Sat, 5 Sep 2020 10:42:09 -0500
From:   Dan Rue <dan.rue@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        ben.hutchings@codethink.co.uk, stable@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux@roeck-us.net
Subject: Re: [PATCH 5.8 00/17] 5.8.7-rc1 review
Message-ID: <20200905154209.gpv5povvpn2v3i3o@nuc.therub.org>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        ben.hutchings@codethink.co.uk, stable@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux@roeck-us.net
References: <20200904120257.983551609@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200904120257.983551609@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 04, 2020 at 03:29:59PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.7 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Results from Linaro’s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>


Summary
------------------------------------------------------------------------

kernel: 5.8.7-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-5.8.y
git commit: 072d7559faf2a3b9f3c93e5cc96b276c6f02adec
git describe: v5.8.5-272-g072d7559faf2
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.8-oe/build/v5.8.5-272-g072d7559faf2

No regressions (compared to build v5.8.5)

No fixes (compared to build v5.8.5)

Ran 35624 total tests in the following environments and test suites.

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
* igt-gpu-tools
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
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
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* ltp-cve-tests
* ltp-sched-tests
* v4l2-compliance
* ltp-open-posix-tests
* network-basic-tests

--
Linaro LKFT
https://lkft.linaro.org
