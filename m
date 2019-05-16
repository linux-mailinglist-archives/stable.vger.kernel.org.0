Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B70F20D5D
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbfEPQtV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:49:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:40846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726808AbfEPQtV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 12:49:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C602205ED;
        Thu, 16 May 2019 16:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558025360;
        bh=NveVv6Q4uybGZ7z8KgxQg+EoijBp4AG6PhqLjNTFtuk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ha4b8+uzYVMXkGCsYm/z2nlq8/2n8i8AQNuu2FEBBbgPs8bIL1x7u25zqNhF3u7yQ
         gODK8UO6AXtykgE7h07OVkpJJeitO49bQsAs8ZSjRpvLZKiBjP5K86c/xSy+Xs2jTB
         mXhkT9LIoS5V2RgNjdxi3fI0z3R6KrOMyPVFsc7I=
Date:   Thu, 16 May 2019 18:49:18 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel Wagner <wagi@monom.org>
Cc:     Jon Hunter <jonathanh@nvidia.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, linux-tegra <linux-tegra@vger.kernel.org>,
        Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 4.4 000/266] 4.4.180-stable review
Message-ID: <20190516164918.GA12641@kroah.com>
References: <20190515090722.696531131@linuxfoundation.org>
 <f32de22f-c928-2eaa-ee3f-d2b26c184dd4@nvidia.com>
 <75c1f549-9098-933e-ab8b-4d0eeab87ddd@monom.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75c1f549-9098-933e-ab8b-4d0eeab87ddd@monom.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 16, 2019 at 01:59:43PM +0200, Daniel Wagner wrote:
> Hi Jon,
> 
> > Boot regression detected for Tegra ...
> > 
> > Test results for stable-v4.4:
> >     6 builds:	6 pass, 0 fail
> >     15 boots:	6 pass, 9 fail
> >     8 tests:	8 pass, 0 fail
> > 
> > Linux version:	4.4.180-rc1-gbe756da
> > Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
> >                 tegra30-cardhu-a04
> > 
> > Bisect is point to the following commit ...
> > 
> > # first bad commit: [7849d64a1700ddae1963ff22a77292e9fb5c2983] mm, vmstat: make quiet_vmstat lighter
> > 
> > Reverting this on top v4.4.180-rc1 fixes the problem.  
> 
> I guess the patch depends on another change. I'll try to figure out what
> is missing.

Jon, thanks for the testing, I'll go drop this patch now from the final
version.

Daniel, if you can come up with a working series, I'll be glad to take
it.  Or, I'd recommend you just move to a newer kernel :)

thanks,

greg k-h
