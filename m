Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE30253F2F
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 09:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbgH0HcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 03:32:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728114AbgH0HcM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Aug 2020 03:32:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84D9E20791;
        Thu, 27 Aug 2020 07:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598513532;
        bh=hwqIdflaQE3G0oWl+rBFPlzU/cXzkGtS/XSPxUGESZ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XmC9pbtjx9YC7JPb2eIMXW/ala1XAi+NhtCYy1vcLB+HMFygKbd/sffSV8vPjeO+a
         LhWClxhBoTowaC74khR3yKRxszn8BJlytnRL0YLq4UDSYlPCHKpZtgX93b/HuOKqEV
         eaKqlABaV0i0PsySSE7JjkZzdCe9WxewADSkyOiY=
Date:   Thu, 27 Aug 2020 09:32:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.8 00/16] 5.8.5-rc1 review
Message-ID: <20200827073226.GA206189@kroah.com>
References: <20200826114911.216745274@linuxfoundation.org>
 <1505aad2fc61485e8c6b02117b0a5ea9@HQMAIL107.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1505aad2fc61485e8c6b02117b0a5ea9@HQMAIL107.nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 26, 2020 at 04:04:15PM +0000, Jon Hunter wrote:
> On Wed, 26 Aug 2020 14:02:37 +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.5 release.
> > There are 16 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 28 Aug 2020 11:49:02 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.5-rc1.gz
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
>     11 builds:	11 pass, 0 fail
>     20 boots:	20 pass, 0 fail
>     45 tests:	45 pass, 0 fail
> 
> Linux version:	5.8.5-rc1-ga8485efcbc70
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks for testing both of these so quickly and letting me know.

greg k-h
