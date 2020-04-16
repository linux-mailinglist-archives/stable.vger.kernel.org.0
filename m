Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B29CF1AB955
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 09:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437960AbgDPHGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 03:06:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437819AbgDPHGU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 03:06:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C39621569;
        Thu, 16 Apr 2020 07:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587020780;
        bh=0D0CpGuyVJ99Ff+dpeV0hzpZeaXOF7wy4rUZSiWqSiE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M9+v6N2Tq0XEEM0QBlUUd0Q2cZ12pWxhBvCDtuzSLe+6jcZKs2MkpkIyaBxh3pNkm
         wsdHYJU5FBGrkMqHLgPHFj/Y6/Wivl8vMrbhXSWclij22oaDSIjYT1N2gUHNUoNctS
         maMKDeDJF88iZ7jbBVsSLC6qm114P+4und4mLMAU=
Date:   Thu, 16 Apr 2020 09:06:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Matthew Wilcox <willy@infradead.org>, bhelgaas@google.com,
        keescook@chromium.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] XArray: Fix xa_find_next for large
 multi-index entries" failed to apply to 5.4-stable tree
Message-ID: <20200416070617.GB372946@kroah.com>
References: <1586948677159164@kroah.com>
 <20200415150222.GD5820@bombadil.infradead.org>
 <20200415165122.GA3654762@kroah.com>
 <20200415224949.GK1068@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415224949.GK1068@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 06:49:49PM -0400, Sasha Levin wrote:
> On Wed, Apr 15, 2020 at 06:51:22PM +0200, Greg KH wrote:
> > On Wed, Apr 15, 2020 at 08:02:22AM -0700, Matthew Wilcox wrote:
> > > On Wed, Apr 15, 2020 at 01:04:37PM +0200, gregkh@linuxfoundation.org wrote:
> > > > The patch below does not apply to the 5.4-stable tree.
> > > > If someone wants it applied there, or to any other stable or longterm
> > > > tree, then please email the backport, including the original git commit
> > > > id to <stable@vger.kernel.org>.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > > >
> > > > ------------------ original commit in Linus's tree ------------------
> > > >
> > > > >From bd40b17ca49d7d110adf456e647701ce74de2241 Mon Sep 17 00:00:00 2001
> > > 
> > > Seems like it's already there as commit
> > > 16696ee7b58101c90bf21c3ab2443c57df4af24e
> > 
> > Ugh.
> > 
> > Sasha, your scripts are applying patches to older kernels before newer
> > ones for some odd reason again, which confuses mine to no end :(
> 
> /me scratches head
> 
> It's in 5.6, 5.5, and 5.4. I've also queued them all at the same time
> and you've released them all at the same time (Apr 8th).
> 
> Yes, it's tagged for stable, but I've grabbed it for the Fixes: tag.
> 
> What am I missing?

{sigh} nothing, my fault, it was a long day of stable patches, all is
fine :)

greg k-h
