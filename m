Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5C411368D
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 21:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbfLDUhb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 15:37:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:45476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727911AbfLDUhb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 15:37:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05B2B2073B;
        Wed,  4 Dec 2019 20:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575491850;
        bh=1MjL0LW0EvInXo0rn8wTxuCEjcjRqg11OdyPfReULqw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FJsNIsEQYANecq/DmuKsNFzKGpT+H+833xwlWyKtLTssX/79bBzFB1nFNAoHAxLKu
         7cVqrrH4bou5rZfRV5lSE5c1QoQiyLv2F9crPMvNT5QsWkPG6QWVxTWDHa3s8K5xHb
         z16XeBA9AotLqeLDKO6itzkh8IY85em/45TK18gA=
Date:   Wed, 4 Dec 2019 21:37:28 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/46] 5.4.2-stable review
Message-ID: <20191204203728.GB3685601@kroah.com>
References: <20191203212705.175425505@linuxfoundation.org>
 <20191204190543.GD11419@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191204190543.GD11419@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 04, 2019 at 11:05:43AM -0800, Guenter Roeck wrote:
> On Tue, Dec 03, 2019 at 11:35:20PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.2 release.
> > There are 46 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 05 Dec 2019 21:20:36 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 158 pass: 157 fail: 1
> Failed builds:
> 	mips:allmodconfig
> Qemu test results:
> 	total: 394 pass: 394 fail: 0

Thanks for testing all of these and letting me know.

greg k-h
