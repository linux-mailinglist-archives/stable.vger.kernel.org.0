Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD7BE148D13
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 18:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390688AbgAXRh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 12:37:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:56630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390668AbgAXRh2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 12:37:28 -0500
Received: from localhost (unknown [84.241.198.31])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E0ED214AF;
        Fri, 24 Jan 2020 17:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579887447;
        bh=GTtLai2FYBRbD2P1+oK+BStkcQduJ3SaU+v1GaonPj4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JZsuU6c0hoT/d7XEqT1QVXL2pyutslhMkgLb8vrDW7HsTf+baCK0pivRjm97Y84rI
         bo9tufdpOlc0objj1SdHUWcZpOPGRS8a3Qw6IIewBGXh/QzNPnCc29xMjS134IFNEO
         RUUTBuNBsFyR4KwJPVjHqAoqm86nD4bomCxlBhLw=
Date:   Fri, 24 Jan 2020 18:36:59 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/639] 4.19.99-stable review
Message-ID: <20200124173659.GD3166016@kroah.com>
References: <20200124093047.008739095@linuxfoundation.org>
 <23f2a904-3351-4a75-aaaf-2623dc55d114@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23f2a904-3351-4a75-aaaf-2623dc55d114@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 24, 2020 at 02:50:05PM +0000, Jon Hunter wrote:
> Hi Greg,
> 
> On 24/01/2020 09:22, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.99 release.
> > There are 639 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 26 Jan 2020 09:26:29 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.99-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> > Pseudo-Shortlog of commits:
> 
> ...
> 
> > Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >     PCI: PM: Skip devices in D0 for suspend-to-idle
> 
> The above commit is causing a suspend regression on Tegra124 Jetson-TK1.
> Reverting this on top of v4.19.99-rc1 fixes the issue.

This is also in the 4.14 queue, so should I drop it there too?

thanks,

greg k-h
