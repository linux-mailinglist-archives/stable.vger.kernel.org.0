Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85EE1D95EC
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 14:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728822AbgESMIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 08:08:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgESMIn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 May 2020 08:08:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5EAE20708;
        Tue, 19 May 2020 12:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589890123;
        bh=EaG4wBKAklDYz64kBQM9KM/hg//IL3j1WxJO74AwWZU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=otxEaEJcMC3xItziyGQQH7pM13WxQPPuEABs/kQ022PW3yvzigoWGEV2KsydY6+b2
         KZ0ItBDzoRUyHUhifZm9ZUl3X+AFCsRS7QV9LWnqGUb64tGcHuF8mO/YT+x7bXmM0X
         FrlgCn/y47de7V5Dn1uSFPKfcheE2saip1Gpw9bA=
Date:   Tue, 19 May 2020 14:08:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     ast@kernel.org, brendan.d.gregg@gmail.com, hch@lst.de,
        mhiramat@kernel.org, torvalds@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] bpf: Restrict bpf_trace_printk()'s %s
 usage and add %pks," failed to apply to 5.4-stable tree
Message-ID: <20200519120841.GB332015@kroah.com>
References: <15898172865189@kroah.com>
 <72fe3785-bfbe-d672-fa77-8a90fc4d2844@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72fe3785-bfbe-d672-fa77-8a90fc4d2844@iogearbox.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 18, 2020 at 09:17:39PM +0200, Daniel Borkmann wrote:
> Hey Greg,
> 
> On 5/18/20 5:54 PM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.4-stable tree.
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
> >  From b2a5212fb634561bb734c6356904e37f6665b955 Mon Sep 17 00:00:00 2001
> > From: Daniel Borkmann <daniel@iogearbox.net>
> > Date: Fri, 15 May 2020 12:11:18 +0200
> > Subject: [PATCH] bpf: Restrict bpf_trace_printk()'s %s usage and add %pks,
> >   %pus specifier
> 
> The whole series related to this commit is:
> 
>  - 0ebeea8ca8a4 ("bpf: Restrict bpf_probe_read{, str}() only to archs where they work")
>  - 47cc0ed574ab ("bpf: Add bpf_probe_read_{user, kernel}_str() to do_refine_retval_range")
>  - b2a5212fb634 ("bpf: Restrict bpf_trace_printk()'s %s usage and add %pks, %pus specifier")
> 
> It would only apply to 5.6.y stable branch, but not older ones.

Thanks for the information, only the last patch was queued up for 5.6.y,
I'll queue the other two for the next round after this one.

greg k-h
