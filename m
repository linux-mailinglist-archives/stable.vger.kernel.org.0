Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC5463CCDC5
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 08:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbhGSGJZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 02:09:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229916AbhGSGJZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 02:09:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 805A660FE9;
        Mon, 19 Jul 2021 06:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626674785;
        bh=7g9w1Qi2KMxbXV7cnZ8TyJt2N8xBXwbFUS21t6byfj4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fX6qTSzfRJoECTNwGkn5LHlY4drpPT8CbI4R/Pckt3p1RlsuXI16+nXv7IjNyS/g6
         ywwrTlyQCCQdbNEs9OO3ikoTRMc3/XPkpr8ZFigzpqhwrC92IFU08w96PWWSKRd4DD
         TBC++yffAlEPwJ96mroNOClkanXro2pzJQiI4j+o=
Date:   Mon, 19 Jul 2021 08:06:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Rapoport <rppt@kernel.org>
Cc:     akpm@linux-foundation.org, bhe@redhat.com, bp@alien8.de,
        david@redhat.com, robert.shteynfeld@gmail.com, rppt@linux.ibm.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject: Re: FAILED: patch "[PATCH] mm/page_alloc: fix memory map
 initialization for descending" failed to apply to 5.10-stable tree
Message-ID: <YPUWXjzX/wnsUC/h@kroah.com>
References: <16264592686170@kroah.com>
 <YPO+i7eeByNMMJiA@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPO+i7eeByNMMJiA@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 18, 2021 at 08:39:23AM +0300, Mike Rapoport wrote:
> Hi,
> 
> On Fri, Jul 16, 2021 at 08:14:28PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> I'm confused. I've sent a version that applied cleanly to 5.10.49:
> 
> https://lore.kernel.org/stable/YOr4DMQITU8yzBNT@kernel.org
> 
> and I've got an email that it was added to the stable tree and the email
> with the patch for stable preview:
> 
> https://lore.kernel.org/lkml/20210715182623.942552790@linuxfoundation.org
> 
> Was anything wrong with the patch?

Yes, it broke the build on ia64 due to duplicated function names :(

thanks,

greg k-h
