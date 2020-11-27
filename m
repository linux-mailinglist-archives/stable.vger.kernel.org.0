Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4218B2C672C
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 14:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729913AbgK0NsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 08:48:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:41304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729662AbgK0NsF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Nov 2020 08:48:05 -0500
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4889D20B1F;
        Fri, 27 Nov 2020 13:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606484884;
        bh=s4L3W3v15jG9m4793BP8yzNg4FXIDOP6MeUh6vZiQrc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qfV/BlxTzXCyLMkp7wyEqjKedhCJ2+5Ddu6UrrUYWq4le0iw+gfSeA/M0UCXLVbqx
         XuLQ8jILdgND4bwXUk2r0aOyYvPfLPJ27YXcVILoDdK0VgyyKua5gOliaJ5cIwpP9K
         YCVTRLJhI1FruS4lS8a3qSBiXZLFYthOpLyfWan4=
Date:   Fri, 27 Nov 2020 14:48:02 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Peter Chen <peter.chen@nxp.com>
Cc:     "balbi@kernel.org" <balbi@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will McVicker <willmcvicker@google.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 4/4] USB: gadget: f_midi: setup SuperSpeed Plus
 descriptors
Message-ID: <X8EDkpkZBI5naECL@kroah.com>
References: <20201126180937.255892-1-gregkh@linuxfoundation.org>
 <20201126180937.255892-4-gregkh@linuxfoundation.org>
 <20201127120621.GD22238@b29397-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127120621.GD22238@b29397-desktop>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 27, 2020 at 12:06:50PM +0000, Peter Chen wrote:
> On 20-11-26 19:09:37, Greg Kroah-Hartman wrote:
> > From: Will McVicker <willmcvicker@google.com>
> > 
> > Needed for SuperSpeed Plus support for f_midi.  This allows the
> > gadget to work properly without crashing at SuperSpeed rates.
> > 
> > Cc: Felipe Balbi <balbi@kernel.org>
> > Cc: stable <stable@vger.kernel.org>
> > Signed-off-by: Will McVicker <willmcvicker@google.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/usb/gadget/function/f_midi.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/drivers/usb/gadget/function/f_midi.c b/drivers/usb/gadget/function/f_midi.c
> > index 85cb15734aa8..ceb67651de4f 100644
> > --- a/drivers/usb/gadget/function/f_midi.c
> > +++ b/drivers/usb/gadget/function/f_midi.c
> > @@ -1048,6 +1048,11 @@ static int f_midi_bind(struct usb_configuration *c, struct usb_function *f)
> >  		f->ss_descriptors = usb_copy_descriptors(midi_function);
> >  		if (!f->ss_descriptors)
> >  			goto fail_f_midi;
> 
> Add one blank line, otherwise:

Will add it, good idea.

> Reviewed-by: Peter Chen <peter.chen@nxp.com>

Thanks for reviewing all of these, much appreciated.

greg k-h
