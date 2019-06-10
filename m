Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8313B3B7C0
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 16:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390946AbfFJOvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 10:51:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389123AbfFJOvQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 10:51:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0EE2206C3;
        Mon, 10 Jun 2019 14:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560178276;
        bh=IZ48GrMjAPiqcC5o9zECGFcbIG65yiVN7gHwu4ZFq0E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jFhcQXnyt3AAV2/8mUPHjqQssWIvFLprn6nPSNDof2Qu5aszoZp5xsv3nRGwZm6Gh
         ToyQJf7mIhl+Ufrl9VbjzFVoezHftLE8MC1qW26vppFMdpZlpBS/1oDlVJdXF7l2Tn
         8x7l6y8DNdvm+P/XO/n5eT3CfNDPoQcM92WZYofQ=
Date:   Mon, 10 Jun 2019 16:51:13 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.1 00/70] 5.1.9-stable review
Message-ID: <20190610145113.GC1481@kroah.com>
References: <20190609164127.541128197@linuxfoundation.org>
 <20190610144503.GE7705@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610144503.GE7705@roeck-us.net>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 10, 2019 at 07:45:03AM -0700, Guenter Roeck wrote:
> On Sun, Jun 09, 2019 at 06:41:11PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.9 release.
> > There are 70 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue 11 Jun 2019 04:40:04 PM UTC.
> > Anything received after that time might be too late.
> > 
> Build results:
> 	total: 159 pass: 159 fail: 0
> Qemu test results:
> 	total: 351 pass: 351 fail: 0

Thanks for testing all of these and letting me know.

greg k-h
