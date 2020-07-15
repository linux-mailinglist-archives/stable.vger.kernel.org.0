Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D208220D17
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 14:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731024AbgGOMj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 08:39:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730153AbgGOMj0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jul 2020 08:39:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 682D12071B;
        Wed, 15 Jul 2020 12:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594816765;
        bh=Mm0sOXAApGS6XP4wrEAQonVs/JhhikOUmoPj10egjVk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W71eWUSy8TBUu9FYoHL46wqDxvSanIvgABViG6MBLyv8F3mb2RhaCh1ZmiJRaaCTy
         8nCFFR6awRTH0qFX1WhtXMknDyGP/uBS0ZsnNlkz7mhvLKvcvv51YigE9pi0fvnyZt
         ZSjdC3vuPCNlEs/1mG+V6NZPjgXuseQTcLyoDsgU=
Date:   Wed, 15 Jul 2020 14:39:22 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.7 000/166] 5.7.9-rc1 review
Message-ID: <20200715123922.GC3134677@kroah.com>
References: <20200714184115.844176932@linuxfoundation.org>
 <fc3af2c8-d6ca-0ad1-597e-3bba2292613c@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc3af2c8-d6ca-0ad1-597e-3bba2292613c@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 15, 2020 at 11:50:30AM +0100, Jon Hunter wrote:
> 
> On 14/07/2020 19:42, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.7.9 release.
> > There are 166 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 16 Jul 2020 18:40:38 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.9-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.7:
>     11 builds:	11 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     56 tests:	56 pass, 0 fail
> 
> Linux version:	5.7.9-rc1-gc2fb28a4b6e4
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 

Thanks for testing all of these and letting me know.

greg k-h
