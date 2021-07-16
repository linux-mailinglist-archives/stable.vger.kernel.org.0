Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE9F73CBBAE
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 20:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbhGPSLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 14:11:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230376AbhGPSLP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 14:11:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAD336109E;
        Fri, 16 Jul 2021 18:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626458898;
        bh=AYwr3PnPcKYg0G7RuSIA9vLukMb6+DpEIPaFqzcAvQU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SECuFziSl4qES4p6XosLO21HVnF436uupy6Tx8CkaUZondgMnp/DkAkA/AR30+RCt
         H0xYIW9wBojDCScXhX8bDp9v3TnmaKc/01hayBQzhHWoa2/rBRPwVXddZWmRib/OQm
         MrQvtVsdgs6VwLMmZkveSyi27DdTf28VXYeO/YMg=
Date:   Fri, 16 Jul 2021 20:08:16 +0200
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
Subject: Re: [PATCH 5.13 000/266] 5.13.3-rc1 review
Message-ID: <YPHLEAE5XLR3r7dn@kroah.com>
References: <20210715182613.933608881@linuxfoundation.org>
 <CAEUSe7-HX=WrpXfcfnBUAjvEMGvraWv5hXwSgXqfUM4X1KarFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEUSe7-HX=WrpXfcfnBUAjvEMGvraWv5hXwSgXqfUM4X1KarFg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 15, 2021 at 04:40:55PM -0500, Daniel Díaz wrote:
> Hello!
> 
> On Thu, 15 Jul 2021 at 14:09, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > This is the start of the stable review cycle for the 5.13.3 release.
> > There are 266 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 17 Jul 2021 18:21:07 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.3-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Build regressions have been found on this release candidate (and on 5.12-rc).
> 
> ## Regressions (compared to v5.13.2)
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
> 

Now dropped, thanks.

greg k-h
