Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E78D178AA2
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 07:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725839AbgCDGen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 01:34:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:53122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725791AbgCDGen (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 01:34:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35695214D8;
        Wed,  4 Mar 2020 06:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583303682;
        bh=vm1PJxz1Eur0jQnEA+GnvtmblRRiAYg6kBegxtix3Bo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A6yFeSNHdCYhPPIIgRcIrRNojRmLP6Ail8pRYkFFedfhi7lKkle5n/m4mQrzXM0cR
         af/2+OcwZF3ukOauSj0dPbgR80gSg++tEifjJitgLVg8Bm59vdawfsXq4G0L5yeblG
         Gq+535m28Di1mXFW6+eeYRjuJS9ZNLvxUB64XEdU=
Date:   Wed, 4 Mar 2020 07:34:40 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.5 000/176] 5.5.8-stable review
Message-ID: <20200304063440.GC1202498@kroah.com>
References: <20200303174304.593872177@linuxfoundation.org>
 <f109bb1e-1520-893b-ae48-70a80fc3f29b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f109bb1e-1520-893b-ae48-70a80fc3f29b@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 03, 2020 at 10:11:19PM +0000, Jon Hunter wrote:
> 
> On 03/03/2020 17:41, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.5.8 release.
> > There are 176 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 05 Mar 2020 17:42:06 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.8-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests passing for Tegra ...
> 
> Test results for stable-v5.5:
>     13 builds:	13 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     40 tests:	40 pass, 0 fail
> 
> Linux version:	5.5.8-rc1-g3517b32c0774
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 

thanks for testing all of these and letting me know.

greg k-h
