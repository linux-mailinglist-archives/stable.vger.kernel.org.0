Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E19B83D7D65
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 20:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbhG0S1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 14:27:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230237AbhG0S1Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 14:27:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B27660F8F;
        Tue, 27 Jul 2021 18:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627410444;
        bh=NqY1RrOMb23Pojp9OEuxHfTg75J8jY98qmtV5kjAfBs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rPIzkyN0wsBREcV8kVZecgRbdRVFoSUwYngmL8Iz+156tuxP8VyEtwcNB5jBsKpRc
         FQNhQ90+LdZbY0dSOycvV9NL4NwNkntFHZLz8MBMxF4RDfl+qhKciuf4xdH3+rIvHP
         Jp7WflWt7CAOxAyIxT/UWsKqhMO4cmOWssPKc6dY=
Date:   Tue, 27 Jul 2021 20:27:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Maxim Devaev <mdevaev@gmail.com>
Cc:     balbi@kernel.org, stable@vger.kernel.org
Subject: Re: patch "usb: gadget: f_hid: added GET_IDLE and SET_IDLE handlers"
 added to usb-linus
Message-ID: <YQBQCmdeCGQoAUfe@kroah.com>
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

Also, that was no way to show a "v2" of a patch, no wonder I was
confused, please in the future, do it in the documented way so our tools
properly pick it up.

thanks,

greg k-h
