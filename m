Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF1A23B72E
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 11:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729854AbgHDJA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 05:00:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729390AbgHDJA6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Aug 2020 05:00:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5099E2075D;
        Tue,  4 Aug 2020 09:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596531657;
        bh=sqH1HNkwbmu0X/RKQEAYlJa/wPVBDXS9d4qCkJrDVnY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bppsZunfxD4IexCBGYEL68ZSMFxz8rQUpm097Oqb/SoBVY9Y3H5yQquZZMDWCvjQX
         V9xHpoxjyLYqnP9CQEGUmgCQjC72Yi1jhOUy0tCCcTiBSyYUU2irk+jrXgQrRQ0ZVw
         Bun/3gbCc6Y/CENId+/EKlpe8ZJONYaSc14gGUTI=
Date:   Tue, 4 Aug 2020 11:00:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 5.7 000/121] 5.7.13-rc2 review
Message-ID: <20200804090038.GA2190164@kroah.com>
References: <20200804072435.385370289@linuxfoundation.org>
 <CA+G9fYs35Eiq1QFM0MOj6Y7gC=YKaiknCPgcJpJ5NMW4Y7qnYQ@mail.gmail.com>
 <20200804082130.GA1768075@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200804082130.GA1768075@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 04, 2020 at 10:21:30AM +0200, Greg Kroah-Hartman wrote:
> On Tue, Aug 04, 2020 at 01:46:31PM +0530, Naresh Kamboju wrote:
> > On Tue, 4 Aug 2020 at 13:03, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.7.13 release.
> > > There are 121 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Thu, 06 Aug 2020 07:23:45 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.13-rc2.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > 
> > arm64 build broken.
> > 
> > make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j16 ARCH=arm64
> > CROSS_COMPILE=aarch64-linux-gnu- HOSTCC=gcc CC="sccache
> > aarch64-linux-gnu-gcc" O=build Image
> > #
> > In file included from ../include/linux/smp.h:67,
> >                  from ../include/linux/percpu.h:7,
> >                  from ../include/linux/prandom.h:12,
> >                  from ../include/linux/random.h:118,
> >                  from ../arch/arm64/include/asm/pointer_auth.h:6,
> >                  from ../arch/arm64/include/asm/processor.h:39,
> >                  from ../include/linux/mutex.h:19,
> >                  from ../include/linux/kernfs.h:12,
> >                  from ../include/linux/sysfs.h:16,
> >                  from ../include/linux/kobject.h:20,
> >                  from ../include/linux/of.h:17,
> >                  from ../include/linux/irqdomain.h:35,
> >                  from ../include/linux/acpi.h:13,
> >                  from ../include/acpi/apei.h:9,
> >                  from ../include/acpi/ghes.h:5,
> >                  from ../include/linux/arm_sdei.h:8,
> >                  from ../arch/arm64/kernel/asm-offsets.c:10:
> > ../arch/arm64/include/asm/smp.h:100:29: error: field ‘ptrauth_key’ has
> > incomplete type
> >   100 |  struct ptrauth_keys_kernel ptrauth_key;
> >       |                             ^~~~~~~~~~~
> > make[2]: *** [../scripts/Makefile.build:100:
> > arch/arm64/kernel/asm-offsets.s] Error 1
> 
> Wow that was fast :(
> 
> So Linus's tree is also broken here.  I think it's time I just removed
> all of these patches from now until we get this all fixed up properly...

Ok, -rc3s are now out, with all of the random patches removed, and
hopefully everything builds properly.

Ah, the joys of messing with .h files after -rc7 :)

thanks,

greg k-h
