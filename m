Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC44A277765
	for <lists+stable@lfdr.de>; Thu, 24 Sep 2020 19:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgIXRGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Sep 2020 13:06:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726458AbgIXRGS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Sep 2020 13:06:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7800C238A1;
        Thu, 24 Sep 2020 17:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600967178;
        bh=Yo8WF+EdBw73gRNMf0BdqmMMSHOuUs07rMcnUOeEhEQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z1+aoCzJmQuEUJ/UGXQTR3vqxNPZuOxDzF2mWHCfWpAUIqYI1oHugVmvXx5dzRn49
         y+OeRw3XmZUOHpQge6hSUubqgU7hmF6pPqQtz+HzWYaL4jZcirZNush5VGiHa0kcNL
         htAFRY7rgY2o2K20ySbCJhmJVZwgxZHcCcLxHqgw=
Date:   Thu, 24 Sep 2020 19:06:34 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.8 000/118] 5.8.11-rc1 review
Message-ID: <20200924170634.GB1182944@kroah.com>
References: <20200921162036.324813383@linuxfoundation.org>
 <632a6d3896b644dea98be80d747174ba@HQMAIL111.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <632a6d3896b644dea98be80d747174ba@HQMAIL111.nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 22, 2020 at 06:46:06AM +0000, Jon Hunter wrote:
> On Mon, 21 Sep 2020 18:26:52 +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.11 release.
> > There are 118 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 23 Sep 2020 16:20:12 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.11-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests passing for Tegra ...
> 
> Test results for stable-v5.8:
>     14 builds:	14 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     60 tests:	60 pass, 0 fail
> 
> Linux version:	5.8.11-rc1-gf2ae9d9cdf48
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks for testing them all and letting me know.

greg k-h
