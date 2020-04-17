Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7D471ADF8C
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 16:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730916AbgDQOKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 10:10:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730899AbgDQOKt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Apr 2020 10:10:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EABA021924;
        Fri, 17 Apr 2020 14:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587132649;
        bh=iE50K8nUl0aeFIB2DRxf8FLJ39+6ykWPxyOtK9Yyb7E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u7G1ua1apO5bQaIiOG7EYZFM7PfKY3jLmckPPEAqC3l6DrPeY5yHHubY7Om1N+/tc
         fR3UgREk7KhOx7bbDGixMVHP2FY/Nae3/GbdGrmBlrkpPvHCtZqCJShfvaeCNmsHiM
         dyQ6Ja5wa7CiO6/erhe7QLMLGtBa1P35HoTP7emw=
Date:   Fri, 17 Apr 2020 16:10:46 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.6 000/254] 5.6.5-rc1 review
Message-ID: <20200417141046.GA657573@kroah.com>
References: <20200416131325.804095985@linuxfoundation.org>
 <7d8d7d76-54e6-c8e4-9e3b-d8d599c26be9@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d8d7d76-54e6-c8e4-9e3b-d8d599c26be9@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 17, 2020 at 10:45:29AM +0100, Jon Hunter wrote:
> 
> On 16/04/2020 14:21, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.6.5 release.
> > There are 254 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 18 Apr 2020 13:11:20 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.5-rc1.gz
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
> Linux version:	5.6.5-rc1-g576aa353744c
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 

Thanks for testing all of these and letting me know.

greg k-h
