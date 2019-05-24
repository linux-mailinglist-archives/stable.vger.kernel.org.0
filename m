Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08BBE29A89
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 17:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389149AbfEXPBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 11:01:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:36004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389035AbfEXPBY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 May 2019 11:01:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 856D12133D;
        Fri, 24 May 2019 15:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558710084;
        bh=Tn8FxSdwwacLr13ZDC+joaDjN+2tjRMH0b8yiUpETn0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KQzrq2SjYlAoFUQr8g9Hecz95RX7HjKkP9AF7DyIg4bdVmhyPBFW2rbtyo6zHboT3
         nTiB/K/e3EQ2bO9ZB/AGPAbvSqA2y+byi4xByAzrsn0kNkObGSWud44MVMo+Ic7eJ3
         5WGK/Scdaeo718OLvN/jsg3XbbhxW0b+kimd346Y=
Date:   Fri, 24 May 2019 17:01:21 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.1 000/122] 5.1.5-stable review
Message-ID: <20190524150121.GB9757@kroah.com>
References: <20190523181705.091418060@linuxfoundation.org>
 <02faed58-61a0-b4ff-a127-533b97207c0f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02faed58-61a0-b4ff-a127-533b97207c0f@nvidia.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 24, 2019 at 12:05:42PM +0100, Jon Hunter wrote:
> 
> On 23/05/2019 20:05, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.5 release.
> > There are 122 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 25 May 2019 06:14:44 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.5-rc1.gz
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
> Linux version:	5.1.5-rc1-gad8ad5ad
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04

Thanks for testing all of these and letting me know.

greg k-h
