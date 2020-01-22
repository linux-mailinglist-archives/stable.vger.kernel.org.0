Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97CFB145860
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 16:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgAVPC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 10:02:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:52674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbgAVPC3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 10:02:29 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4443021734;
        Wed, 22 Jan 2020 15:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579705349;
        bh=GHIZDwh6/OLbPNJGIAY5Gcvycz20K9xpPhgq90Te7Q4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yjSnCb60q5tXlEfnrM2lBt0H76FTu94uD0/6z88bfWoy+wEWEtz30NpyJOqYVf1Nc
         zjKlhEhc0wZr2lokrcTVUcPGoQtEVTQTQJloUyyXoyoJ2dUqV6FTge605KKL/2oEO3
         TmwYxZIW1aEiCht8YeZTEWgALBSzj/1aPxyKjGCk=
Date:   Wed, 22 Jan 2020 16:02:26 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/222] 5.4.14-stable review
Message-ID: <20200122150226.GA61380@kroah.com>
References: <20200122092833.339495161@linuxfoundation.org>
 <012c6d63-a4cb-ead4-1a7e-d5727426200d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <012c6d63-a4cb-ead4-1a7e-d5727426200d@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 22, 2020 at 02:58:33PM +0000, Jon Hunter wrote:
> 
> On 22/01/2020 09:26, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.14 release.
> > There are 222 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 24 Jan 2020 09:25:24 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.14-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.4:
>     13 builds:	13 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     38 tests:	38 pass, 0 fail
> 
> Linux version:	5.4.14-rc1-g8045d34c9af0
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04

Wonderful, thanks for testing all of these and letting me know.

greg k-h
