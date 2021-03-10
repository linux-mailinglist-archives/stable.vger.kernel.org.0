Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E874E3346A5
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 19:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbhCJS0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 13:26:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:38554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231138AbhCJS0R (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 13:26:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20AFD64EE6;
        Wed, 10 Mar 2021 18:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615400777;
        bh=UWnQsIGwkgbWSvIc8G15s/a5eaz1NZT7a4zcMVwZDAU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ti3Mev1IJa4BycbRYeWecKa8ZM5CCUHjI2YO8nwTqh4L3Lj474IHJQEz4Pug2p/b8
         CtmEa5F6bEWQOmA8hileaVaXiBVxzKNmWUEk+lpKvfOE34zr3WoCimJ0G1Y/AZI47y
         38eexWiDbE2kOixPr3zhvCirhzhgnD4Rx9gBbNPU=
Date:   Wed, 10 Mar 2021 19:26:15 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alex Elder <elder@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>, lkft-triage@lists.linaro.org
Subject: Re: [PATCH 5.10 00/49] 5.10.23-rc1 review
Message-ID: <YEkPRy/RUfF764r+@kroah.com>
References: <20210310132321.948258062@linuxfoundation.org>
 <CA+G9fYuydf-g2FPOtP9LAX-4zY3EF64Bx0OQjbjn=a4V+0=eLA@mail.gmail.com>
 <20210310175834.GA257774@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310175834.GA257774@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 09:58:34AM -0800, Guenter Roeck wrote:
> On Wed, Mar 10, 2021 at 11:08:10PM +0530, Naresh Kamboju wrote:
> > On Wed, 10 Mar 2021 at 18:54, <gregkh@linuxfoundation.org> wrote:
> > >
> > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > >
> > > This is the start of the stable review cycle for the 5.10.23 release.
> > > There are 49 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.23-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > 
> > While building stable rc 5.10 for arm64 the build failed due to
> > the following errors / warnings.
> > 
> > make --silent --keep-going --jobs=8
> > O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=arm64
> > CROSS_COMPILE=aarch64-linux-gnu- 'HOSTCC=sccache clang' 'CC=sccache
> > clang'
> > drivers/net/ipa/gsi.c:1074:7: error: use of undeclared identifier
> > 'GENERIC_EE_CHANNEL_NOT_RUNNING_FVAL'
> >         case GENERIC_EE_CHANNEL_NOT_RUNNING_FVAL:
> >              ^
> > 1 error generated.
> > make[4]: *** [scripts/Makefile.build:279: drivers/net/ipa/gsi.o] Error 1
> > 
> Also:
> 
> Building arm64:allmodconfig ... failed
> --------------
> Error log:
> sound/soc/intel/boards/sof_rt5682.c:117:6: error: 'SOF_RT1015_SPEAKER_AMP_100FS' undeclared here

This patch now dropped, thanks.

greg k-h
