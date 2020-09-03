Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E345225BE72
	for <lists+stable@lfdr.de>; Thu,  3 Sep 2020 11:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgICJaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Sep 2020 05:30:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbgICJaF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Sep 2020 05:30:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C15C9206C0;
        Thu,  3 Sep 2020 09:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599125403;
        bh=yuXQhqJRp97Dk8GmAowisGG0EVBX6hEwX82YbZahov4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NODYlADCYtxuZqB1uyYhPLnpKSj89EMLHAN3KOQeNvw5GSxRJtdP+OneqzJEvJvWl
         6p6FRxtRewBM4jmoF4bDqSwfRIHcCUHBMbYr54kGlnLb9Y6Uofcf3TJtSEu7JQoQhj
         tx9QZiDbNjx7dVyY74y+4stKuLXcNTA2vfPnDpWQ=
Date:   Thu, 3 Sep 2020 11:30:27 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.8 000/253] 5.8.6-rc2 review
Message-ID: <20200903093027.GD2220117@kroah.com>
References: <20200902074837.329205434@linuxfoundation.org>
 <20200902165151.GF56237@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902165151.GF56237@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 02, 2020 at 09:51:51AM -0700, Guenter Roeck wrote:
> On Wed, Sep 02, 2020 at 09:49:11AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.6 release.
> > There are 253 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 04 Sep 2020 07:47:48 +0000.
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
> The build failure is:
> 
> Inconsistent kallsyms data
> Try make KALLSYMS_EXTRA_PASS=1 as a workaround
> 
> The suggested workaround doesn't help. I see the problem in mainline
> and in -next as well, and it is elusive (meaning it is not easy to
> reproduce). Given that, it is not an immediate concern.
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks for testing all of these and letting me know.

greg k-h
