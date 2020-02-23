Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0ACB1698D6
	for <lists+stable@lfdr.de>; Sun, 23 Feb 2020 18:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgBWR0J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Feb 2020 12:26:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:60708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbgBWR0I (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 23 Feb 2020 12:26:08 -0500
Received: from localhost (95-141-97-180.as16211.net [95.141.97.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20A652067D;
        Sun, 23 Feb 2020 17:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582478766;
        bh=/ZkETHgTdYzbHnFqULWsjzMztm5RWK6yU5jFZTyLP1M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T3YAJkNMAl3s5FiFsAcCORC/PFvKxlYmrAz6iyrywPDyzc7a6oJ6mJzMa3ZDVeZip
         1tpvniBBXwnNyyoWKnpt8O39QujKJ9iqxc77z1ibflIbLSPv7HvD4HS8LVgD9ViEdf
         ErXeHQQczK6+CeeV8roE6m9SqtgBWOa9y/+kzat0=
Date:   Sun, 23 Feb 2020 18:26:04 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tero Kristo <t-kristo@ti.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Jon Hunter <jonathanh@nvidia.com>
Subject: Re: [PATCH 5.4 000/344] 5.4.22-stable review
Message-ID: <20200223172604.GC349989@kroah.com>
References: <20200221072349.335551332@linuxfoundation.org>
 <529a5a4a-974e-995a-9556-c2a14d09bb5d@nvidia.com>
 <CA+G9fYv-KC0v++YsyXR-rhC2JBGUfhNGD+XYaZjN3fJSX1x_mg@mail.gmail.com>
 <f671fbf6-1cd5-ae8a-82e7-d3aba63e9840@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f671fbf6-1cd5-ae8a-82e7-d3aba63e9840@ti.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 21, 2020 at 01:57:20PM +0200, Tero Kristo wrote:
> On 21/02/2020 13:17, Naresh Kamboju wrote:
> > On Fri, 21 Feb 2020 at 15:34, Jon Hunter <jonathanh@nvidia.com> wrote:
> > > 
> > > 
> > > On 21/02/2020 07:36, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 5.4.22 release.
> > > > There are 344 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Sun, 23 Feb 2020 07:19:49 +0000.
> > > > Anything received after that time might be too late.
> > > > 
> > > > The whole patch series can be found in one patch at:
> > > >        https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.22-rc1.gz
> > > > or in the git tree and branch at:
> > > >        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > > > and the diffstat can be found below.
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > > 
> > > > -------------
> > > > Pseudo-Shortlog of commits:
> > > 
> > > ...
> > > 
> > > > Tero Kristo <t-kristo@ti.com>
> > > >      ARM: OMAP2+: pdata-quirks: add PRM data for reset support
> > > 
> > > 
> > > The above commit is generating the following build error on ARM systems ...
> > > 
> > > dvs/git/dirty/git-master_l4t-upstream/kernel/arch/arm/mach-omap2/pdata-quirks.c:27:10: fatal error: linux/platform_data/ti-prm.h: No such file or directory
> > >   #include <linux/platform_data/ti-prm.h>
> > >            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > 
> > build error:
> > 
> > ../arch/arm/mach-omap2/pdata-quirks.c:27:10: fatal error:
> > linux/platform_data/ti-prm.h: No such file or directory
> >     27 | #include <linux/platform_data/ti-prm.h>
> >        |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > compilation terminated.
> > make[2]: *** [../scripts/Makefile.build:265:
> > arch/arm/mach-omap2/pdata-quirks.o] Error 1
> > 
> > With these below three patches, it applies cleanly and builds.
> > But I'm not sure these are not expected to get into stable rc 5.4 branch.
> 
> Yeah, without PRM driver the pdata-quirk patch should not have been picked
> up. I wonder why it ended up in stable. Tony, any ideas?

I've dropped the offending patch now, sorry about that.

greg k-h
