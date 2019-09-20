Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 006F2B919E
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387944AbfITOYf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:24:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387938AbfITOYf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Sep 2019 10:24:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 273F72080F;
        Fri, 20 Sep 2019 14:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568989474;
        bh=/kEOe6iIjAq0AE1gdlHbwtYLINqv36CWSrQAhIyQfJw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aH6T/cI5l18ilkRUUjq9bDjrGWFbwM6iUDIT1rY/PKyFXiN95AlnEXDDSUuRalZl2
         FOmB4g02JDEINxGDe9cKI+rgRSeTRI/qwCqoe2fY9b/nUm/CZpHg1x9EFrWWtDHyIa
         jrClhMudeuRqcEUsmY8+O3icEoUaSEve8rGSY+n4=
Date:   Fri, 20 Sep 2019 16:24:32 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.3 00/21] 5.3.1-stable review
Message-ID: <20190920142432.GA601228@kroah.com>
References: <20190919214657.842130855@linuxfoundation.org>
 <572eca6e-47a9-c554-c6b2-bafd4c5df18b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <572eca6e-47a9-c554-c6b2-bafd4c5df18b@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 20, 2019 at 02:54:26PM +0100, Jon Hunter wrote:
> 
> On 19/09/2019 23:03, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.1 release.
> > There are 21 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 21 Sep 2019 09:44:25 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.1-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> No new regressions* for Tegra ...
> 
> Test results for stable-v5.3:
>     12 builds:	12 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     38 tests:	37 pass, 1 fail
> 
> Linux version:	5.3.1-rc1-g0aa7f3d6baae
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04
> 
> * Note we had one regression in v5.3 for a warnings test for Tegra194
>   causing the above test failure. This has since been fixed by the
>   following commits [0] but given it is just a warning, I have not
>   bothered CC'ing for stable.
> 
> Cheers
> Jon
> 
> [0] https://lkml.org/lkml/2019/8/21/602

I'll be glad to take this in stable for 5.3.y, what is the git commit
id?

Also, thanks for testing all of these and letting me know.

greg k-h

> 
> -- 
> nvpublic
