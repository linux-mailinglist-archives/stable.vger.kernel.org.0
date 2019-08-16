Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C99F8FF30
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 11:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbfHPJkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 05:40:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726867AbfHPJkN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Aug 2019 05:40:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 974F12086C;
        Fri, 16 Aug 2019 09:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565948412;
        bh=yePkunOEcTfiro3IUJz5MalfR+GjBycABpkUDdKaFJ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0o+12I3nusFd8rlr6q28G+YfVmqcL6pLOX6WwgxCLlgccyBNoShs1rALMRfwxU2p9
         UmDD48fy4K0ZPIeM6Y+sqrJS/pu7GcU25Otue9S5ZXNOnPso82T4SoCTIGWM+kKw9Q
         LNTQXt5bUJKQt0DgYLlhGIN9cZDv8lMXDtaUzFJk=
Date:   Fri, 16 Aug 2019 11:40:09 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Thierry Reding <treding@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.2 000/144] 5.2.9-stable review
Message-ID: <20190816094009.GA17851@kroah.com>
References: <20190814165759.466811854@linuxfoundation.org>
 <20190816092133.16205-1-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190816092133.16205-1-treding@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 16, 2019 at 11:21:33AM +0200, Thierry Reding wrote:
> On Wed, 14 Aug 2019 18:59:16 +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.9 release.
> > There are 144 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri 16 Aug 2019 04:55:34 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.9-rc1.gz
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
> Linux version:	5.2.9-rc1-g2440e485aeda
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04

Wonderful, thanks for testing all of these and letting me know.

greg k-h
