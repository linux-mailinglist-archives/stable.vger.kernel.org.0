Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD6411D1F4
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 17:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729731AbfLLQLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 11:11:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:54296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729416AbfLLQLW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Dec 2019 11:11:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE5382073B;
        Thu, 12 Dec 2019 16:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576167081;
        bh=slAzlIzEDDtUyqYVNRNXCpBSABhNHtvTF49rt/tiHk4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TXL7ZmvdaRoOtUG+0//y+M9Nvl+dVjSNQMClD1WuGoP2cMQoONYFN9ckoARPeJjeb
         hmk4pVP+57s6BBdu+VdXTnKvHTNB2ik1isslv92n1jy68zxItcRDCt6zKCJdxR9kWZ
         wePOqL23XkD1UCBHry0W8LugqiLff13yTvnqVNk0=
Date:   Thu, 12 Dec 2019 17:11:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chen-Yu Tsai <wens@csie.org>
Cc:     Pavel Machek <pavel@denx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        Maxime Ripard <mripard@kernel.org>
Subject: Re: [PATCH 4.19 185/243] ARM: dts: sun8i: a23/a33: Fix up RTC device
 node
Message-ID: <20191212161119.GA1673133@kroah.com>
References: <20191211150339.185439726@linuxfoundation.org>
 <20191211150351.658072828@linuxfoundation.org>
 <20191212133132.GA13171@amd>
 <20191212140241.GA1595136@kroah.com>
 <CAGb2v67z5T4XVOc03LL9K0p1yP9UtiDhmLNj8kzxVnsDsr0rew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGb2v67z5T4XVOc03LL9K0p1yP9UtiDhmLNj8kzxVnsDsr0rew@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 12, 2019 at 10:18:34PM +0800, Chen-Yu Tsai wrote:
> On Thu, Dec 12, 2019 at 10:02 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Dec 12, 2019 at 02:31:32PM +0100, Pavel Machek wrote:
> > > Hi!
> > >
> > > > The RTC module on the A23 was claimed to be the same as on the A31, when
> > > > in fact it is not. The A31 does not have an RTC external clock output,
> > > > and its internal RC oscillator's average clock rate is not in the same
> > > > range. The A33's RTC is the same as the A23.
> > > >
> > > > This patch fixes the compatible string and clock properties to conform
> > > > to the updated bindings. The register range is also fixed.
> > >
> > > No, this is not okay for v4.19. New compatible is not in
> > > ./drivers/rtc/rtc-sun6i.c, so this will completely break rtc support.
> >
> > Good catch, I would have thought both of those would happen at the same
> > time.
> 
> (Fixed Maxime's email)
> 
> Neither were marked for stable. I guess Sasha's auto selection bot is at
> work here. Is there anything we can do to prevent them from being selected?
> For sunxi, we pretty much don't expect things to be backported, unless
> something critical was fixed.

Sasha can add any files to the bot to ignore, just let him know what
ones to mark that way.

thanks,

greg k-h
