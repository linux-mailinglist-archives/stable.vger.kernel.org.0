Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06F423EB5BF
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 14:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240354AbhHMMsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 08:48:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:60264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240266AbhHMMsL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 08:48:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D7AF60F14;
        Fri, 13 Aug 2021 12:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628858864;
        bh=sxTkRJm85mSff18ceXrqhEF2XPUHdx6QuR6aTRg9CQU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=De4t5zVokTLA/IC0vMHrIQlv1o1f19nVO+o4nnt9zN3XkAU8Q+bfUM6HKaEOo8/d0
         ms/J9xUsG8Fob7frrObWicnlFlEP06D34rlViblbzmA9q3901tPfN9aQiFzuQDA8P4
         sGep1aGCR7AZT7Hgh9vb7dxlYyLffGtyDNA+qkFE=
Date:   Fri, 13 Aug 2021 14:47:42 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     alois1@gmx-topmail.de, stable <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] ovl: prevent private clone if bind mount
 is not allowed" failed to apply to 4.9-stable tree
Message-ID: <YRZp7t8SOJvJtdM9@kroah.com>
References: <1628845325236177@kroah.com>
 <CAOssrKds1jpyoq296kfJocwbo8H+cbMRRDnAQeaxM3Fk4pHO-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOssrKds1jpyoq296kfJocwbo8H+cbMRRDnAQeaxM3Fk4pHO-A@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 13, 2021 at 02:24:59PM +0200, Miklos Szeredi wrote:
> On Fri, Aug 13, 2021 at 11:02 AM <gregkh@linuxfoundation.org> wrote:
> >
> >
> > The patch below does not apply to the 4.9-stable tree.
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
> > From 427215d85e8d1476da1a86b8d67aceb485eb3631 Mon Sep 17 00:00:00 2001
> 
> Attaching backport.  Applies to 4.4 and 4.9.

Thanks, now queued up.

greg k-h
