Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D8832D1B5
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 12:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239489AbhCDLYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 06:24:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:42494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231877AbhCDLX6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 06:23:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA98164F0A;
        Thu,  4 Mar 2021 11:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614856998;
        bh=ATRq1K4aXnURfrCxB9naFZ2vK8QttOmkqhGzAxe7gEQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LAiUXvqTs1vJCPEvCrqjnOLwReOJAWnhu+4rXljsOMhL1CqPMu4G+N7YTYl+LIlgZ
         O65jZBPxNQPm/z2r8GVe/kKSL5f7x/qgPxyLXSsJWfxNoruoQruiyEr0GTVyxGJZi6
         G11tkuis3fSfY6KyprTDA4ZlSvKG5UwFAeS/hO5o=
Date:   Thu, 4 Mar 2021 12:23:15 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        LTP List <ltp@lists.linux.it>
Subject: Re: [PATCH 5.11 000/773] 5.11.3-rc3 review
Message-ID: <YEDDIzz32JqSvi1S@kroah.com>
References: <20210302192719.741064351@linuxfoundation.org>
 <CA+G9fYvkW+84U9e0Cjft_pq9bGnBBqCXST7Hg+gx4pKNyuGPFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYvkW+84U9e0Cjft_pq9bGnBBqCXST7Hg+gx4pKNyuGPFQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 03, 2021 at 02:02:20PM +0530, Naresh Kamboju wrote:
> On Wed, 3 Mar 2021 at 00:59, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.11.3 release.
> > There are 773 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.3-rc3.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> Results from Linaro’s test farm.
> All our builds are getting PASS now.
> But,
> Regressions detected on all devices (arm64, arm, x86_64 and i386).
> LTP pty test case hangup01 failed on all devices
> 
> hangup01    1  TFAIL  :  hangup01.c:133: unexpected message 3
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> This failure is specific to stable-rc v5.10.20-rc4 and v5.11.3-rc3
> Test PASS on the v5.12-rc1 mainline and Linux next kernel.
> 
> Following two commits caused this test failure,
> 
>    Linus Torvalds <torvalds@linux-foundation.org>
>        tty: implement read_iter
> 
>    Linus Torvalds <torvalds@linux-foundation.org>
>        tty: convert tty_ldisc_ops 'read()' function to take a kernel pointer
> 
> Test case failed link,
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.11.y/build/v5.11.2-774-g6ca52dbc58df/testrun/4070143/suite/ltp-pty-tests/test/hangup01/log
> 

Thanks for testing them all, I'll try to debug this later today...

greg k-h
