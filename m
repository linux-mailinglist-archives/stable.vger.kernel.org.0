Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B18AF19C1BC
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 15:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgDBNJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 09:09:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733234AbgDBNJF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 09:09:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1BF420678;
        Thu,  2 Apr 2020 13:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585832944;
        bh=HRwxHQBC9kQTrRQvz+Yh0uMWoXqH51d6avWK4AF0BRY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tO5CP1TDTdurRKmXFFZa0qT+4oJmnBN72UgjAdwp6ItX9gqSkfixrA46lUPl6laSm
         JeyeMroW+P9huBT9Gj3dwkAJs1FVDqFrNs9Xbqmw62Ahdq/eUUCQf/8BIepQANAfF4
         6znlPPWmpuWa+nuAlwHCvwpAiT/9HgIAN7d4OPR8=
Date:   Thu, 2 Apr 2020 15:09:02 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.6 00/10] 5.6.2-rc1 review
Message-ID: <20200402130902.GA2774407@kroah.com>
References: <20200401161413.974936041@linuxfoundation.org>
 <a78aab3d-2d00-dd1b-24e0-67db41898349@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a78aab3d-2d00-dd1b-24e0-67db41898349@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 02, 2020 at 08:11:07AM +0100, Jon Hunter wrote:
> 
> On 01/04/2020 17:17, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.6.2 release.
> > There are 10 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 03 Apr 2020 16:09:36 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.2-rc1.gz
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
> Linux version:	5.6.2-rc1-g6c8d51f98078
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 

Great, thanks for testing all of these and letting me know.

greg k-h
