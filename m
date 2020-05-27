Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A65A81E3E4E
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 12:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729645AbgE0KA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 06:00:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728253AbgE0KA7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 May 2020 06:00:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97A202084C;
        Wed, 27 May 2020 10:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590573659;
        bh=Yg4do3QGiR/CHgycBhbn4KX2zuVwKpVFGhOD6UUqfeI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GGyW0GgfOsOdBoSDyPlJsal9a6oGDnIU+9qTn8AFs+YQcWcfbcUhshBK2rYsPcDBm
         91QvCmPlA7F70PgeXYPBN1inZ0Z4/BiD58S90CQBpX3y5deoaGa68TtOfAwuBCcLg2
         gnKfQLZ8B8eJLR/xCjiiDcIx0ERQFYNJdM0WWMKE=
Date:   Wed, 27 May 2020 12:00:56 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.6 000/126] 5.6.15-rc1 review
Message-ID: <20200527100056.GB277684@kroah.com>
References: <20200526183937.471379031@linuxfoundation.org>
 <d5c1dffe-98d3-d60e-669b-90277bbb0a03@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5c1dffe-98d3-d60e-669b-90277bbb0a03@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 27, 2020 at 09:34:24AM +0100, Jon Hunter wrote:
> 
> On 26/05/2020 19:52, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.6.15 release.
> > There are 126 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 28 May 2020 18:36:22 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.15-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.6:
>     11 builds:	11 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     42 tests:	42 pass, 0 fail
> 
> Linux version:	5.6.15-rc1-g8f40203f4915
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04

Wonderful, thanks for testing all of these and letting me know.

greg k-h
