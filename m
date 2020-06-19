Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A631C20040E
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 10:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730983AbgFSIfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 04:35:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731534AbgFSIfG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 04:35:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C320206D7;
        Fri, 19 Jun 2020 08:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592555704;
        bh=qt7wUO5Okt22pY3Qi6z5k0ztaixQvYzTJG0C4fiC/IY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gg5yLOJbaMmE0tsH6CoZ1JXrwUsHSKZrvn/yv2GKdEUns0S65RWJj/6j9h2L9SIyN
         FnJE2DQs5I+6edweRAOey2guqXX9l/L/qxuZnq6npAq++kwHnq/H9zNyU7LyfXkbvh
         ANDDCMJDCO1LK6NcAF+q6z6mWkwSdeyPIHl5Acro=
Date:   Fri, 19 Jun 2020 10:35:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Monakov <amonakov@ispras.ru>
Cc:     Sasha Levin <sashal@kernel.org>, stable-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: Patch "x86/amd_nb: Add AMD family 17h model 60h PCI IDs" has
 been added to the 5.7-stable tree
Message-ID: <20200619083502.GC473790@kroah.com>
References: <20200618211421.CDE7820890@mail.kernel.org>
 <alpine.LNX.2.20.13.2006191051350.31660@monopod.intra.ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.20.13.2006191051350.31660@monopod.intra.ispras.ru>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 19, 2020 at 10:56:42AM +0300, Alexander Monakov wrote:
> On Thu, 18 Jun 2020, Sasha Levin wrote:
> 
> > This is a note to let you know that I've just added the patch titled
> > 
> >     x86/amd_nb: Add AMD family 17h model 60h PCI IDs
> > 
> > to the 5.7-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >      x86-amd_nb-add-amd-family-17h-model-60h-pci-ids.patch
> > and it can be found in the queue-5.7 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> 
> It's not good to pick this patch alone into stable. Either all 3 patches
> from https://lore.kernel.org/lkml/20200510204842.2603-1-amonakov@ispras.ru/
> should be taken, or none of those.
> 
> In particular, the edac module will warn on load without the third patch.
> 
> Likewise for 5.4-stable (should I send a separate mail for that?)

What are the git commit ids that should be applied that are not?

thanks,

greg k-h
