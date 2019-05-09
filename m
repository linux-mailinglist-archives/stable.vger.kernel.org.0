Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DED0918595
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 08:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbfEIGx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 02:53:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbfEIGx1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 02:53:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F549208C3;
        Thu,  9 May 2019 06:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557384806;
        bh=dAe8QjULl4HoxlEX4m0F4d63srd+dKX/P1oy0OpJfXg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i6fGs8HeR2NRB6YkpW+mCdAC1oIMsAcYr7LowmXSP08SIUy5z0ECTSng+shdLBCbq
         QizX0K2LIcu4MWdtYli8NRSlsozwm0TOPla55s6VmZb6t2ZTiMbzau/DiyD7U931nQ
         Yc0jN1Hdi/V+gkK3PrJgzkAKZ4v5VskziFbP3fzs=
Date:   Thu, 9 May 2019 08:53:24 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     stable@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: Build failure in v4.4.y.queue (ppc:allmodconfig)
Message-ID: <20190509065324.GA3864@kroah.com>
References: <20190508202642.GA28212@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508202642.GA28212@roeck-us.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 08, 2019 at 01:26:42PM -0700, Guenter Roeck wrote:
> I see multiple instances of:
> 
> arch/powerpc/kernel/exceptions-64s.S:839: Error:
> 	attempt to move .org backwards
> 
> in v4.4.y.queue (v4.4.179-143-gc4db218e9451).
> 
> This is due to commit 9b2d4e06d7f1 ("powerpc/64s: Add support for a store
> forwarding barrier at kernel entry/exit"), which is part of a large patch
> series and can not easily be reverted.
> 
> Guess I'll stop doing ppc:allmodconfig builds in v4.4.y ?

Michael, I thought this patch series was supposed to fix ppc issues, not
add to them :)

Any ideas on what to do here?

thanks,

greg k-h
