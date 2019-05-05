Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F25A213F63
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 14:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfEEMRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 08:17:51 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:36626 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbfEEMRv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 May 2019 08:17:51 -0400
Received: by mail-it1-f194.google.com with SMTP id v143so15995527itc.1
        for <stable@vger.kernel.org>; Sun, 05 May 2019 05:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=4hW+IQ2/rTPS/q+t3hSiYLPkw+JIBhPbTU/d3yEZ+Ag=;
        b=RIqkcjUP+0yGZF+usrElKEbnS+TbP8EnW8D2nvEuJL3nzANp2OYUp0iCzpd1bKsi5e
         97Qwq7KiwG7Sm7gaRyA+6576Vb5chfrRYUJKbvFhdkr8bjsng1a0SzRF1ucHE52q1SRQ
         BxR//I7c7dsctWCndYuwoLJaHQTLlO0y0UMQ4RduSAEaKb+YG3+bsVCoeeEhhmp/ly80
         xsauVvoYbzPaRqg1j933HzTEwnEKsdk9YxAISN/sEiOHBHl1vnMskkjqQwGghgDrT995
         wevsH+LHYL29W7XCcj6kXWesqtS40DeBLEfl6BQRyAl4OFEnPTZFEUgaaxdMeEpdvfd4
         HBsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=4hW+IQ2/rTPS/q+t3hSiYLPkw+JIBhPbTU/d3yEZ+Ag=;
        b=iK3lyoEX+ziCATIj5yb1O/dUi5nhj1mFyUZiyXsrYJPWME0I68bxhKqSfQTDW7V1IV
         7Jdsk1FGVmBnlmJNlqy9LCMU+kinxYSXIhU2QAnzYQYbFigPPhw3/FwG/rHDGs9bdG0z
         5V5ZO8R4F5LDAkmt3FHmjZRgNcgfSK9oVnhuvmX+OHZtXqsQjZaQ3l5Ddbn+C/F9s+az
         40i/MJ2w5ykiQCcGiiwc32YqDrKryG1lgaUfrPx3I8hpiqZRuIgFolN9EMRIoJZBOJ5y
         ph39X4Neh6/yiJFbEDnS4J0BYK4hpeL8jHcXaRZHiBtx7V4kqGCYjOZQWJ20vsfBJcqt
         SSQw==
X-Gm-Message-State: APjAAAU7H5G3ZQMdAmAnOwOo76DwlnZ68dm0RzQtBs2zaUrb12ZpuzD6
        ytpYqb7SM2rrFVg2A5MOjkt/Kw==
X-Google-Smtp-Source: APXvYqxgO1PkegUm1ms5/MUjuQVvD2EG3EsQSAzR2eDvgPBCmQoeegeW6AdcePuHbNSKQnMWq+vIPg==
X-Received: by 2002:a02:b088:: with SMTP id v8mr15263674jah.21.1557058670076;
        Sun, 05 May 2019 05:17:50 -0700 (PDT)
Received: from localhost (c-75-72-120-115.hsd1.mn.comcast.net. [75.72.120.115])
        by smtp.gmail.com with ESMTPSA id d133sm3761472ita.5.2019.05.05.05.17.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 05 May 2019 05:17:48 -0700 (PDT)
Date:   Sun, 5 May 2019 07:17:48 -0500
From:   Dan Rue <dan.rue@linaro.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.0 00/32] 5.0.13-stable review
Message-ID: <20190505121748.p7yeymdissakg4q5@xps.therub.org>
Mail-Followup-To: Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190504102452.523724210@linuxfoundation.org>
 <20190505030515.txopqluki6mc2px2@xps.therub.org>
 <4913833a-5b46-20d0-4dce-3e6d46a7a498@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4913833a-5b46-20d0-4dce-3e6d46a7a498@roeck-us.net>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 04, 2019 at 08:31:36PM -0700, Guenter Roeck wrote:
> On 5/4/19 8:05 PM, Dan Rue wrote:
> > On Sat, May 04, 2019 at 12:24:45PM +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.0.13 release.
> > > There are 32 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Mon 06 May 2019 10:24:23 AM UTC.
> > > Anything received after that time might be too late.
> > 
> > Results from Linaro’s test farm.
> > Regressions detected.
> > 
> 
> Confusing. What are the regressions ? Below it says that there are none.

My mistake for dashing it off too quickly. No regressions on arm64, arm,
x86_64, and i386.

Dan

> 
> Guenter
> 
> > Summary
> > ------------------------------------------------------------------------
> > 
> > kernel: 5.0.13-rc1
> > git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > git branch: linux-5.0.y
> > git commit: c6bd3efdcefd68cc590853c50594a9fc971d93cd
> > git describe: v5.0.12-33-gc6bd3efdcefd
> > Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.0-oe/build/v5.0.12-33-gc6bd3efdcefd
> > 
> > No regressions (compared to build v5.0.11-102-g17f93022a8c9)
> > 
> > No fixes (compared to build v5.0.11-102-g17f93022a8c9)
> > 
> > Ran 25060 total tests in the following environments and test suites.
> > 
> > Environments
> > --------------
> > - dragonboard-410c
> > - hi6220-hikey
> > - i386
> > - juno-r2
> > - qemu_arm
> > - qemu_arm64
> > - qemu_i386
> > - qemu_x86_64
> > - x15
> > - x86
> > 
> > Test Suites
> > -----------
> > * build
> > * install-android-platform-tools-r2600
> > * kselftest
> > * libgpiod
> > * libhugetlbfs
> > * ltp-cap_bounds-tests
> > * ltp-commands-tests
> > * ltp-containers-tests
> > * ltp-cpuhotplug-tests
> > * ltp-cve-tests
> > * ltp-dio-tests
> > * ltp-fcntl-locktests-tests
> > * ltp-filecaps-tests
> > * ltp-fs_bind-tests
> > * ltp-fs_perms_simple-tests
> > * ltp-fsx-tests
> > * ltp-hugetlb-tests
> > * ltp-io-tests
> > * ltp-ipc-tests
> > * ltp-math-tests
> > * ltp-mm-tests
> > * ltp-nptl-tests
> > * ltp-pty-tests
> > * ltp-sched-tests
> > * ltp-securebits-tests
> > * ltp-syscalls-tests
> > * ltp-timers-tests
> > * perf
> > * spectre-meltdown-checker-test
> > * v4l2-compliance
> > * kvm-unit-tests
> > * ltp-fs-tests
> > * ltp-open-posix-tests
> > * kselftest-vsyscall-mode-native
> > * kselftest-vsyscall-mode-none
> > 
> 

-- 
Linaro - Kernel Validation
