Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A193C62FC
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 20:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236041AbhGLS47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 14:56:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236046AbhGLS46 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 14:56:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9295561241;
        Mon, 12 Jul 2021 18:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626116050;
        bh=4RJkxnDXnZSVwbYLKvsFPbNIF/Qu+BmQAFClaLF5500=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SoMkIfBZLV4RY4sQHlVgHyBxGPCuhrKYZ9pf6bXqP7/ULvoWqz1Gpiz1Le8YPAain
         VhbKr6hcZ6fFKuJn9SSRjvlNOooM1AWswFsstbdfbUEAz9V8Lw/n5OuBJt574TfUPP
         niXWgvr3YPDxtfwYJDSnXNxJUrTsi/8EJTL7DepA=
Date:   Mon, 12 Jul 2021 20:54:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>,
        Nathan Lynch <nathanl@linux.ibm.com>
Subject: Re: [PATCH 5.10 000/593] 5.10.50-rc1 review
Message-ID: <YOyP0Bv8FZIoaENk@kroah.com>
References: <20210712060843.180606720@linuxfoundation.org>
 <CA+G9fYtdYvUse1Osfrux6DVU_DiLAKveQqnEZ36eoG-fThJBqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYtdYvUse1Osfrux6DVU_DiLAKveQqnEZ36eoG-fThJBqw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 12, 2021 at 05:51:53PM +0530, Naresh Kamboju wrote:
> On Mon, 12 Jul 2021 at 11:59, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.50 release.
> > There are 593 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.50-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> Regression detected on powerpc,
> 
> Regressions found on powerpc:
>  - build/gcc-10-cell_defconfig
>  - build/gcc-10-maple_defconfig
>  - build/gcc-10-defconfig
>  - build/gcc-8-defconfig
>  - build/gcc-9-defconfig
>  - build/gcc-9-maple_defconfig
>  - build/gcc-8-maple_defconfig
>  - build/gcc-8-cell_defconfig
>  - build/gcc-9-cell_defconfig
> 
> The following patch caused build warnings / errors on powerpc.
> 
> > Michael Ellerman <mpe@ellerman.id.au>
> >     powerpc/stacktrace: Fix spurious "stale" traces in raise_backtrace_ipi()
> 
> Build error:
> --------------
> arch/powerpc/kernel/stacktrace.c: In function 'raise_backtrace_ipi':
> arch/powerpc/kernel/stacktrace.c:248:5: error: implicit declaration of
> function 'udelay' [-Werror=implicit-function-declaration]
>   248 |     udelay(1);
>       |     ^~~~~~
> cc1: all warnings being treated as errors
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> link to build log:
> https://builds.tuxbuild.com/1vCh34NozLpcdYwjDS72K2fkiM3/

Added the needed .h file and pushed out a -rc2.

thanks,

greg k-h
