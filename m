Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86CBF134A67
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 19:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgAHSXF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 13:23:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:50338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727169AbgAHSXF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jan 2020 13:23:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D3B220692;
        Wed,  8 Jan 2020 18:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578507784;
        bh=wJkO4jwYR01OobwJluN3nVcvloMFyriIEFSdls9FHjU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p6mt2Rz2DgWSaXx9seCc5HKNtTBmpdebhNG+ZgfeY6lyzDJsIZZP6rG99rcpCrfwi
         cRqKWsuA0+KPR0pmIRvt5WzyAaJofCwPPjgHGdm0zZneWrbKTnIrD9AOR6S1Fb8dMI
         LJsybpa8UA76gf1lvLhVijAVf5orTHFIgVJZ0B6E=
Date:   Wed, 8 Jan 2020 19:23:02 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/191] 5.4.9-stable review
Message-ID: <20200108182302.GB2547623@kroah.com>
References: <20200107205332.984228665@linuxfoundation.org>
 <87bea213-7dd5-412b-0faa-fc3b336da673@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bea213-7dd5-412b-0faa-fc3b336da673@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 08, 2020 at 04:24:07PM +0000, Jon Hunter wrote:
> 
> On 07/01/2020 20:52, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.9 release.
> > There are 191 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 09 Jan 2020 20:44:51 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.9-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> 
> All tests for Tegra are passing ...
> 
> Test results for stable-v5.4:
>     13 builds:	13 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     38 tests:	38 pass, 0 fail
> 
> Linux version:	5.4.9-rc2-gdd269ce619cb
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04
> 

Wonderful, thanks for testing and letting me know.

greg k-h
