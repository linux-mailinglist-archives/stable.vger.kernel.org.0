Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0F13CBBAC
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 20:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbhGPSLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 14:11:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231640AbhGPSLA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 14:11:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13651613E8;
        Fri, 16 Jul 2021 18:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626458885;
        bh=wU2Vt9y/IhP/lZgkJE2DXzPbKDt6BlCiq57u/JPPOWU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F/b30JeY0Qb1rSr7OCCO0mRbYy3YjunPVAutdmVYfH9VnMMU1IAYVc50G7JU5DZL/
         y+SAmhoJ32faOGyNvkdN02GltCmVxmZTVE8yGGyqw5PzmyCvmE1+SiitPbVboCnizC
         fiw3a2bQBFoDk3zNlPheNowM9+e8eDVUW8w6asD4=
Date:   Fri, 16 Jul 2021 20:08:03 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        linux- stable <stable@vger.kernel.org>, svens@linux.ibm.com
Subject: Re: [PATCH 5.12 000/242] 5.12.18-rc1 review
Message-ID: <YPHLA3WNKBVawKDa@kroah.com>
References: <20210715182551.731989182@linuxfoundation.org>
 <CAEUSe7_+8fQZ=1+jcxJVTRw0DYttGmR-aBdobZ0GWYQi3Vg97w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEUSe7_+8fQZ=1+jcxJVTRw0DYttGmR-aBdobZ0GWYQi3Vg97w@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 15, 2021 at 04:49:16PM -0500, Daniel Díaz wrote:
> Hello!
> 
> On Thu, 15 Jul 2021 at 13:56, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > This is the start of the stable review cycle for the 5.12.18 release.
> > There are 242 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 17 Jul 2021 18:21:07 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.18-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Build regressions have been found on this release candidate (and on 5.13-rc).
> 
> ## Regressions (compared to v5.12.17)
> * s390, build
>   - clang-10-allnoconfig
>   - clang-10-defconfig
>   - clang-10-tinyconfig
>   - clang-11-allnoconfig
>   - clang-11-defconfig
>   - clang-11-tinyconfig
>   - clang-12-allnoconfig
>   - clang-12-defconfig
>   - clang-12-tinyconfig
>   - gcc-8-allnoconfig
>   - gcc-8-defconfig
>   - gcc-8-tinyconfig
>   - gcc-9-allnoconfig
>   - gcc-9-defconfig
>   - gcc-9-tinyconfig
>   - gcc-10-allnoconfig
>   - gcc-10-defconfig
>   - gcc-10-tinyconfig
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> [...]
> > Sven Schnelle <svens@linux.ibm.com>
> >     s390/signal: switch to using vdso for sigreturn and syscall restart
> [...]
> 
> Our bisections pointed to this commit. Reverting it made the build pass again.

Will go drop this, thanks.

greg k-h
