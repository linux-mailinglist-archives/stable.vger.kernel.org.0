Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEC4F55D1F
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 02:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfFZA4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 20:56:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbfFZA4m (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 20:56:42 -0400
Received: from localhost (unknown [172.104.248.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ABE72085A;
        Wed, 26 Jun 2019 00:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561510601;
        bh=abXAdpfboVZdQSoog5ldf1FPShcMnkPsqNEx5/DnyCo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OB4KBcaQM89i63n0Gb2hSuILySIPM2YSgq8ZxYt49ot4+fLd9JpEOQIalLoFooiVa
         7QUzKC1I3qhJy3qkBvBX9ntPKIILa0FniwApxmaeVozNMpmltU/mey7ZbADb2Et6bj
         Ms2hnQ6aRK4eUPN6B48TwhSUPvzs93bawrgrcDso=
Date:   Wed, 26 Jun 2019 08:51:16 +0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.1 000/121] 5.1.15-stable review
Message-ID: <20190626005116.GC21530@kroah.com>
References: <20190624092320.652599624@linuxfoundation.org>
 <163f4750-24c9-104c-95aa-16f51656ef63@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163f4750-24c9-104c-95aa-16f51656ef63@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 25, 2019 at 11:01:11AM +0100, Jon Hunter wrote:
> 
> On 24/06/2019 10:55, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.15 release.
> > There are 121 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed 26 Jun 2019 09:22:03 AM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.15-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests passing for Tegra ...
> 
> Test results for stable-v5.1:
>     12 builds:	12 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     32 tests:	32 pass, 0 fail
> 
> Linux version:	5.1.15-rc1-gd74a88068af9
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04
> 

Thanks for testing all of these and letting me know.

greg k-h
