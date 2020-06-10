Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4451F53D2
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 13:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbgFJLu6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 07:50:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728558AbgFJLu5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jun 2020 07:50:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DC482072E;
        Wed, 10 Jun 2020 11:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591789857;
        bh=YIB/QxY+kFi44EYUQu8N4ZO01G6LNQ6fIC2Z+fyL0SQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jvQbJrlbXL8rAGRZ2n6o31brUUNYgSzxi0ypyNyzGQz5wrfmtO/UiHrlwFsQ+aZzt
         EMcDBHwB/OFJj4cCltecSwl7aotJE4vG4kfHvTz8IudZ24IGXAMUmqMSg2HiqUiBlU
         Dv4znIEp6z30PTKKpRVFsjLC39vzKiukrGKPh2TA=
Date:   Wed, 10 Jun 2020 13:50:51 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.7 00/24] 5.7.2-rc1 review
Message-ID: <20200610115051.GB1896587@kroah.com>
References: <20200609174149.255223112@linuxfoundation.org>
 <7208a2cc-c439-57bc-f154-a23e6ac683f5@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7208a2cc-c439-57bc-f154-a23e6ac683f5@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 10, 2020 at 12:30:28PM +0100, Jon Hunter wrote:
> 
> On 09/06/2020 18:45, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.7.2 release.
> > There are 24 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 11 Jun 2020 17:41:38 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.2-rc1.gz
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
>     50 tests:	50 pass, 0 fail
> 
> Linux version:	5.7.2-rc1-g00f7cc67908b
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04

Wonderful, thanks for testing all of these and letting me know.

greg k-h
