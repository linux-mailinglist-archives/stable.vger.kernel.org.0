Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1A2E838E8
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 20:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfHFSoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 14:44:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbfHFSoI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 14:44:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2106F20818;
        Tue,  6 Aug 2019 18:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565117047;
        bh=82KdnV5xgDw0h/RCZKJpwmgLGzGBvW3IThY72SpKrcA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SBOXAzFLr0DfHY9SWf8LsgEhWckLONpPtqkpqmKD+sHQXkPj8u8YtWI2v4SSRYwCP
         yJ8CvUUllkvyex4vgZlPj1d+wag8DGgyI3ybWNnX7DDcXoa7gi0lo17nNC0kBNwcy8
         u+222RaBSFjyOHk6fXPUV8zVN8CEkytzIMgTb7z0=
Date:   Tue, 6 Aug 2019 20:44:05 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.2 000/131] 5.2.7-stable review
Message-ID: <20190806184405.GA28058@kroah.com>
References: <20190805124951.453337465@linuxfoundation.org>
 <c01bc729-c9c1-fe90-4850-7907fee27a2b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c01bc729-c9c1-fe90-4850-7907fee27a2b@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 06, 2019 at 07:30:45PM +0100, Jon Hunter wrote:
> 
> On 05/08/2019 14:01, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.7 release.
> > There are 131 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed 07 Aug 2019 12:47:58 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.7-rc1.gz
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
> Linux version:	5.2.7-rc1-g22499a291939
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04

Thanks for testing all of these and letting me know.

greg k-h
