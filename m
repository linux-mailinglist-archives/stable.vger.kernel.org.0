Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E07533E9C
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 07:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfFDFuw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 01:50:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:39792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbfFDFuw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 01:50:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 851DA2064A;
        Tue,  4 Jun 2019 05:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559627452;
        bh=8YP+B1ND8Pm6lUjJ+92tc60zGcMtjXzLQtP4SnSTPjg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dC7E8LMpNhv7m1w5hAs2kIIAEmJZv/A/Zh5PoL8Zwc9/o18HYNCCppUBMYW8CVJ/d
         7ikuisF18Q+6tLxxAbXKDHKDQvx0xn8Lt4HERNsQwvRfv/lxn5I8zlBYb4uS3qX30C
         6KuPQfln5P31K1C7TkF/DOu8VdOKxYV2lU9mCCok=
Date:   Tue, 4 Jun 2019 07:50:48 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.1 00/40] 5.1.7-stable review
Message-ID: <20190604055048.GD16504@kroah.com>
References: <20190603090522.617635820@linuxfoundation.org>
 <75303365-74d0-de3c-2f54-5cff3469d8a0@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75303365-74d0-de3c-2f54-5cff3469d8a0@nvidia.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 03, 2019 at 07:34:09PM +0100, Jon Hunter wrote:
> 
> On 03/06/2019 10:08, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.7 release.
> > There are 40 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed 05 Jun 2019 09:04:46 AM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.7-rc1.gz
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
> Linux version:	5.1.7-rc1-ge674455
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04

Thanks for testing all of these and letting me know.

greg k-h
