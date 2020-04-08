Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA471A1C58
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 09:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgDHHKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 03:10:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbgDHHKZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Apr 2020 03:10:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B37C520747;
        Wed,  8 Apr 2020 07:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586329823;
        bh=kepLEXBy2tFmdjV0mo6zqwbI/K+d5pPQOFTZ9SLxBPo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FgladuloSDuIIzJJ1SymTzu2iqSkhkNxtN34xFlDgJgPAxKGmohyo/NBHovBUDYcr
         VMAelMlgLnk7tJh5aMVJ+2cHm/fMYt4tWmmBfWZGMaS9DEimxAn2eUbUhIX7ha8cXS
         mKKClh6PysGg/8xeswOXL+88sx0vcJnrhDm4z0+c=
Date:   Wed, 8 Apr 2020 09:10:21 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.6 00/30] 5.6.3-rc2 review
Message-ID: <20200408071021.GC1019278@kroah.com>
References: <20200407154752.006506420@linuxfoundation.org>
 <f5ca935a-22f8-a342-af07-6ed9923e912e@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5ca935a-22f8-a342-af07-6ed9923e912e@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 07, 2020 at 08:02:57PM +0100, Jon Hunter wrote:
> 
> On 07/04/2020 17:39, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.6.3 release.
> > There are 30 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 09 Apr 2020 15:46:32 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.3-rc2.gz
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
>     13 builds:	13 pass, 0 fail
>     24 boots:	24 pass, 0 fail
>     40 tests:	40 pass, 0 fail
> 
> Linux version:	5.6.3-rc2-gf106acd0db7c
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 

Thanks for testing all of these again :)

greg k-h
