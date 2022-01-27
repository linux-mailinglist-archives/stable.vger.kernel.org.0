Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B139149DC5F
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 09:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbiA0IRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 03:17:20 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:36616 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbiA0IRS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 03:17:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 48642CE213A;
        Thu, 27 Jan 2022 08:17:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D34CC340E4;
        Thu, 27 Jan 2022 08:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643271435;
        bh=Vz6j8+veRlY62brRWPOqvaCy7k66WD4jXoCSaiRWZ6I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v5lMxpSU5SWkGRjbjqfQGKBOxmtjq9zczKb+qt6FVzlKRX78kXGz2/FKGW3pd9rvT
         oibDwE48VkIwW+lfP2vx2ZX7nTCyOd3m3QfJZBaFlkjynpPj3Y481UgpoxMD1Gdz68
         DCVOCT42EEBW8J8LNpsHulEfF/gFC+LEXVb2DGhQ=
Date:   Thu, 27 Jan 2022 09:17:12 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.16 0000/1033] 5.16.3-rc2 review
Message-ID: <YfJVCNjvDUWj/s5e@kroah.com>
References: <20220125155447.179130255@linuxfoundation.org>
 <20220126210546.GA3265892@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126210546.GA3265892@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 26, 2022 at 01:05:46PM -0800, Guenter Roeck wrote:
> On Tue, Jan 25, 2022 at 05:33:08PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.16.3 release.
> > There are 1033 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.3-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> > Pseudo-Shortlog of commits:
> > 
> > 
> [ ... ]
> > 
> > Chen Wandun <chenwandun@huawei.com>
> >     mm/page_isolation: unset migratetype directly for non Buddy page
> > 
> 
> This patch causes some of my qemu emulations to crash due to lack of memory.
> This is seen both in v5.16.3-rc2 and in the mainline kernel. A request to
> revert this patch is here:
> 
> https://lore.kernel.org/linux-mm/20220124084151.GA95197@francesco-nb.int.toradex.com/t/

Thanks, I'll go drop it from the queue.

greg k-h
