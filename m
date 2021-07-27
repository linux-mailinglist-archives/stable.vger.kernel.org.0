Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30D03D7D59
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 20:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbhG0S0Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 14:26:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229453AbhG0S0Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 14:26:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA68B60F37;
        Tue, 27 Jul 2021 18:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627410384;
        bh=xmp+iRpJqMzi9QPLJqTk2tNN78wacKLnD6oC78fBogI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hYV8M1IKY9JrMW3PoFkk/EZDA4Jnu0jdClJlY2Rwqm2fNIw9/iXw2SKTpkXQwKJoa
         EpgTR1MSraKE1uc3D4vA3d+9pTK5afrHC8ScGhDJO/bXPS3tgNbpZVt0lSjhV42Gpq
         u+K01LBcn4SorKNxfzu4g7OVoa67YrmgtxlRgVr8=
Date:   Tue, 27 Jul 2021 20:26:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Maxim Devaev <mdevaev@gmail.com>
Cc:     balbi@kernel.org, stable@vger.kernel.org
Subject: Re: patch "usb: gadget: f_hid: added GET_IDLE and SET_IDLE handlers"
 added to usb-linus
Message-ID: <YQBPzar+RhoqGTOO@kroah.com>
References: <1627394158704@kroah.com>
 <20210727210754.20af2cda@reki>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727210754.20af2cda@reki>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 27, 2021 at 09:07:54PM +0300, Maxim Devaev wrote:
> > <gregkh@linuxfoundation.org> wrote:
> > This is a note to let you know that I've just added the patch titled
> > 
> >     usb: gadget: f_hid: added GET_IDLE and SET_IDLE handlers
> > 
> > to my usb git tree which can be found at
> > +		hidg->idle = value;
> 
> Please use the second version of the patch from the thread.
> During the discussion, we found out that value should be shifted 8 bits to the right.
> 
> https://www.spinics.net/lists/linux-usb/msg214841.html

Can you provide a lore.kernel.org link?

Wait, I can't take a patch in the middle of a thread, that's horrid.

Please just send a fix patch on top of what I took.

thanks,

greg k-h
