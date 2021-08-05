Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F15C23E195B
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 18:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhHEQTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 12:19:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231528AbhHEQTj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Aug 2021 12:19:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92F3A610CD;
        Thu,  5 Aug 2021 16:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628180365;
        bh=NGUqEfI7h03AqKpJHW5T9oEmXdeRhpzrWZql0s4opM0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BrvpAMdUThQjjgHoN9IHEQDaygT7htzQP4OZaoBoA2PD1rGVZsmeRwDFgt+9zKwBn
         i7nS/AD3tvOJQczUorWY5b4pOgZ3U7JqILX5mHZvNsKRYIjdC9JTbsYAnObbmvzYgw
         oLg69fUVcqGcHtkxgoYxc7vFe44SzRYFilTT2DEs=
Date:   Thu, 5 Aug 2021 18:19:15 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: Regressions in stable releases
Message-ID: <YQwPg1VQZTyPSkXe@kroah.com>
References: <efee3a58-a4d2-af22-0931-e81b877ab539@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <efee3a58-a4d2-af22-0931-e81b877ab539@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 05, 2021 at 09:11:02AM -0700, Guenter Roeck wrote:
> Hi folks,
> 
> we have (at least) two severe regressions in stable releases right now.
> 
> [SHAs are from linux-5.10.y]
> 
> 2435dcfd16ac spi: mediatek: fix fifo rx mode
> 	Breaks SPI access on all Mediatek devices for small transactions
> 	(including all Mediatek based Chromebooks since they use small SPI
> 	 transactions for EC communication)
> 
> 60789afc02f5 Bluetooth: Shutdown controller after workqueues are flushed or cancelled
> 	Breaks Bluetooth on various devices (Mediatek and possibly others)
> 	Discussion: https://lkml.org/lkml/2021/7/28/569

Are either of these being tracked on the regressions list?  I have not
noticed them being reported there, or on the stable list :(

> Unfortunately, it appears that all our testing doesn't cover SPI and Bluetooth.
> 
> I understand that upstream is just as broken until fixes are applied there.
> Still, it shows that our test coverage is far from where it needs to be,
> and/or that we may be too aggressive with backporting patches to stable
> releases.
> 
> If you have an idea how to improve the situation, please let me know.

We need to get tests running in kernelci on real hardware, that's going
to be much more helpful here.

thanks,

greg k-h
