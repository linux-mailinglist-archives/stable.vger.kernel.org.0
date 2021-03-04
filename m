Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0BFE32D81A
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 17:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbhCDQxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 11:53:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236786AbhCDQxb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 11:53:31 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD1EC061574;
        Thu,  4 Mar 2021 08:52:50 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id a13so30820398oid.0;
        Thu, 04 Mar 2021 08:52:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=pQ2I+V66AMcAwQfqsnZhOw7PXkTt/5x9hT6p4MnWawA=;
        b=QPJ2DoKh/JAtTcfSaKOck7R6fNv75KA8aT8wZdYjKlfIgvTTCBRRtO/qJ+orj2pv2B
         1H1cyBC/clM4zDEPFuyRafZyDMKWIIsEqgf7KKQOOMIe9rxToUDvomsDy1WPhhkMrf5G
         irFuJqe9h7kRfzlSEwreaOWpN0fWNrRh0s1Yoq1gA/kwkzZfKFk3fKGgeQO2yM9whs9H
         Uvou6okjND23Xx9DJlxfes4dRh/fhxlNOmIQ5EGk5+mFIorNDBuOMRk6wyxRvfo0hh7k
         x0Oo2FtwZri/J2s3eE5uZFWh8+ma0fZMAgnSC2TCO3BDu8jFVm3aAMuqz8Se0BapO4XS
         4hyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=pQ2I+V66AMcAwQfqsnZhOw7PXkTt/5x9hT6p4MnWawA=;
        b=Du+Kz1ye5v09AqlwKytKHGZVrIxj03suyVsvCkX3YLN+pia6tGom+qEUYLwfQ+IBgt
         t/t+tXqqylZltH5iEuWP6JNeVlQL7HvseqqKiC3hPa0PPLRlB9ANU5pErIe68cKV2cFc
         GUZM9bqIJXlRtoURAeE4TRg5Nc9vVAfrQRanacWGFT7cQH2x71Ig1ceCnFo+kP9XtjTb
         SY/0JRkfjbwPr5IlmiOO9L1ksY5XziyUFzCXd8UiWBmPyEJt72k5H0YM6sRCd8ms1pMT
         CUyqTLFjyw41YmYckpf8HCYyu0EWIu35a7NIaOp7DWOI8oa47pBciyqs7+TGE1IF+jyE
         EQZg==
X-Gm-Message-State: AOAM532Us21LpMw00GeonCBDYbyApsIiIWo2/Gj9VHtyIiiJsWpMDv2M
        Q1p8tzW6icxdaOQolp/bZuQ=
X-Google-Smtp-Source: ABdhPJxJlftwX9kPs+Ilsz6C+1AZL4ACZVS+3xLZM3+umkgK6VMQBFhXjlQlT3gCTsYt4p6azEk5GA==
X-Received: by 2002:a54:470a:: with SMTP id k10mr3625194oik.80.1614876770334;
        Thu, 04 Mar 2021 08:52:50 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v3sm592463oix.48.2021.03.04.08.52.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Mar 2021 08:52:49 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 4 Mar 2021 08:52:47 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        LTP List <ltp@lists.linux.it>
Subject: Re: [PATCH 5.11 000/773] 5.11.3-rc3 review
Message-ID: <20210304165247.GA131220@roeck-us.net>
References: <20210302192719.741064351@linuxfoundation.org>
 <CA+G9fYvkW+84U9e0Cjft_pq9bGnBBqCXST7Hg+gx4pKNyuGPFQ@mail.gmail.com>
 <YEDDIzz32JqSvi1S@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YEDDIzz32JqSvi1S@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 04, 2021 at 12:23:15PM +0100, Greg Kroah-Hartman wrote:
> On Wed, Mar 03, 2021 at 02:02:20PM +0530, Naresh Kamboju wrote:
> > On Wed, 3 Mar 2021 at 00:59, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.11.3 release.
> > > There are 773 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.3-rc3.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > 
> > 
> > Results from Linaro’s test farm.
> > All our builds are getting PASS now.
> > But,
> > Regressions detected on all devices (arm64, arm, x86_64 and i386).
> > LTP pty test case hangup01 failed on all devices
> > 
> > hangup01    1  TFAIL  :  hangup01.c:133: unexpected message 3
> > 
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > 
> > This failure is specific to stable-rc v5.10.20-rc4 and v5.11.3-rc3
> > Test PASS on the v5.12-rc1 mainline and Linux next kernel.
> > 
> > Following two commits caused this test failure,
> > 
> >    Linus Torvalds <torvalds@linux-foundation.org>
> >        tty: implement read_iter
> > 
> >    Linus Torvalds <torvalds@linux-foundation.org>
> >        tty: convert tty_ldisc_ops 'read()' function to take a kernel pointer
> > 
> > Test case failed link,
> > https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.11.y/build/v5.11.2-774-g6ca52dbc58df/testrun/4070143/suite/ltp-pty-tests/test/hangup01/log
> > 
> 
> Thanks for testing them all, I'll try to debug this later today...
> 

Did you see my response to v5.10.y ? It looks like two related patches
may be missing from v5.10.y and v5.11.y.

Guenter
