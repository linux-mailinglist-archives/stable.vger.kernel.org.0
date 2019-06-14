Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B163E45FAB
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 15:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbfFNNz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 09:55:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727382AbfFNNzZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 09:55:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7043D20850;
        Fri, 14 Jun 2019 13:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560520524;
        bh=lx29tlqAuaVeeTpHAGAyie4v7VVjd5N0QwIzLnn3vXw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zgB3gLXV3hSmed6kVh+AzNNMVm7LjSp5FQD93hDfx2rPVaKz1FSmXrC5nP42YlIF8
         rU3F+fa+ISzujXFUuZWkf5SL55ZH3CHXR2sE26rM5C9feHMAhJ/d4o03fyvYUXZZpk
         L3iiqWMu5RdwJ4E3747pH6ZlNfsrSOLOKoWDVpAM=
Date:   Fri, 14 Jun 2019 15:55:22 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.1 000/155] 5.1.10-stable review
Message-ID: <20190614135522.GA6498@kroah.com>
References: <20190613075652.691765927@linuxfoundation.org>
 <80f289fa-2a01-7a88-eedf-82534ef265be@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80f289fa-2a01-7a88-eedf-82534ef265be@nvidia.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 14, 2019 at 11:28:12AM +0100, Jon Hunter wrote:
> 
> On 13/06/2019 09:31, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.10 release.
> > There are 155 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 15 Jun 2019 07:54:40 AM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.10-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.1:
>     12 builds:	12 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     32 tests:	32 pass, 0 fail
> 
> Linux version:	5.1.10-rc2-gb7eabc3862b8
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04
> 

Wonderful, thanks for testing all of these and letting me know.

greg k-h
