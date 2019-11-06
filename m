Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 836D0F1452
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 11:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731151AbfKFKth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 05:49:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:41718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726656AbfKFKth (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Nov 2019 05:49:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BC97217F5;
        Wed,  6 Nov 2019 10:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573037375;
        bh=wzHfT5hKFfwxSi6NWsmb2i+jJfdPqcVnD9L0KI+55EM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WJyn23cCMmFIxVSWo14cpMn9tRVmEZYGBQip5vOhIPagQlV06UoriVgVrO7a1s5/3
         hWpavV3Nl9UPOgpuXmI0LG/h5d/kmAUkeZyzbpdGYSkQSQyFATZ6WKTk3VdGOUroGo
         Ns8kksx+9Cd/gu21RKhzdslkOb2MZ0R92cGwP1yw=
Date:   Wed, 6 Nov 2019 11:49:32 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.3 000/163] 5.3.9-stable review
Message-ID: <20191106104932.GD2982490@kroah.com>
References: <20191104212140.046021995@linuxfoundation.org>
 <a9c51735-86c7-9e77-707b-74628a99f76b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9c51735-86c7-9e77-707b-74628a99f76b@nvidia.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 05, 2019 at 11:41:15PM +0000, Jon Hunter wrote:
> 
> On 04/11/2019 21:43, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.9 release.
> > There are 163 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed 06 Nov 2019 09:14:04 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.9-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests for Tegra are passing ...
> 
> Test results for stable-v5.3:
>     12 builds:	12 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     38 tests:	38 pass, 0 fail
> 
> Linux version:	5.3.9-rc1-g75c9913bbf6e
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04

Thanks for testing all of these and letting me know.

greg k-h
