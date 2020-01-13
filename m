Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62A9A1398E2
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 19:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgAMS10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 13:27:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:52608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728516AbgAMS1Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Jan 2020 13:27:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23DF92075B;
        Mon, 13 Jan 2020 18:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578940045;
        bh=F/IFQvW78wy+MhG3sUx5KYFYXZ/M/Vs1nJt/glF23XM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SBIws59xaB15heoKVXw56LyflYjh864rqgwje5/U2TgC7aH9IvKLU9dKZS6LK2qNs
         pbGrpWfw9lecx1r0wuiPFDWeXe1lXKZrCaDfaUb18zpTIusa5AhCnUnpNQfAHH6gLx
         5NW0U+/gGMmLg7Kr716bngjs9En94eJmhyYQrhhQ=
Date:   Mon, 13 Jan 2020 19:27:21 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/165] 5.4.11-stable review
Message-ID: <20200113182721.GJ411698@kroah.com>
References: <20200111094921.347491861@linuxfoundation.org>
 <ace61a61-9241-5734-aeea-86de9e9e608a@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ace61a61-9241-5734-aeea-86de9e9e608a@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 13, 2020 at 03:49:01PM +0000, Jon Hunter wrote:
> 
> On 11/01/2020 09:48, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.11 release.
> > There are 165 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Mon, 13 Jan 2020 09:46:17 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.11-rc1.gz
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
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.4:
>     13 builds:	13 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     38 tests:	38 pass, 0 fail
> 
> Linux version:	5.4.11-g9d61432efb21
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04
> 

Thanks for testing all of these and letting me know.

greg k-h
