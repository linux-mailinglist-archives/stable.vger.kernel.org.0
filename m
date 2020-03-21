Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0F6918DE63
	for <lists+stable@lfdr.de>; Sat, 21 Mar 2020 08:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbgCUHJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Mar 2020 03:09:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727963AbgCUHJJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Mar 2020 03:09:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54D6220739;
        Sat, 21 Mar 2020 07:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584774548;
        bh=e31TypMS9tEW1Nr7rExcOyMH73vCgbSohVld9tY7byI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L12+lRIjgADv0ldM4tCG/B8pbgepzstWKwPNNlSWfZW/Gp+JCYO+nYSn+y7Sd+taE
         ToOCjF4/6zhlcUMqQm5UyNN5Lmavq80pUXFnxsc4sPNy8Amq4jkUYzAs86dWa5ozTW
         p5kd7zojo4FNNcXABhPfp8MWEmSpIZ94GUGcH/qs=
Date:   Sat, 21 Mar 2020 08:09:06 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Faiz Abbas <faiz_abbas@ti.com>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 4.19 00/48] 4.19.112-rc1 review
Message-ID: <20200321070906.GB850676@kroah.com>
References: <20200319123902.941451241@linuxfoundation.org>
 <CA+G9fYsDw6JEznSHm2X=Wvq1dysGbGa4-VpXJyzKWZQxLMdagw@mail.gmail.com>
 <7a8c6a752793f0907662c3e9c197c284fc461550.camel@codethink.co.uk>
 <20200320080317.GA312074@kroah.com>
 <20200320081122.GA349027@kroah.com>
 <CA+G9fYtS0u1onCKCiZApRkZXzLMgW6X54z5OfHBOeE+v1=ApOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYtS0u1onCKCiZApRkZXzLMgW6X54z5OfHBOeE+v1=ApOQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 20, 2020 at 10:11:39PM +0530, Naresh Kamboju wrote:
> On Fri, 20 Mar 2020 at 13:41, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Fri, Mar 20, 2020 at 09:03:17AM +0100, Greg Kroah-Hartman wrote:
> > > On Thu, Mar 19, 2020 at 08:00:32PM +0000, Ben Hutchings wrote:
> > > > On Fri, 2020-03-20 at 01:12 +0530, Naresh Kamboju wrote:
> > > > > On Thu, 19 Mar 2020 at 18:50, Greg Kroah-Hartman
> > > > > <gregkh@linuxfoundation.org> wrote:
> > > > > > This is the start of the stable review cycle for the 4.19.112 release.
> > > > > > There are 48 patches in this series, all will be posted as a response
> > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > let me know.
> > > > > >
> > > > > > Responses should be made by Sat, 21 Mar 2020 12:37:04 +0000.
> > > > > > Anything received after that time might be too late.
> > > > > >
> > > > > > The whole patch series can be found in one patch at:
> > > > > >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.112-rc1.gz
> > > > > > or in the git tree and branch at:
> > > > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > > > > > and the diffstat can be found below.
> > > > > >
> > > > > > thanks,
> > > > > >
> > > > > > greg k-h
> > > > > >
> > > > > > Faiz Abbas <faiz_abbas@ti.com>
> > > > > >     mmc: sdhci-omap: Fix Tuning procedure for temperatures < -20C
> > > > > >
> > > > > > Faiz Abbas <faiz_abbas@ti.com>
> > > > > >     mmc: sdhci-omap: Don't finish_mrq() on a command error during tuning
> > > > >
> > > > > Results from Linaro’s test farm.
> > > > > No regressions on arm64, arm, x86_64, and i386.
> > > > >
> > > > > NOTE:
> > > > > The arm beagleboard x15 device running stable rc 4.19.112-rc1, 5.4.27-rc1
> > > > > and 5.5.11-rc2 kernel pops up the following messages on console log,
> > > > > Is this a problem ?
> > > > >
> > > > > [   15.737765] mmc1: unspecified timeout for CMD6 - use generic
> > > > > [   16.754248] mmc1: unspecified timeout for CMD6 - use generic
> > > > > [   16.842071] mmc1: unspecified timeout for CMD6 - use generic
> > > > > ...
> > > > > [  977.126652] mmc1: unspecified timeout for CMD6 - use generic
> > > > > [  985.449798] mmc1: unspecified timeout for CMD6 - use generic
> > > > [...]
> > > >
> > > > This warning was introduced by commit 533a6cfe08f9 "mmc: core: Default
> > > > to generic_cmd6_time as timeout in __mmc_switch()".  That should not be
> > > > applied to stable branches; it is not valid without (at least) these
> > > > preparatory changes:
> > > >
> > > > 0c204979c691 mmc: core: Cleanup BKOPS support
> > > > 24ed3bd01d6a mmc: core: Specify timeouts for BKOPS and CACHE_FLUSH for eMMC
> > > > ad91619aa9d7 mmc: block: Use generic_cmd6_time when modifying INAND_CMD38_ARG_EXT_CSD
> > >
> > > Ok, I've now dropped that patch, which also required me to drop
> > > 1292e3efb149 ("mmc: core: Allow host controllers to require R1B for
> > > CMD6").  I've done so for 5.5.y, 5.4.y, and 4.19.y.
> >
> > Ugh, I forgot, that broke other things.  I'm going to go rip out a bunch
> > of mmc patches now...
> 
> [Am i missing rc2 tag ?]

Nope, didn't do one.

> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Wonderful, thanks!

greg k-h

