Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C14537ED93
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 00:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387710AbhELUjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 16:39:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:45008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1377705AbhELTIi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 15:08:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13F8261352;
        Wed, 12 May 2021 19:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620846449;
        bh=0BxTJXcbZFHuOpFmr3eUucmK1hxwPAdwUxvGwpApFI0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mSGjSWC+9EAUkgWfiqaR5wTM0BUA9PUhfYo51Zu4LG4ubBNd9exctXyNaPLp8J+QS
         af82vo4EksXjrCpaFEgeInFncqHVmQufcuKAijWywzOErH1FGJ1Kf72sqAZPAovnTY
         XFILde18E8BgsyBbpkvU0MLcMxlbmzJamXGkCbkk=
Date:   Wed, 12 May 2021 21:07:27 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Huacai Chen <chenhuacai@kernel.org>
Subject: Re: [PATCH 5.12 000/677] 5.12.4-rc1 review
Message-ID: <YJwnb4BwQEr7xFsV@kroah.com>
References: <20210512144837.204217980@linuxfoundation.org>
 <CA+G9fYufHvM+C=39gtk5CF-r4sYYpRkQFGsmKrkdQcXj_XKFag@mail.gmail.com>
 <YJwW2bNXGZw5kmpo@kroah.com>
 <CA+G9fYvbe9L=3uJk2+5fR_e2-fnw=UXSDRnHh+u3nMFeOjOwjg@mail.gmail.com>
 <YJwjuJrYiyS/eeR8@kroah.com>
 <8615959b-9054-5c9f-0afa-f15672274d12@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8615959b-9054-5c9f-0afa-f15672274d12@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 12:04:04PM -0700, Nathan Chancellor wrote:
> On 5/12/2021 11:51 AM, Greg Kroah-Hartman wrote:
> > On Thu, May 13, 2021 at 12:18:32AM +0530, Naresh Kamboju wrote:
> > > On Wed, 12 May 2021 at 23:26, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > > 
> > > > On Wed, May 12, 2021 at 10:53:04PM +0530, Naresh Kamboju wrote:
> > > > > On Wed, 12 May 2021 at 21:27, Greg Kroah-Hartman
> > > > > <gregkh@linuxfoundation.org> wrote:
> > > > > > 
> > > > > > This is the start of the stable review cycle for the 5.12.4 release.
> > > > > > There are 677 patches in this series, all will be posted as a response
> > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > let me know.
> > > > > > 
> > > > > > Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> > > > > > Anything received after that time might be too late.
> > > > > > 
> > > > > > The whole patch series can be found in one patch at:
> > > > > >          https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.4-rc1.gz
> > > > > > or in the git tree and branch at:
> > > > > >          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> > > > > > and the diffstat can be found below.
> > > > > > 
> > > > > > thanks,
> > > > > > 
> > > > > > greg k-h
> > > > > 
> > > > > 
> > > > > MIPS Clang build regression detected.
> > > > > MIPS gcc-10,9 and 8 build PASS.
> > > > > 
> > > > > > Maciej W. Rozycki <macro@orcam.me.uk>
> > > > > >      MIPS: Reinstate platform `__div64_32' handler
> > > > > 
> > > > > mips clang build breaks on stable rc 5.4 .. 5.12 due to below warnings / errors
> > > > >   - mips (defconfig) with clang-12
> > > > >   - mips (tinyconfig) with clang-12
> > > > >   - mips (allnoconfig) with clang-12
> > > > > 
> > > > > make --silent --keep-going --jobs=8
> > > > > O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=mips
> > > > > CROSS_COMPILE=mips-linux-gnu- 'HOSTCC=sccache clang' 'CC=sccache
> > > > > clang'
> > > > > kernel/time/hrtimer.c:318:2: error: couldn't allocate output register
> > > > > for constraint 'x'
> > > > >          do_div(tmp, (u32) div);
> > > > >          ^
> > > > > include/asm-generic/div64.h:243:11: note: expanded from macro 'do_div'
> > > > >                  __rem = __div64_32(&(n), __base);       \
> > > > >                          ^
> > > > > arch/mips/include/asm/div64.h:74:11: note: expanded from macro '__div64_32'
> > > > >                  __asm__("divu   $0, %z1, %z2"                           \
> > > > >                          ^
> > > > > 1 error generated.
> > > > 
> > > > Does this also show up in Linus's tree?  The same MIPS patch is there as
> > > > well from what I can tell.
> > > 
> > > No.
> > > Linus's tree builds MIPS clang successfully.
> > 
> > Ick, ok, I'll go drop this and let a MIPS developer send us the correct
> > thing.
> > 
> > thanks!
> > 
> > greg k-h
> > 
> 
> I think you just need to grab commits c1d337d45ec0 ("MIPS: Avoid DIVU in
> `__div64_32' is result would be zero") and 25ab14cbe9d1 ("MIPS: Avoid
> handcoded DIVU in `__div64_32' altogether") to fix this up.

It was easier for me to drop it, let's see if any MIPS developers (are
there any anymore?) care enough to send the proper series.

thanks,

greg k-h
