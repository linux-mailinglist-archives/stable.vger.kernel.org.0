Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 647D71EA59D
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 16:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgFAOPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 10:15:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726073AbgFAOPZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 10:15:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 570A020738;
        Mon,  1 Jun 2020 14:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591020924;
        bh=f2T43K/j3ni+yibd5X+YwhRNtuSBeHyltsA7XSmqFgw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tIpO2wr2TfuuAyZdShkSMsj47vvnuRFBfaCdPvHre+/oJ+FrPT3OMTAy54WmdGvhT
         bUJhzlQGMMfv+n8F59CCO4UUeLNxfjZJsfEGLxb6k5DGZ3VWSS5U6J9JGzybo2avuX
         P/MxnS3oM3Vh29B4URBDFA34aNj75YSthk5tIY+I=
Date:   Mon, 1 Jun 2020 16:15:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc:     Yalin.Wang@sonymobile.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: FAILED: patch "[PATCH] mm: add VM_BUG_ON_PAGE() to
 page_mapcount()" failed to apply to 4.4-stable tree
Message-ID: <20200601141522.GA722623@kroah.com>
References: <159100964424864@kroah.com>
 <20200601140519.rm5lthhe6cf45567@black.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601140519.rm5lthhe6cf45567@black.fi.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 01, 2020 at 05:05:19PM +0300, Kirill A. Shutemov wrote:
> On Mon, Jun 01, 2020 at 01:07:24PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Please don't.
> 
> The patch known to cause trouble and going to be effectively reverted:
> 
> https://lore.kernel.org/r/159032779896.957378.7852761411265662220.stgit@buzz

Oops, I ment to say that 6988f31d558a ("mm: remove VM_BUG_ON(PageSlab())
from page_mapcount()") did not apply to the 4.4 tree and needs a working
backport.

I put in the wrong id as that is the commit that 6988f31d558a fixes.

So, if you could provide a working backport, that would be wonderful.

thanks,

greg k-h
