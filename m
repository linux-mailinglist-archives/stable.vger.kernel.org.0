Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49543CA494
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 19:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbhGORhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 13:37:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:58020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229516AbhGORho (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 13:37:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB6666128C;
        Thu, 15 Jul 2021 17:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626370490;
        bh=2BcOrIA8P1/+LPCkopyj9BUJTJAY4uGjHOthK7bK86s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vm0PSbye9FamEXPikrT6iCvuRqbQzOEtOsygMHrmx7gJD5x91N+7ZDaumkaA2/o33
         g31+X/3oSvzNli4+YdvZzUXdB0kZpWJ3jVmP7/IuG0wT4LrRx0iwqYZioYXiJI5QfM
         ivHtTcLPB2u7MC5/biNpCI35s+7RbzElH0DKYA8U=
Date:   Thu, 15 Jul 2021 19:34:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Borislav Petkov <bp@suse.de>
Cc:     tglx@linutronix.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/fpu: Make init_fpstate correct with
 optimized XSAVE" failed to apply to 4.4-stable tree
Message-ID: <YPBxt2KfrVXmGHaN@kroah.com>
References: <1624803899162147@kroah.com>
 <YNyWlkF9BdYcdwBs@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNyWlkF9BdYcdwBs@zn.tnic>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 30, 2021 at 06:06:46PM +0200, Borislav Petkov wrote:
> On Sun, Jun 27, 2021 at 04:24:59PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > From f9dfb5e390fab2df9f7944bb91e7705aba14cd26 Mon Sep 17 00:00:00 2001
> > From: Thomas Gleixner <tglx@linutronix.de>
> > Date: Fri, 18 Jun 2021 16:18:25 +0200
> > Subject: [PATCH] x86/fpu: Make init_fpstate correct with optimized XSAVE
> 
> Let's try this: it boots in a VM so it should be good. I had to remove
> some of the newly added XSTATE states. tglx, can you have a quick look
> pls?

Anyone still want this???
