Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47FC03DBBC9
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 17:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239558AbhG3PMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 11:12:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238909AbhG3PMI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Jul 2021 11:12:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5242A60F5C;
        Fri, 30 Jul 2021 15:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627657923;
        bh=kxUtOLEZStV/pG0MsyqmAQ170ubCws0dYqCyy6etDis=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mWDfR7V9oCVq0MkC9xUhJWbF/OyheNka88BQx4QMENMtQGXntWdEfeHnEPVR14s0k
         1ZNkKyW2v62mCESdSd4UE3SijJM1uT4itJPP9RZSJZ7bpXMapz9njpvhbGA1T36jaO
         AX5MhngJbrGQtK8SWvZevcJs4gc4UL3wSjTwS58xE9H6UHuFgAQCwD9u8CP/SmKEBO
         wq24Cb4xBGYCmX4PPDh/7Ozjfqm+PCYK1AKWHUAjP0QXKcUWds9rNYQ3/RqWi/XUhY
         eb+IwiRwsb2ATJvFvrzEUsDVH+gwf25Q9uclp681m9mWhYOoSqJfbTtj6xnOhpa9CW
         W7lkp4xi3h3Pw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1m9UAY-00046W-Tn; Fri, 30 Jul 2021 17:11:26 +0200
Date:   Fri, 30 Jul 2021 17:11:26 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg KH <greg@kroah.com>
Cc:     Charles Yeh <charlesyeh522@gmail.com>,
        =?utf-8?B?WWVoLkNoYXJsZXMgW+iRieamrumRq10=?= 
        <charles-yeh@prolific.com.tw>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris <chris@cyber-anlage.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH] USB: serial: pl2303: fix HX type detection
Message-ID: <YQQWnnhhumPq2IB8@hovoldconsulting.com>
References: <YQPsgPey1V+7ccGq@hovoldconsulting.com>
 <20210730122156.718-1-johan@kernel.org>
 <YQPwwygDuJklttlP@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQPwwygDuJklttlP@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 30, 2021 at 02:29:55PM +0200, Greg Kroah-Hartman wrote:
> On Fri, Jul 30, 2021 at 02:21:56PM +0200, Johan Hovold wrote:
> > The device release number for HX-type devices is configurable in
> > EEPROM/OTPROM and cannot be used reliably for type detection.
> > 
> > Assume all (non-H) devices with bcdUSB 1.1 and unknown bcdDevice to be
> > of HX type while adding a bcdDevice check for HXD and TB (1.1 and 2.0,
> > respectively).
> > 
> > Reported-by: Chris <chris@cyber-anlage.de>
> > Fixes: 8a7bf7510d1f ("USB: serial: pl2303: amend and tighten type detection")
> > Cc: stable@vger.kernel.org	# 5.13
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > ---
> >  drivers/usb/serial/pl2303.c | 41 ++++++++++++++++++++++---------------
> >  1 file changed, 25 insertions(+), 16 deletions(-)
> > 
> 
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks for reviewing. Now applied.

Johan
