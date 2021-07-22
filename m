Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A43F43D262E
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 16:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbhGVOJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 10:09:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232520AbhGVOJR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 10:09:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E30A61221;
        Thu, 22 Jul 2021 14:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626965391;
        bh=TjkHfGXhg4CKKEPFgnCmzFmprxPDIv1dfXvT5sitIsc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BYtJV62a0tJ7tVksiidI/gLG+85o9WSN2oC3Mt/+76GEVUaZDhXvQdzfffUo3W5gr
         V6dOs9t66yLocpreO2aG5XPCnGa9BctPZS0zZj0QLPVkUa4o6ZZlHGa4eaSw7B9yGN
         0vLVHMWZwqwtXJ77sOa+QfuBWJXrO3tFMz/35IVk=
Date:   Thu, 22 Jul 2021 16:49:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Borislav Petkov <bp@suse.de>
Cc:     tglx@linutronix.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/fpu: Make init_fpstate correct with
 optimized XSAVE" failed to apply to 4.4-stable tree
Message-ID: <YPmFjHVmux6L+kd+@kroah.com>
References: <1624803899162147@kroah.com>
 <YNyWlkF9BdYcdwBs@zn.tnic>
 <YPBxt2KfrVXmGHaN@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPBxt2KfrVXmGHaN@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 15, 2021 at 07:34:47PM +0200, Greg KH wrote:
> On Wed, Jun 30, 2021 at 06:06:46PM +0200, Borislav Petkov wrote:
> > On Sun, Jun 27, 2021 at 04:24:59PM +0200, gregkh@linuxfoundation.org wrote:
> > > 
> > > The patch below does not apply to the 4.4-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > > 
> > > ------------------ original commit in Linus's tree ------------------
> > > 
> > > From f9dfb5e390fab2df9f7944bb91e7705aba14cd26 Mon Sep 17 00:00:00 2001
> > > From: Thomas Gleixner <tglx@linutronix.de>
> > > Date: Fri, 18 Jun 2021 16:18:25 +0200
> > > Subject: [PATCH] x86/fpu: Make init_fpstate correct with optimized XSAVE
> > 
> > Let's try this: it boots in a VM so it should be good. I had to remove
> > some of the newly added XSTATE states. tglx, can you have a quick look
> > pls?
> 
> Anyone still want this???

Cool, this works for 4.4.y, but what about 4.9.y, 4.14.y, 4.19.y, and
5.4.y?  Your proposed patch here blows up the build on all of those
other branches.

thanks,

greg k-h
