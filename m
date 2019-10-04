Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C50ECB582
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 09:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387933AbfJDHzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 03:55:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387511AbfJDHzR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 03:55:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E254207FF;
        Fri,  4 Oct 2019 07:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570175716;
        bh=UuvG8lDsrw06dYiW7ZD+MvegXchW0FHoee1VIf8wfYk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x5rYE/IvQu08H5jhQTfrJ3PCHyxaJAeDG+Q//6w/o6O5q/d7rwXKl2G3uYoiKqULi
         K4CtXrntuB/hPkXtQiJU614XJEHl75D0wZkruFhzRZ0iFRILo3IAuHb95CmZRZ9vwA
         EtFSrvkIS8MSnHHDSgWSZeFnqkYqUljStmakTtWo=
Date:   Fri, 4 Oct 2019 09:55:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.3 000/344] 5.3.4-stable review
Message-ID: <20191004075514.GB10406@kroah.com>
References: <20191003154540.062170222@linuxfoundation.org>
 <fe3f55e2-9252-786d-0541-7dd253ffc438@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe3f55e2-9252-786d-0541-7dd253ffc438@nvidia.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 04, 2019 at 08:38:48AM +0100, Jon Hunter wrote:
> 
> On 03/10/2019 16:49, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.4 release.
> > There are 344 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 05 Oct 2019 03:37:47 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.4-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.3:
>     12 builds:	12 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     38 tests:	38 pass, 0 fail
> 
> Linux version:	5.3.4-rc1-gc9adc631ac5f
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04

Wonderful, thanks for testing all of these and letting me know.

greg k-h
