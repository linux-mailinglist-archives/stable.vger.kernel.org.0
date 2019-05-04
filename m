Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 587D0137DF
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 08:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfEDGrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 02:47:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbfEDGrU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 02:47:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C2EF20675;
        Sat,  4 May 2019 06:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556952440;
        bh=q82cmbLfUjJBJBMoTYVQaUqJ61t4A7eulKHRX5l3lzM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aKYsyplMPy8uspDNlqJl/f8psYhIZ/LAeqs8nOkOGDMo4oVy8mVZ5i04jSZ+Kbefx
         tTRNQ7I/T8hLSfyFtfvanN8d59XeSU2yRsXsY0cEbi09RytZyy3+GL2ZnStK2JV/l5
         zHu9QIY5DB8xvkD5+c5XWCo68c/p1WSPXsg0/X3U=
Date:   Sat, 4 May 2019 08:47:17 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.0 000/101] 5.0.12-stable review
Message-ID: <20190504064717.GF26311@kroah.com>
References: <20190502143339.434882399@linuxfoundation.org>
 <7a4ddaf6-819f-b8f3-4104-f979b2c08655@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a4ddaf6-819f-b8f3-4104-f979b2c08655@nvidia.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 03, 2019 at 10:27:56AM +0100, Jon Hunter wrote:
> 
> On 02/05/2019 16:20, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.0.12 release.
> > There are 101 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 04 May 2019 02:32:10 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.0.12-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.0.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.0:
>     12 builds:	12 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     32 tests:	32 pass, 0 fail
> 
> Linux version:	5.0.12-rc1-g17f9302
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana, tegra210,
>                 tegra210-p2371-2180, tegra30-cardhu-a04

Thanks for testing all of these and letting me know.

greg k-h
