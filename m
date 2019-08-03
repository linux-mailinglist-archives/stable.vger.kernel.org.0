Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41B36804F9
	for <lists+stable@lfdr.de>; Sat,  3 Aug 2019 09:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbfHCHJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Aug 2019 03:09:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727206AbfHCHJf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 3 Aug 2019 03:09:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 775262087C;
        Sat,  3 Aug 2019 07:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564816175;
        bh=oIP0s2FV8ZaMzOByk4tNkmE6OsrqP67Ic4EDR6TzQ3o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sJENMaVvneEr1vMbSAmmKeotVVwPJfSK0T+Gx4MxlXhBjpgL72vziEJiRIbQLua77
         x4pf7xDA4JgC4MFcBoP58V/j8Hh8dgo645GL/1pM+iXX34ahUZznLm/yhy1XE+pdFT
         Ybw7QNWGVYQolnhxfC4RYnukyHz35jKHc761ouqU=
Date:   Sat, 3 Aug 2019 09:09:32 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.2 00/20] 5.2.6-stable review
Message-ID: <20190803070932.GB24334@kroah.com>
References: <20190802092055.131876977@linuxfoundation.org>
 <20190802172105.18999-1-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802172105.18999-1-thierry.reding@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 02, 2019 at 07:21:05PM +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> On Fri, 02 Aug 2019 11:39:54 +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.6 release.
> > There are 20 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun 04 Aug 2019 09:19:34 AM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.6-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests passing for Tegra ...
> 
> Test results for stable-v5.2:
>     12 builds:	12 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     38 tests:	38 pass, 0 fail
> 
> Linux version:	5.2.6-rc1-gbe893953fcc2
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04

Great!  Thanks for testing all of these and letting me know.

greg k-h
