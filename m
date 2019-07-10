Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 520B964294
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 09:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbfGJHYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 03:24:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbfGJHYG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jul 2019 03:24:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AB5D2064A;
        Wed, 10 Jul 2019 07:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562743445;
        bh=07abPqHi0bx/2V6DX3mR/4wGcFkZzvDnRhGgdklDc9s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ILoG/RDAWFrlvtKlF4riZ3+q0NwHP0NTPHSafg2g1jlb+pFkcu4Yr1MwLFQkNXfaG
         ajRFr0akoFFeR/6yAeoxlU81kjldRDFkLSTc8TE4nnVwjFMWMtWlkm8hWzkUWZKq3+
         k0N0rAxCHR9nfeoIhxP6mfcZioHe+CTzDkMVP3Oo=
Date:   Wed, 10 Jul 2019 09:24:03 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.1 00/96] 5.1.17-stable review
Message-ID: <20190710072403.GB12087@kroah.com>
References: <20190708150526.234572443@linuxfoundation.org>
 <65c41248-f391-1231-c2b3-9c65922a696e@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65c41248-f391-1231-c2b3-9c65922a696e@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 10, 2019 at 07:14:05AM +0100, Jon Hunter wrote:
> 
> On 08/07/2019 16:12, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.17 release.
> > There are 96 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed 10 Jul 2019 03:03:52 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.17-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.1:
>     12 builds:	12 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     32 tests:	32 pass, 0 fail
> 
> Linux version:	5.1.17-rc1-gb64119f8dffe
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04
> 

Thanks for testing all of these and letting me know.

greg k-h
