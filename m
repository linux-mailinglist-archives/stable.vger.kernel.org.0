Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A92305CFD
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 14:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238343AbhA0NWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 08:22:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:57770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238192AbhA0NU0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Jan 2021 08:20:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48E21207A0;
        Wed, 27 Jan 2021 13:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611753586;
        bh=mEyKKZtnfCDXUWi0Gv46XvzrorI7dMgLG2jQd8FWI2c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PiNXrRucy97pvBflEbGHiJp8mDwqXs7L5XDWkgFZ8ZZhWiWDHRk/CBE+bTKSsryJ1
         PZjNSHUfRQUrONcFGyiUSh29g5T/BpQu1ob61yUjrPB+cii/K5R89iIs8WvMq3T6Wr
         H2RMj5+U0dncXxjCBJjXQcIjUcz5215AvMODXk6w=
Date:   Wed, 27 Jan 2021 14:19:42 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>, stable@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: Re: [PATCH 5.10-stable] gpio: mvebu: fix pwm .get_state period
 calculation
Message-ID: <YBFobgWtygnREgU7@kroah.com>
References: <d1d7d548eba25119397de87211de763c54b5d8cd.1611651611.git.baruch@tkos.co.il>
 <20210126180650.xsrycbnwzu4lzl55@pengutronix.de>
 <87im7iy1e8.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87im7iy1e8.fsf@tarshish>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 27, 2021 at 03:06:55PM +0200, Baruch Siach wrote:
> Hi Uwe,
> 
> Thanks for your review.
> 
> On Tue, Jan 26 2021, Uwe Kleine-König wrote:
> > On Tue, Jan 26, 2021 at 11:00:11AM +0200, Baruch Siach wrote:
> >> commit e73b0101ae5124bf7cd3fb5d250302ad2f16a416 upstream.
> >> 
> >> The period is the sum of on and off values. That is, calculate period as
> >> 
> >>   ($on + $off) / clkrate
> >> 
> >> instead of
> >> 
> >>   $off / clkrate - $on / clkrate
> >> 
> >> that makes no sense.
> >> 
> >> Reported-by: Russell King <linux@armlinux.org.uk>
> >> Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> >> Fixes: 757642f9a584e ("gpio: mvebu: Add limited PWM support")
> >> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> >> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> >
> > Doesn't this need something like:
> >
> > 	[baruch: Backported to 5.10]
> >
> > plus a new S-o-B?
> 
> I could not find this requirement in the stable-kernel-rules.rst (Option
> 3) text.
> 
> Greg, should I resend the patch with another SoB?

Please do!

thanks,

greg k-h
