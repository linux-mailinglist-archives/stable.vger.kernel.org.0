Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3DB61EA609
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 16:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgFAOlR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 10:41:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726968AbgFAOlR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 10:41:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3CB92074B;
        Mon,  1 Jun 2020 14:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591022476;
        bh=Z8LZw8h+dE/ikWHgAMqwK/rIHXpcsJgyfGPQbZndahU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T2j59+b+e+aJyeKSBoUs1b1aNe4MGexuiRd98QzBMn3R92xd5UkSETYBw6jqo25sC
         JhZAbgdwdx2iKG69ZzNxTatqrHLcCprkrvQtPuZvtSUiAcl8nq8wkqAi3/aEf0a3RB
         7c7FqVDa9T5/nzPYo+JUC1PGkKKD5VzxYncAwdvE=
Date:   Mon, 1 Jun 2020 16:41:14 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc:     Yalin.Wang@sonymobile.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: FAILED: patch "[PATCH] mm: add VM_BUG_ON_PAGE() to
 page_mapcount()" failed to apply to 4.4-stable tree
Message-ID: <20200601144114.GA777584@kroah.com>
References: <159100964424864@kroah.com>
 <20200601140519.rm5lthhe6cf45567@black.fi.intel.com>
 <20200601141522.GA722623@kroah.com>
 <20200601143023.pzwhggnbwplqral6@black.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601143023.pzwhggnbwplqral6@black.fi.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 01, 2020 at 05:30:23PM +0300, Kirill A. Shutemov wrote:
> On Mon, Jun 01, 2020 at 04:15:22PM +0200, Greg KH wrote:
> > On Mon, Jun 01, 2020 at 05:05:19PM +0300, Kirill A. Shutemov wrote:
> > > On Mon, Jun 01, 2020 at 01:07:24PM +0200, gregkh@linuxfoundation.org wrote:
> > > > 
> > > > The patch below does not apply to the 4.4-stable tree.
> > > > If someone wants it applied there, or to any other stable or longterm
> > > > tree, then please email the backport, including the original git commit
> > > > id to <stable@vger.kernel.org>.
> > > 
> > > Please don't.
> > > 
> > > The patch known to cause trouble and going to be effectively reverted:
> > > 
> > > https://lore.kernel.org/r/159032779896.957378.7852761411265662220.stgit@buzz
> > 
> > Oops, I ment to say that 6988f31d558a ("mm: remove VM_BUG_ON(PageSlab())
> > from page_mapcount()") did not apply to the 4.4 tree and needs a working
> > backport.
> > 
> > I put in the wrong id as that is the commit that 6988f31d558a fixes.
> > 
> > So, if you could provide a working backport, that would be wonderful.
> 
> The patch below should do. I've dropped the comments. They are not
> relevant for v4.4.

That worked, thanks!

greg k-h
