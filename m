Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214E23124B5
	for <lists+stable@lfdr.de>; Sun,  7 Feb 2021 15:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhBGOhf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Feb 2021 09:37:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:49436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229491AbhBGOhe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Feb 2021 09:37:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7C5464E42;
        Sun,  7 Feb 2021 14:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612708614;
        bh=UYMVP2TObAQvuYc6IhEdgAZLVaZDttd6GNpSbBNDb3g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rp8tfdzJiGq/skg34Mi0O0U9mmUNkpQL4/e/RKkXMeudXmCkoPtT0PAfz49QOjtX+
         iE1vRmVI85GmmNPTwQORhNL9FY1To5oG1U6ow8i6o821oRgKctr+3soldYk48zjFr/
         ueol6UxajSiQKeuKVcHF5M6RVa62Xk29TEiv5/sM=
Date:   Sun, 7 Feb 2021 15:36:51 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/32] 5.4.96-rc1 review
Message-ID: <YB/7A042akCqhsGq@kroah.com>
References: <20210205140652.348864025@linuxfoundation.org>
 <761601f4-ecdc-8cba-e2f8-c571a75770c6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <761601f4-ecdc-8cba-e2f8-c571a75770c6@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 05, 2021 at 01:16:29PM -0800, Florian Fainelli wrote:
> On 2/5/21 6:07 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.96 release.
> > There are 32 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 07 Feb 2021 14:06:42 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.96-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Tested-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> On ARCH_BRCMSTB with both ARM 32-bit and ARM 64-bit configurations, no
> regressions observed.

Thanks for testing this kernel and letting me know.

greg k-h
