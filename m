Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3762912D715
	for <lists+stable@lfdr.de>; Tue, 31 Dec 2019 09:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725875AbfLaIbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Dec 2019 03:31:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:35274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbfLaIbR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Dec 2019 03:31:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D6EE206DB;
        Tue, 31 Dec 2019 08:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577781076;
        bh=rvMR+E9omx4eCaqSUjlIrwJ0PKoCXLsH6vsG5WrM0jA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2MTQVTjLkNboVCVdRdsrDI8w3KmvExh+24BuU8xlw8yAzBuQbWEIMTupedv/Y//WM
         Depsi/TCA9b+N9ELGzvn8AySLcin5u/QbP0wwGsxQfvXOrn9IE+dGRs6JWYFAHnTTw
         XQmLIcS+jdgHH77M4cka+38/KEg7LqI2c3rNOZj0=
Date:   Tue, 31 Dec 2019 09:31:14 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/434] 5.4.7-stable review
Message-ID: <20191231083114.GB1928116@kroah.com>
References: <20191229172702.393141737@linuxfoundation.org>
 <43686be4-0ea2-472f-8b8f-2c69e16de96d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43686be4-0ea2-472f-8b8f-2c69e16de96d@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 30, 2019 at 08:20:41PM +0000, Jon Hunter wrote:
> 
> On 29/12/2019 17:20, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.7 release.
> > There are 434 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue, 31 Dec 2019 17:25:52 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.7-rc1.gz
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
> Linux version:	5.4.7-rc1-g6bc086f94af5
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04
> 

Thanks for testing all of these and letting me know.

greg k-h
