Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A293615F74B
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 21:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389240AbgBNUCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 15:02:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:33614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389205AbgBNUCI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 15:02:08 -0500
Received: from localhost (unknown [12.246.51.142])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4554324654;
        Fri, 14 Feb 2020 20:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581710527;
        bh=kOzvk+OzpzpOrtXBp+yNd2QeJJMOZmbEEHg8kegYTaA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f4SD7CDJVEys1xUJy3wS9/Wyn8ojDRHL8Ps1Rit4bznxmbDcHkGWt3BhBX07ISy++
         BzrrE7UEtNmZpGOzTG3Bh+a3AXdPpOni5dwHlvGrlibwBe4n26Ya+ziubNfsAb5Nqt
         +hsnOvu7E9RWH83MlKucTpmr4Ab8a6ls3lw7RQLI=
Date:   Fri, 14 Feb 2020 07:28:07 -0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.5 000/120] 5.5.4-stable review
Message-ID: <20200214152807.GA3960470@kroah.com>
References: <20200213151901.039700531@linuxfoundation.org>
 <e49bd26e-560c-840e-7f21-ee040a783143@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e49bd26e-560c-840e-7f21-ee040a783143@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 10:27:39AM +0000, Jon Hunter wrote:
> 
> On 13/02/2020 15:19, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.5.4 release.
> > There are 120 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 15 Feb 2020 15:16:41 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.4-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.5:
>     13 builds:	13 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     40 tests:	40 pass, 0 fail
> 
> Linux version:	5.5.4-rc2-ged6d023a1817
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 

Thanks for testing all of these and letting me know.

greg k-h
