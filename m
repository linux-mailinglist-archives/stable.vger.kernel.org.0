Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E29A911C921
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 10:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbfLLJa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 04:30:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:58008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728261AbfLLJaY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Dec 2019 04:30:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7F8421655;
        Thu, 12 Dec 2019 09:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576143021;
        bh=WLLz/+MINSEFbqQts+ckh3RtQutBOa1c7Yny63WPibw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=plvp96yI1hZz08EPlquQd8De9ZqBzZDL2yD65ChZimyeNY7TikPshYphSOUQg+PHI
         1KDJ5Mk+D+OeGJcHwvA1zrD69dsjIFt5AN5AJ+b901UI1xILY+z2KTrag+PlAeWvyb
         YzTS4DqBLdgzWand1DebgztLOCDiH9YSFoIBQxN4=
Date:   Thu, 12 Dec 2019 10:30:18 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Jon Hunter <jonathanh@nvidia.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/243] 4.19.89-stable review
Message-ID: <20191212093018.GA1378792@kroah.com>
References: <20191211150339.185439726@linuxfoundation.org>
 <7b43a504-160f-e793-99b2-bcb79d331b6a@nvidia.com>
 <8de7c018-32c7-f46e-4c43-ea3a70378a14@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8de7c018-32c7-f46e-4c43-ea3a70378a14@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 05:40:34PM -0800, Guenter Roeck wrote:
> On 12/11/19 1:36 PM, Jon Hunter wrote:
> > 
> > On 11/12/2019 15:02, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 4.19.89 release.
> > > There are 243 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Fri, 13 Dec 2019 14:56:06 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.89-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
> > > Linus Walleij <linus.walleij@linaro.org>
> > >      gpio: OF: Parse MMC-specific CD and WP properties
> > 
> > The above change is causing intermittent failures on Tegra30 eMMC.
> > Reverting this change on top of the 4.19.89-rc1 fixes the problem.
> > 
> 
> Thanks for tracking that down. I see boot failures for arm:vexpress-a9
> when trying to boot from mmc.
> 
> I dimly recall that this was a problem before. Ah yes ... commit 89a5e15bcba8
> ("gpio/mmc/of: Respect polarity in the device tree") fixes the above commit.
> Can you give it a try ?
> 
> [ One may wonder though why this was back-ported in the first place. ]

I've dropped the original patch here now, thanks.

greg k-h
