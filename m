Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9931110C4AC
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 09:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbfK1IFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 03:05:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:46122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726301AbfK1IFG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Nov 2019 03:05:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E7B121741;
        Thu, 28 Nov 2019 08:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574928304;
        bh=2UM8mIcEpLNwa1RV2YM+IG8ba13V6SC31zZzyOpUkQs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AmIn6lljIPfm9G52AKSPytk2oeX9xxsLOY+xe9X2Tfi0Vc1Stf0Ky68DMNcx+MG3w
         Z53+XsDGosYIfQ0v1xKv1EPytvWWjEIBMllA3XGo2bdIfTsA5WzqjP60uvki+7mbqh
         Hk3kqjzoTLVicrvg37/SmL8ptkN3CmYCSuiDJCf0=
Date:   Thu, 28 Nov 2019 09:05:01 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/306] 4.19.87-stable review
Message-ID: <20191128080501.GA3384654@kroah.com>
References: <20191127203114.766709977@linuxfoundation.org>
 <CAEUSe7_KTY_06epzsXW0LFLVASOiLaFb0ZgRg+4bE2kjQXnEZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEUSe7_KTY_06epzsXW0LFLVASOiLaFb0ZgRg+4bE2kjQXnEZA@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 27, 2019 at 06:27:55PM -0600, Daniel Díaz wrote:
> Hello!
> 
> 
> On Wed, 27 Nov 2019 at 14:55, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > This is the start of the stable review cycle for the 4.19.87 release.
> > There are 306 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.87-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> We're seeing this build failure on 4.19 (and 4.14) on x86 32-bits:
> > In file included from /srv/oe/build/tmp-lkft-glibc/work-shared/intel-core2-32/kernel-source/include/linux/export.h:45:0,
> >                  from /srv/oe/build/tmp-lkft-glibc/work-shared/intel-core2-32/kernel-source/include/linux/linkage.h:7,
> >                  from /srv/oe/build/tmp-lkft-glibc/work-shared/intel-core2-32/kernel-source/include/linux/preempt.h:10,
> >                  from /srv/oe/build/tmp-lkft-glibc/work-shared/intel-core2-32/kernel-source/include/linux/spinlock.h:51,
> >                  from /srv/oe/build/tmp-lkft-glibc/work-shared/intel-core2-32/kernel-source/arch/x86/mm/cpu_entry_area.c:3:
> > In function 'setup_cpu_entry_area_ptes',
> >     inlined from 'setup_cpu_entry_areas' at /srv/oe/build/tmp-lkft-glibc/work-shared/intel-core2-32/kernel-source/arch/x86/mm/cpu_entry_area.c:209:2:
> > /srv/oe/build/tmp-lkft-glibc/work-shared/intel-core2-32/kernel-source/include/linux/compiler.h:348:38: error: call to '__compiletime_assert_192' declared with attribute error: BUILD_BUG_ON failed: (CPU_ENTRY_AREA_PAGES+1)*PAGE_SIZE != CPU_ENTRY_AREA_MAP_SIZE
> >   _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
> >                                       ^
> > /srv/oe/build/tmp-lkft-glibc/work-shared/intel-core2-32/kernel-source/include/linux/compiler.h:329:4: note: in definition of macro '__compiletime_assert'
> >     prefix ## suffix();    \
> >     ^~~~~~
> > /srv/oe/build/tmp-lkft-glibc/work-shared/intel-core2-32/kernel-source/include/linux/compiler.h:348:2: note: in expansion of macro '_compiletime_assert'
> >   _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
> >   ^~~~~~~~~~~~~~~~~~~
> > /srv/oe/build/tmp-lkft-glibc/work-shared/intel-core2-32/kernel-source/include/linux/build_bug.h:45:37: note: in expansion of macro 'compiletime_assert'
> >  #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
> >                                      ^~~~~~~~~~~~~~~~~~
> > /srv/oe/build/tmp-lkft-glibc/work-shared/intel-core2-32/kernel-source/include/linux/build_bug.h:69:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
> >   BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
> >   ^~~~~~~~~~~~~~~~
> > /srv/oe/build/tmp-lkft-glibc/work-shared/intel-core2-32/kernel-source/arch/x86/mm/cpu_entry_area.c:192:2: note: in expansion of macro 'BUILD_BUG_ON'
> >   BUILD_BUG_ON((CPU_ENTRY_AREA_PAGES+1)*PAGE_SIZE != CPU_ENTRY_AREA_MAP_SIZE);
> >   ^~~~~~~~~~~~
> 
> Bisection points to "x86/cpu_entry_area: Add guard page for entry
> stack on 32bit" (e50622b4a1, also present in 4.14.y as 880a98c339).

Ugh, I was hoping that 32bit stuff "just worked".  I'll take a look at
the whole series later today and try to work to backport some of the
known-missing parts of that series.

thanks,

greg k-h
