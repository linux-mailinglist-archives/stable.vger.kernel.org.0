Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38EDF169912
	for <lists+stable@lfdr.de>; Sun, 23 Feb 2020 18:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgBWRhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Feb 2020 12:37:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:37032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726208AbgBWRhF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 23 Feb 2020 12:37:05 -0500
Received: from localhost (95-141-97-180.as16211.net [95.141.97.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 144CF206E2;
        Sun, 23 Feb 2020 17:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582479424;
        bh=fCCWSFRGjJQ4taId+rc465kT+Xw5dNcetYBo4cATl8E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pHp0uoltyxC07ezp1SC+AsMxUBMNDi8MKoMBo/RqH6C8ApusUxDcbwN2KihEzT35U
         PNtAf0Aj/iJG8arYc1fV9wiHCesICCrqST52mHz/WwYG7z33E4tDNkIavyx9GdlVsz
         csHG9FsAhKcZ+7Ufs+9Xk0M8syIgtigruetj1iXU=
Date:   Sun, 23 Feb 2020 18:37:02 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.5 000/399] 5.5.6-stable review
Message-ID: <20200223173702.GA488033@kroah.com>
References: <20200221072402.315346745@linuxfoundation.org>
 <dea062e3-48c7-f878-c733-addf39a9c4f3@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dea062e3-48c7-f878-c733-addf39a9c4f3@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 21, 2020 at 10:10:06AM +0000, Jon Hunter wrote:
> 
> On 21/02/2020 07:35, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.5.6 release.
> > There are 399 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 23 Feb 2020 07:19:49 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.6-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.5:
>     13 builds:	13 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     40 tests:	40 pass, 0 fail
> 
> Linux version:	5.5.6-rc1-g84fa24740caa
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 

Thanks for testing these and letting me know.  Hopefully 5.4 is now also
working for you.

greg k-h
