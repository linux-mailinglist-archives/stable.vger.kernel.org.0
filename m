Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8737158E31
	for <lists+stable@lfdr.de>; Tue, 11 Feb 2020 13:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbgBKMQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Feb 2020 07:16:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:47876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727950AbgBKMQt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Feb 2020 07:16:49 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 394FE206DB;
        Tue, 11 Feb 2020 12:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581423409;
        bh=KHNDwelMhPhYYRCIOXWR7Xld6woG2x8V5JdMXH0YamI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dF9gsQ9y8v5ZtdFIFFa/ugYBc0DrIUCKgbUMfTkZdQn6RYF7pZe8TCQRLZRTyVtzY
         TVoX1MxOwENUbyFr0DtlAAo9kZ7u9A7ksPE+x+tKxRat3HzPGYuWJArZZRsL9QXyQg
         /t0E9A1lUwcvIwqhsR8L+0aUfT/AA8gzTY5DW47Q=
Date:   Tue, 11 Feb 2020 04:16:48 -0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.5 000/367] 5.5.3-stable review
Message-ID: <20200211121648.GA1856500@kroah.com>
References: <20200210122423.695146547@linuxfoundation.org>
 <ecd95628-a1c2-307a-1d59-34a37bf425ff@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ecd95628-a1c2-307a-1d59-34a37bf425ff@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 10, 2020 at 08:05:39PM +0000, Jon Hunter wrote:
> 
> On 10/02/2020 12:28, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.5.3 release.
> > There are 367 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 12 Feb 2020 12:18:57 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.3-rc1.gz
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
> Linux version:	5.5.3-rc1-g1d9d90e88c9f
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04

Wonderful, thanks for testing all of these and letting me know.

greg k-h
