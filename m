Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C04448BECB
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 08:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351097AbiALHDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 02:03:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351092AbiALHDw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 02:03:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70506C06173F;
        Tue, 11 Jan 2022 23:03:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 266E4B818BD;
        Wed, 12 Jan 2022 07:03:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50AA4C36AE9;
        Wed, 12 Jan 2022 07:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641971030;
        bh=GMpGBehdAz9+K5BoERP8asUPg6bAWLb0QZ6i4XTmtbg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vCDfe+/+If4bwLtCvdqRtlqWGSV58LuyFgB5/Togt3iUbgykndsswhuy1LjgSQJi8
         gbqOFRtvzzN4DE7WaZtaPePC23Vjpg2kOM9D8Q85k1WuX1HIlsXyqBTZxv6EuzU51+
         TX1qkLOEC8Rj80B+vfRS1b7lFJTOZqPV/hb63hdM=
Date:   Wed, 12 Jan 2022 08:03:47 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Karl Kurbjun <kkurbjun@gmail.com>
Cc:     linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        stable@vger.kernel.org
Subject: Re: [PATCH] HID: Ignore battery for Elan touchscreen on HP Envy X360
 15t-dr100
Message-ID: <Yd59U8SbtPeWwRwM@kroah.com>
References: <20220110034935.15623-1-kkurbjun@gmail.com>
 <YdvYVQub0+pu5ahg@kroah.com>
 <6735bf4f-b5e1-a982-6502-bd62c7715443@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6735bf4f-b5e1-a982-6502-bd62c7715443@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 11, 2022 at 07:54:16PM -0700, Karl Kurbjun wrote:
> On 1/9/22 23:55, Greg KH wrote:
> > On Sun, Jan 09, 2022 at 08:49:35PM -0700, Karl Kurbjun wrote:
> > > Battery status on Elan tablet driver is reported for the HP ENVY x360
> > > 15t-dr100. There is no separate battery for the Elan controller resulting
> > > in a battery level report of 0% or 1% depending on whether a stylus has
> > > interacted with the screen. These low battery level reports causes a
> > > variety of bad behavior in desktop environments. This patch adds the
> > > appropriate quirk to indicate that the batery status is unused for this
> > > target.
> > > 
> > > Signed-off-by: Karl Kurbjun <kkurbjun@gmail.com>
> > > ---
> > >   drivers/hid/hid-ids.h   | 1 +
> > >   drivers/hid/hid-input.c | 2 ++
> > >   2 files changed, 3 insertions(+)
> > 
> > 
> > <formletter>
> > 
> > This is not the correct way to submit patches for inclusion in the
> > stable kernel tree.  Please read:
> >      https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> > for how to do this properly.
> > 
> > </formletter>
> 
> Thanks Greg,
> 
> Sorry for the mix-up on my side.  I read that page before I submitted the
> patch but I went back and reread it.  I was trying to follow "option 1" but
> I am guessing what I messed up was the cc in the signed-off area rather than
> the cc through email?

Yes, please just put it in the signed-off-by area.

> I was looking for an example of that - I found these threads:
> https://lore.kernel.org/lkml/20130618161238.626277186@linuxfoundation.org/
> and this one was what I was originally modeling my submission off of:
> https://lore.kernel.org/lkml/20210125183218.373193047@linuxfoundation.org/
> 
> Is there an example of how I should add the cc to the sign-off area.  As I
> read those threads the stable list was added to the email cc?  Should I
> resubmit it to the linux-input with the appropriate change or follow a
> different flow now that the first email went out?
> 
> If I were going to resubmit I think I would need to to like so:
> 
> ...
> > target.
> >
> Cc: stable@vger.kernel.org
> > Signed-off-by: Karl Kurbjun <kkurbjun@gmail.com>
> > ---
> >  drivers/hid/hid-ids.h   | 1 +
> >  drivers/hid/hid-input.c | 2 ++
> >  2 files changed, 3 insertions(+)
> >
> > diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> > index 19da07777d62..a5a5a64c7abc 100644
> ...
> 
> Is that correct?

Yes, that is correct.

thanks,

greg k-h
