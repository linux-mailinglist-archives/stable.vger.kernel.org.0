Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9043D3B1D00
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 17:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbhFWPC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 11:02:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhFWPCz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Jun 2021 11:02:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9E2A6100B;
        Wed, 23 Jun 2021 15:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624460437;
        bh=5X5dTyS50Nv6v7nF9v6/zRpPW4X2tSo4N7dMFiljys8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h2w3yytHupsmnVmVnUJNxsRJLfwS9qgjUgsRCu6yGObadK/nDaIalYVJctk2sQzR6
         3HHnrDLIq8LboDcYRv5Ldx9gM/AouBsc9Uj0HvIawF0Lo2AOFOMCe4U4w1GwxUKY/7
         Hhy6F4IjlubCcJ0doUurT2fuiPu7oVERE0M4Gj08=
Date:   Wed, 23 Jun 2021 17:00:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Borislav Petkov <bp@suse.de>, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/fpu: Reset state for all signal
 restore failures" failed to apply to 4.4-stable tree
Message-ID: <YNNMkzyPUcrMF/u5@kroah.com>
References: <162427273275124@kroah.com>
 <YNDQHgGztJAWO2H+@zn.tnic>
 <YNG4q++kHwWtVupg@kroah.com>
 <878s31ekg8.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878s31ekg8.ffs@nanos.tec.linutronix.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 22, 2021 at 10:03:03PM +0200, Thomas Gleixner wrote:
> On Tue, Jun 22 2021 at 12:17, Greg KH wrote:
> 
> > On Mon, Jun 21, 2021 at 07:45:02PM +0200, Borislav Petkov wrote:
> >> On Mon, Jun 21, 2021 at 12:52:12PM +0200, gregkh@linuxfoundation.org wrote:
> >> > 
> >> > The patch below does not apply to the 4.4-stable tree.
> >> > If someone wants it applied there, or to any other stable or longterm
> >> > tree, then please email the backport, including the original git commit
> >> > id to <stable@vger.kernel.org>.
> >> 
> >> Ok, how's this below?
> >> 
> >> It should at least capture the gist of what this commit is trying to
> >> achieve as the FPU mess has changed substantially since 4.4 so I'm
> >> really cautious here not to break any existing setups.
> >> 
> >> I've boot-tested this in a VM but Greg, I'd appreciate running it
> >> through some sort of stable testing framework if you're using one.
> >
> > This applied to 4.4.y and 4.9.y, but we still need a 4.14.y and 4.19.y
> > version if at all possible.
> 
> Everything is possible :)

Thanks for this, now queued up!

greg k-h
