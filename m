Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7FD2A2F4E
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 17:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgKBQHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 11:07:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:50986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726751AbgKBQGx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 11:06:53 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D7F02225E;
        Mon,  2 Nov 2020 16:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604333213;
        bh=x8f88ndVTtTtF6ELNU18qL4UwNl/+m+W7mskQUfUYAI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PDecE+owTqEF+PpLSXRK37J8c9QMRIqK52MkvN8feHvzzQrPQHQZt6v3fKLHDSeug
         HGYTTkmvbO7+b2n8UV0aAPEfYawJHVSF0xXf6Fu7gSWv2NExzFvg1hOWDAzjguxeTt
         PFwruMjLAhfNjrHqByqkSGcFV5UwZlv8obXhONSA=
Date:   Mon, 2 Nov 2020 17:07:47 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ross Lagerwall <ross.lagerwall@citrix.com>
Cc:     =?iso-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>,
        stable@vger.kernel.org
Subject: Re: Stable backport request for "xen/events: don't use chip_data for
 legacy IRQs"
Message-ID: <20201102160747.GA1845823@kroah.com>
References: <0e4837c4-b750-4889-bb8c-8a36c73c7110@citrix.com>
 <1a63ad59-c0d3-893b-8098-97146920214b@suse.com>
 <20201031100314.GA3847955@kroah.com>
 <fd6482d4-d28e-d1bd-9e08-daf7a36f9b79@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fd6482d4-d28e-d1bd-9e08-daf7a36f9b79@citrix.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 02, 2020 at 01:40:07PM +0000, Ross Lagerwall wrote:
> On 2020-10-31 10:03, Greg KH wrote:
> > [CAUTION - EXTERNAL EMAIL] DO NOT reply, click links, or open attachments unless you have verified the sender and know the content is safe.
> > 
> > On Fri, Oct 30, 2020 at 03:17:09PM +0100, Jürgen Groß wrote:
> >> On 30.10.20 14:29, Ross Lagerwall wrote:
> >>> Hi,
> >>>
> >>> Please backport [1] to 4.4, 4.9, 4.14, 4.19.
> >>>
> >>> It fixes a commit that has been backported to all the current stable releases but for some reason the fixup was only backported to 5.4 & 5.8.
> >>
> >> Greg has told me he queued my backport already.
> > 
> > I did?  I don't see that commit backported anywhere, did you get
> > confused with some other patch?
> > 
> > I need a backported version of this patch if we are able to accept it,
> > as it does not apply cleanly to those kernel releases.  Can someone
> > please provide it and send it?
> > 
> 
> The clean backport to older releases was sent by Jürgen on Oct 5th (subject [PATCH] xen/events: don't use chip_data for legacy IRQs).
> 
> https://lists.linaro.org/pipermail/linux-stable-mirror/2020-October/221081.html
> 
> It was queued for 5.4 but not older releases even though it applies cleanly to 4.4..4.19.

Can you please resend it, that's long out of my mboxes...

thanks,

greg k-h
