Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1418A33B23F
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 13:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbhCOMJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 08:09:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231241AbhCOMJ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 08:09:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF29864E76;
        Mon, 15 Mar 2021 12:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615810165;
        bh=4dGy2llSx7XEaMNzR4zA+6ClqI3HgMXzddrgHFnaB8Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BIvYXyaIyBwcUYbLAP3wNCPdm/aBo3LznXHrPQPAVip3Sh9Ou8GOUhwyrODXt7kcs
         QJQhoLZD0ZwDeR3PASI2BoZq4bJ3dKwN5bDmClkcmjDtGcm29cQQGoylT3x0uuDIOj
         Lti5CmmAck+AEdzkOj2Z3XL3f9slLJMDMiEjrIC0=
Date:   Mon, 15 Mar 2021 13:09:23 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Rapoport <rppt@linux.ibm.com>
Cc:     rppt@kernel.org, aarcange@redhat.com, akpm@linux-foundation.org,
        bhe@redhat.com, bp@alien8.de, cai@lca.pw, chris@chris-wilson.co.uk,
        david@redhat.com, hpa@zytor.com, lma@semihalf.com, mgorman@suse.de,
        mhocko@kernel.org, mingo@redhat.com, stable@vger.kernel.org,
        tglx@linutronix.de, tomi.p.sarvela@intel.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject: Re: FAILED: patch "[PATCH] mm/page_alloc.c: refactor initialization
 of struct page for" failed to apply to 5.11-stable tree
Message-ID: <YE9Oc461sWN2bUdC@kroah.com>
References: <161579835811940@kroah.com>
 <YE8ngJ3k/RuL5RER@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YE8ngJ3k/RuL5RER@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 11:23:12AM +0200, Mike Rapoport wrote:
> Hi,
> 
> On Mon, Mar 15, 2021 at 09:52:38AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.11-stable tree.
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
> > From 0740a50b9baa4472cfb12442df4b39e2712a64a4 Mon Sep 17 00:00:00 2001
> > From: Mike Rapoport <rppt@kernel.org>
> > Date: Fri, 12 Mar 2021 21:07:12 -0800
> > Subject: [PATCH] mm/page_alloc.c: refactor initialization of struct page for
> >  holes in memory layout
> 
> The version below applies to v5.11 and v5.10.

Now applied, thanks.

greg k-h
