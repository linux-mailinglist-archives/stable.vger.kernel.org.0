Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3845E3D2533
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 16:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbhGVNZs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 09:25:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232201AbhGVNZn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 09:25:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0552B6128A;
        Thu, 22 Jul 2021 14:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626962774;
        bh=2XEDrYa/c7hz+y8g148HTZInCxH4lAnB1lTHv6Tvsd4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cCLNdazcEJS1sluJtwBxvOQYAD1Vym8YqmwuTd6L6PdSFYr/t0wJRqTeqHGAsiij4
         C39kX2v7xLs0ee5nex5pJ2RtJQVrnDkCepZMrOJZXo47e8wr35/rGCC9I+mPET328y
         CKxjJq9p2W70mVmKHJW8Yd0c60ByTx1L3SAHbjug=
Date:   Thu, 22 Jul 2021 16:06:11 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Rapoport <rppt@kernel.org>
Cc:     akpm@linux-foundation.org, bhe@redhat.com, bp@alien8.de,
        david@redhat.com, robert.shteynfeld@gmail.com, rppt@linux.ibm.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject: Re: FAILED: patch "[PATCH] mm/page_alloc: fix memory map
 initialization for descending" failed to apply to 5.10-stable tree
Message-ID: <YPl7U8NgmeKoP6Q1@kroah.com>
References: <16264592686170@kroah.com>
 <YPO+i7eeByNMMJiA@kernel.org>
 <YPUWXjzX/wnsUC/h@kroah.com>
 <YPWTdETYFq+MdlEL@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPWTdETYFq+MdlEL@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 19, 2021 at 06:00:04PM +0300, Mike Rapoport wrote:
> On Mon, Jul 19, 2021 at 08:06:22AM +0200, Greg KH wrote:
> > On Sun, Jul 18, 2021 at 08:39:23AM +0300, Mike Rapoport wrote:
> > > Hi,
> > > 
> > > On Fri, Jul 16, 2021 at 08:14:28PM +0200, gregkh@linuxfoundation.org wrote:
> > > > 
> > > > The patch below does not apply to the 5.10-stable tree.
> > > > If someone wants it applied there, or to any other stable or longterm
> > > > tree, then please email the backport, including the original git commit
> > > > id to <stable@vger.kernel.org>.
> > > 
> > > I'm confused. I've sent a version that applied cleanly to 5.10.49:
> > > 
> > > https://lore.kernel.org/stable/YOr4DMQITU8yzBNT@kernel.org
> > > 
> > > and I've got an email that it was added to the stable tree and the email
> > > with the patch for stable preview:
> > > 
> > > https://lore.kernel.org/lkml/20210715182623.942552790@linuxfoundation.org
> > > 
> > > Was anything wrong with the patch?
> > 
> > Yes, it broke the build on ia64 due to duplicated function names :(
> 
> The version below takes care of compatibility with ia64 in the least
> intrusive way I could think of. 

Thanks, will go queue this up now.

greg k-h
