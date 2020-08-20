Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C8824BC5D
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbgHTMow (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:44:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729648AbgHTMoZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 08:44:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 213542224D;
        Thu, 20 Aug 2020 12:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597927464;
        bh=3QpRcK+mDvHWXX9GbNnxpfogGwfRiDJijcfq160llu0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EQJPdEDRCE9+UODEN8vduKuUk/lcabOD4u9C5BkcBtcBeBy/chlTwXJUligAoPKAL
         Y7w1fkqACc0VdG2q0fNUCewsSELHMIjjMZWBJwW67NoU/siWnc2wx02AniPEgERnlU
         YixcvZ+kcsN/ancZp2kUZblBik+TREebqbabKnsM=
Date:   Thu, 20 Aug 2020 14:44:45 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 000/228] 4.14.194-rc1 review
Message-ID: <20200820124445.GB1482630@kroah.com>
References: <20200820091607.532711107@linuxfoundation.org>
 <a6b632f8-b327-3f8d-5306-12989cfaf4e3@nvidia.com>
 <20200820123828.GA1465682@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820123828.GA1465682@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 02:38:28PM +0200, Greg Kroah-Hartman wrote:
> On Thu, Aug 20, 2020 at 12:57:36PM +0100, Jon Hunter wrote:
> > 
> > On 20/08/2020 10:19, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 4.14.194 release.
> > > There are 228 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Sat, 22 Aug 2020 09:15:09 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.194-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > > 
> > > -------------
> > > Pseudo-Shortlog of commits:
> > 
> > ...
> > 
> > > Tomasz Maciej Nowak <tmn505@gmail.com>
> > >     arm64: dts: marvell: espressobin: add ethernet alias
> > 
> > 
> > The above change is causing the following build failure for ARM64 ...
> > 
> > arch/arm64/boot/dts/marvell/armada-3720-espressobin.dtb: ERROR (path_references): Reference to non-existent node or label "uart1"
> > ERROR: Input tree has errors, aborting (use -f to force output)
> > scripts/Makefile.lib:317: recipe for target 'arch/arm64/boot/dts/marvell/armada-3720-espressobin.dtb' failed
> > make[3]: *** [arch/arm64/boot/dts/marvell/armada-3720-espressobin.dtb] Error 2
> > 
> > Reverting this fixes the problem.
> 
> Thanks, now dropping it.  Sad as it said it was to be backported here...
> 
> Will go push out a -rc2 with that fixed.

Well, will push out -rc2 once kernel.org's maintenance is finished,
might be an hour or so...

thanks,

greg k-h
