Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5C127FE89
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 18:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389867AbfHBQWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 12:22:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:51798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732861AbfHBQWs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 12:22:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E84A2087E;
        Fri,  2 Aug 2019 16:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564762967;
        bh=KLUnAC1kW/wvlsrYeGLOrOTfvQpSNqWzHmgPCosr+mU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jTfBzQX/4PULLra8Cvx4lY05lOnLSLJ1jR1dDbCzr0yjb2cVkJIEVWtehR8L8XoqJ
         umL9IWHCnMQUIh7h4/AYkKDT2Bx2yNp4jVqXVydJnZlxAzFUWzlAT/zR7fMFQ0gUiJ
         RiJYf3Ez/QihLiHwu/eLNwSsrlyT2Ts3IImMjbm4=
Date:   Fri, 2 Aug 2019 18:22:44 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/158] 4.4.187-stable review
Message-ID: <20190802162244.GA13783@kroah.com>
References: <20190802092203.671944552@linuxfoundation.org>
 <20190802155211.GA25315@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190802155211.GA25315@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 02, 2019 at 08:52:11AM -0700, Guenter Roeck wrote:
> On Fri, Aug 02, 2019 at 11:27:01AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.4.187 release.
> > There are 158 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun 04 Aug 2019 09:19:34 AM UTC.
> > Anything received after that time might be too late.
> > 
> 
> Early feedback:
> 
> Build reference: v4.4.186-159-g26f755a0d3e0
> 
> Building powerpc:defconfig ... failed
> 
> arch/powerpc/platforms/pseries/mobility.c: In function ‘post_mobility_fixup’:
> arch/powerpc/platforms/pseries/mobility.c:318:2: error: implicit declaration of function ‘cpus_read_lock’
> arch/powerpc/platforms/pseries/mobility.c:325:2: error: implicit declaration of function ‘cacheinfo_teardown’
> arch/powerpc/platforms/pseries/mobility.c:332:2: error: implicit declaration of function ‘cacheinfo_rebuild’
> arch/powerpc/platforms/pseries/mobility.c:334:2: error: implicit declaration of function ‘cpus_read_unlock’
> 
> Culprits:
> 
> 9d263cc3b7c1 powerpc/pseries/mobility: rebuild cacheinfo hierarchy post-migration
> d4b0908c6289 powerpc/pseries/mobility: prevent cpu hotplug during DT update

Both patches now dropped, thanks for letting me know.  I'll go push out
a -rc2 with those removed.

greg k-h
