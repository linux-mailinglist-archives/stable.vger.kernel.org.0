Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83932E6F89
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 10:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgL2JqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Dec 2020 04:46:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:38790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726014AbgL2JqB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Dec 2020 04:46:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51A9B206ED;
        Tue, 29 Dec 2020 09:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609235120;
        bh=ikzZSWPZcfevqFLZzmBWlt7GhdeqEQ9aV/rBXNGlqxE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bJb36JbHX3xztJ2ylFWqE26OqOPXH+h+cf09WpiicppGz5JzFiBwpSVjRpBbILbC7
         ho0XbLSJxlJbE4oeJkX2BCE2kJn0mQFsVjHULzDeVxuN3jtReMudtkbXOUWT2BLjYG
         wE8QYMoe1ItsNJVq29DYloL2zwRk4RYV7wnTGJSs=
Date:   Tue, 29 Dec 2020 10:46:41 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/453] 5.4.86-rc1 review
Message-ID: <X+r7AS3IpT1+nEvk@kroah.com>
References: <20201228124937.240114599@linuxfoundation.org>
 <1a037a15-0cc1-0fa2-ff89-31ab992ece94@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a037a15-0cc1-0fa2-ff89-31ab992ece94@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 28, 2020 at 09:33:22AM -0800, Guenter Roeck wrote:
> On 12/28/20 4:43 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.86 release.
> > There are 453 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 30 Dec 2020 12:48:23 +0000.
> > Anything received after that time might be too late.
> > 
> 
> 
> Building arm:multi_v5_defconfig ... failed
> --------------
> Error log:
> drivers/leds/leds-netxbig.c: In function 'netxbig_leds_get_of_pdata':
> drivers/leds/leds-netxbig.c:571:13: error: 'gpio_ext_dev' undeclared

THanks for reporting this, I'll go delete the offending patch...

greg k-h
