Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0878F2A1D62
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 11:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbgKAKkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 05:40:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:53636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726145AbgKAKkj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Nov 2020 05:40:39 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C34FD2071A;
        Sun,  1 Nov 2020 10:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604227238;
        bh=a34Fa8zSUoEFOWkQ64CFIi3bkN0UU0QPhpXYCisAipE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ijQgrX+ZVWGBnYXrg4sfmIWLdKfFQemfI0JwJzVI9xbDUwUZIqJLa4mbIT4oXBydx
         gSvP91Y4RsnOzuREFw8BCJW+lb8fqU1Gj1XL3R04WAtFfDgymIXhi1xRbj9DgC6qiF
         MRPmFTMkWIBDqLV4fvNRCQn1xPnjHeRksxvHV80s=
Date:   Sun, 1 Nov 2020 11:41:21 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.9 00/74] 5.9.3-rc1 review
Message-ID: <20201101104121.GB2689688@kroah.com>
References: <20201031113500.031279088@linuxfoundation.org>
 <ca2501e512973270c6b7b7cc05c7f50791541a66.camel@rajagiritech.edu.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca2501e512973270c6b7b7cc05c7f50791541a66.camel@rajagiritech.edu.in>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 31, 2020 at 10:41:38PM +0530, Jeffrin Jose T wrote:
> On Sat, 2020-10-31 at 12:35 +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.9.3 release.
> > There are 74 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied,
> > please
> > let me know.
> > 
> > Responses should be made by Mon, 02 Nov 2020 11:34:42 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	
> > https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.3-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> > stable-rc.git linux-5.9.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> hello,
> i have build using ktest. but then i did the normal compile.
> compiled and booted 5.9.3-rc1+ . dmesg -l err is clear.
> 
> some lines from dmesg output related  
> ----------x------------------x---------------------------x---
> video: module verification failed: signature and/or required key
> missing - tainting kernel
> sdhci-pci 0000:00:1e.6: failed to setup card detect gpio
> --------x-------------------------------x-----------------x---
> 
> 
> Now something related to kernel build and install..
> ----------x---------------------x--------------------------x-------
> WARNING: modpost: EXPORT symbol "copy_mc_fragile" [vmlinux] version
> generation failed, symbol will not be versioned.
> W: Possible missing firmware /lib/firmware/i915/rkl_dmc_ver2_01.bin for
> module i915
> -------------x-------------------x-------------------------x---------
> 
> Now one thing during boot..
> -----------x------------x---- 
> unable to start nftables
> -x-----------------------x---
> 
> iam attaching a file....please see...

Is this any different from 5.9.2?

thanks,

greg k-h
