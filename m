Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F21CC13CE5
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 05:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbfEEDFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 23:05:18 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:33082 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727314AbfEEDFR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 May 2019 23:05:17 -0400
Received: by mail-io1-f65.google.com with SMTP id z4so1693881iol.0
        for <stable@vger.kernel.org>; Sat, 04 May 2019 20:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=emRPC54eEEGPljgaYDyg2blaUdPBnxIXD/btz0DOitM=;
        b=qW4qXU7iFLIPbzwtjY1gBy4sEed7o2W/qL5jClpQf1nIFEwaC2FzBINq/0SJVP4lRB
         eZ7HOMOdBXXoVqhHaEPQJ6stA2PEA3bNc4/TVwZTQdw3pDilydPiGD/uxPgE6eyeu+wI
         L1ctJ7cOyJUeY5q7O7X7C1RqMDcCuH+EaLKdmdb3gcbxJNTQc62keG+xWU6g9CZRQLCh
         P/ckE0ZFjpqx1GUS/12C64a4RBUlrISwGO6yHZkj/4IqGJnh/fM4QgCr69Dhf2o1tIal
         eMXkCWUF7BlEjQAxdqr8q+gMnrGC3OD++QCehV51Hyd9Efdp0K4DIALiPB/wGrVNMOFt
         tG4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=emRPC54eEEGPljgaYDyg2blaUdPBnxIXD/btz0DOitM=;
        b=VBty8cUpDxqzI4ih0yqyo79JbZf3/xUnsreMMgRqsHBmjqmHUsWWbMu0Fr8UqBtyTN
         SZO6NCYCz4vXS91zOa4wu+1X6T0YGyMipBq0E7Qt2Tf+QDlCaRkGHB9fBclvhCjHBSA1
         oYl1efbmIaOYbLQPNMLmQWIAcfOU+Pt2zXA/JsCtxFu9stJCfADr1B6bapUgGmlLAm+7
         GbY3s2AkI9OOz2mwHSbJPyH4a1h+4eUOcEBMiLwHYMWwS6mlM1U1g8GSGtseaaDKvnnV
         Z/o4jFDQlNNSyNytTuoMiAVm1SXG0dDWra5pRHV5EKE5CLcE15CT9v0pIHpoaPZp7jzH
         y1eg==
X-Gm-Message-State: APjAAAV5WAfhb0EKyeIPz0ZW6MrSplCdadDdStpr/cWmxgyBgvSIXP81
        wH1KYosEoz4cXFM3L0zVDlG3MQ==
X-Google-Smtp-Source: APXvYqzqeVyMohwp7nuUAIPMA3l/6F7O/Kb5YzSp928OMzPBB8QXuZA6KFMxPAsRYxtHeIGSJ9i/XQ==
X-Received: by 2002:a6b:b485:: with SMTP id d127mr1493717iof.273.1557025516873;
        Sat, 04 May 2019 20:05:16 -0700 (PDT)
Received: from localhost (c-75-72-120-115.hsd1.mn.comcast.net. [75.72.120.115])
        by smtp.gmail.com with ESMTPSA id s124sm3405317itb.42.2019.05.04.20.05.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 04 May 2019 20:05:16 -0700 (PDT)
Date:   Sat, 4 May 2019 22:05:15 -0500
From:   Dan Rue <dan.rue@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.0 00/32] 5.0.13-stable review
Message-ID: <20190505030515.txopqluki6mc2px2@xps.therub.org>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
References: <20190504102452.523724210@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190504102452.523724210@linuxfoundation.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 04, 2019 at 12:24:45PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.0.13 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon 06 May 2019 10:24:23 AM UTC.
> Anything received after that time might be too late.

Results from Linaro’s test farm.
Regressions detected.

Summary
------------------------------------------------------------------------

kernel: 5.0.13-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-5.0.y
git commit: c6bd3efdcefd68cc590853c50594a9fc971d93cd
git describe: v5.0.12-33-gc6bd3efdcefd
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.0-oe/build/v5.0.12-33-gc6bd3efdcefd

No regressions (compared to build v5.0.11-102-g17f93022a8c9)

No fixes (compared to build v5.0.11-102-g17f93022a8c9)

Ran 25060 total tests in the following environments and test suites.

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
* kvm-unit-tests
* ltp-fs-tests
* ltp-open-posix-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

-- 
Linaro LKFT
https://lkft.linaro.org
