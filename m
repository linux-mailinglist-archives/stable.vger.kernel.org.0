Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8D63263539
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 20:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbgIISBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 14:01:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726408AbgIISBN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Sep 2020 14:01:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2C4321D46;
        Wed,  9 Sep 2020 18:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599674472;
        bh=pgP4b85+7vWCX47zJKllmqZNSN2rbSk1645eUT2KDcI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fsfo9hAEgI98VGQewvG8mYFbBBuD0TO3DbV1GR5yA3kHtDXak0puLOTW7yRtYQuQT
         Ecbmjum8Z0yLAE0YNqSTzciTsAs1/XXh7pHVvEH5hGI4j8vXnV/2bUKo7Xw1wTmH0r
         teG7ruPbCR67OKzBV99SZu1FFnNhrxEIv+C2Pbg4=
Date:   Wed, 9 Sep 2020 20:01:21 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.8 000/186] 5.8.8-rc1 review
Message-ID: <20200909180121.GD1003763@kroah.com>
References: <20200908152241.646390211@linuxfoundation.org>
 <20200909164705.GE1479@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909164705.GE1479@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 09, 2020 at 09:47:05AM -0700, Guenter Roeck wrote:
> On Tue, Sep 08, 2020 at 05:22:22PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.8 release.
> > There are 186 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 10 Sep 2020 15:21:57 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 153 fail: 1
> Failed builds:
> 	powerpc:allmodconfig
> Qemu test results:
> 	total: 430 pass: 430 fail: 0
> 
> The powerpc problem is the same as before:
> 
> Inconsistent kallsyms data
> Try make KALLSYMS_EXTRA_PASS=1 as a workaround
> 
> KALLSYMS_EXTRA_PASS=1 doesn't help. The problem is sporadic, elusive, and all
> but impossible to bisect. The same build passes on another system, for example,
> with a different load pattern. It may pass with -j30 and fail with -j40.
> The problem started at some point after v5.8, and got worse over time; by now
> it almost always happens. I'd be happy to debug if there is a means to do it,
> but I don't have an idea where to even start. I'd disable KALLSYMS in my
> test configurations, but the symbol is selected from various places and thus
> difficult to disable. So unless I stop building ppc:allmodconfig entirely
> we'll just have to live with the failure.

Ah, I was worried when I saw your dashboard orange for this kernel.

I guess the powerpc maintainers don't care?  Sad :(

Anyway, thanks for testing them all and letting me know.

greg k-h
