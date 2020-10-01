Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70C7227F77C
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 03:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbgJABkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 21:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJABkb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Sep 2020 21:40:31 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD53C0613D0
        for <stable@vger.kernel.org>; Wed, 30 Sep 2020 18:40:29 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id z5so4544345ilq.5
        for <stable@vger.kernel.org>; Wed, 30 Sep 2020 18:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=IFdWuM8G8vVnjiDr+AATWqEEKCOF43QhP7SKC5atKmA=;
        b=EvOCVOJgeZvBkAv1oqbBBKXVtME1hPqFSBlCZ9bygLNNT6pAadUhuykHu5pJE7MnVN
         GUPnG5S1PhHX117vmA+vf21lwTRJwq4fmD9dWqMaMf9DpQlKGYOg/ECS+RIQ1m4JVnFz
         HgkaVSdgsezD89YOvuA0xNJflPdxu60oXR3nYpwpI6Jx8HBIB5lIpCLDS6CBjlFFnuYm
         OD/Bko5YLN4OD1eXb/oL6JDke6lmxpqiSZcfOXqrv5nemo82SuuveEYlwMfr9zu8xIG6
         TWWV8oZB3zBcPNXS4ijQg7EkfwPVxxJFwFL4vyb/S7FFtinnyewblK3uz0Qf4FmtT27p
         t3jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=IFdWuM8G8vVnjiDr+AATWqEEKCOF43QhP7SKC5atKmA=;
        b=nHX7aIK4rVnWa9HOupFmQFmQQFwA3XAdfnxbkAggO6owdXndjNVi+PhM2g8Qz4S1wE
         RbncrJcQ8FOsvqtkwm6pTmhldUjgd3YCzdB+8U2G5AeVmiq29GmygYx7vrsa1uqqAEUv
         90t4DeGtpxC5r9szacrp0bK5KHEYYvB8pd8oSVVM0dVTz/0x/8feBK5W+4KERPDqeCQ1
         sNv29BDugtkuLEtGtz5tcnt8WIGXHihqGP/xCURB6ul54ANHx7lsD8iMrjY6k8fsGwtV
         c39vt4j4k6DaSAcdm5+Rv3GWuN49bdZNLNdoQ4b80tvRnPsdfYXukDn1XuSdHtnK8oa4
         j6Yw==
X-Gm-Message-State: AOAM532srQUyBfFGAKcXr+y7i+17iMUkD1WN9p6DsoLAF9P2CKmFfpZw
        6QLd17/UUtOChtva0PiTaAUORA==
X-Google-Smtp-Source: ABdhPJxP8ZHAaBvk5RNDgOsaGX9+iG7Xl+BV58eHxUevXEnlgjFW4ktfvNyj4WNgHxq0qWYTKeKg/w==
X-Received: by 2002:a92:d905:: with SMTP id s5mr618252iln.224.1601516428251;
        Wed, 30 Sep 2020 18:40:28 -0700 (PDT)
Received: from localhost ([2601:441:27f:8f73:8a14:ee62:2db2:372a])
        by smtp.gmail.com with ESMTPSA id f22sm2027951ilf.56.2020.09.30.18.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 18:40:27 -0700 (PDT)
Date:   Wed, 30 Sep 2020 20:40:27 -0500
From:   Dan Rue <dan.rue@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/121] 4.9.238-rc1 review
Message-ID: <20201001014027.yaah7ghcuebfu6jr@nuc.therub.org>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
References: <20200929105930.172747117@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200929105930.172747117@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 29, 2020 at 12:59:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.238 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Results from Linaro’s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.9.238-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-4.9.y
git commit: 054f04eb3d5d58da303f70d141cf2ff1fddcbd71
git describe: v4.9.237-122-g054f04eb3d5d
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.237-122-g054f04eb3d5d


No regressions (compared to build v4.9.237)

No fixes (compared to build v4.9.237)

Ran 21423 total tests in the following environments and test suites.

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
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
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
* perf
* v4l2-compliance
* network-basic-tests
* libhugetlbfs
* ltp-open-posix-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* ssuite

--
Linaro LKFT
https://lkft.linaro.org
