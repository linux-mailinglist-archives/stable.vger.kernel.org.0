Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFA1164DFA
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 19:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgBSSwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 13:52:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:37246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726613AbgBSSwX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Feb 2020 13:52:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C348206DB;
        Wed, 19 Feb 2020 18:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582138342;
        bh=TBGyAuLJhlacQKzVsxu4sHDNN3pRIstVtB7Jv3McrqE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YGMcoCFA3VBqHbXrbN0wqtGXXzHqxDJ5pdz+kPdtdAoLgt+gUUU/VBxlCo8JO7K09
         o+fTPe6cG7I4EEqrayo70x8uvlDNIJ/3czE1NbLHnT58jddUiVEE/c0aIx4n0ZKXxv
         DGyEAPmrNlUzRP6NEGZN2g/CmLyX7mwDSNB+TAj0=
Date:   Wed, 19 Feb 2020 19:52:20 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.5 00/80] 5.5.5-stable review
Message-ID: <20200219185220.GC2857377@kroah.com>
References: <20200218190432.043414522@linuxfoundation.org>
 <67cf2b44-666d-c573-0e99-8f433444f84f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67cf2b44-666d-c573-0e99-8f433444f84f@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 19, 2020 at 11:06:26AM +0000, Jon Hunter wrote:
> 
> On 18/02/2020 19:54, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.5.5 release.
> > There are 80 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 20 Feb 2020 19:03:19 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.5-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.5:
>     13 builds:	13 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     40 tests:	40 pass, 0 fail
> 
> Linux version:	5.5.5-rc1-g8aa3a43b129c
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04

Thanks for testing all of these and letting me know.

greg k-h
